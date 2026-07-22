package com.quizapp.entities;

import com.quizapp.entities.enums.ATTEMPT_STATUS;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "quiz_attempt")
@Getter
@Setter
@NoArgsConstructor
public class QuizAttempt extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    @Column(nullable = false)
    private LocalDateTime startedAt;

    @Column(nullable = false)
    private LocalDateTime serverDeadline;

    private LocalDateTime submittedAt;

    private BigDecimal score;

    private Integer totalQuestions;

    private Integer correctAnswers;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ATTEMPT_STATUS status = ATTEMPT_STATUS.IN_PROGRESS;

    @OneToMany(mappedBy = "attempt", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AttemptAnswer> answers = new ArrayList<>();
}