package com.giftbox.userservice.controller;

import com.giftbox.userservice.dto.AuthResponseDTO;
import com.giftbox.userservice.dto.LoginRequestDTO;
import com.giftbox.userservice.dto.RegisterRequestDTO;
import com.giftbox.userservice.dto.UserDTO;
import com.giftbox.userservice.service.AuthService;
import com.giftbox.userservice.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;
import java.util.UUID;

/**
 * User REST Controller
 * 
 * REST API endpoints for user management and authentication.
 */
@RestController
@RequestMapping("/api/v1/users")
@Tag(name = "User Management", description = "User management and authentication APIs")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:8080", "http://localhost:9081"})
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private AuthService authService;

    /**
     * Register a new user
     */
    @PostMapping("/register")
    @Operation(summary = "Register a new user", description = "Create a new user account")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "User registered successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid input data"),
            @ApiResponse(responseCode = "409", description = "User already exists")
    })
    public ResponseEntity<AuthResponseDTO> register(@Valid @RequestBody RegisterRequestDTO registerRequest) {
        logger.info("Register request received for email: {}", registerRequest.getEmail());
        
        AuthResponseDTO response = authService.register(registerRequest);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * Login user
     */
    @PostMapping("/login")
    @Operation(summary = "Login user", description = "Authenticate user and return JWT tokens")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Login successful"),
            @ApiResponse(responseCode = "400", description = "Invalid credentials"),
            @ApiResponse(responseCode = "404", description = "User not found")
    })
    public ResponseEntity<AuthResponseDTO> login(@Valid @RequestBody LoginRequestDTO loginRequest) {
        logger.info("Login request received for: {}", loginRequest.getEmailOrPhone());
        
        AuthResponseDTO response = authService.login(loginRequest);
        return ResponseEntity.ok(response);
    }

    /**
     * Refresh access token
     */
    @PostMapping("/refresh")
    @Operation(summary = "Refresh access token", description = "Generate new access token using refresh token")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Token refreshed successfully"),
            @ApiResponse(responseCode = "401", description = "Invalid refresh token")
    })
    public ResponseEntity<AuthResponseDTO> refreshToken(@RequestParam String refreshToken) {
        logger.info("Refresh token request received");
        
        AuthResponseDTO response = authService.refreshToken(refreshToken);
        return ResponseEntity.ok(response);
    }

    /**
     * Get user profile
     */
    @GetMapping("/profile")
    @Operation(summary = "Get user profile", description = "Get current user's profile information")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Profile retrieved successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "404", description = "User not found")
    })
    public ResponseEntity<UserDTO> getProfile(@RequestHeader("Authorization") String token) {
        logger.debug("Get profile request received");
        
        String jwtToken = token.substring(7); // Remove "Bearer " prefix
        UserDTO user = userService.findById(UUID.fromString(authService.getUserFromToken(jwtToken).getId().toString()));
        return ResponseEntity.ok(user);
    }

    /**
     * Update user profile
     */
    @PutMapping("/profile")
    @Operation(summary = "Update user profile", description = "Update current user's profile information")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Profile updated successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid input data"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "404", description = "User not found"),
            @ApiResponse(responseCode = "409", description = "Email or phone already exists")
    })
    public ResponseEntity<UserDTO> updateProfile(
            @RequestHeader("Authorization") String token,
            @Valid @RequestBody UserDTO userDTO) {
        logger.info("Update profile request received");
        
        String jwtToken = token.substring(7); // Remove "Bearer " prefix
        UUID userId = authService.getUserFromToken(jwtToken).getId();
        UserDTO updatedUser = userService.updateUser(userId, userDTO);
        return ResponseEntity.ok(updatedUser);
    }

    /**
     * Get user by ID (Admin only)
     */
    @GetMapping("/{id}")
    @Operation(summary = "Get user by ID", description = "Get user information by ID (Admin only)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User retrieved successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "403", description = "Forbidden"),
            @ApiResponse(responseCode = "404", description = "User not found")
    })
    public ResponseEntity<UserDTO> getUserById(@PathVariable UUID id) {
        logger.debug("Get user by ID request received: {}", id);
        
        UserDTO user = userService.findById(id);
        return ResponseEntity.ok(user);
    }

    /**
     * Get all users with pagination (Admin only)
     */
    @GetMapping
    @Operation(summary = "Get all users", description = "Get all users with pagination (Admin only)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Users retrieved successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "403", description = "Forbidden")
    })
    public ResponseEntity<Page<UserDTO>> getAllUsers(
            @Parameter(description = "Pagination parameters") Pageable pageable) {
        logger.debug("Get all users request received");
        
        Page<UserDTO> users = userService.getAllUsers(pageable);
        return ResponseEntity.ok(users);
    }

    /**
     * Search users by name (Admin only)
     */
    @GetMapping("/search")
    @Operation(summary = "Search users by name", description = "Search users by name (Admin only)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Search results retrieved successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "403", description = "Forbidden")
    })
    public ResponseEntity<List<UserDTO>> searchUsers(
            @RequestParam String name) {
        logger.debug("Search users request received for name: {}", name);
        
        List<UserDTO> users = userService.searchUsersByName(name);
        return ResponseEntity.ok(users);
    }

    /**
     * Verify user (Admin only)
     */
    @PostMapping("/{id}/verify")
    @Operation(summary = "Verify user", description = "Verify user account (Admin only)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User verified successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "403", description = "Forbidden"),
            @ApiResponse(responseCode = "404", description = "User not found")
    })
    public ResponseEntity<Void> verifyUser(@PathVariable UUID id) {
        logger.info("Verify user request received for ID: {}", id);
        
        userService.verifyUser(id);
        return ResponseEntity.ok().build();
    }

    /**
     * Activate user (Admin only)
     */
    @PostMapping("/{id}/activate")
    @Operation(summary = "Activate user", description = "Activate user account (Admin only)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User activated successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "403", description = "Forbidden"),
            @ApiResponse(responseCode = "404", description = "User not found")
    })
    public ResponseEntity<Void> activateUser(@PathVariable UUID id) {
        logger.info("Activate user request received for ID: {}", id);
        
        userService.activateUser(id);
        return ResponseEntity.ok().build();
    }

    /**
     * Deactivate user (Admin only)
     */
    @PostMapping("/{id}/deactivate")
    @Operation(summary = "Deactivate user", description = "Deactivate user account (Admin only)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User deactivated successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "403", description = "Forbidden"),
            @ApiResponse(responseCode = "404", description = "User not found")
    })
    public ResponseEntity<Void> deactivateUser(@PathVariable UUID id) {
        logger.info("Deactivate user request received for ID: {}", id);
        
        userService.deactivateUser(id);
        return ResponseEntity.ok().build();
    }

    /**
     * Delete user (Admin only)
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete user", description = "Delete user account (Admin only)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "User deleted successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "403", description = "Forbidden"),
            @ApiResponse(responseCode = "404", description = "User not found")
    })
    public ResponseEntity<Void> deleteUser(@PathVariable UUID id) {
        logger.info("Delete user request received for ID: {}", id);
        
        userService.deleteUser(id);
        return ResponseEntity.ok().build();
    }

    /**
     * Get user statistics (Admin only)
     */
    @GetMapping("/statistics")
    @Operation(summary = "Get user statistics", description = "Get user statistics (Admin only)")
    @SecurityRequirement(name = "bearerAuth")
    @PreAuthorize("hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Statistics retrieved successfully"),
            @ApiResponse(responseCode = "401", description = "Unauthorized"),
            @ApiResponse(responseCode = "403", description = "Forbidden")
    })
    public ResponseEntity<UserService.UserStatistics> getUserStatistics() {
        logger.debug("Get user statistics request received");
        
        UserService.UserStatistics statistics = userService.getUserStatistics();
        return ResponseEntity.ok(statistics);
    }

    /**
     * Health check endpoint
     */
    @GetMapping("/health")
    @Operation(summary = "Health check", description = "Check service health")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Service is healthy")
    })
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("User Service is healthy");
    }
}
