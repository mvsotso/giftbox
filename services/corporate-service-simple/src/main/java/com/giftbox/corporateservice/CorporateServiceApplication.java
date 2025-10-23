package com.giftbox.corporateservice;

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
public class CorporateServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(CorporateServiceApplication.class, args);
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Corporate Service");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Gift Box Corporate Service");
        response.put("version", "1.0.0");
        response.put("status", "running");
        return response;
    }

    @PostMapping("/api/v1/corporate/register")
    public Map<String, Object> registerCorporate(@RequestBody Map<String, Object> corporateData) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Corporate client registered successfully");
        response.put("corporateId", UUID.randomUUID().toString());
        response.put("companyName", corporateData.get("companyName"));
        response.put("contactEmail", corporateData.get("contactEmail"));
        response.put("status", "active");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/api/v1/corporate/clients")
    public Map<String, Object> getCorporateClients() {
        Map<String, Object> response = new HashMap<>();
        response.put("clients", new Object[]{
            Map.of("id", "corp-1", "name", "Demo Corp", "email", "corp@demo.com", "status", "active"),
            Map.of("id", "corp-2", "name", "Test Corp", "email", "corp@test.com", "status", "active")
        });
        response.put("total", 2);
        response.put("timestamp", LocalDateTime.now());
        return response;
    }
}
