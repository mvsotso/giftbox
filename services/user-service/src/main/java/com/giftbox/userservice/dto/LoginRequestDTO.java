package com.giftbox.userservice.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * Login Request DTO
 * 
 * Used for user authentication requests.
 */
public class LoginRequestDTO {

    @NotBlank(message = "Email or phone is required")
    private String emailOrPhone;

    @NotBlank(message = "Password is required")
    private String password;

    // Constructors
    public LoginRequestDTO() {}

    public LoginRequestDTO(String emailOrPhone, String password) {
        this.emailOrPhone = emailOrPhone;
        this.password = password;
    }

    // Getters and Setters
    public String getEmailOrPhone() {
        return emailOrPhone;
    }

    public void setEmailOrPhone(String emailOrPhone) {
        this.emailOrPhone = emailOrPhone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "LoginRequestDTO{" +
                "emailOrPhone='" + emailOrPhone + '\'' +
                '}';
    }
}
