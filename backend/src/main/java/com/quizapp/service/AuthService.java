package com.quizapp.service;

import com.quizapp.dto.AuthResponse;
import com.quizapp.dto.LoginRequest;
import com.quizapp.dto.RegisterRequest;
import com.quizapp.entities.User;
import com.quizapp.entities.Course;
import com.quizapp.entities.CourseEnrollment;
import com.quizapp.entities.Student;
import com.quizapp.entities.enums.USER_ROLE;
import com.quizapp.repository.CourseEnrollmentRepository;
import com.quizapp.repository.CourseRepository;
import com.quizapp.repository.UserRepository;
import com.quizapp.repository.StudentRepository;
import com.quizapp.security.JwtService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import jakarta.persistence.EntityNotFoundException;

@Service
/*
 * Handles registration and login. Spring Security is currently removed, so a
 * successful login returns profile and role information for frontend navigation.
 */
public class AuthService {
    private final UserRepository users;
    private final CourseRepository courses;
    private final CourseEnrollmentRepository enrollments;
    private final LoggingClient logging;
    private final PasswordService passwords;
    private final StudentRepository students;
    private final JwtService tokens;

    public AuthService(UserRepository users, CourseRepository courses,
                       CourseEnrollmentRepository enrollments, LoggingClient logging,
                       PasswordService passwords, StudentRepository students,
                       JwtService tokens) {
        this.users = users;
        this.courses = courses;
        this.enrollments = enrollments;
        this.logging = logging;
        this.passwords = passwords;
        this.students = students;
        this.tokens = tokens;
    }

    @Transactional
    /*
     * Registration always creates a student account; public users cannot choose
     * instructor or admin for themselves. The account and course enrollments are
     * saved together before the new profile is returned.
     */
    public AuthResponse register(RegisterRequest request) {
        if (users.existsByEmailIgnoreCase(request.getEmail())) {
            throw new IllegalArgumentException("An account with this email already exists");
        }
        User user = new User();
        user.setFullName(request.getFullName().trim());
        user.setEmail(request.getEmail().trim().toLowerCase());
        user.setPasswordHash(passwords.prepareForStorage(request.getPassword()));
        user.setRole(USER_ROLE.ROLE_STUDENT);
        User saved = users.save(user);

        Student student = new Student();
        student.setUser(saved);
        student.setBranch(request.getBranch());
        student.setGraduationYear(request.getGraduationYear());
        students.save(student);

        for (Long courseId : request.getCourseIds().stream().distinct().toList()) {
            Course course = courses.findById(courseId)
                    .orElseThrow(() -> new EntityNotFoundException("Selected course not found"));
            CourseEnrollment enrollment = new CourseEnrollment();
            enrollment.setStudent(student);
            enrollment.setCourse(course);
            enrollments.save(enrollment);
        }

        logging.log("USER_REGISTERED", "New student account registered", saved.getId());
        return AuthResponse.from(saved, tokens.create(saved));
    }

    /*
     * Login uses the same error for an unknown email and a wrong password so it
     * does not confirm which email addresses exist.
     */
    public AuthResponse login(LoginRequest request) {
        User user = users.findByEmailIgnoreCase(request.getEmail().trim())
                .orElseThrow(() -> new IllegalArgumentException("Invalid email or password"));
        if (!passwords.matches(request.getPassword(), user.getPasswordHash())) {
            throw new IllegalArgumentException("Invalid email or password");
        }
        if (!passwords.isHashed(user.getPasswordHash())) {
            user.setPasswordHash(passwords.prepareForStorage(request.getPassword()));
            users.save(user);
            logging.log("PASSWORD_STORAGE_UPGRADED", "Legacy password storage upgraded", user.getId());
        }
        logging.log("USER_LOGIN", "User logged in", user.getId());
        return AuthResponse.from(user, tokens.create(user));
    }

}
