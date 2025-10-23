package com.giftbox.userservice.service;

import com.giftbox.userservice.dto.AuthResponseDTO;
import com.giftbox.userservice.dto.LoginRequestDTO;
import com.giftbox.userservice.dto.RegisterRequestDTO;
import com.giftbox.userservice.exception.InvalidCredentialsException;
import com.giftbox.userservice.exception.UserAlreadyExistsException;
import com.giftbox.userservice.exception.UserNotFoundException;
import com.giftbox.userservice.model.User;
import com.giftbox.userservice.repository.UserRepository;
import com.giftbox.userservice.security.JwtTokenProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Authentication Service
 * 
 * Handles user authentication, registration, and token management.
 */
@Service
@Transactional
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    /**
     * Register a new user
     */
    @Transactional
    public AuthResponseDTO register(RegisterRequestDTO registerRequest) {
        logger.info("Registering new user with email: {}", registerRequest.getEmail());

        // Check if user already exists
        if (userRepository.existsByEmail(registerRequest.getEmail())) {
            throw new UserAlreadyExistsException("User with email " + registerRequest.getEmail() + " already exists");
        }

        if (registerRequest.getPhone() != null && userRepository.existsByPhone(registerRequest.getPhone())) {
            throw new UserAlreadyExistsException("User with phone " + registerRequest.getPhone() + " already exists");
        }

        // Create new user
        User user = new User();
        user.setEmail(registerRequest.getEmail());
        user.setPhone(registerRequest.getPhone());
        user.setPasswordHash(passwordEncoder.encode(registerRequest.getPassword()));
        user.setFirstName(registerRequest.getFirstName());
        user.setLastName(registerRequest.getLastName());
        user.setDateOfBirth(registerRequest.getDateOfBirth());
        user.setGender(registerRequest.getGender());
        user.setIsVerified(false);
        user.setIsActive(true);

        User savedUser = userRepository.save(user);
        logger.info("User registered successfully with ID: {}", savedUser.getId());

        // Generate tokens
        String accessToken = jwtTokenProvider.generateAccessToken(savedUser);
        String refreshToken = jwtTokenProvider.generateRefreshToken(savedUser);
        LocalDateTime expiresAt = LocalDateTime.now().plusSeconds(jwtTokenProvider.getAccessTokenValidityInSeconds());

        return new AuthResponseDTO(
                savedUser.getId(),
                savedUser.getEmail(),
                savedUser.getFirstName(),
                savedUser.getLastName(),
                accessToken,
                refreshToken,
                (long) jwtTokenProvider.getAccessTokenValidityInSeconds(),
                expiresAt,
                savedUser.getIsVerified(),
                savedUser.getIsActive()
        );
    }

    /**
     * Login user
     */
    @Transactional(readOnly = true)
    public AuthResponseDTO login(LoginRequestDTO loginRequest) {
        logger.info("Login attempt for: {}", loginRequest.getEmailOrPhone());

        // Find user by email or phone
        User user = userRepository.findByEmailOrPhone(loginRequest.getEmailOrPhone())
                .orElseThrow(() -> new UserNotFoundException("User not found with email or phone: " + loginRequest.getEmailOrPhone()));

        // Check if user is active
        if (!user.getIsActive()) {
            throw new InvalidCredentialsException("User account is deactivated");
        }

        // Verify password
        if (!passwordEncoder.matches(loginRequest.getPassword(), user.getPasswordHash())) {
            throw new InvalidCredentialsException("Invalid password");
        }

        // Update last login time
        user.setLastLoginAt(LocalDateTime.now());
        userRepository.save(user);

        // Generate tokens
        String accessToken = jwtTokenProvider.generateAccessToken(user);
        String refreshToken = jwtTokenProvider.generateRefreshToken(user);
        LocalDateTime expiresAt = LocalDateTime.now().plusSeconds(jwtTokenProvider.getAccessTokenValidityInSeconds());

        logger.info("User logged in successfully with ID: {}", user.getId());

        return new AuthResponseDTO(
                user.getId(),
                user.getEmail(),
                user.getFirstName(),
                user.getLastName(),
                accessToken,
                refreshToken,
                (long) jwtTokenProvider.getAccessTokenValidityInSeconds(),
                expiresAt,
                user.getIsVerified(),
                user.getIsActive()
        );
    }

    /**
     * Refresh access token
     */
    @Transactional(readOnly = true)
    public AuthResponseDTO refreshToken(String refreshToken) {
        logger.info("Refreshing token");

        if (!jwtTokenProvider.validateToken(refreshToken)) {
            throw new InvalidCredentialsException("Invalid refresh token");
        }

        String userId = jwtTokenProvider.getUserIdFromToken(refreshToken);
        User user = userRepository.findById(UUID.fromString(userId))
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + userId));

        if (!user.getIsActive()) {
            throw new InvalidCredentialsException("User account is deactivated");
        }

        // Generate new tokens
        String newAccessToken = jwtTokenProvider.generateAccessToken(user);
        String newRefreshToken = jwtTokenProvider.generateRefreshToken(user);
        LocalDateTime expiresAt = LocalDateTime.now().plusSeconds(jwtTokenProvider.getAccessTokenValidityInSeconds());

        logger.info("Token refreshed successfully for user ID: {}", user.getId());

        return new AuthResponseDTO(
                user.getId(),
                user.getEmail(),
                user.getFirstName(),
                user.getLastName(),
                newAccessToken,
                newRefreshToken,
                (long) jwtTokenProvider.getAccessTokenValidityInSeconds(),
                expiresAt,
                user.getIsVerified(),
                user.getIsActive()
        );
    }

    /**
     * Validate token
     */
    @Transactional(readOnly = true)
    public boolean validateToken(String token) {
        return jwtTokenProvider.validateToken(token);
    }

    /**
     * Get user from token
     */
    @Transactional(readOnly = true)
    public User getUserFromToken(String token) {
        String userId = jwtTokenProvider.getUserIdFromToken(token);
        return userRepository.findById(UUID.fromString(userId))
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + userId));
    }

    /**
     * Logout user (invalidate token)
     */
    @Transactional
    public void logout(String token) {
        logger.info("Logging out user");
        // In a real implementation, you might want to blacklist the token
        // For now, we'll just log the logout
        jwtTokenProvider.invalidateToken(token);
    }
}
