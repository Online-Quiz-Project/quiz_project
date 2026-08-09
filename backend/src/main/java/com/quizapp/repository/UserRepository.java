package com.quizapp.repository;

import com.quizapp.entities.User;
import com.quizapp.entities.enums.USER_ROLE;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByRole(USER_ROLE userRole);
    long countByRole(USER_ROLE userRole);
    Optional<User> findByEmailIgnoreCase(String email);
    boolean existsByEmailIgnoreCase(String email);
}
