package com.quizapp.dto;

import com.quizapp.entities.Course;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InstructorCourseView {
    private Long id;
    private String courseName;
    private String description;
    private Long instructorId;
    private String instructorName;

    public static InstructorCourseView from(Course course) {
        return new InstructorCourseView(
                course.getId(),
                course.getCourseName(),
                course.getDescription(),
                course.getInstructor().getId(),
                course.getInstructor().getUser().getFullName()
        );
    }
}
