package com.quizapp.entities;

import com.quizapp.entities.enums.USER_ROLE;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "users")
@Getter
@Setter
@NoArgsConstructor
public class User extends BaseEntity {

	@Column(nullable = false, length = 100)
	private String fullName;

	@Column(nullable = false, unique = true, length = 100)
	private String email;

	@Column(nullable = false, length = 255)
	private String passwordHash;

	@Enumerated(EnumType.STRING)
	@Column(nullable = false)
	private USER_ROLE role;

	// Courses taught by this instructor
	@OneToMany(mappedBy = "instructor")
	private List<Course> coursesTaught = new ArrayList<>();

	// Course enrollments for this student
	@OneToMany(mappedBy = "student")
	private List<CourseEnrollment> enrollments = new ArrayList<>();

	// Quiz attempts by this student
	@OneToMany(mappedBy = "student")
	private List<QuizAttempt> quizAttempts = new ArrayList<>();

	// Quizzes created by this instructor/admin
	@OneToMany(mappedBy = "createdBy")
	private List<Quiz> quizzesCreated = new ArrayList<>();
}