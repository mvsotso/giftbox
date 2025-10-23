package com.giftbox.userservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@SpringBootApplication
@RestController
public class UserServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(UserServiceApplication.class, args);
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "User Service");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Gift Box User Service");
        response.put("version", "1.0.0");
        response.put("status", "running");
        return response;
    }

    @PostMapping("/api/v1/users/register")
    public Map<String, Object> register(@RequestBody Map<String, Object> userData) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "User registered successfully");
        response.put("userId", UUID.randomUUID().toString());
        response.put("username", userData.get("username"));
        response.put("email", userData.get("email"));
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @PostMapping("/api/v1/users/login")
    public Map<String, Object> login(@RequestBody Map<String, Object> loginData) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Login successful");
        response.put("accessToken", "mock-access-token-" + UUID.randomUUID().toString());
        response.put("refreshToken", "mock-refresh-token-" + UUID.randomUUID().toString());
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/api/v1/users/profile")
    public Map<String, Object> getProfile() {
        Map<String, Object> response = new HashMap<>();
        response.put("userId", "mock-user-id");
        response.put("username", "demo_user");
        response.put("email", "demo@example.com");
        response.put("status", "active");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }
}
