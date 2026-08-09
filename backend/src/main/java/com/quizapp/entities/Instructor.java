package com.quizapp.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "instructors")
@Getter
@Setter
@NoArgsConstructor
public class Instructor {

    @Id
    private Long id;

    /*
     * This shared primary key guarantees that an instructor profile cannot exist
     * without its base user account and cannot be linked to the wrong account.
     */
    @OneToOne(fetch = FetchType.LAZY)
    @MapsId
    @JoinColumn(name = "user_id")
    private User user;

    @Column(length = 100)
    private String department;

    @Column(columnDefinition = "TEXT")
    private String qualifications;

    @OneToMany(mappedBy = "instructor")
    private List<Course> coursesTaught = new ArrayList<>();

    @OneToMany(mappedBy = "createdBy")
    private List<Quiz> quizzesCreated = new ArrayList<>();
}
