package com.quizapp.dto;

import com.quizapp.entities.enums.QUESTION_TYPE;
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
public class QuestionRequest {
    @NotBlank
    private String questionText;

    @NotNull
    private QUESTION_TYPE questionType;

    @Min(1)
    @Max(100)
    private Integer points;

    @Size(max = 5000)
    private String explanation;

    @Size(max = 100)
    private String skillTag;

    @Pattern(regexp = "(?i)easy|medium|hard", message = "must be easy, medium, or hard")
    private String difficulty;

    @NotEmpty
    @Size(min = 2, max = 6)
    private List<@Valid OptionRequest> options;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OptionRequest {
        @NotBlank
        private String optionText;

        private boolean correct;
    }
}
