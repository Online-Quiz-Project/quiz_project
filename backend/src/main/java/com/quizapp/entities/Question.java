package com.quizapp.entities;

import com.quizapp.entities.enums.QUESTION_TYPE;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "questions")
@Getter
@Setter
@NoArgsConstructor
public class Question extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id", nullable = false)
    private Quiz quiz;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String questionText;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private QUESTION_TYPE questionType;

    @Column(nullable = false)
    private Integer points = 1;

    @Column(nullable = false)
    private Integer displayOrder;

    @Column(columnDefinition = "TEXT")
    private String explanation;

    @Column(length = 100)
    private String skillTag;

    @Column(length = 20)
    private String difficulty;

    @OneToMany(mappedBy = "question", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("displayOrder ASC")
    private List<QuestionOption> options = new ArrayList<>();
}
