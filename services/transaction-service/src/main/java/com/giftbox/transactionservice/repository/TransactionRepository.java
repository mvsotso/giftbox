package com.giftbox.transactionservice.repository;

import com.giftbox.transactionservice.model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Transaction Repository
 * 
 * Data access layer for Transaction entities.
 */
@Repository
public interface TransactionRepository extends JpaRepository<Transaction, UUID> {

    /**
     * Find transactions by user ID
     */
    List<Transaction> findByUserIdOrderByCreatedAtDesc(UUID userId);

    /**
     * Find transactions by merchant ID
     */
    List<Transaction> findByMerchantIdOrderByCreatedAtDesc(UUID merchantId);

    /**
     * Find transactions by status
     */
    List<Transaction> findByStatusOrderByCreatedAtDesc(Transaction.TransactionStatus status);

    /**
     * Find transactions by transaction type
     */
    List<Transaction> findByTransactionTypeOrderByCreatedAtDesc(Transaction.TransactionType transactionType);

    /**
     * Find transactions by user ID and status
     */
    List<Transaction> findByUserIdAndStatusOrderByCreatedAtDesc(UUID userId, Transaction.TransactionStatus status);

    /**
     * Find transactions by merchant ID and status
     */
    List<Transaction> findByMerchantIdAndStatusOrderByCreatedAtDesc(UUID merchantId, Transaction.TransactionStatus status);

    /**
     * Find transactions by date range
     */
    @Query("SELECT t FROM Transaction t WHERE t.transactionDate BETWEEN :startDate AND :endDate ORDER BY t.createdAt DESC")
    List<Transaction> findByTransactionDateBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    /**
     * Find transactions by user ID and date range
     */
    @Query("SELECT t FROM Transaction t WHERE t.userId = :userId AND t.transactionDate BETWEEN :startDate AND :endDate ORDER BY t.createdAt DESC")
    List<Transaction> findByUserIdAndTransactionDateBetween(@Param("userId") UUID userId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    /**
     * Find transactions by merchant ID and date range
     */
    @Query("SELECT t FROM Transaction t WHERE t.merchantId = :merchantId AND t.transactionDate BETWEEN :startDate AND :endDate ORDER BY t.createdAt DESC")
    List<Transaction> findByMerchantIdAndTransactionDateBetween(@Param("merchantId") UUID merchantId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    /**
     * Find transactions by payment gateway transaction ID
     */
    Optional<Transaction> findByPaymentGatewayTransactionId(String paymentGatewayTransactionId);

    /**
     * Count transactions by user ID
     */
    long countByUserId(UUID userId);

    /**
     * Count transactions by merchant ID
     */
    long countByMerchantId(UUID merchantId);

    /**
     * Count transactions by status
     */
    long countByStatus(Transaction.TransactionStatus status);

    /**
     * Count transactions by transaction type
     */
    long countByTransactionType(Transaction.TransactionType transactionType);

    /**
     * Sum amount by user ID and status
     */
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.userId = :userId AND t.status = :status")
    BigDecimal sumAmountByUserIdAndStatus(@Param("userId") UUID userId, @Param("status") Transaction.TransactionStatus status);

    /**
     * Sum amount by merchant ID and status
     */
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.merchantId = :merchantId AND t.status = :status")
    BigDecimal sumAmountByMerchantIdAndStatus(@Param("merchantId") UUID merchantId, @Param("status") Transaction.TransactionStatus status);

    /**
     * Sum amount by date range and status
     */
    @Query("SELECT SUM(t.amount) FROM Transaction t WHERE t.transactionDate BETWEEN :startDate AND :endDate AND t.status = :status")
    BigDecimal sumAmountByDateRangeAndStatus(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate, @Param("status") Transaction.TransactionStatus status);

    /**
     * Find pending transactions
     */
    @Query("SELECT t FROM Transaction t WHERE t.status = 'PENDING' AND t.createdAt < :cutoffTime ORDER BY t.createdAt ASC")
    List<Transaction> findPendingTransactionsOlderThan(@Param("cutoffTime") LocalDateTime cutoffTime);

    /**
     * Find transactions for settlement
     */
    @Query("SELECT t FROM Transaction t WHERE t.merchantId = :merchantId AND t.status = 'COMPLETED' AND t.transactionDate BETWEEN :startDate AND :endDate ORDER BY t.createdAt ASC")
    List<Transaction> findTransactionsForSettlement(@Param("merchantId") UUID merchantId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    /**
     * Find failed transactions for retry
     */
    @Query("SELECT t FROM Transaction t WHERE t.status = 'FAILED' AND t.createdAt > :retryAfter ORDER BY t.createdAt ASC")
    List<Transaction> findFailedTransactionsForRetry(@Param("retryAfter") LocalDateTime retryAfter);

    /**
     * Soft delete transaction
     */
    @Query("UPDATE Transaction t SET t.deletedAt = :deleteTime, t.status = 'CANCELLED' WHERE t.id = :transactionId")
    void softDeleteTransaction(@Param("transactionId") UUID transactionId, @Param("deleteTime") LocalDateTime deleteTime);

    /**
     * Update transaction status
     */
    @Query("UPDATE Transaction t SET t.status = :status WHERE t.id = :transactionId")
    void updateTransactionStatus(@Param("transactionId") UUID transactionId, @Param("status") Transaction.TransactionStatus status);

    /**
     * Find transactions by user ID with pagination
     */
    @Query("SELECT t FROM Transaction t WHERE t.userId = :userId ORDER BY t.createdAt DESC")
    List<Transaction> findByUserIdWithPagination(@Param("userId") UUID userId);

    /**
     * Find transactions by merchant ID with pagination
     */
    @Query("SELECT t FROM Transaction t WHERE t.merchantId = :merchantId ORDER BY t.createdAt DESC")
    List<Transaction> findByMerchantIdWithPagination(@Param("merchantId") UUID merchantId);

    /**
     * Find transactions by payment method
     */
    List<Transaction> findByPaymentMethodOrderByCreatedAtDesc(String paymentMethod);

    /**
     * Find transactions by currency
     */
    List<Transaction> findByCurrencyOrderByCreatedAtDesc(String currency);

    /**
     * Find transactions by amount range
     */
    @Query("SELECT t FROM Transaction t WHERE t.amount BETWEEN :minAmount AND :maxAmount ORDER BY t.createdAt DESC")
    List<Transaction> findByAmountBetween(@Param("minAmount") BigDecimal minAmount, @Param("maxAmount") BigDecimal maxAmount);

    /**
     * Find transactions by user ID and amount range
     */
    @Query("SELECT t FROM Transaction t WHERE t.userId = :userId AND t.amount BETWEEN :minAmount AND :maxAmount ORDER BY t.createdAt DESC")
    List<Transaction> findByUserIdAndAmountBetween(@Param("userId") UUID userId, @Param("minAmount") BigDecimal minAmount, @Param("maxAmount") BigDecimal maxAmount);

    /**
     * Find transactions by merchant ID and amount range
     */
    @Query("SELECT t FROM Transaction t WHERE t.merchantId = :merchantId AND t.amount BETWEEN :minAmount AND :maxAmount ORDER BY t.createdAt DESC")
    List<Transaction> findByMerchantIdAndAmountBetween(@Param("merchantId") UUID merchantId, @Param("minAmount") BigDecimal minAmount, @Param("maxAmount") BigDecimal maxAmount);
}
