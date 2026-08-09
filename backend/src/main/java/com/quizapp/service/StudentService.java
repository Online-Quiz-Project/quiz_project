package com.quizapp.service;

import com.quizapp.dto.StudentProfileView;
import com.quizapp.entities.Course;
import com.quizapp.entities.CourseEnrollment;
import com.quizapp.entities.Student;
import com.quizapp.entities.User;
import com.quizapp.entities.enums.USER_ROLE;
import com.quizapp.repository.CourseEnrollmentRepository;
import com.quizapp.repository.CourseRepository;
import com.quizapp.repository.StudentRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StudentService {
    private final CourseRepository courses;
    private final CourseEnrollmentRepository enrollments;
    private final StudentRepository students;
    private final LoggingClient logging;

    public StudentService(CourseRepository courses,
                          CourseEnrollmentRepository enrollments, StudentRepository students,
                          LoggingClient logging) {
        this.courses = courses;
        this.enrollments = enrollments;
        this.students = students;
        this.logging = logging;
    }

    @Transactional(readOnly = true)
    // Builds the profile shown to a student, including every enrolled course and
    // the instructor responsible for each one.
    public StudentProfileView getProfile(Long studentId) {
        Student student = students.findById(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student not found"));
        User user = student.getUser();
        return new StudentProfileView(
                user.getId(),
                user.getFullName(),
                user.getEmail(),
                student.getBranch(),
                student.getGraduationYear(),
                courses.findForStudent(studentId).stream()
                        .map(course -> new StudentProfileView.CourseView(
                                course.getId(),
                                course.getCourseName(),
                                course.getInstructor().getUser().getFullName()))
                        .toList()
        );
    }

    @Transactional
    // Adds a course to the signed-in student's profile after checking ownership,
    // role, course availability, and duplicate enrollment.
    public StudentProfileView enroll(Long studentId, Long courseId) {
        Student student = students.findById(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student not found"));
        User user = student.getUser();
        if (user.getRole() != USER_ROLE.ROLE_STUDENT) {
            throw new IllegalArgumentException("Selected user is not a student");
        }
        Course course = courses.findById(courseId)
                .orElseThrow(() -> new EntityNotFoundException("Course not found"));
        if (enrollments.existsByCourseIdAndStudentId(courseId, studentId)) {
            throw new IllegalArgumentException("You are already enrolled in this course");
        }

        CourseEnrollment enrollment = new CourseEnrollment();
        enrollment.setStudent(student);
        enrollment.setCourse(course);
        enrollments.save(enrollment);
        logging.log("COURSE_ENROLLED", "Enrolled in " + course.getCourseName(), studentId);
        return getProfile(studentId);
    }
}
