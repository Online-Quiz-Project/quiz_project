package com.quizapp.repository;

import com.quizapp.entities.Quiz;
import com.quizapp.entities.enums.QUIZ_STATUS;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {
    List<Quiz> findByCourseId(Long courseId);

    List<Quiz> findByCreatedId(Long instructorId);

    // For some reason, I'm not able to directly to use QUIZ_STATUS enum directly
    @Query("select q from Quiz q join q.course c join c.enrollments e " +
            "where e.student.id = :studentId and q.status = com.quizapp.entities.enums.QUIZ_STATUS.PUBLISHED")
    List<Quiz> findPublishedForStudent(Long studentId);

    long countByStatus(QUIZ_STATUS status);
}
