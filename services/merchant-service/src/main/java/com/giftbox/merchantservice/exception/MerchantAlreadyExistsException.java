package com.giftbox.merchantservice.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * Exception thrown when a merchant with the same email, phone, or business registration number already exists.
 */
@ResponseStatus(HttpStatus.CONFLICT)
public class MerchantAlreadyExistsException extends RuntimeException {
    public MerchantAlreadyExistsException(String message) {
        super(message);
    }
}
