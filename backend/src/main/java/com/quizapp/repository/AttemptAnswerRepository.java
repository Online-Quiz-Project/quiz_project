package com.quizapp.repository;

import com.quizapp.entities.AttemptAnswer;
import jakarta.persistence.Id;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AttemptAnswerRepository extends JpaRepository<AttemptAnswer, Long> {
}
