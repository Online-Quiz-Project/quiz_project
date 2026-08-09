package com.quizapp.dto;

import com.quizapp.entities.Question;
import com.quizapp.entities.QuestionOption;
import com.quizapp.entities.Quiz;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class QuizDetailsView {
    private Long id;
    private String title;
    private String description;
    private Integer timeLimitMinutes;
    private Integer passPercentage;
    private List<QuestionView> questions;

    public static QuizDetailsView from(Quiz quiz) {
        return new QuizDetailsView(
                quiz.getId(),
                quiz.getTitle(),
                quiz.getDescription(),
                quiz.getTimeLimitMinutes(),
                quiz.getPassPercentage(),
                quiz.getQuestions().stream()
                        .map(QuestionView::from)
                        .toList()
        );
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class QuestionView {
        private Long id;
        private String questionText;
        private Integer points;
        private List<OptionView> options;

        private static QuestionView from(Question question) {
            return new QuestionView(
                    question.getId(),
                    question.getQuestionText(),
                    question.getPoints(),
                    question.getOptions().stream()
                            .map(OptionView::from)
                            .toList()
            );
        }
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OptionView {
        private Long id;
        private String optionText;

        private static OptionView from(QuestionOption option) {
            return new OptionView(option.getId(), option.getOptionText());
        }
    }
}
