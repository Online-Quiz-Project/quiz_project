package com.quizapp.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "students")
@Getter
@Setter
@NoArgsConstructor
public class Student {

    @Id
    private Long id;

    /*
     * The student uses the same primary key as the matching user. This is a true
     * one-to-one extension: users stores login data, while students stores only
     * details that make sense for a student.
     */
    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    @Column(length = 100)
    private String branch;

    private Integer graduationYear;

    @OneToMany(mappedBy = "student")
    private List<CourseEnrollment> enrollments = new ArrayList<>();

    @OneToMany(mappedBy = "student")
    private List<QuizAttempt> quizAttempts = new ArrayList<>();
}
