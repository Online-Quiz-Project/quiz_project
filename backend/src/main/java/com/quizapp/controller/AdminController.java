package com.quizapp.controller;

import com.quizapp.entities.enums.QUIZ_STATUS;
import com.quizapp.entities.enums.USER_ROLE;
import com.quizapp.dto.AdminUserRequest;
import com.quizapp.dto.AdminUserView;
import com.quizapp.dto.CourseRequest;
import com.quizapp.dto.InstructorCourseView;
import com.quizapp.dto.RoleRequest;
import com.quizapp.service.AdminService;
import jakarta.validation.Valid;
import com.quizapp.repository.CourseRepository;
import com.quizapp.repository.QuizAttemptRepository;
import com.quizapp.repository.QuizRepository;
import com.quizapp.repository.UserRepository;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {
    private final UserRepository users;
    private final CourseRepository courses;
    private final QuizRepository quizzes;
    private final QuizAttemptRepository attempts;
    private final AdminService adminService;

    public AdminController(UserRepository users, CourseRepository courses,
                           QuizRepository quizzes, QuizAttemptRepository attempts,
                           AdminService adminService) {
        this.users = users;
        this.courses = courses;
        this.quizzes = quizzes;
        this.attempts = attempts;
        this.adminService = adminService;
    }

    @GetMapping("/metrics")
    // Collects the main totals for the admin dashboard in one response so the
    // page does not need to make a separate request for every card.
    public Map<String, Object> metrics() {
        Map<String, Object> metrics = new LinkedHashMap<>();
        metrics.put("students", users.countByRole(USER_ROLE.ROLE_STUDENT));
        metrics.put("instructors", users.countByRole(USER_ROLE.ROLE_INSTRUCTOR));
        metrics.put("courses", courses.count());
        metrics.put("quizzes", quizzes.count());
        metrics.put("publishedQuizzes", quizzes.countByStatus(QUIZ_STATUS.PUBLISHED));
        metrics.put("draftQuizzes", quizzes.countByStatus(QUIZ_STATUS.DRAFT));
        metrics.put("attempts", attempts.count());
        metrics.put("passed", attempts.countPassed());
        metrics.put("failed", attempts.countFailed());
        metrics.put("averageScore", attempts.averageScore());
        return metrics;
    }

    @GetMapping("/users")
    // Returns the account list used for role management and course visibility.
    public List<AdminUserView> users() {
        return adminService.getUsers();
    }

    @PostMapping("/users")
    // Passes admin-created account details to the service that also handles
    // course enrollment for new students.
    public AdminUserView createUser(@Valid @RequestBody AdminUserRequest request) {
        return adminService.createUser(request);
    }

    @PatchMapping("/users/{id}/role")
    // Updates only the selected account's role without replacing its other data.
    public AdminUserView changeRole(@PathVariable Long id, @Valid @RequestBody RoleRequest request) {
        return adminService.changeRole(id, request.getRole());
    }

    @PostMapping("/courses")
    // Adds a course and assigns its instructor from the same admin form.
    public InstructorCourseView createCourse(@Valid @RequestBody CourseRequest request) {
        return adminService.createCourse(request);
    }
}
