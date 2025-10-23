package com.giftbox.voucherservice;

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
public class VoucherServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(VoucherServiceApplication.class, args);
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("service", "Voucher Service");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/")
    public Map<String, Object> home() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Gift Box Voucher Service");
        response.put("version", "1.0.0");
        response.put("status", "running");
        return response;
    }

    @PostMapping("/api/v1/vouchers/create")
    public Map<String, Object> createVoucher(@RequestBody Map<String, Object> voucherData) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Voucher created successfully");
        response.put("voucherId", UUID.randomUUID().toString());
        response.put("voucherCode", "VOUCHER" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        response.put("value", voucherData.get("value"));
        response.put("status", "active");
        response.put("timestamp", LocalDateTime.now());
        return response;
    }

    @GetMapping("/api/v1/vouchers")
    public Map<String, Object> getVouchers() {
        Map<String, Object> response = new HashMap<>();
        response.put("vouchers", new Object[]{
            Map.of("id", "voucher-1", "code", "VOUCHER123", "value", 10.0, "status", "active"),
            Map.of("id", "voucher-2", "code", "VOUCHER456", "value", 20.0, "status", "active")
        });
        response.put("total", 2);
        response.put("timestamp", LocalDateTime.now());
        return response;
    }
}
