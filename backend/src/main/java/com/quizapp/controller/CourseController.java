package com.quizapp.controller;

import com.quizapp.dto.InstructorCourseView;
import com.quizapp.repository.CourseRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/courses")
public class CourseController {
    private final CourseRepository courses;

    public CourseController(CourseRepository courses) {
        this.courses = courses;
    }

    @GetMapping
    // Lists all available courses with instructor names for registration,
    // enrollment, quiz creation, and administration screens.
    public List<InstructorCourseView> allCourses() {
        return courses.findAllWithInstructor().stream()
                .map(InstructorCourseView::from)
                .toList();
    }
}
