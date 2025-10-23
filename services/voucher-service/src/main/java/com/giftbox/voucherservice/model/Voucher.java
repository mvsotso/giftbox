package com.giftbox.voucherservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Voucher Entity
 * 
 * Represents an individual voucher instance created from a voucher template.
 */
@Entity
@Table(name = "vouchers")
@EntityListeners(AuditingEntityListener.class)
public class Voucher {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NotNull(message = "Template ID is required")
    @Column(name = "template_id", nullable = false)
    private UUID templateId;

    @NotBlank(message = "Voucher code is required")
    @Size(min = 8, max = 50, message = "Voucher code must be between 8 and 50 characters")
    @Column(name = "code", nullable = false, unique = true, length = 50)
    private String code;

    @Column(name = "owner_user_id")
    private UUID ownerUserId;

    @NotNull(message = "Current value is required")
    @DecimalMin(value = "0.00", message = "Current value must be positive")
    @Column(name = "current_value", nullable = false, precision = 10, scale = 2)
    private BigDecimal currentValue;

    @NotBlank(message = "Status is required")
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private VoucherStatus status = VoucherStatus.ACTIVE;

    @Column(name = "issued_at")
    private LocalDateTime issuedAt;

    @Column(name = "redeemed_at")
    private LocalDateTime redeemedAt;

    @NotNull(message = "Expires at date is required")
    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    @Column(name = "is_gift", nullable = false)
    private Boolean isGift = false;

    @Column(name = "gift_message", columnDefinition = "TEXT")
    private String giftMessage;

    @Column(name = "sender_user_id")
    private UUID senderUserId;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    // Constructors
    public Voucher() {}

    public Voucher(UUID templateId, String code, BigDecimal currentValue, LocalDateTime expiresAt) {
        this.templateId = templateId;
        this.code = code;
        this.currentValue = currentValue;
        this.expiresAt = expiresAt;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getTemplateId() {
        return templateId;
    }

    public void setTemplateId(UUID templateId) {
        this.templateId = templateId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public UUID getOwnerUserId() {
        return ownerUserId;
    }

    public void setOwnerUserId(UUID ownerUserId) {
        this.ownerUserId = ownerUserId;
    }

    public BigDecimal getCurrentValue() {
        return currentValue;
    }

    public void setCurrentValue(BigDecimal currentValue) {
        this.currentValue = currentValue;
    }

    public VoucherStatus getStatus() {
        return status;
    }

    public void setStatus(VoucherStatus status) {
        this.status = status;
    }

    public LocalDateTime getIssuedAt() {
        return issuedAt;
    }

    public void setIssuedAt(LocalDateTime issuedAt) {
        this.issuedAt = issuedAt;
    }

    public LocalDateTime getRedeemedAt() {
        return redeemedAt;
    }

    public void setRedeemedAt(LocalDateTime redeemedAt) {
        this.redeemedAt = redeemedAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public Boolean getIsGift() {
        return isGift;
    }

    public void setIsGift(Boolean isGift) {
        this.isGift = isGift;
    }

    public String getGiftMessage() {
        return giftMessage;
    }

    public void setGiftMessage(String giftMessage) {
        this.giftMessage = giftMessage;
    }

    public UUID getSenderUserId() {
        return senderUserId;
    }

    public void setSenderUserId(UUID senderUserId) {
        this.senderUserId = senderUserId;
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

    public LocalDateTime getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(LocalDateTime deletedAt) {
        this.deletedAt = deletedAt;
    }

    // Utility methods
    public boolean isDeleted() {
        return deletedAt != null;
    }

    public void softDelete() {
        this.deletedAt = LocalDateTime.now();
        this.status = VoucherStatus.CANCELLED;
    }

    public boolean isValid() {
        LocalDateTime now = LocalDateTime.now();
        return status == VoucherStatus.ACTIVE && 
               !isDeleted() && 
               expiresAt.isAfter(now);
    }

    public boolean isExpired() {
        LocalDateTime now = LocalDateTime.now();
        return expiresAt.isBefore(now);
    }

    public void redeem() {
        this.status = VoucherStatus.REDEEMED;
        this.redeemedAt = LocalDateTime.now();
    }

    public void cancel() {
        this.status = VoucherStatus.CANCELLED;
    }

    @Override
    public String toString() {
        return "Voucher{" +
                "id=" + id +
                ", templateId=" + templateId +
                ", code='" + code + '\'' +
                ", ownerUserId=" + ownerUserId +
                ", currentValue=" + currentValue +
                ", status=" + status +
                ", isGift=" + isGift +
                '}';
    }

    // Voucher Status enum
    public enum VoucherStatus {
        ACTIVE, REDEEMED, EXPIRED, PENDING, CANCELLED
    }
}
