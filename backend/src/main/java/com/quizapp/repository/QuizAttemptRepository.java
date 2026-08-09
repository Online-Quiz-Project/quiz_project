package com.quizapp.repository;

import com.quizapp.entities.QuizAttempt;
import com.quizapp.entities.enums.ATTEMPT_STATUS;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, Long> {
    boolean existsByStudentId(Long studentId);
    boolean existsByQuizId(Long quizId);
    List<QuizAttempt> findByStudentIdOrderByCreatedAtDesc(Long studentId);
    Optional<QuizAttempt> findFirstByQuizIdAndStudentIdAndStatusOrderByCreatedAtDesc(
            Long quizId, Long studentId, ATTEMPT_STATUS status);

    @Query("select count(a) from QuizAttempt a where a.score >= a.quiz.passPercentage")
    long countPassed();

    @Query("select count(a) from QuizAttempt a where a.score < a.quiz.passPercentage")
    long countFailed();

    @Query("select coalesce(avg(a.score), 0) from QuizAttempt a where a.score is not null")
    Double averageScore();
}
