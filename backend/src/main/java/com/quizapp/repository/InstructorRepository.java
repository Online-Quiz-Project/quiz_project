package com.quizapp.repository;

import com.quizapp.entities.Instructor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface InstructorRepository extends JpaRepository<Instructor, Long> {
    Optional<Instructor> findByUserEmailIgnoreCase(String email);

    // A profile response needs shared name/email fields as well as instructor-only
    // fields, so load the linked user before the database session closes.
    @Query("select i from Instructor i join fetch i.user where i.id = :id")
    Optional<Instructor> findProfileById(Long id);
}
