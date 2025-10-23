package com.giftbox.merchantservice;

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
public class MerchantServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(MerchantServiceApplication.class, args);
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Merchant Service");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Gift Box Merchant Service");
        response.put("version", "1.0.0");
        response.put("status", "running");
        return response;
    }

    @PostMapping("/api/v1/merchants/register")
    public Map<String, Object> registerMerchant(@RequestBody Map<String, Object> merchantData) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Merchant registered successfully");
        response.put("merchantId", UUID.randomUUID().toString());
        response.put("businessName", merchantData.get("businessName"));
        response.put("businessEmail", merchantData.get("businessEmail"));
        response.put("status", "pending_verification");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/api/v1/merchants")
    public Map<String, Object> getMerchants() {
        Map<String, Object> response = new HashMap<>();
        response.put("merchants", new Object[]{
            Map.of("id", "merchant-1", "name", "Demo Restaurant", "status", "verified"),
            Map.of("id", "merchant-2", "name", "Demo Spa", "status", "verified")
        });
        response.put("total", 2);
        response.put("timestamp", LocalDateTime.now());
        return response;
    }
}
