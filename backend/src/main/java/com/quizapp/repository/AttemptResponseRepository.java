package com.quizapp.repository;

import com.quizapp.entities.AttemptResponse;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AttemptResponseRepository extends JpaRepository<AttemptResponse, Long> {
    List<AttemptResponse> findByAttemptIdOrderByQuestionDisplayOrderAsc(Long attemptId);
}
