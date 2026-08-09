package com.quizapp.controller;

import com.quizapp.dto.SubmitAttemptRequest;
import com.quizapp.service.AttemptService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import com.quizapp.security.AuthenticatedUser;

import java.util.Map;
@RestController
@RequestMapping("/api/attempts")
public class AttemptController {
    private final AttemptService attemptService;

    public AttemptController(AttemptService attemptService) {
        this.attemptService = attemptService;
    }

    @PostMapping("/start")
    @PreAuthorize("hasRole('STUDENT') and #studentId == authentication.principal.userId")
    // Starts a timed attempt, or resumes the student's unfinished attempt when one exists.
    public Map<String, Object> start(@RequestParam Long quizId, @RequestParam Long studentId) {
        return attemptService.start(quizId, studentId);
    }

    @PostMapping("/{attemptId}/submit")
    @PreAuthorize("hasRole('STUDENT')")
    // Sends the student's selected answers for server-side scoring and pass/fail calculation.
    public Map<String, Object> submit(@PathVariable Long attemptId,
                                      @Valid @RequestBody SubmitAttemptRequest request,
                                      @AuthenticationPrincipal AuthenticatedUser user) {
        return attemptService.submit(attemptId, request, user.userId());
    }

    @GetMapping("/{attemptId}/review")
    @PreAuthorize("hasRole('STUDENT') and #studentId == authentication.principal.userId")
    public Map<String, Object> review(@PathVariable Long attemptId,
                                      @RequestParam Long studentId) {
        return attemptService.review(attemptId, studentId);
    }
}
