package com.giftbox.corporateservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Gift Box Corporate Service Application
 * 
 * This is the main Spring Boot application class for the Corporate Service.
 * It handles B2B bulk orders, employee distribution, and corporate client management.
 * 
 * @author Gift Box Team
 * @version 1.0
 */
@SpringBootApplication
@EnableJpaAuditing
@EnableCaching
@EnableKafka
@EnableAsync
@EnableScheduling
@EnableFeignClients
public class CorporateServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(CorporateServiceApplication.class, args);
    }
}
