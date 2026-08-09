package com.quizapp.dto;

import com.quizapp.entities.enums.USER_ROLE;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class RoleRequest {
    @NotNull
    private USER_ROLE role;
}
