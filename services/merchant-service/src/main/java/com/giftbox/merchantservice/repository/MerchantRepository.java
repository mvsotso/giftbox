package com.giftbox.merchantservice.repository;

import com.giftbox.merchantservice.model.Merchant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Merchant Repository
 * 
 * Data access layer for Merchant entities.
 */
@Repository
public interface MerchantRepository extends JpaRepository<Merchant, UUID> {

    /**
     * Find merchant by contact email
     */
    Optional<Merchant> findByContactEmail(String contactEmail);

    /**
     * Find merchant by contact phone
     */
    Optional<Merchant> findByContactPhone(String contactPhone);

    /**
     * Find merchant by business registration number
     */
    Optional<Merchant> findByBusinessRegistrationNumber(String businessRegistrationNumber);

    /**
     * Find active merchant by email
     */
    @Query("SELECT m FROM Merchant m WHERE m.contactEmail = :email AND m.isActive = true AND m.deletedAt IS NULL")
    Optional<Merchant> findActiveMerchantByEmail(@Param("email") String email);

    /**
     * Find active merchant by phone
     */
    @Query("SELECT m FROM Merchant m WHERE m.contactPhone = :phone AND m.isActive = true AND m.deletedAt IS NULL")
    Optional<Merchant> findActiveMerchantByPhone(@Param("phone") String phone);

    /**
     * Check if email exists
     */
    boolean existsByContactEmail(String contactEmail);

    /**
     * Check if phone exists
     */
    boolean existsByContactPhone(String contactPhone);

    /**
     * Check if business registration number exists
     */
    boolean existsByBusinessRegistrationNumber(String businessRegistrationNumber);

    /**
     * Check if email exists for different merchant
     */
    @Query("SELECT COUNT(m) > 0 FROM Merchant m WHERE m.contactEmail = :email AND m.id != :merchantId AND m.deletedAt IS NULL")
    boolean existsByContactEmailAndIdNot(@Param("email") String email, @Param("merchantId") UUID merchantId);

    /**
     * Check if phone exists for different merchant
     */
    @Query("SELECT COUNT(m) > 0 FROM Merchant m WHERE m.contactPhone = :phone AND m.id != :merchantId AND m.deletedAt IS NULL")
    boolean existsByContactPhoneAndIdNot(@Param("phone") String phone, @Param("merchantId") UUID merchantId);

    /**
     * Find all active merchants
     */
    @Query("SELECT m FROM Merchant m WHERE m.isActive = true AND m.deletedAt IS NULL")
    List<Merchant> findAllActiveMerchants();

    /**
     * Find merchants by verification status
     */
    @Query("SELECT m FROM Merchant m WHERE m.verificationStatus = :status AND m.isActive = true AND m.deletedAt IS NULL")
    List<Merchant> findByVerificationStatus(@Param("status") Merchant.VerificationStatus status);

    /**
     * Find verified merchants
     */
    @Query("SELECT m FROM Merchant m WHERE m.isVerified = true AND m.isActive = true AND m.deletedAt IS NULL")
    List<Merchant> findVerifiedMerchants();

    /**
     * Find unverified merchants
     */
    @Query("SELECT m FROM Merchant m WHERE m.isVerified = false AND m.isActive = true AND m.deletedAt IS NULL")
    List<Merchant> findUnverifiedMerchants();

    /**
     * Find merchants by business type
     */
    @Query("SELECT m FROM Merchant m WHERE m.businessType = :businessType AND m.isActive = true AND m.deletedAt IS NULL")
    List<Merchant> findByBusinessType(@Param("businessType") String businessType);

    /**
     * Find merchants created after specific date
     */
    @Query("SELECT m FROM Merchant m WHERE m.createdAt >= :date AND m.isActive = true AND m.deletedAt IS NULL")
    List<Merchant> findMerchantsCreatedAfter(@Param("date") LocalDateTime date);

    /**
     * Search merchants by business name
     */
    @Query("SELECT m FROM Merchant m WHERE LOWER(m.businessName) LIKE LOWER(CONCAT('%', :name, '%')) AND m.isActive = true AND m.deletedAt IS NULL")
    List<Merchant> findByBusinessNameContainingIgnoreCase(@Param("name") String name);

    /**
     * Count active merchants
     */
    @Query("SELECT COUNT(m) FROM Merchant m WHERE m.isActive = true AND m.deletedAt IS NULL")
    long countActiveMerchants();

    /**
     * Count verified merchants
     */
    @Query("SELECT COUNT(m) FROM Merchant m WHERE m.isVerified = true AND m.isActive = true AND m.deletedAt IS NULL")
    long countVerifiedMerchants();

    /**
     * Count merchants by verification status
     */
    @Query("SELECT COUNT(m) FROM Merchant m WHERE m.verificationStatus = :status AND m.isActive = true AND m.deletedAt IS NULL")
    long countByVerificationStatus(@Param("status") Merchant.VerificationStatus status);

    /**
     * Soft delete merchant
     */
    @Query("UPDATE Merchant m SET m.deletedAt = :deleteTime, m.isActive = false WHERE m.id = :merchantId")
    void softDeleteMerchant(@Param("merchantId") UUID merchantId, @Param("deleteTime") LocalDateTime deleteTime);

    /**
     * Restore soft deleted merchant
     */
    @Query("UPDATE Merchant m SET m.deletedAt = NULL, m.isActive = true WHERE m.id = :merchantId")
    void restoreMerchant(@Param("merchantId") UUID merchantId);

    /**
     * Verify merchant
     */
    @Query("UPDATE Merchant m SET m.isVerified = true, m.verificationStatus = 'APPROVED', m.verifiedAt = CURRENT_TIMESTAMP WHERE m.id = :merchantId")
    void verifyMerchant(@Param("merchantId") UUID merchantId);

    /**
     * Reject merchant
     */
    @Query("UPDATE Merchant m SET m.isVerified = false, m.verificationStatus = 'REJECTED', m.verificationNotes = :notes WHERE m.id = :merchantId")
    void rejectMerchant(@Param("merchantId") UUID merchantId, @Param("notes") String notes);

    /**
     * Suspend merchant
     */
    @Query("UPDATE Merchant m SET m.verificationStatus = 'SUSPENDED' WHERE m.id = :merchantId")
    void suspendMerchant(@Param("merchantId") UUID merchantId);

    /**
     * Activate merchant
     */
    @Query("UPDATE Merchant m SET m.isActive = true WHERE m.id = :merchantId")
    void activateMerchant(@Param("merchantId") UUID merchantId);

    /**
     * Deactivate merchant
     */
    @Query("UPDATE Merchant m SET m.isActive = false WHERE m.id = :merchantId")
    void deactivateMerchant(@Param("merchantId") UUID merchantId);
}
