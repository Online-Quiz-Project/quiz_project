package com.quizapp.controller;

import com.quizapp.dto.QuestionRequest;
import com.quizapp.dto.QuizRequest;
import com.quizapp.dto.QuizDetailsView;
import com.quizapp.dto.QuizView;
import com.quizapp.service.QuizService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import com.quizapp.security.AuthenticatedUser;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/quizzes")
public class QuizController {
    private final QuizService quizService;

    public QuizController(QuizService quizService) {
        this.quizService = quizService;
    }

    @GetMapping("/student/{studentId}")
    @PreAuthorize("hasRole('STUDENT') and #studentId == authentication.principal.userId")
    // Shows only published quizzes belonging to courses the student has joined.
    public List<QuizView> studentQuizzes(@PathVariable Long studentId) {
        return quizService.forStudent(studentId);
    }

    @GetMapping("/instructor/{instructorId}")
    @PreAuthorize("hasRole('INSTRUCTOR') and #instructorId == authentication.principal.userId")
    // Returns both drafts and published quizzes owned by this instructor.
    public List<QuizView> instructorQuizzes(@PathVariable Long instructorId) {
        return quizService.forInstructor(instructorId);
    }

    @GetMapping("/{id}")
    // Loads the complete quiz, including saved questions and answer choices,
    // which is used by both the editor and the student quiz runner.
    public QuizDetailsView details(@PathVariable Long id,
                                   @AuthenticationPrincipal AuthenticatedUser user) {
        return quizService.details(id, user);
    }

    @GetMapping("/{id}/answer-key")
    @PreAuthorize("hasRole('INSTRUCTOR') and #instructorId == authentication.principal.userId")
    public Map<String, Object> answerKey(@PathVariable Long id,
                                         @RequestParam Long instructorId) {
        return quizService.answerKey(id, instructorId);
    }

    @PostMapping
    @PreAuthorize("hasRole('INSTRUCTOR') and #request.createdById == authentication.principal.userId")
    // Creates a new draft or published quiz from the instructor form.
    public QuizView create(@Valid @RequestBody QuizRequest request) {
        return quizService.save(null, request);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('INSTRUCTOR') and #request.createdById == authentication.principal.userId")
    // Saves changes to an existing quiz while keeping the same quiz record.
    public QuizView update(@PathVariable Long id, @Valid @RequestBody QuizRequest request) {
        return quizService.save(id, request);
    }

    @PostMapping("/{id}/questions")
    // Adds one question to a quiz when a caller uses the smaller question-only API.
    @PreAuthorize("hasRole('INSTRUCTOR') and #instructorId == authentication.principal.userId")
    public QuizView addQuestion(@PathVariable Long id, @RequestParam Long instructorId,
                                @Valid @RequestBody QuestionRequest request) {
        return quizService.addQuestion(id, instructorId, request);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    @PreAuthorize("hasRole('INSTRUCTOR') and #instructorId == authentication.principal.userId")
    public void delete(@PathVariable Long id, @RequestParam Long instructorId) {
        quizService.delete(id, instructorId);
    }
}
