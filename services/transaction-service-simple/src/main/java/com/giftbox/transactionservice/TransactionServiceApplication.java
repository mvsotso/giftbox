package com.giftbox.transactionservice;

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
public class TransactionServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(TransactionServiceApplication.class, args);
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Transaction Service");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Gift Box Transaction Service");
        response.put("version", "1.0.0");
        response.put("status", "running");
        return response;
    }

    @PostMapping("/api/v1/transactions/create")
    public Map<String, Object> createTransaction(@RequestBody Map<String, Object> transactionData) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Transaction created successfully");
        response.put("transactionId", UUID.randomUUID().toString());
        response.put("amount", transactionData.get("amount"));
        response.put("status", "completed");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/api/v1/transactions")
    public Map<String, Object> getTransactions() {
        Map<String, Object> response = new HashMap<>();
        response.put("transactions", new Object[]{
            Map.of("id", "txn-1", "amount", 25.0, "status", "completed", "type", "purchase"),
            Map.of("id", "txn-2", "amount", 50.0, "status", "completed", "type", "purchase")
        });
        response.put("total", 2);
        response.put("timestamp", LocalDateTime.now());
        return response;
    }
}
