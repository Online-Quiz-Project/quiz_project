package com.quizapp.repository;

import com.quizapp.entities.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface QuizRepository extends JpaRepository<Quiz, Long> {
    List<Quiz> findByCourseId(Long courseId);

    List<Quiz> findByCreatedById(Long instructorId);

    // A student should only receive published quizzes connected to one of their
    // enrollments. Drafts and quizzes from unrelated courses stay out of the result.
    @Query("select q from Quiz q join q.course c join c.enrollments e " +
            "where e.student.id = :studentId and q.status = QUIZ_STATUS.PUBLISHED")
    List<Quiz> findPublishedForStudent(Long studentId);

    long countByStatus(com.quizapp.entities.enums.QUIZ_STATUS status);
}
