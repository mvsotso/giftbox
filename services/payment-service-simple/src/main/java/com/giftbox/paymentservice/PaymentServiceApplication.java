package com.giftbox.paymentservice;

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
public class PaymentServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(PaymentServiceApplication.class, args);
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Payment Service");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Gift Box Payment Service");
        response.put("version", "1.0.0");
        response.put("status", "running");
        return response;
    }

    @PostMapping("/api/v1/payments/process")
    public Map<String, Object> processPayment(@RequestBody Map<String, Object> paymentData) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Payment processed successfully");
        response.put("paymentId", UUID.randomUUID().toString());
        response.put("amount", paymentData.get("amount"));
        response.put("method", paymentData.get("method"));
        response.put("status", "completed");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/api/v1/payments")
    public Map<String, Object> getPayments() {
        Map<String, Object> response = new HashMap<>();
        response.put("payments", new Object[]{
            Map.of("id", "pay-1", "amount", 25.0, "method", "credit_card", "status", "completed"),
            Map.of("id", "pay-2", "amount", 50.0, "method", "bank_transfer", "status", "completed")
        });
        response.put("total", 2);
        response.put("timestamp", LocalDateTime.now());
        return response;
    }
}
