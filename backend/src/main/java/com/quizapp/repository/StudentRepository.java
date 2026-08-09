package com.quizapp.repository;

import com.quizapp.entities.Student;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StudentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findByUserEmailIgnoreCase(String email);
}
