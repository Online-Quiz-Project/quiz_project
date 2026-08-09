package com.quizapp.dto;

import com.quizapp.entities.Quiz;
import com.quizapp.entities.enums.QUIZ_STATUS;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class QuizView {
    private Long id;
    private String title;
    private String description;
    private Long courseId;
    private String courseName;
    private Integer timeLimitMinutes;
    private Integer passPercentage;
    private QUIZ_STATUS status;
    private int questionCount;

    public static QuizView from(Quiz quiz) {
        return new QuizView(
                quiz.getId(),
                quiz.getTitle(),
                quiz.getDescription(),
                quiz.getCourse().getId(),
                quiz.getCourse().getCourseName(),
                quiz.getTimeLimitMinutes(),
                quiz.getPassPercentage(),
                quiz.getStatus(),
                quiz.getQuestions().size()
        );
    }
}
