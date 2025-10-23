package com.giftbox.merchantservice.controller;

import com.giftbox.merchantservice.dto.MerchantDTO;
import com.giftbox.merchantservice.model.Merchant;
import com.giftbox.merchantservice.service.MerchantService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * Merchant Controller
 * 
 * REST API endpoints for merchant management operations.
 */
@RestController
@RequestMapping("/api/v1/merchants")
@RequiredArgsConstructor
@Slf4j
public class MerchantController {

    private final MerchantService merchantService;

    /**
     * Create a new merchant
     */
    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('MERCHANT')")
    public ResponseEntity<MerchantDTO> createMerchant(@Valid @RequestBody MerchantDTO merchantDTO) {
        log.info("Creating new merchant: {}", merchantDTO.getBusinessName());
        MerchantDTO createdMerchant = merchantService.createMerchant(merchantDTO);
        return new ResponseEntity<>(createdMerchant, HttpStatus.CREATED);
    }

    /**
     * Get merchant by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<MerchantDTO> getMerchantById(@PathVariable UUID id) {
        log.info("Getting merchant by ID: {}", id);
        MerchantDTO merchant = merchantService.getMerchantById(id);
        return ResponseEntity.ok(merchant);
    }

    /**
     * Get merchant by email
     */
    @GetMapping("/email/{email}")
    public ResponseEntity<MerchantDTO> getMerchantByEmail(@PathVariable String email) {
        log.info("Getting merchant by email: {}", email);
        MerchantDTO merchant = merchantService.getMerchantByEmail(email);
        return ResponseEntity.ok(merchant);
    }

    /**
     * Get merchant by phone
     */
    @GetMapping("/phone/{phone}")
    public ResponseEntity<MerchantDTO> getMerchantByPhone(@PathVariable String phone) {
        log.info("Getting merchant by phone: {}", phone);
        MerchantDTO merchant = merchantService.getMerchantByPhone(phone);
        return ResponseEntity.ok(merchant);
    }

    /**
     * Get all active merchants
     */
    @GetMapping
    public ResponseEntity<List<MerchantDTO>> getAllActiveMerchants() {
        log.info("Getting all active merchants");
        List<MerchantDTO> merchants = merchantService.getAllActiveMerchants();
        return ResponseEntity.ok(merchants);
    }

    /**
     * Get merchants by verification status
     */
    @GetMapping("/status/{status}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<MerchantDTO>> getMerchantsByVerificationStatus(@PathVariable Merchant.VerificationStatus status) {
        log.info("Getting merchants by verification status: {}", status);
        List<MerchantDTO> merchants = merchantService.getMerchantsByVerificationStatus(status);
        return ResponseEntity.ok(merchants);
    }

    /**
     * Get verified merchants
     */
    @GetMapping("/verified")
    public ResponseEntity<List<MerchantDTO>> getVerifiedMerchants() {
        log.info("Getting verified merchants");
        List<MerchantDTO> merchants = merchantService.getVerifiedMerchants();
        return ResponseEntity.ok(merchants);
    }

    /**
     * Get unverified merchants
     */
    @GetMapping("/unverified")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<MerchantDTO>> getUnverifiedMerchants() {
        log.info("Getting unverified merchants");
        List<MerchantDTO> merchants = merchantService.getUnverifiedMerchants();
        return ResponseEntity.ok(merchants);
    }

    /**
     * Get merchants by business type
     */
    @GetMapping("/business-type/{businessType}")
    public ResponseEntity<List<MerchantDTO>> getMerchantsByBusinessType(@PathVariable String businessType) {
        log.info("Getting merchants by business type: {}", businessType);
        List<MerchantDTO> merchants = merchantService.getMerchantsByBusinessType(businessType);
        return ResponseEntity.ok(merchants);
    }

    /**
     * Search merchants by name
     */
    @GetMapping("/search")
    public ResponseEntity<List<MerchantDTO>> searchMerchantsByName(@RequestParam String name) {
        log.info("Searching merchants by name: {}", name);
        List<MerchantDTO> merchants = merchantService.searchMerchantsByName(name);
        return ResponseEntity.ok(merchants);
    }

    /**
     * Update merchant
     */
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('MERCHANT')")
    public ResponseEntity<MerchantDTO> updateMerchant(@PathVariable UUID id, @Valid @RequestBody MerchantDTO merchantDTO) {
        log.info("Updating merchant with ID: {}", id);
        MerchantDTO updatedMerchant = merchantService.updateMerchant(id, merchantDTO);
        return ResponseEntity.ok(updatedMerchant);
    }

    /**
     * Verify merchant
     */
    @PostMapping("/{id}/verify")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MerchantDTO> verifyMerchant(@PathVariable UUID id) {
        log.info("Verifying merchant with ID: {}", id);
        MerchantDTO verifiedMerchant = merchantService.verifyMerchant(id);
        return ResponseEntity.ok(verifiedMerchant);
    }

    /**
     * Reject merchant
     */
    @PostMapping("/{id}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MerchantDTO> rejectMerchant(@PathVariable UUID id, @RequestBody RejectMerchantRequest request) {
        log.info("Rejecting merchant with ID: {}", id);
        MerchantDTO rejectedMerchant = merchantService.rejectMerchant(id, request.getNotes());
        return ResponseEntity.ok(rejectedMerchant);
    }

    /**
     * Suspend merchant
     */
    @PostMapping("/{id}/suspend")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MerchantDTO> suspendMerchant(@PathVariable UUID id) {
        log.info("Suspending merchant with ID: {}", id);
        MerchantDTO suspendedMerchant = merchantService.suspendMerchant(id);
        return ResponseEntity.ok(suspendedMerchant);
    }

    /**
     * Activate merchant
     */
    @PostMapping("/{id}/activate")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MerchantDTO> activateMerchant(@PathVariable UUID id) {
        log.info("Activating merchant with ID: {}", id);
        MerchantDTO activatedMerchant = merchantService.activateMerchant(id);
        return ResponseEntity.ok(activatedMerchant);
    }

    /**
     * Deactivate merchant
     */
    @PostMapping("/{id}/deactivate")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MerchantDTO> deactivateMerchant(@PathVariable UUID id) {
        log.info("Deactivating merchant with ID: {}", id);
        MerchantDTO deactivatedMerchant = merchantService.deactivateMerchant(id);
        return ResponseEntity.ok(deactivatedMerchant);
    }

    /**
     * Delete merchant
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Void> deleteMerchant(@PathVariable UUID id) {
        log.info("Deleting merchant with ID: {}", id);
        merchantService.deleteMerchant(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * Get merchant statistics
     */
    @GetMapping("/statistics")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<MerchantService.MerchantStatisticsDTO> getMerchantStatistics() {
        log.info("Getting merchant statistics");
        MerchantService.MerchantStatisticsDTO statistics = merchantService.getMerchantStatistics();
        return ResponseEntity.ok(statistics);
    }

    /**
     * Health check endpoint
     */
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Merchant Service is up and running!");
    }

    /**
     * Reject Merchant Request DTO
     */
    public static class RejectMerchantRequest {
        private String notes;

        public String getNotes() {
            return notes;
        }

        public void setNotes(String notes) {
            this.notes = notes;
        }
    }
}
