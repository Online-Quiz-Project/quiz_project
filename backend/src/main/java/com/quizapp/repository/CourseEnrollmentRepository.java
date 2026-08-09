package com.quizapp.repository;

import com.quizapp.entities.CourseEnrollment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseEnrollmentRepository extends JpaRepository<CourseEnrollment, Long> {
    boolean existsByCourseIdAndStudentId(Long courseId, Long studentId);
    boolean existsByStudentId(Long studentId);
}
