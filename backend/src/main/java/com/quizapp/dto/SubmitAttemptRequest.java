package com.quizapp.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SubmitAttemptRequest {
    @NotNull
    private List<@Valid AnswerRequest> answers;

    private boolean timedOut;

    @jakarta.validation.constraints.Min(0)
    private int proctorWarnings;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AnswerRequest {
        @NotNull
        private Long questionId;

        @NotNull
        private Long selectedOptionId;
    }
}
