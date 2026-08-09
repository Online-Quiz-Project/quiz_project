package com.quizapp.security;

import com.quizapp.entities.enums.USER_ROLE;

public record AuthenticatedUser(Long userId, String email, USER_ROLE role) {
}
