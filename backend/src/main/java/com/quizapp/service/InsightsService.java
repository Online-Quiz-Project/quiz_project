package com.quizapp.service;

import com.quizapp.entities.QuizAttempt;
import com.quizapp.entities.enums.ATTEMPT_STATUS;
import com.quizapp.repository.ActivityLogRepository;
import com.quizapp.repository.QuizAttemptRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@Service
public class InsightsService {
    private final QuizAttemptRepository attempts;
    private final ActivityLogRepository activityLogs;

    public InsightsService(QuizAttemptRepository attempts, ActivityLogRepository activityLogs) {
        this.attempts = attempts;
        this.activityLogs = activityLogs;
    }

    private boolean completed(QuizAttempt attempt) {
        return attempt.getScore() != null && attempt.getStatus() != ATTEMPT_STATUS.IN_PROGRESS;
    }

    private int xp(QuizAttempt attempt) {
        int scoreXp = attempt.getScore() == null ? 0 : attempt.getScore().setScale(0, RoundingMode.HALF_UP).intValue();
        boolean passed = attempt.getScore() != null
                && attempt.getScore().doubleValue() >= attempt.getQuiz().getPassPercentage();
        return scoreXp + (passed ? 25 : 0);
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> leaderboard() {
        Map<Long, List<QuizAttempt>> grouped = attempts.findAll().stream()
                .filter(this::completed)
                .collect(Collectors.groupingBy(item -> item.getStudent().getId()));
        List<Map<String, Object>> result = grouped.values().stream().map(items -> {
            int totalXp = items.stream().mapToInt(this::xp).sum();
            double average = items.stream().map(QuizAttempt::getScore)
                    .mapToDouble(BigDecimal::doubleValue).average().orElse(0);
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("studentId", items.get(0).getStudent().getId());
            row.put("name", items.get(0).getStudent().getUser().getFullName());
            row.put("xp", totalXp);
            row.put("level", totalXp / 500 + 1);
            row.put("averageScore", Math.round(average * 10.0) / 10.0);
            row.put("quizzesCompleted", items.size());
            return row;
        }).sorted(Comparator.comparingInt(row -> -((Number) row.get("xp")).intValue())).toList();
        for (int index = 0; index < result.size(); index++) result.get(index).put("rank", index + 1);
        return result;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> student(Long studentId) {
        List<QuizAttempt> completed = attempts.findByStudentIdOrderByCreatedAtDesc(studentId).stream()
                .filter(this::completed).toList();
        int totalXp = completed.stream().mapToInt(this::xp).sum();
        long passed = completed.stream().filter(this::passed).count();
        int streak = 0;
        for (QuizAttempt attempt : completed) {
            if (!passed(attempt)) break;
            streak++;
        }
        int rank = leaderboard().stream()
                .filter(row -> row.get("studentId").equals(studentId))
                .map(row -> ((Number) row.get("rank")).intValue()).findFirst().orElse(0);
        Map<String, Object> result = commonAnalytics(completed);
        result.put("xp", totalXp);
        result.put("level", totalXp / 500 + 1);
        result.put("xpToNextLevel", 500 - (totalXp % 500));
        result.put("streak", streak);
        result.put("rank", rank);
        result.put("passed", passed);
        result.put("recentScores", completed.stream().limit(8).map(this::scorePoint).toList());
        return result;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> instructor(Long instructorId) {
        List<QuizAttempt> relevant = attempts.findAll().stream()
                .filter(this::completed)
                .filter(item -> item.getQuiz().getCreatedBy().getId().equals(instructorId)).toList();
        Map<String, Object> result = commonAnalytics(relevant);
        Map<String, List<QuizAttempt>> byQuiz = relevant.stream()
                .collect(Collectors.groupingBy(item -> item.getQuiz().getTitle(), LinkedHashMap::new, Collectors.toList()));
        result.put("quizPerformance", byQuiz.entrySet().stream().map(entry -> {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("quiz", entry.getKey());
            item.put("attempts", entry.getValue().size());
            item.put("average", roundedAverage(entry.getValue()));
            item.put("passRate", rate(entry.getValue(), this::passed));
            return item;
        }).toList());
        return result;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> platform() {
        List<QuizAttempt> completed = attempts.findAll().stream().filter(this::completed).toList();
        Map<String, Object> result = commonAnalytics(completed);
        LocalDateTime weekAgo = LocalDateTime.now().minusDays(7);
        result.put("attemptsThisWeek", completed.stream()
                .filter(item -> item.getSubmittedAt() != null && item.getSubmittedAt().isAfter(weekAgo)).count());
        result.put("completionRate", attempts.count() == 0 ? 0
                : Math.round(completed.size() * 1000.0 / attempts.count()) / 10.0);
        result.put("topPerformers", leaderboard().stream().limit(5).toList());
        return result;
    }

    @Transactional(readOnly = true)
    public List<Map<String, Object>> logs() {
        return activityLogs.findTop50ByOrderByCreatedAtDesc().stream().map(log -> {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", log.getId());
            item.put("eventType", log.getEventType());
            item.put("message", log.getMessage());
            item.put("userId", log.getUserId());
            item.put("createdAt", log.getCreatedAt());
            return item;
        }).toList();
    }

    private Map<String, Object> commonAnalytics(List<QuizAttempt> items) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("completed", items.size());
        result.put("averageScore", roundedAverage(items));
        result.put("passRate", rate(items, this::passed));
        result.put("averageDurationMinutes", items.stream()
                .filter(item -> item.getSubmittedAt() != null)
                .mapToLong(item -> Duration.between(item.getStartedAt(), item.getSubmittedAt()).toMinutes())
                .average().orElse(0));
        return result;
    }

    private boolean passed(QuizAttempt attempt) {
        return attempt.getScore().doubleValue() >= attempt.getQuiz().getPassPercentage();
    }

    private double roundedAverage(List<QuizAttempt> items) {
        double value = items.stream().map(QuizAttempt::getScore)
                .mapToDouble(BigDecimal::doubleValue).average().orElse(0);
        return Math.round(value * 10.0) / 10.0;
    }

    private double rate(List<QuizAttempt> items, Predicate<QuizAttempt> predicate) {
        return items.isEmpty() ? 0
                : Math.round(items.stream().filter(predicate).count() * 1000.0 / items.size()) / 10.0;
    }

    private Map<String, Object> scorePoint(QuizAttempt item) {
        Map<String, Object> point = new LinkedHashMap<>();
        point.put("quiz", item.getQuiz().getTitle());
        point.put("score", item.getScore());
        point.put("date", item.getSubmittedAt());
        return point;
    }
}
