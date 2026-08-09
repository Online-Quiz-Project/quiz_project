package com.quizapp.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class StudentProfileView {
    private Long id;
    private String fullName;
    private String email;
    private String branch;
    private Integer graduationYear;
    private List<CourseView> courses;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CourseView {
        private Long id;
        private String courseName;
        private String instructorName;
    }
}
