package com.quizapp.security;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.quizapp.entities.User;
import com.quizapp.entities.enums.USER_ROLE;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Instant;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class JwtService {
    private static final Base64.Encoder ENCODER = Base64.getUrlEncoder().withoutPadding();
    private static final Base64.Decoder DECODER = Base64.getUrlDecoder();
    private static final String HEADER = ENCODER.encodeToString(
            "{\"alg\":\"HS256\",\"typ\":\"JWT\"}".getBytes(StandardCharsets.UTF_8));

    private final byte[] secret;
    private final long expirationSeconds;
    private final ObjectMapper json = new ObjectMapper();

    public JwtService(@Value("${app.jwt.secret}") String secret,
                      @Value("${app.jwt.expiration-hours}") long expirationHours) {
        if (secret.length() < 32) {
            throw new IllegalStateException("JWT_SECRET must contain at least 32 characters");
        }
        if (expirationHours < 1) {
            throw new IllegalStateException("JWT_EXPIRATION_HOURS must be at least 1");
        }
        this.secret = secret.getBytes(StandardCharsets.UTF_8);
        this.expirationSeconds = expirationHours * 3600;
    }

    public String create(User user) {
        try {
            long now = Instant.now().getEpochSecond();
            Map<String, Object> claims = new LinkedHashMap<>();
            claims.put("sub", user.getId());
            claims.put("email", user.getEmail());
            claims.put("role", user.getRole().name());
            claims.put("iat", now);
            claims.put("exp", now + expirationSeconds);
            String payload = ENCODER.encodeToString(json.writeValueAsBytes(claims));
            String unsigned = HEADER + "." + payload;
            return unsigned + "." + ENCODER.encodeToString(sign(unsigned));
        } catch (Exception exception) {
            throw new IllegalStateException("Could not create login token", exception);
        }
    }

    public AuthenticatedUser parse(String token) {
        try {
            if (token == null || token.length() > 4096) throw new IllegalArgumentException("Invalid token");
            String[] parts = token.split("\\.");
            if (parts.length != 3 || !parts[0].equals(HEADER)) {
                throw new IllegalArgumentException("Invalid token");
            }
            byte[] expected = sign(parts[0] + "." + parts[1]);
            if (!MessageDigest.isEqual(expected, DECODER.decode(parts[2]))) {
                throw new IllegalArgumentException("Invalid token signature");
            }
            Map<String, Object> claims = json.readValue(
                    DECODER.decode(parts[1]), new TypeReference<>() { });
            long expiresAt = ((Number) claims.get("exp")).longValue();
            if (expiresAt <= Instant.now().getEpochSecond()) {
                throw new IllegalArgumentException("Token expired");
            }
            return new AuthenticatedUser(
                    ((Number) claims.get("sub")).longValue(),
                    String.valueOf(claims.get("email")),
                    USER_ROLE.valueOf(String.valueOf(claims.get("role"))));
        } catch (Exception exception) {
            throw new IllegalArgumentException("Invalid or expired login token");
        }
    }

    private byte[] sign(String content) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(secret, "HmacSHA256"));
        return mac.doFinal(content.getBytes(StandardCharsets.UTF_8));
    }
}
