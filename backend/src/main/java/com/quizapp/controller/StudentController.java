package com.quizapp.controller;

import com.quizapp.dto.StudentProfileView;
import com.quizapp.service.StudentService;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;

@RestController
@RequestMapping("/api/students")
public class StudentController {
    private final StudentService studentService;

    public StudentController(StudentService studentService) {
        this.studentService = studentService;
    }

    @GetMapping("/{id}/profile")
    @PreAuthorize("hasRole('STUDENT') and #id == authentication.principal.userId")
    // Loads the student's basic details together with all current course enrollments.
    public StudentProfileView profile(@PathVariable Long id) {
        return studentService.getProfile(id);
    }

    @PostMapping("/{id}/courses/{courseId}")
    @PreAuthorize("hasRole('STUDENT') and #id == authentication.principal.userId")
    // Enrolls the signed-in student in another course and returns the refreshed profile.
    public StudentProfileView enroll(@PathVariable Long id, @PathVariable Long courseId) {
        return studentService.enroll(id, courseId);
    }
}
