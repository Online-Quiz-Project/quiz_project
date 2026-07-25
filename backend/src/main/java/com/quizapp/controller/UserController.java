package com.quizapp.controller;

import com.quizapp.entities.User;
import com.quizapp.entities.enums.USER_ROLE;
import com.quizapp.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/students")
    public List<User> getStudents() {
        return userRepository.findByRole(USER_ROLE.ROLE_STUDENT);
    }

    @GetMapping("/instructors")
    public List<User> getInstructors() {
        return userRepository.findByRole(USER_ROLE.ROLE_INSTRUCTOR);
    }

}
