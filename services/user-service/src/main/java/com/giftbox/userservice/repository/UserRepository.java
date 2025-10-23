package com.giftbox.userservice.repository;

import com.giftbox.userservice.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * User Repository
 * 
 * Data access layer for User entities.
 * Provides methods for querying and managing user data.
 */
@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

    /**
     * Find user by email
     */
    Optional<User> findByEmail(String email);

    /**
     * Find user by phone number
     */
    Optional<User> findByPhone(String phone);

    /**
     * Find active user by email
     */
    @Query("SELECT u FROM User u WHERE u.email = :email AND u.isActive = true AND u.deletedAt IS NULL")
    Optional<User> findActiveUserByEmail(@Param("email") String email);

    /**
     * Find active user by phone
     */
    @Query("SELECT u FROM User u WHERE u.phone = :phone AND u.isActive = true AND u.deletedAt IS NULL")
    Optional<User> findActiveUserByPhone(@Param("phone") String phone);

    /**
     * Find user by email or phone
     */
    @Query("SELECT u FROM User u WHERE (u.email = :emailOrPhone OR u.phone = :emailOrPhone) AND u.isActive = true AND u.deletedAt IS NULL")
    Optional<User> findByEmailOrPhone(@Param("emailOrPhone") String emailOrPhone);

    /**
     * Check if email exists
     */
    boolean existsByEmail(String email);

    /**
     * Check if phone exists
     */
    boolean existsByPhone(String phone);

    /**
     * Check if email exists for different user
     */
    @Query("SELECT COUNT(u) > 0 FROM User u WHERE u.email = :email AND u.id != :userId AND u.deletedAt IS NULL")
    boolean existsByEmailAndIdNot(@Param("email") String email, @Param("userId") UUID userId);

    /**
     * Check if phone exists for different user
     */
    @Query("SELECT COUNT(u) > 0 FROM User u WHERE u.phone = :phone AND u.id != :userId AND u.deletedAt IS NULL")
    boolean existsByPhoneAndIdNot(@Param("phone") String phone, @Param("userId") UUID userId);

    /**
     * Find all active users
     */
    @Query("SELECT u FROM User u WHERE u.isActive = true AND u.deletedAt IS NULL")
    List<User> findAllActiveUsers();

    /**
     * Find users created after specific date
     */
    @Query("SELECT u FROM User u WHERE u.createdAt >= :date AND u.isActive = true AND u.deletedAt IS NULL")
    List<User> findUsersCreatedAfter(@Param("date") LocalDateTime date);

    /**
     * Find users with last login before specific date (inactive users)
     */
    @Query("SELECT u FROM User u WHERE u.lastLoginAt < :date OR u.lastLoginAt IS NULL AND u.isActive = true AND u.deletedAt IS NULL")
    List<User> findInactiveUsers(@Param("date") LocalDateTime date);

    /**
     * Find verified users
     */
    @Query("SELECT u FROM User u WHERE u.isVerified = true AND u.isActive = true AND u.deletedAt IS NULL")
    List<User> findVerifiedUsers();

    /**
     * Find unverified users
     */
    @Query("SELECT u FROM User u WHERE u.isVerified = false AND u.isActive = true AND u.deletedAt IS NULL")
    List<User> findUnverifiedUsers();

    /**
     * Count active users
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.isActive = true AND u.deletedAt IS NULL")
    long countActiveUsers();

    /**
     * Count verified users
     */
    @Query("SELECT COUNT(u) FROM User u WHERE u.isVerified = true AND u.isActive = true AND u.deletedAt IS NULL")
    long countVerifiedUsers();

    /**
     * Find users by name (case insensitive search)
     */
    @Query("SELECT u FROM User u WHERE " +
           "(LOWER(u.firstName) LIKE LOWER(CONCAT('%', :name, '%')) OR " +
           "LOWER(u.lastName) LIKE LOWER(CONCAT('%', :name, '%')) OR " +
           "LOWER(CONCAT(u.firstName, ' ', u.lastName)) LIKE LOWER(CONCAT('%', :name, '%'))) " +
           "AND u.isActive = true AND u.deletedAt IS NULL")
    List<User> findByNameContainingIgnoreCase(@Param("name") String name);

    /**
     * Find users by gender
     */
    @Query("SELECT u FROM User u WHERE u.gender = :gender AND u.isActive = true AND u.deletedAt IS NULL")
    List<User> findByGender(@Param("gender") User.Gender gender);

    /**
     * Find users created between dates
     */
    @Query("SELECT u FROM User u WHERE u.createdAt BETWEEN :startDate AND :endDate AND u.isActive = true AND u.deletedAt IS NULL")
    List<User> findUsersCreatedBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    /**
     * Update last login time
     */
    @Query("UPDATE User u SET u.lastLoginAt = :loginTime WHERE u.id = :userId")
    void updateLastLoginTime(@Param("userId") UUID userId, @Param("loginTime") LocalDateTime loginTime);

    /**
     * Soft delete user
     */
    @Query("UPDATE User u SET u.deletedAt = :deleteTime, u.isActive = false WHERE u.id = :userId")
    void softDeleteUser(@Param("userId") UUID userId, @Param("deleteTime") LocalDateTime deleteTime);

    /**
     * Restore soft deleted user
     */
    @Query("UPDATE User u SET u.deletedAt = NULL, u.isActive = true WHERE u.id = :userId")
    void restoreUser(@Param("userId") UUID userId);

    /**
     * Verify user
     */
    @Query("UPDATE User u SET u.isVerified = true WHERE u.id = :userId")
    void verifyUser(@Param("userId") UUID userId);

    /**
     * Activate user
     */
    @Query("UPDATE User u SET u.isActive = true WHERE u.id = :userId")
    void activateUser(@Param("userId") UUID userId);

    /**
     * Deactivate user
     */
    @Query("UPDATE User u SET u.isActive = false WHERE u.id = :userId")
    void deactivateUser(@Param("userId") UUID userId);
}
