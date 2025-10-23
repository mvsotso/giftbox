package com.giftbox.merchantservice.dto;

import com.giftbox.merchantservice.model.Merchant;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Merchant Data Transfer Object
 * 
 * Used for transferring merchant data between client and server.
 */
public class MerchantDTO {

    private UUID id;

    @NotBlank(message = "Business name is required")
    @Size(min = 2, max = 255, message = "Business name must be between 2 and 255 characters")
    private String businessName;

    @NotBlank(message = "Business type is required")
    @Size(min = 2, max = 100, message = "Business type must be between 2 and 100 characters")
    private String businessType;

    @Pattern(regexp = "^[A-Z0-9\\-]{5,50}$", message = "Business registration number format is invalid")
    private String businessRegistrationNumber;

    private String taxId;

    @NotBlank(message = "Contact email is required")
    @Email(message = "Contact email should be valid")
    private String contactEmail;

    @NotBlank(message = "Contact phone is required")
    @Pattern(regexp = "^[+]?[0-9]{10,20}$", message = "Phone number should be valid")
    private String contactPhone;

    @NotBlank(message = "Contact person name is required")
    @Size(min = 2, max = 255, message = "Contact person name must be between 2 and 255 characters")
    private String contactPersonName;

    private String contactPersonPosition;

    private String businessDescription;

    private String businessLogoUrl;

    private String websiteUrl;

    private String facebookUrl;

    private String instagramUrl;

    private Boolean isVerified;

    private Merchant.VerificationStatus verificationStatus;

    private String verificationNotes;

    private Boolean isActive;

    @DecimalMin(value = "0.0", message = "Commission rate must be positive")
    @DecimalMax(value = "100.0", message = "Commission rate cannot exceed 100%")
    private BigDecimal commissionRate;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    private LocalDateTime verifiedAt;

    // Constructors
    public MerchantDTO() {}

    public MerchantDTO(Merchant merchant) {
        this.id = merchant.getId();
        this.businessName = merchant.getBusinessName();
        this.businessType = merchant.getBusinessType();
        this.businessRegistrationNumber = merchant.getBusinessRegistrationNumber();
        this.taxId = merchant.getTaxId();
        this.contactEmail = merchant.getContactEmail();
        this.contactPhone = merchant.getContactPhone();
        this.contactPersonName = merchant.getContactPersonName();
        this.contactPersonPosition = merchant.getContactPersonPosition();
        this.businessDescription = merchant.getBusinessDescription();
        this.businessLogoUrl = merchant.getBusinessLogoUrl();
        this.websiteUrl = merchant.getWebsiteUrl();
        this.facebookUrl = merchant.getFacebookUrl();
        this.instagramUrl = merchant.getInstagramUrl();
        this.isVerified = merchant.getIsVerified();
        this.verificationStatus = merchant.getVerificationStatus();
        this.verificationNotes = merchant.getVerificationNotes();
        this.isActive = merchant.getIsActive();
        this.commissionRate = merchant.getCommissionRate();
        this.createdAt = merchant.getCreatedAt();
        this.updatedAt = merchant.getUpdatedAt();
        this.verifiedAt = merchant.getVerifiedAt();
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getBusinessName() {
        return businessName;
    }

    public void setBusinessName(String businessName) {
        this.businessName = businessName;
    }

    public String getBusinessType() {
        return businessType;
    }

    public void setBusinessType(String businessType) {
        this.businessType = businessType;
    }

    public String getBusinessRegistrationNumber() {
        return businessRegistrationNumber;
    }

    public void setBusinessRegistrationNumber(String businessRegistrationNumber) {
        this.businessRegistrationNumber = businessRegistrationNumber;
    }

    public String getTaxId() {
        return taxId;
    }

    public void setTaxId(String taxId) {
        this.taxId = taxId;
    }

    public String getContactEmail() {
        return contactEmail;
    }

    public void setContactEmail(String contactEmail) {
        this.contactEmail = contactEmail;
    }

    public String getContactPhone() {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone) {
        this.contactPhone = contactPhone;
    }

    public String getContactPersonName() {
        return contactPersonName;
    }

    public void setContactPersonName(String contactPersonName) {
        this.contactPersonName = contactPersonName;
    }

    public String getContactPersonPosition() {
        return contactPersonPosition;
    }

    public void setContactPersonPosition(String contactPersonPosition) {
        this.contactPersonPosition = contactPersonPosition;
    }

    public String getBusinessDescription() {
        return businessDescription;
    }

    public void setBusinessDescription(String businessDescription) {
        this.businessDescription = businessDescription;
    }

    public String getBusinessLogoUrl() {
        return businessLogoUrl;
    }

    public void setBusinessLogoUrl(String businessLogoUrl) {
        this.businessLogoUrl = businessLogoUrl;
    }

    public String getWebsiteUrl() {
        return websiteUrl;
    }

    public void setWebsiteUrl(String websiteUrl) {
        this.websiteUrl = websiteUrl;
    }

    public String getFacebookUrl() {
        return facebookUrl;
    }

    public void setFacebookUrl(String facebookUrl) {
        this.facebookUrl = facebookUrl;
    }

    public String getInstagramUrl() {
        return instagramUrl;
    }

    public void setInstagramUrl(String instagramUrl) {
        this.instagramUrl = instagramUrl;
    }

    public Boolean getIsVerified() {
        return isVerified;
    }

    public void setIsVerified(Boolean isVerified) {
        this.isVerified = isVerified;
    }

    public Merchant.VerificationStatus getVerificationStatus() {
        return verificationStatus;
    }

    public void setVerificationStatus(Merchant.VerificationStatus verificationStatus) {
        this.verificationStatus = verificationStatus;
    }

    public String getVerificationNotes() {
        return verificationNotes;
    }

    public void setVerificationNotes(String verificationNotes) {
        this.verificationNotes = verificationNotes;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public BigDecimal getCommissionRate() {
        return commissionRate;
    }

    public void setCommissionRate(BigDecimal commissionRate) {
        this.commissionRate = commissionRate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getVerifiedAt() {
        return verifiedAt;
    }

    public void setVerifiedAt(LocalDateTime verifiedAt) {
        this.verifiedAt = verifiedAt;
    }

    @Override
    public String toString() {
        return "MerchantDTO{" +
                "id=" + id +
                ", businessName='" + businessName + '\'' +
                ", businessType='" + businessType + '\'' +
                ", contactEmail='" + contactEmail + '\'' +
                ", isActive=" + isActive +
                ", isVerified=" + isVerified +
                ", verificationStatus=" + verificationStatus +
                '}';
    }
}
