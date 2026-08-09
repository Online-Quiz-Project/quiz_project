package com.quizapp.dto;

import com.quizapp.entities.User;
import com.quizapp.entities.enums.USER_ROLE;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AdminUserView {
    private Long id;
    private String fullName;
    private String email;
    private USER_ROLE role;
    private List<String> subjects;
    private String branch;
    private Integer graduationYear;
    private String department;
    private String qualifications;

    public static AdminUserView from(User user) {
        List<String> subjects = user.getRole() == USER_ROLE.ROLE_INSTRUCTOR
                && user.getInstructorProfile() != null
                ? user.getInstructorProfile().getCoursesTaught().stream()
                        .map(course -> course.getCourseName())
                        .sorted()
                        .toList()
                : List.of();
        var student = user.getStudentProfile();
        var instructor = user.getInstructorProfile();
        return new AdminUserView(
                user.getId(),
                user.getFullName(),
                user.getEmail(),
                user.getRole(),
                subjects,
                student == null ? null : student.getBranch(),
                student == null ? null : student.getGraduationYear(),
                instructor == null ? null : instructor.getDepartment(),
                instructor == null ? null : instructor.getQualifications()
        );
    }
}
