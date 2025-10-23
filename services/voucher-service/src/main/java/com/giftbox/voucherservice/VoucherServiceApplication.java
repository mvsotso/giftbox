package com.giftbox.voucherservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Gift Box Voucher Service Application
 * 
 * This is the main Spring Boot application class for the Voucher Service.
 * It handles voucher creation, validation, redemption, and fraud detection.
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
public class VoucherServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(VoucherServiceApplication.class, args);
    }
}
