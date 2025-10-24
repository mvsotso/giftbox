-- =====================================================
-- Gift Box Backend System - Test Data Cleanup Script
-- =====================================================
-- Description: This script removes all test data from the database
-- Usage: Run this script after testing to clean up test data
-- Author: System Implementation Team
-- Date: December 19, 2024
-- Version: 1.0
-- =====================================================

-- Disable foreign key checks temporarily for cleanup
SET session_replication_role = replica;

-- =====================================================
-- 1. CLEANUP TRANSACTION-RELATED TABLES
-- =====================================================

-- Clean up payment records
DELETE FROM payments WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';
DELETE FROM payment_methods WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up transaction records
DELETE FROM transactions WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';
DELETE FROM transaction_items WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up voucher redemptions
DELETE FROM voucher_redemptions WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';
DELETE FROM voucher_transactions WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- =====================================================
-- 2. CLEANUP VOUCHER-RELATED TABLES
-- =====================================================

-- Clean up voucher usage history
DELETE FROM voucher_usage_history WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up voucher assignments
DELETE FROM voucher_assignments WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up test vouchers (keep production vouchers)
DELETE FROM vouchers 
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
AND (voucher_code LIKE 'TEST_%' 
     OR voucher_code LIKE 'VOUCHER_%' 
     OR amount IN (1.00, 5.00, 10.00, 25.00, 50.00, 100.00)
     OR description LIKE '%test%'
     OR description LIKE '%Test%');

-- =====================================================
-- 3. CLEANUP USER-RELATED TABLES
-- =====================================================

-- Clean up user sessions
DELETE FROM user_sessions WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up user preferences (test data)
DELETE FROM user_preferences 
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
AND (preference_key LIKE 'test_%' OR preference_value LIKE '%test%');

-- Clean up user activity logs
DELETE FROM user_activity_logs WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up user notifications
DELETE FROM user_notifications WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up test users (keep production users)
DELETE FROM users 
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
AND (username LIKE 'test_%' 
     OR username LIKE 'user_%'
     OR email LIKE '%@test.com'
     OR email LIKE '%@example.com'
     OR first_name LIKE 'Test%'
     OR last_name LIKE 'User%');

-- =====================================================
-- 4. CLEANUP MERCHANT-RELATED TABLES
-- =====================================================

-- Clean up merchant staff
DELETE FROM merchant_staff WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up merchant locations
DELETE FROM merchant_locations WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up merchant settings
DELETE FROM merchant_settings WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up test merchants
DELETE FROM merchants 
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
AND (business_name LIKE '%Test%'
     OR business_name LIKE '%Demo%'
     OR email LIKE '%@test.com'
     OR email LIKE '%@example.com'
     OR contact_person LIKE 'Test%');

-- =====================================================
-- 5. CLEANUP CORPORATE-RELATED TABLES
-- =====================================================

-- Clean up corporate users
DELETE FROM corporate_users WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up corporate departments
DELETE FROM corporate_departments WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up corporate budgets
DELETE FROM corporate_budgets WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up test corporate accounts
DELETE FROM corporate_accounts 
WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
AND (company_name LIKE '%Test%'
     OR company_name LIKE '%Demo%'
     OR email LIKE '%@test.com'
     OR email LIKE '%@example.com');

-- =====================================================
-- 6. CLEANUP AUDIT AND LOG TABLES
-- =====================================================

-- Clean up audit logs
DELETE FROM audit_logs WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up system logs
DELETE FROM system_logs WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up error logs
DELETE FROM error_logs WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up access logs
DELETE FROM access_logs WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- =====================================================
-- 7. CLEANUP NOTIFICATION TABLES
-- =====================================================

-- Clean up email notifications
DELETE FROM email_notifications WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up SMS notifications
DELETE FROM sms_notifications WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up push notifications
DELETE FROM push_notifications WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- =====================================================
-- 8. CLEANUP INTEGRATION TABLES
-- =====================================================

-- Clean up API logs
DELETE FROM api_logs WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up webhook logs
DELETE FROM webhook_logs WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up integration logs
DELETE FROM integration_logs WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- =====================================================
-- 9. CLEANUP CACHE AND SESSION TABLES
-- =====================================================

-- Clean up Redis cache entries (if stored in database)
DELETE FROM cache_entries WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up session data
DELETE FROM session_data WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- =====================================================
-- 10. CLEANUP ANALYTICS TABLES
-- =====================================================

-- Clean up analytics events
DELETE FROM analytics_events WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up user analytics
DELETE FROM user_analytics WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- Clean up merchant analytics
DELETE FROM merchant_analytics WHERE created_at >= CURRENT_DATE - INTERVAL '7 days';

-- =====================================================
-- 11. RESET SEQUENCES (Optional - Use with caution)
-- =====================================================

-- Reset auto-increment sequences for clean test data
-- WARNING: Only use in test environments, not production!

-- Reset user ID sequence
-- ALTER SEQUENCE users_id_seq RESTART WITH 1;

-- Reset merchant ID sequence
-- ALTER SEQUENCE merchants_id_seq RESTART WITH 1;

-- Reset voucher ID sequence
-- ALTER SEQUENCE vouchers_id_seq RESTART WITH 1;

-- Reset transaction ID sequence
-- ALTER SEQUENCE transactions_id_seq RESTART WITH 1;

-- =====================================================
-- 12. CLEANUP TEMPORARY TABLES
-- =====================================================

-- Drop temporary tables if they exist
DROP TABLE IF EXISTS temp_test_data;
DROP TABLE IF EXISTS temp_user_data;
DROP TABLE IF EXISTS temp_merchant_data;
DROP TABLE IF EXISTS temp_voucher_data;
DROP TABLE IF EXISTS temp_transaction_data;

-- =====================================================
-- 13. VACUUM AND ANALYZE
-- =====================================================

-- Vacuum tables to reclaim space
VACUUM ANALYZE;

-- =====================================================
-- 14. VERIFICATION QUERIES
-- =====================================================

-- Check remaining data counts
SELECT 'Users' as table_name, COUNT(*) as remaining_count FROM users
UNION ALL
SELECT 'Merchants', COUNT(*) FROM merchants
UNION ALL
SELECT 'Vouchers', COUNT(*) FROM vouchers
UNION ALL
SELECT 'Transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Corporate Accounts', COUNT(*) FROM corporate_accounts;

-- =====================================================
-- 15. RESTORE FOREIGN KEY CHECKS
-- =====================================================

-- Re-enable foreign key checks
SET session_replication_role = DEFAULT;

-- =====================================================
-- CLEANUP COMPLETE
-- =====================================================

-- Log cleanup completion
INSERT INTO system_logs (log_level, message, created_at) 
VALUES ('INFO', 'Test data cleanup completed successfully', NOW());

-- Display completion message
SELECT 'Test data cleanup completed successfully!' as status;

-- =====================================================
-- END OF CLEANUP SCRIPT
-- =====================================================
