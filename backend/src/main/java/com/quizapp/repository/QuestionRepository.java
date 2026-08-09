package com.quizapp.repository;

import com.quizapp.entities.Question;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Long> {
    List<Question> findByQuizIdOrderByDisplayOrder(Long quizId);
}
