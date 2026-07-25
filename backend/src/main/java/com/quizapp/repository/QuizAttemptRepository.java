package com.quizapp.repository;

import com.quizapp.entities.QuizAttempt;
import com.quizapp.entities.enums.ATTEMPT_STATUS;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, Long> {

    List<QuizAttempt> findByStudentIdOrderByCreatedAtDesc(Long studentId);

    @Query("SELECT q FROM QuizAttempt q WHERE q.quiz.id = :quizId AND q.student.id = :studentId AND q.status =  :status ORDER BY q.createdAt")
    Optional<QuizAttempt> findFirstByQuizIdAndStudentIdAndStatusOrderByCreatedAtDesc(Long quizId, Long studentId, ATTEMPT_STATUS status);

    @Query("SELECT COUNT(a) FROM QuizAttempt a where a.score >= a.quiz.passPercentage")
    long countPassed();

    @Query("SELECT COUNT(a) FROM QuizAttempt a where a.score < a.quiz.passPercentage")
    long countFailed();

    @Query("SELECT coalesce(avg(a.score), 0) FROM QuizAttempt a where a.score is not null")
    long averageScore();

}
