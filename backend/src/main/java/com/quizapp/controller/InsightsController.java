package com.quizapp.controller;

import com.quizapp.service.InsightsService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/insights")
public class InsightsController {
    private final InsightsService insights;

    public InsightsController(InsightsService insights) {
        this.insights = insights;
    }

    @GetMapping("/leaderboard")
    public List<Map<String, Object>> leaderboard() {
        return insights.leaderboard();
    }

    @GetMapping("/students/{studentId}")
    @PreAuthorize("hasRole('STUDENT') and #studentId == authentication.principal.userId")
    public Map<String, Object> student(@PathVariable Long studentId) {
        return insights.student(studentId);
    }

    @GetMapping("/instructors/{instructorId}")
    @PreAuthorize("hasRole('INSTRUCTOR') and #instructorId == authentication.principal.userId")
    public Map<String, Object> instructor(@PathVariable Long instructorId) {
        return insights.instructor(instructorId);
    }

    @GetMapping("/platform")
    @PreAuthorize("hasRole('ADMIN')")
    public Map<String, Object> platform() {
        return insights.platform();
    }

    @GetMapping("/logs")
    @PreAuthorize("hasRole('ADMIN')")
    public List<Map<String, Object>> logs() {
        return insights.logs();
    }
}
