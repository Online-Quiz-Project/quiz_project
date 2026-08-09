package com.quizapp.service;

import com.quizapp.entities.ActivityLog;
import com.quizapp.repository.ActivityLogRepository;
import org.springframework.beans.factory.annotation.Value;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.TransactionTemplate;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

@Service
public class LoggingClient {
    private static final Logger LOGGER = LoggerFactory.getLogger(LoggingClient.class);
    private final HttpClient client = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(2))
            .build();
    private final String serviceUrl;
    private final ActivityLogRepository activityLogs;
    private final TransactionTemplate logTransaction;

    public LoggingClient(@Value("${logging.service.url}") String serviceUrl,
                         ActivityLogRepository activityLogs,
                         PlatformTransactionManager transactionManager) {
        this.serviceUrl = serviceUrl;
        this.activityLogs = activityLogs;
        this.logTransaction = new TransactionTemplate(transactionManager);
        this.logTransaction.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
    }

    // Sends a small activity record to the separate C# logging service without
    // allowing logging problems to interrupt the main quiz action.
    public void log(String eventType, String message, Long userId) {
        String safeType = truncate(eventType, 60);
        String safeMessage = truncate(message, 500);
        try {
            logTransaction.executeWithoutResult(status -> {
                ActivityLog entry = new ActivityLog();
                entry.setEventType(safeType);
                entry.setMessage(safeMessage);
                entry.setUserId(userId);
                activityLogs.save(entry);
            });
        } catch (RuntimeException exception) {
            LOGGER.warn("Could not persist activity log {}", safeType, exception);
        }

        try {
            String body = "{\"eventType\":\"" + jsonEscape(safeType)
                    + "\",\"message\":\"" + jsonEscape(safeMessage)
                    + "\",\"userId\":" + (userId == null ? "null" : userId) + "}";
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(serviceUrl + "/logs"))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(3))
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();
            client.sendAsync(request, HttpResponse.BodyHandlers.discarding())
                    .thenAccept(response -> {
                        if (response.statusCode() >= 400) {
                            LOGGER.debug("Logging service returned HTTP {}", response.statusCode());
                        }
                    })
                    .exceptionally(error -> {
                        LOGGER.debug("Logging service is unavailable", error);
                        return null;
                    });
        } catch (RuntimeException exception) {
            LOGGER.warn("Could not send activity log {}", safeType, exception);
        }
    }

    private String truncate(String value, int maximumLength) {
        String text = value == null ? "" : value.trim();
        return text.length() <= maximumLength ? text : text.substring(0, maximumLength);
    }

    private String jsonEscape(String value) {
        StringBuilder escaped = new StringBuilder(value.length());
        for (int index = 0; index < value.length(); index++) {
            char character = value.charAt(index);
            switch (character) {
                case '\\' -> escaped.append("\\\\");
                case '"' -> escaped.append("\\\"");
                case '\n' -> escaped.append("\\n");
                case '\r' -> escaped.append("\\r");
                case '\t' -> escaped.append("\\t");
                default -> {
                    if (character < 0x20) escaped.append(String.format("\\u%04x", (int) character));
                    else escaped.append(character);
                }
            }
        }
        return escaped.toString();
    }
}
