package com.quizapp.repository;

import com.quizapp.entities.Question;
import org.springframework.data.jpa.repository.JpaRepository;

public interface QuestionRepository extends JpaRepository<Question, JpaRepository> {
}
