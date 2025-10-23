package com.giftbox.userservice.service;

import com.giftbox.userservice.dto.RegisterRequestDTO;
import com.giftbox.userservice.dto.UserDTO;
import com.giftbox.userservice.exception.UserAlreadyExistsException;
import com.giftbox.userservice.exception.UserNotFoundException;
import com.giftbox.userservice.model.User;
import com.giftbox.userservice.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * User Service
 * 
 * Business logic layer for user management operations.
 * Handles user CRUD operations, authentication, and profile management.
 */
@Service
@Transactional
public class UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Create a new user
     */
    @Transactional
    public UserDTO createUser(RegisterRequestDTO registerRequest) {
        logger.info("Creating new user with email: {}", registerRequest.getEmail());

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
        logger.info("User created successfully with ID: {}", savedUser.getId());

        return new UserDTO(savedUser);
    }

    /**
     * Find user by ID
     */
    @Cacheable(value = "users", key = "#id")
    @Transactional(readOnly = true)
    public UserDTO findById(UUID id) {
        logger.debug("Finding user by ID: {}", id);
        
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + id));
        
        return new UserDTO(user);
    }

    /**
     * Find user by email
     */
    @Cacheable(value = "users", key = "'email:' + #email")
    @Transactional(readOnly = true)
    public UserDTO findByEmail(String email) {
        logger.debug("Finding user by email: {}", email);
        
        User user = userRepository.findActiveUserByEmail(email)
                .orElseThrow(() -> new UserNotFoundException("User not found with email: " + email));
        
        return new UserDTO(user);
    }

    /**
     * Find user by email or phone
     */
    @Transactional(readOnly = true)
    public UserDTO findByEmailOrPhone(String emailOrPhone) {
        logger.debug("Finding user by email or phone: {}", emailOrPhone);
        
        User user = userRepository.findByEmailOrPhone(emailOrPhone)
                .orElseThrow(() -> new UserNotFoundException("User not found with email or phone: " + emailOrPhone));
        
        return new UserDTO(user);
    }

    /**
     * Update user profile
     */
    @CachePut(value = "users", key = "#id")
    @Transactional
    public UserDTO updateUser(UUID id, UserDTO userDTO) {
        logger.info("Updating user with ID: {}", id);
        
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + id));

        // Check if email is being changed and if it already exists
        if (!user.getEmail().equals(userDTO.getEmail()) && 
            userRepository.existsByEmailAndIdNot(userDTO.getEmail(), id)) {
            throw new UserAlreadyExistsException("User with email " + userDTO.getEmail() + " already exists");
        }

        // Check if phone is being changed and if it already exists
        if (userDTO.getPhone() != null && 
            (user.getPhone() == null || !user.getPhone().equals(userDTO.getPhone())) &&
            userRepository.existsByPhoneAndIdNot(userDTO.getPhone(), id)) {
            throw new UserAlreadyExistsException("User with phone " + userDTO.getPhone() + " already exists");
        }

        // Update user fields
        user.setEmail(userDTO.getEmail());
        user.setPhone(userDTO.getPhone());
        user.setFirstName(userDTO.getFirstName());
        user.setLastName(userDTO.getLastName());
        user.setDateOfBirth(userDTO.getDateOfBirth());
        user.setGender(userDTO.getGender());
        user.setProfileImageUrl(userDTO.getProfileImageUrl());

        User updatedUser = userRepository.save(user);
        logger.info("User updated successfully with ID: {}", updatedUser.getId());

        return new UserDTO(updatedUser);
    }

    /**
     * Delete user (soft delete)
     */
    @CacheEvict(value = "users", key = "#id")
    @Transactional
    public void deleteUser(UUID id) {
        logger.info("Deleting user with ID: {}", id);
        
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + id));
        
        user.softDelete();
        userRepository.save(user);
        
        logger.info("User deleted successfully with ID: {}", id);
    }

    /**
     * Get all active users
     */
    @Transactional(readOnly = true)
    public List<UserDTO> getAllActiveUsers() {
        logger.debug("Getting all active users");
        
        List<User> users = userRepository.findAllActiveUsers();
        return users.stream()
                .map(UserDTO::new)
                .collect(Collectors.toList());
    }

    /**
     * Get users with pagination
     */
    @Transactional(readOnly = true)
    public Page<UserDTO> getAllUsers(Pageable pageable) {
        logger.debug("Getting users with pagination: {}", pageable);
        
        Page<User> users = userRepository.findAll(pageable);
        return users.map(UserDTO::new);
    }

    /**
     * Search users by name
     */
    @Transactional(readOnly = true)
    public List<UserDTO> searchUsersByName(String name) {
        logger.debug("Searching users by name: {}", name);
        
        List<User> users = userRepository.findByNameContainingIgnoreCase(name);
        return users.stream()
                .map(UserDTO::new)
                .collect(Collectors.toList());
    }

    /**
     * Verify user
     */
    @CacheEvict(value = "users", key = "#id")
    @Transactional
    public void verifyUser(UUID id) {
        logger.info("Verifying user with ID: {}", id);
        
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + id));
        
        user.setIsVerified(true);
        userRepository.save(user);
        
        logger.info("User verified successfully with ID: {}", id);
    }

    /**
     * Activate user
     */
    @CacheEvict(value = "users", key = "#id")
    @Transactional
    public void activateUser(UUID id) {
        logger.info("Activating user with ID: {}", id);
        
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + id));
        
        user.setIsActive(true);
        userRepository.save(user);
        
        logger.info("User activated successfully with ID: {}", id);
    }

    /**
     * Deactivate user
     */
    @CacheEvict(value = "users", key = "#id")
    @Transactional
    public void deactivateUser(UUID id) {
        logger.info("Deactivating user with ID: {}", id);
        
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + id));
        
        user.setIsActive(false);
        userRepository.save(user);
        
        logger.info("User deactivated successfully with ID: {}", id);
    }

    /**
     * Update last login time
     */
    @CacheEvict(value = "users", key = "#id")
    @Transactional
    public void updateLastLoginTime(UUID id) {
        logger.debug("Updating last login time for user ID: {}", id);
        
        userRepository.updateLastLoginTime(id, LocalDateTime.now());
    }

    /**
     * Change password
     */
    @CacheEvict(value = "users", key = "#id")
    @Transactional
    public void changePassword(UUID id, String newPassword) {
        logger.info("Changing password for user ID: {}", id);
        
        User user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("User not found with ID: " + id));
        
        user.setPasswordHash(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        
        logger.info("Password changed successfully for user ID: {}", id);
    }

    /**
     * Check if user exists by email
     */
    @Transactional(readOnly = true)
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * Check if user exists by phone
     */
    @Transactional(readOnly = true)
    public boolean existsByPhone(String phone) {
        return userRepository.existsByPhone(phone);
    }

    /**
     * Get user statistics
     */
    @Transactional(readOnly = true)
    public UserStatistics getUserStatistics() {
        logger.debug("Getting user statistics");
        
        long totalUsers = userRepository.countActiveUsers();
        long verifiedUsers = userRepository.countVerifiedUsers();
        long unverifiedUsers = totalUsers - verifiedUsers;
        
        return new UserStatistics(totalUsers, verifiedUsers, unverifiedUsers);
    }

    /**
     * User Statistics DTO
     */
    public static class UserStatistics {
        private final long totalUsers;
        private final long verifiedUsers;
        private final long unverifiedUsers;

        public UserStatistics(long totalUsers, long verifiedUsers, long unverifiedUsers) {
            this.totalUsers = totalUsers;
            this.verifiedUsers = verifiedUsers;
            this.unverifiedUsers = unverifiedUsers;
        }

        public long getTotalUsers() { return totalUsers; }
        public long getVerifiedUsers() { return verifiedUsers; }
        public long getUnverifiedUsers() { return unverifiedUsers; }
    }
}
