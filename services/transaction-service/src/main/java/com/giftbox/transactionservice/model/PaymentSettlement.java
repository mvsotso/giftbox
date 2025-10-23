package com.giftbox.transactionservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Payment Settlement Entity
 * 
 * Represents merchant payment settlements for commission payouts.
 */
@Entity
@Table(name = "payment_settlements")
@EntityListeners(AuditingEntityListener.class)
public class PaymentSettlement {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NotNull(message = "Merchant ID is required")
    @Column(name = "merchant_id", nullable = false)
    private UUID merchantId;

    @NotNull(message = "Settlement period start is required")
    @Column(name = "settlement_period_start", nullable = false)
    private LocalDateTime settlementPeriodStart;

    @NotNull(message = "Settlement period end is required")
    @Column(name = "settlement_period_end", nullable = false)
    private LocalDateTime settlementPeriodEnd;

    @NotNull(message = "Total revenue is required")
    @DecimalMin(value = "0.00", message = "Total revenue must be positive")
    @Column(name = "total_revenue", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalRevenue;

    @NotNull(message = "Total fees is required")
    @DecimalMin(value = "0.00", message = "Total fees must be positive")
    @Column(name = "total_fees", nullable = false, precision = 10, scale = 2)
    private BigDecimal totalFees;

    @NotNull(message = "Net payout amount is required")
    @DecimalMin(value = "0.00", message = "Net payout amount must be positive")
    @Column(name = "net_payout_amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal netPayoutAmount;

    @Column(name = "payout_date")
    private LocalDateTime payoutDate;

    @NotBlank(message = "Status is required")
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private SettlementStatus status = SettlementStatus.PENDING;

    @Column(name = "bank_transaction_id", columnDefinition = "TEXT")
    private String bankTransactionId;

    @Column(name = "notes", columnDefinition = "TEXT")
    private String notes;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // Constructors
    public PaymentSettlement() {}

    public PaymentSettlement(UUID merchantId, LocalDateTime settlementPeriodStart, LocalDateTime settlementPeriodEnd, 
                           BigDecimal totalRevenue, BigDecimal totalFees, BigDecimal netPayoutAmount) {
        this.merchantId = merchantId;
        this.settlementPeriodStart = settlementPeriodStart;
        this.settlementPeriodEnd = settlementPeriodEnd;
        this.totalRevenue = totalRevenue;
        this.totalFees = totalFees;
        this.netPayoutAmount = netPayoutAmount;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(UUID merchantId) {
        this.merchantId = merchantId;
    }

    public LocalDateTime getSettlementPeriodStart() {
        return settlementPeriodStart;
    }

    public void setSettlementPeriodStart(LocalDateTime settlementPeriodStart) {
        this.settlementPeriodStart = settlementPeriodStart;
    }

    public LocalDateTime getSettlementPeriodEnd() {
        return settlementPeriodEnd;
    }

    public void setSettlementPeriodEnd(LocalDateTime settlementPeriodEnd) {
        this.settlementPeriodEnd = settlementPeriodEnd;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public BigDecimal getTotalFees() {
        return totalFees;
    }

    public void setTotalFees(BigDecimal totalFees) {
        this.totalFees = totalFees;
    }

    public BigDecimal getNetPayoutAmount() {
        return netPayoutAmount;
    }

    public void setNetPayoutAmount(BigDecimal netPayoutAmount) {
        this.netPayoutAmount = netPayoutAmount;
    }

    public LocalDateTime getPayoutDate() {
        return payoutDate;
    }

    public void setPayoutDate(LocalDateTime payoutDate) {
        this.payoutDate = payoutDate;
    }

    public SettlementStatus getStatus() {
        return status;
    }

    public void setStatus(SettlementStatus status) {
        this.status = status;
    }

    public String getBankTransactionId() {
        return bankTransactionId;
    }

    public void setBankTransactionId(String bankTransactionId) {
        this.bankTransactionId = bankTransactionId;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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

    // Utility methods
    public void complete() {
        this.status = SettlementStatus.COMPLETED;
        this.payoutDate = LocalDateTime.now();
    }

    public void fail() {
        this.status = SettlementStatus.FAILED;
    }

    public void cancel() {
        this.status = SettlementStatus.CANCELLED;
    }

    @Override
    public String toString() {
        return "PaymentSettlement{" +
                "id=" + id +
                ", merchantId=" + merchantId +
                ", totalRevenue=" + totalRevenue +
                ", totalFees=" + totalFees +
                ", netPayoutAmount=" + netPayoutAmount +
                ", status=" + status +
                '}';
    }

    // Settlement Status enum
    public enum SettlementStatus {
        PENDING, COMPLETED, FAILED, CANCELLED
    }
}
