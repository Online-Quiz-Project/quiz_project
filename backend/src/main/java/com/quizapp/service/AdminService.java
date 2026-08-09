package com.quizapp.service;

import com.quizapp.dto.AdminUserRequest;
import com.quizapp.dto.AdminUserView;
import com.quizapp.dto.CourseRequest;
import com.quizapp.dto.InstructorCourseView;
import com.quizapp.entities.Course;
import com.quizapp.entities.CourseEnrollment;
import com.quizapp.entities.User;
import com.quizapp.entities.Student;
import com.quizapp.entities.Instructor;
import com.quizapp.entities.enums.USER_ROLE;
import com.quizapp.repository.CourseRepository;
import com.quizapp.repository.CourseEnrollmentRepository;
import com.quizapp.repository.UserRepository;
import com.quizapp.repository.StudentRepository;
import com.quizapp.repository.InstructorRepository;
import com.quizapp.repository.QuizAttemptRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AdminService {
    private final UserRepository users;
    private final CourseRepository courses;
    private final PasswordService passwords;
    private final CourseEnrollmentRepository enrollments;
    private final StudentRepository students;
    private final InstructorRepository instructors;
    private final QuizAttemptRepository attempts;
    private final LoggingClient logging;

    public AdminService(UserRepository users, CourseRepository courses,
                        PasswordService passwords, CourseEnrollmentRepository enrollments,
                        StudentRepository students, InstructorRepository instructors,
                        QuizAttemptRepository attempts, LoggingClient logging) {
        this.users = users;
        this.courses = courses;
        this.passwords = passwords;
        this.enrollments = enrollments;
        this.students = students;
        this.instructors = instructors;
        this.attempts = attempts;
        this.logging = logging;
    }

    @Transactional(readOnly = true)
    // Builds the user list shown in the admin panel, including each person's
    // current role and course information.
    public List<AdminUserView> getUsers() {
        return users.findAll().stream().map(AdminUserView::from).toList();
    }

    @Transactional
    // Creates an account on behalf of an administrator. Student accounts are
    // enrolled in every selected course as part of the same database operation.
    public AdminUserView createUser(AdminUserRequest request) {
        if (users.existsByEmailIgnoreCase(request.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
        User user = new User();
        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail().trim().toLowerCase());
        user.setPasswordHash(passwords.prepareForStorage(request.getPassword()));
        user.setRole(request.getRole());
        User saved = users.save(user);
        if (request.getRole() == USER_ROLE.ROLE_STUDENT) {
            Student student = new Student();
            student.setUser(saved);
            student.setBranch(request.getBranch());
            student.setGraduationYear(request.getGraduationYear());
            students.save(student);
            if (request.getCourseIds() == null || request.getCourseIds().isEmpty()) {
                throw new IllegalArgumentException("Select at least one course for a student");
            }
            for (Long courseId : request.getCourseIds().stream().distinct().toList()) {
                Course course = courses.findById(courseId)
                        .orElseThrow(() -> new EntityNotFoundException("Selected course not found"));
                CourseEnrollment enrollment = new CourseEnrollment();
                enrollment.setStudent(student);
                enrollment.setCourse(course);
                enrollments.save(enrollment);
            }
        } else if (request.getRole() == USER_ROLE.ROLE_INSTRUCTOR) {
            Instructor instructor = new Instructor();
            instructor.setUser(saved);
            instructor.setDepartment(request.getDepartment());
            instructor.setQualifications(request.getQualifications());
            instructors.save(instructor);
        }
        logging.log("ADMIN_USER_CREATED", "Created " + saved.getRole() + " account", saved.getId());
        return AdminUserView.from(saved);
    }

    @Transactional
    // Changes the user's role so their next request and next login use the new
    // set of screens and permissions.
    public AdminUserView changeRole(Long userId, USER_ROLE role) {
        User user = users.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        if (user.getRole() == USER_ROLE.ROLE_INSTRUCTOR && role != USER_ROLE.ROLE_INSTRUCTOR
                && courses.existsByInstructorId(userId)) {
            throw new IllegalArgumentException("Reassign this instructor's courses before changing the role");
        }
        if (user.getRole() == USER_ROLE.ROLE_STUDENT && role != USER_ROLE.ROLE_STUDENT
                && (enrollments.existsByStudentId(userId) || attempts.existsByStudentId(userId))) {
            throw new IllegalArgumentException("A student with enrollments or attempts cannot change roles");
        }
        USER_ROLE previousRole = user.getRole();
        user.setRole(role);
        if (role == USER_ROLE.ROLE_STUDENT && !students.existsById(userId)) {
            Student student = new Student();
            student.setUser(user);
            students.save(student);
        }
        if (role == USER_ROLE.ROLE_INSTRUCTOR && !instructors.existsById(userId)) {
            Instructor instructor = new Instructor();
            instructor.setUser(user);
            instructors.save(instructor);
        }
        AdminUserView updated = AdminUserView.from(users.save(user));
        logging.log("USER_ROLE_CHANGED", "Role changed from " + previousRole + " to " + role, userId);
        return updated;
    }

    @Transactional
    // Creates a course and connects it to the instructor chosen by the admin.
    // The role check prevents a student or admin from being assigned by mistake.
    public InstructorCourseView createCourse(CourseRequest request) {
        Instructor instructor = instructors.findById(request.getInstructorId())
                .orElseThrow(() -> new EntityNotFoundException("Instructor not found"));
        if (instructor.getUser().getRole() != USER_ROLE.ROLE_INSTRUCTOR) {
            throw new IllegalArgumentException("Selected user is not an instructor");
        }
        Course course = new Course();
        course.setCourseName(request.getCourseName());
        course.setDescription(request.getDescription());
        course.setInstructor(instructor);
        Course saved = courses.save(course);
        logging.log("COURSE_CREATED", saved.getCourseName() + " assigned to instructor "
                + instructor.getId(), instructor.getId());
        return InstructorCourseView.from(saved);
    }
}
