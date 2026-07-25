package com.quizapp.dtos;

import java.util.List;

// DTO's for studennt's profile,
// CourseView is nested here, because we only use it within this response
// Used in StudentService
public record StudentProfileView(Long id, String fullName, String email, List<CourseView> courses) {
    public record CourseView(Long id, String courseName, String instructorName) {

    }
}
