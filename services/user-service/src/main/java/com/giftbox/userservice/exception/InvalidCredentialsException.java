package com.giftbox.userservice.exception;

/**
 * Invalid Credentials Exception
 * 
 * Thrown when authentication credentials are invalid.
 */
public class InvalidCredentialsException extends RuntimeException {
    
    public InvalidCredentialsException(String message) {
        super(message);
    }
    
    public InvalidCredentialsException(String message, Throwable cause) {
        super(message, cause);
    }
}
