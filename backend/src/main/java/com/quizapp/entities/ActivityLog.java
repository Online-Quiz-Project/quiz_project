package com.quizapp.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "activity_logs")
@Getter
@Setter
@NoArgsConstructor
public class ActivityLog extends BaseEntity {

    @Column(nullable = false, length = 60)
    private String eventType;

    @Column(nullable = false, length = 500)
    private String message;

    private Long userId;
}
