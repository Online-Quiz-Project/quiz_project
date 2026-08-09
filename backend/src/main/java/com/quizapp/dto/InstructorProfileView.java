package com.quizapp.dto;

import com.quizapp.entities.Instructor;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class InstructorProfileView {
    private Long id;
    private String fullName;
    private String email;
    private String department;
    private String qualifications;

    public static InstructorProfileView from(Instructor instructor) {
        return new InstructorProfileView(
                instructor.getId(),
                instructor.getUser().getFullName(),
                instructor.getUser().getEmail(),
                instructor.getDepartment(),
                instructor.getQualifications()
        );
    }
}
