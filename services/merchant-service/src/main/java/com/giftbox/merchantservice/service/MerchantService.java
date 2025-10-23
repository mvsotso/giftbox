package com.giftbox.merchantservice.service;

import com.giftbox.merchantservice.dto.MerchantDTO;
import com.giftbox.merchantservice.exception.MerchantAlreadyExistsException;
import com.giftbox.merchantservice.exception.MerchantNotFoundException;
import com.giftbox.merchantservice.model.Merchant;
import com.giftbox.merchantservice.repository.MerchantRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Merchant Service
 * 
 * Business logic for merchant management operations.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class MerchantService {

    private final MerchantRepository merchantRepository;
    private final KafkaTemplate<String, String> kafkaTemplate;

    /**
     * Create a new merchant
     */
    @Transactional
    @CacheEvict(value = "merchants", allEntries = true)
    public MerchantDTO createMerchant(MerchantDTO merchantDTO) {
        log.info("Creating new merchant: {}", merchantDTO.getBusinessName());

        // Check if merchant with same email already exists
        if (merchantRepository.existsByContactEmail(merchantDTO.getContactEmail())) {
            throw new MerchantAlreadyExistsException("Merchant with email " + merchantDTO.getContactEmail() + " already exists");
        }

        // Check if merchant with same phone already exists
        if (merchantRepository.existsByContactPhone(merchantDTO.getContactPhone())) {
            throw new MerchantAlreadyExistsException("Merchant with phone " + merchantDTO.getContactPhone() + " already exists");
        }

        // Check if business registration number already exists (if provided)
        if (merchantDTO.getBusinessRegistrationNumber() != null && 
            merchantRepository.existsByBusinessRegistrationNumber(merchantDTO.getBusinessRegistrationNumber())) {
            throw new MerchantAlreadyExistsException("Merchant with business registration number " + 
                merchantDTO.getBusinessRegistrationNumber() + " already exists");
        }

        Merchant merchant = new Merchant();
        merchant.setBusinessName(merchantDTO.getBusinessName());
        merchant.setBusinessType(merchantDTO.getBusinessType());
        merchant.setBusinessRegistrationNumber(merchantDTO.getBusinessRegistrationNumber());
        merchant.setTaxId(merchantDTO.getTaxId());
        merchant.setContactEmail(merchantDTO.getContactEmail());
        merchant.setContactPhone(merchantDTO.getContactPhone());
        merchant.setContactPersonName(merchantDTO.getContactPersonName());
        merchant.setContactPersonPosition(merchantDTO.getContactPersonPosition());
        merchant.setBusinessDescription(merchantDTO.getBusinessDescription());
        merchant.setBusinessLogoUrl(merchantDTO.getBusinessLogoUrl());
        merchant.setWebsiteUrl(merchantDTO.getWebsiteUrl());
        merchant.setFacebookUrl(merchantDTO.getFacebookUrl());
        merchant.setInstagramUrl(merchantDTO.getInstagramUrl());
        merchant.setCommissionRate(merchantDTO.getCommissionRate());

        Merchant savedMerchant = merchantRepository.save(merchant);

        // Publish merchant created event
        kafkaTemplate.send("merchant-events", "merchant-created", savedMerchant.getId().toString());

        log.info("Merchant created successfully with ID: {}", savedMerchant.getId());
        return new MerchantDTO(savedMerchant);
    }

    /**
     * Get merchant by ID
     */
    @Cacheable(value = "merchants", key = "#id")
    public MerchantDTO getMerchantById(UUID id) {
        log.info("Getting merchant by ID: {}", id);
        
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with ID: " + id));
        
        return new MerchantDTO(merchant);
    }

    /**
     * Get merchant by email
     */
    @Cacheable(value = "merchants", key = "#email")
    public MerchantDTO getMerchantByEmail(String email) {
        log.info("Getting merchant by email: {}", email);
        
        Merchant merchant = merchantRepository.findActiveMerchantByEmail(email)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with email: " + email));
        
        return new MerchantDTO(merchant);
    }

    /**
     * Get merchant by phone
     */
    @Cacheable(value = "merchants", key = "#phone")
    public MerchantDTO getMerchantByPhone(String phone) {
        log.info("Getting merchant by phone: {}", phone);
        
        Merchant merchant = merchantRepository.findActiveMerchantByPhone(phone)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with phone: " + phone));
        
        return new MerchantDTO(merchant);
    }

    /**
     * Get all active merchants
     */
    public List<MerchantDTO> getAllActiveMerchants() {
        log.info("Getting all active merchants");
        
        return merchantRepository.findAllActiveMerchants()
                .stream()
                .map(MerchantDTO::new)
                .collect(Collectors.toList());
    }

    /**
     * Get merchants by verification status
     */
    public List<MerchantDTO> getMerchantsByVerificationStatus(Merchant.VerificationStatus status) {
        log.info("Getting merchants by verification status: {}", status);
        
        return merchantRepository.findByVerificationStatus(status)
                .stream()
                .map(MerchantDTO::new)
                .collect(Collectors.toList());
    }

    /**
     * Get verified merchants
     */
    public List<MerchantDTO> getVerifiedMerchants() {
        log.info("Getting verified merchants");
        
        return merchantRepository.findVerifiedMerchants()
                .stream()
                .map(MerchantDTO::new)
                .collect(Collectors.toList());
    }

    /**
     * Get unverified merchants
     */
    public List<MerchantDTO> getUnverifiedMerchants() {
        log.info("Getting unverified merchants");
        
        return merchantRepository.findUnverifiedMerchants()
                .stream()
                .map(MerchantDTO::new)
                .collect(Collectors.toList());
    }

    /**
     * Get merchants by business type
     */
    public List<MerchantDTO> getMerchantsByBusinessType(String businessType) {
        log.info("Getting merchants by business type: {}", businessType);
        
        return merchantRepository.findByBusinessType(businessType)
                .stream()
                .map(MerchantDTO::new)
                .collect(Collectors.toList());
    }

    /**
     * Search merchants by business name
     */
    public List<MerchantDTO> searchMerchantsByName(String name) {
        log.info("Searching merchants by name: {}", name);
        
        return merchantRepository.findByBusinessNameContainingIgnoreCase(name)
                .stream()
                .map(MerchantDTO::new)
                .collect(Collectors.toList());
    }

    /**
     * Update merchant
     */
    @Transactional
    @CacheEvict(value = "merchants", key = "#id", allEntries = true)
    public MerchantDTO updateMerchant(UUID id, MerchantDTO merchantDTO) {
        log.info("Updating merchant with ID: {}", id);
        
        Merchant existingMerchant = merchantRepository.findById(id)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with ID: " + id));

        // Check if email is being changed and if new email already exists
        if (!existingMerchant.getContactEmail().equals(merchantDTO.getContactEmail()) &&
            merchantRepository.existsByContactEmailAndIdNot(merchantDTO.getContactEmail(), id)) {
            throw new MerchantAlreadyExistsException("Merchant with email " + merchantDTO.getContactEmail() + " already exists");
        }

        // Check if phone is being changed and if new phone already exists
        if (!existingMerchant.getContactPhone().equals(merchantDTO.getContactPhone()) &&
            merchantRepository.existsByContactPhoneAndIdNot(merchantDTO.getContactPhone(), id)) {
            throw new MerchantAlreadyExistsException("Merchant with phone " + merchantDTO.getContactPhone() + " already exists");
        }

        // Update merchant fields
        existingMerchant.setBusinessName(merchantDTO.getBusinessName());
        existingMerchant.setBusinessType(merchantDTO.getBusinessType());
        existingMerchant.setBusinessRegistrationNumber(merchantDTO.getBusinessRegistrationNumber());
        existingMerchant.setTaxId(merchantDTO.getTaxId());
        existingMerchant.setContactEmail(merchantDTO.getContactEmail());
        existingMerchant.setContactPhone(merchantDTO.getContactPhone());
        existingMerchant.setContactPersonName(merchantDTO.getContactPersonName());
        existingMerchant.setContactPersonPosition(merchantDTO.getContactPersonPosition());
        existingMerchant.setBusinessDescription(merchantDTO.getBusinessDescription());
        existingMerchant.setBusinessLogoUrl(merchantDTO.getBusinessLogoUrl());
        existingMerchant.setWebsiteUrl(merchantDTO.getWebsiteUrl());
        existingMerchant.setFacebookUrl(merchantDTO.getFacebookUrl());
        existingMerchant.setInstagramUrl(merchantDTO.getInstagramUrl());
        existingMerchant.setCommissionRate(merchantDTO.getCommissionRate());

        Merchant updatedMerchant = merchantRepository.save(existingMerchant);

        // Publish merchant updated event
        kafkaTemplate.send("merchant-events", "merchant-updated", updatedMerchant.getId().toString());

        log.info("Merchant updated successfully with ID: {}", updatedMerchant.getId());
        return new MerchantDTO(updatedMerchant);
    }

    /**
     * Verify merchant
     */
    @Transactional
    @CacheEvict(value = "merchants", key = "#id", allEntries = true)
    public MerchantDTO verifyMerchant(UUID id) {
        log.info("Verifying merchant with ID: {}", id);
        
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with ID: " + id));

        merchant.verify();
        Merchant verifiedMerchant = merchantRepository.save(merchant);

        // Publish merchant verified event
        kafkaTemplate.send("merchant-events", "merchant-verified", verifiedMerchant.getId().toString());

        log.info("Merchant verified successfully with ID: {}", verifiedMerchant.getId());
        return new MerchantDTO(verifiedMerchant);
    }

    /**
     * Reject merchant
     */
    @Transactional
    @CacheEvict(value = "merchants", key = "#id", allEntries = true)
    public MerchantDTO rejectMerchant(UUID id, String notes) {
        log.info("Rejecting merchant with ID: {}", id);
        
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with ID: " + id));

        merchant.reject(notes);
        Merchant rejectedMerchant = merchantRepository.save(merchant);

        // Publish merchant rejected event
        kafkaTemplate.send("merchant-events", "merchant-rejected", rejectedMerchant.getId().toString());

        log.info("Merchant rejected successfully with ID: {}", rejectedMerchant.getId());
        return new MerchantDTO(rejectedMerchant);
    }

    /**
     * Suspend merchant
     */
    @Transactional
    @CacheEvict(value = "merchants", key = "#id", allEntries = true)
    public MerchantDTO suspendMerchant(UUID id) {
        log.info("Suspending merchant with ID: {}", id);
        
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with ID: " + id));

        merchant.setVerificationStatus(Merchant.VerificationStatus.SUSPENDED);
        Merchant suspendedMerchant = merchantRepository.save(merchant);

        // Publish merchant suspended event
        kafkaTemplate.send("merchant-events", "merchant-suspended", suspendedMerchant.getId().toString());

        log.info("Merchant suspended successfully with ID: {}", suspendedMerchant.getId());
        return new MerchantDTO(suspendedMerchant);
    }

    /**
     * Activate merchant
     */
    @Transactional
    @CacheEvict(value = "merchants", key = "#id", allEntries = true)
    public MerchantDTO activateMerchant(UUID id) {
        log.info("Activating merchant with ID: {}", id);
        
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with ID: " + id));

        merchant.setIsActive(true);
        Merchant activatedMerchant = merchantRepository.save(merchant);

        // Publish merchant activated event
        kafkaTemplate.send("merchant-events", "merchant-activated", activatedMerchant.getId().toString());

        log.info("Merchant activated successfully with ID: {}", activatedMerchant.getId());
        return new MerchantDTO(activatedMerchant);
    }

    /**
     * Deactivate merchant
     */
    @Transactional
    @CacheEvict(value = "merchants", key = "#id", allEntries = true)
    public MerchantDTO deactivateMerchant(UUID id) {
        log.info("Deactivating merchant with ID: {}", id);
        
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with ID: " + id));

        merchant.setIsActive(false);
        Merchant deactivatedMerchant = merchantRepository.save(merchant);

        // Publish merchant deactivated event
        kafkaTemplate.send("merchant-events", "merchant-deactivated", deactivatedMerchant.getId().toString());

        log.info("Merchant deactivated successfully with ID: {}", deactivatedMerchant.getId());
        return new MerchantDTO(deactivatedMerchant);
    }

    /**
     * Soft delete merchant
     */
    @Transactional
    @CacheEvict(value = "merchants", key = "#id", allEntries = true)
    public void deleteMerchant(UUID id) {
        log.info("Deleting merchant with ID: {}", id);
        
        Merchant merchant = merchantRepository.findById(id)
                .orElseThrow(() -> new MerchantNotFoundException("Merchant not found with ID: " + id));

        merchant.softDelete();
        merchantRepository.save(merchant);

        // Publish merchant deleted event
        kafkaTemplate.send("merchant-events", "merchant-deleted", id.toString());

        log.info("Merchant deleted successfully with ID: {}", id);
    }

    /**
     * Get merchant statistics
     */
    public MerchantStatisticsDTO getMerchantStatistics() {
        log.info("Getting merchant statistics");
        
        long totalMerchants = merchantRepository.countActiveMerchants();
        long verifiedMerchants = merchantRepository.countVerifiedMerchants();
        long pendingMerchants = merchantRepository.countByVerificationStatus(Merchant.VerificationStatus.PENDING);
        long rejectedMerchants = merchantRepository.countByVerificationStatus(Merchant.VerificationStatus.REJECTED);
        long suspendedMerchants = merchantRepository.countByVerificationStatus(Merchant.VerificationStatus.SUSPENDED);

        return new MerchantStatisticsDTO(totalMerchants, verifiedMerchants, pendingMerchants, rejectedMerchants, suspendedMerchants);
    }

    /**
     * Merchant Statistics DTO
     */
    public static class MerchantStatisticsDTO {
        private final long totalMerchants;
        private final long verifiedMerchants;
        private final long pendingMerchants;
        private final long rejectedMerchants;
        private final long suspendedMerchants;

        public MerchantStatisticsDTO(long totalMerchants, long verifiedMerchants, long pendingMerchants, long rejectedMerchants, long suspendedMerchants) {
            this.totalMerchants = totalMerchants;
            this.verifiedMerchants = verifiedMerchants;
            this.pendingMerchants = pendingMerchants;
            this.rejectedMerchants = rejectedMerchants;
            this.suspendedMerchants = suspendedMerchants;
        }

        // Getters
        public long getTotalMerchants() { return totalMerchants; }
        public long getVerifiedMerchants() { return verifiedMerchants; }
        public long getPendingMerchants() { return pendingMerchants; }
        public long getRejectedMerchants() { return rejectedMerchants; }
        public long getSuspendedMerchants() { return suspendedMerchants; }
    }
}
