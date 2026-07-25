package com.quizapp.repository;

import com.quizapp.entities.User;
import com.quizapp.entities.enums.USER_ROLE;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByRole(USER_ROLE userRole);
    long countByRole(USER_ROLE userRole);
    Optional<User> findByEmailIgnoreCase(String email);
    boolean existsByEmailIgnoreCase(String email);
}
