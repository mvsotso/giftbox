package com.giftbox.test;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class SimpleTestApplication {

    public static void main(String[] args) {
        SpringApplication.run(SimpleTestApplication.class, args);
    }

    @GetMapping("/health")
    public String health() {
        return "Simple Test Service is running!";
    }

    @GetMapping("/")
    public String home() {
        return "Gift Box Backend Test Service - All systems operational!";
    }
}
