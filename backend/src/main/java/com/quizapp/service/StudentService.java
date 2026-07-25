package com.quizapp.service;

import com.quizapp.dtos.StudentProfileView;
import com.quizapp.entities.Course;
import com.quizapp.entities.CourseEnrollment;
import com.quizapp.entities.User;
import com.quizapp.entities.enums.USER_ROLE;
import com.quizapp.repository.CourseEnrollmentRepository;
import com.quizapp.repository.CourseRepository;
import com.quizapp.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StudentService {
    private final UserRepository users;
    private final CourseRepository courses;
    private final CourseEnrollmentRepository enrollments;


    public StudentService(UserRepository users, CourseRepository courses, CourseEnrollmentRepository enrollments) {
        this.users = users;
        this.courses = courses;
        this.enrollments = enrollments;
    }

    @Transactional(readOnly = true)
    public StudentProfileView getProfile(Long studentId) {
        User student = users.findById(studentId).orElseThrow(() -> new EntityNotFoundException(("Student not found")));

        return new StudentProfileView(student.getId(), student.getFullName(), student.getEmail(),
                    courses.findForStudent(studentId).stream().map(
                            course -> new StudentProfileView.CourseView(
                                    course.getId(),
                                    course.getCourseName(),
                                    course.getInstructor().getFullName()
                            )
                    ).toList()
        );
    }

    @Transactional(readOnly = true)
    public StudentProfileView enroll(Long studentId, Long courseId, String signedInEmail) {
        User student = users.findById(studentId).orElseThrow(() -> new EntityNotFoundException("Student nnt found"));
        if (student.getRole() != USER_ROLE.ROLE_STUDENT) {
            throw new IllegalArgumentException("Selected user is not a student");
        }
        if (!student.getEmail().equalsIgnoreCase(signedInEmail)) {
            throw new IllegalArgumentException("You can only add courses to your own account");
        }
        Course course = courses.findById(courseId).orElseThrow(() -> new EntityNotFoundException("Course not found"));
        if (enrollments.existsByCourseIdAndStudentID(courseId, studentId)) {
            throw new IllegalArgumentException("You are already enrolled in this course");
        }

        CourseEnrollment enrollment = new CourseEnrollment();
        enrollment.setStudent(student);
        enrollment.setCourse(course);
        enrollments.save(enrollment);
        return getProfile(studentId);

    }
}
