package com.quizapp.dto;

import com.quizapp.entities.enums.QUIZ_STATUS;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class QuizRequest {
    @NotBlank
    private String title;

    private String description;

    @NotNull
    private Long courseId;

    @NotNull
    private Long createdById;

    @NotNull
    @Min(1)
    @Max(300)
    private Integer timeLimitMinutes;

    @NotNull
    @Min(1)
    @Max(100)
    private Integer passPercentage;

    private QUIZ_STATUS status;

    private List<@Valid QuestionRequest> questions;
}
