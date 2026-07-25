package com.quizapp.repository;

import com.quizapp.entities.CourseEnrollment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CourseEnrollmentRepository extends JpaRepository<CourseEnrollment, Long> {
    boolean existsByCourseIdAndStudentID(Long courseId, Long studentId);
}
