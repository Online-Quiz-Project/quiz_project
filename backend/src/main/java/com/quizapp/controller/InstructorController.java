package com.quizapp.controller;

import com.quizapp.dto.InstructorCourseView;
import com.quizapp.dto.InstructorProfileView;
import com.quizapp.repository.CourseRepository;
import com.quizapp.repository.InstructorRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.List;
@RestController
@RequestMapping("/api/instructors")
public class InstructorController {
    private final CourseRepository courses;
    private final InstructorRepository instructors;

    public InstructorController(CourseRepository courses, InstructorRepository instructors) {
        this.courses = courses;
        this.instructors = instructors;
    }

    @GetMapping("/{id}/profile")
    @PreAuthorize("hasRole('INSTRUCTOR') and #id == authentication.principal.userId")
    // Loads instructor-only fields from the instructor table while shared identity
    // details continue to come from the linked user row.
    public InstructorProfileView profile(@PathVariable Long id) {
        return InstructorProfileView.from(instructors.findProfileById(id)
                .orElseThrow(() -> new EntityNotFoundException("Instructor not found")));
    }

    @GetMapping("/{id}/courses")
    @PreAuthorize("hasRole('INSTRUCTOR') and #id == authentication.principal.userId")
    // Returns every subject assigned to this instructor, since one instructor
    // may teach more than one course.
    public List<InstructorCourseView> courses(@PathVariable Long id) {
        instructors.findProfileById(id)
                .orElseThrow(() -> new EntityNotFoundException("Instructor not found"));
        return courses.findByInstructorId(id).stream()
                .map(InstructorCourseView::from)
                .toList();
    }
}
