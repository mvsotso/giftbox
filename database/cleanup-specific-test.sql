-- =====================================================
-- Gift Box Backend System - Specific Test Data Cleanup
-- =====================================================
-- Description: Targeted cleanup for specific test scenarios
-- Usage: Run specific sections based on test type
-- Author: System Implementation Team
-- Date: December 19, 2024
-- Version: 1.0
-- =====================================================

-- =====================================================
-- USER TESTING CLEANUP
-- =====================================================

-- Clean up user authentication tests
DELETE FROM user_sessions WHERE user_id IN (
    SELECT id FROM users WHERE username LIKE 'testuser%'
);

DELETE FROM users WHERE username LIKE 'testuser%' 
OR email LIKE '%@testuser.com'
OR email LIKE '%@test.com';

-- =====================================================
-- MERCHANT TESTING CLEANUP
-- =====================================================

-- Clean up merchant testing data
DELETE FROM merchant_staff WHERE merchant_id IN (
    SELECT id FROM merchants WHERE business_name LIKE '%Test Store%'
);

DELETE FROM merchants WHERE business_name LIKE '%Test Store%'
OR business_name LIKE '%Demo Store%'
OR email LIKE '%@merchant-test.com';

-- =====================================================
-- VOUCHER TESTING CLEANUP
-- =====================================================

-- Clean up voucher testing data
DELETE FROM voucher_redemptions WHERE voucher_id IN (
    SELECT id FROM vouchers WHERE voucher_code LIKE 'TEST_%'
);

DELETE FROM vouchers WHERE voucher_code LIKE 'TEST_%'
OR voucher_code LIKE 'VOUCHER_%'
OR amount IN (1.00, 5.00, 10.00, 25.00, 50.00, 100.00);

-- =====================================================
-- TRANSACTION TESTING CLEANUP
-- =====================================================

-- Clean up transaction testing data
DELETE FROM transaction_items WHERE transaction_id IN (
    SELECT id FROM transactions WHERE transaction_id LIKE 'TXN_TEST_%'
);

DELETE FROM transactions WHERE transaction_id LIKE 'TXN_TEST_%'
OR amount IN (1.00, 5.00, 10.00, 25.00, 50.00, 100.00);

-- =====================================================
-- PAYMENT TESTING CLEANUP
-- =====================================================

-- Clean up payment testing data
DELETE FROM payments WHERE payment_id LIKE 'PAY_TEST_%'
OR amount IN (1.00, 5.00, 10.00, 25.00, 50.00, 100.00);

-- =====================================================
-- CORPORATE TESTING CLEANUP
-- =====================================================

-- Clean up corporate testing data
DELETE FROM corporate_users WHERE corporate_id IN (
    SELECT id FROM corporate_accounts WHERE company_name LIKE '%Test Corp%'
);

DELETE FROM corporate_accounts WHERE company_name LIKE '%Test Corp%'
OR company_name LIKE '%Demo Corp%'
OR email LIKE '%@corporate-test.com';

-- =====================================================
-- API TESTING CLEANUP
-- =====================================================

-- Clean up API testing logs
DELETE FROM api_logs WHERE endpoint LIKE '%/test%'
OR endpoint LIKE '%/demo%'
OR user_agent LIKE '%Postman%'
OR user_agent LIKE '%curl%';

-- =====================================================
-- LOAD TESTING CLEANUP
-- =====================================================

-- Clean up load testing data
DELETE FROM users WHERE created_at >= NOW() - INTERVAL '1 hour'
AND (username LIKE 'loadtest_%' OR email LIKE '%@loadtest.com');

DELETE FROM transactions WHERE created_at >= NOW() - INTERVAL '1 hour'
AND amount BETWEEN 0.01 AND 1.00;

-- =====================================================
-- PERFORMANCE TESTING CLEANUP
-- =====================================================

-- Clean up performance testing data
DELETE FROM system_logs WHERE created_at >= NOW() - INTERVAL '2 hours'
AND message LIKE '%performance%';

DELETE FROM error_logs WHERE created_at >= NOW() - INTERVAL '2 hours'
AND error_type = 'PERFORMANCE';

-- =====================================================
-- SECURITY TESTING CLEANUP
-- =====================================================

-- Clean up security testing data
DELETE FROM access_logs WHERE created_at >= NOW() - INTERVAL '1 hour'
AND (ip_address LIKE '192.168.%' OR ip_address LIKE '10.%' OR ip_address LIKE '127.%');

DELETE FROM user_activity_logs WHERE created_at >= NOW() - INTERVAL '1 hour'
AND activity_type IN ('SECURITY_TEST', 'AUTH_TEST', 'PERMISSION_TEST');

-- =====================================================
-- INTEGRATION TESTING CLEANUP
-- =====================================================

-- Clean up integration testing data
DELETE FROM webhook_logs WHERE created_at >= NOW() - INTERVAL '1 hour'
AND endpoint LIKE '%/webhook/test%';

DELETE FROM integration_logs WHERE created_at >= NOW() - INTERVAL '1 hour'
AND integration_type IN ('TEST_WEBHOOK', 'TEST_API', 'TEST_SERVICE');

-- =====================================================
-- NOTIFICATION TESTING CLEANUP
-- =====================================================

-- Clean up notification testing data
DELETE FROM email_notifications WHERE created_at >= NOW() - INTERVAL '1 hour'
AND recipient_email LIKE '%@test.com';

DELETE FROM sms_notifications WHERE created_at >= NOW() - INTERVAL '1 hour'
AND phone_number LIKE '+123456789%';

DELETE FROM push_notifications WHERE created_at >= NOW() - INTERVAL '1 hour'
AND device_token LIKE 'test_%';

-- =====================================================
-- ANALYTICS TESTING CLEANUP
-- =====================================================

-- Clean up analytics testing data
DELETE FROM analytics_events WHERE created_at >= NOW() - INTERVAL '1 hour'
AND event_type LIKE 'TEST_%';

DELETE FROM user_analytics WHERE created_at >= NOW() - INTERVAL '1 hour'
AND user_id IN (SELECT id FROM users WHERE username LIKE 'testuser%');

-- =====================================================
-- CACHE CLEANUP
-- =====================================================

-- Clean up test cache entries
DELETE FROM cache_entries WHERE created_at >= NOW() - INTERVAL '1 hour'
AND cache_key LIKE 'test_%';

-- =====================================================
-- SESSION CLEANUP
-- =====================================================

-- Clean up test sessions
DELETE FROM session_data WHERE created_at >= NOW() - INTERVAL '1 hour'
AND session_id LIKE 'test_%';

-- =====================================================
-- VERIFICATION
-- =====================================================

-- Check cleanup results
SELECT 
    'Users' as table_name, 
    COUNT(*) as remaining_count,
    'Test users cleaned' as status
FROM users 
WHERE username LIKE 'testuser%'

UNION ALL

SELECT 
    'Merchants', 
    COUNT(*),
    'Test merchants cleaned'
FROM merchants 
WHERE business_name LIKE '%Test Store%'

UNION ALL

SELECT 
    'Vouchers', 
    COUNT(*),
    'Test vouchers cleaned'
FROM vouchers 
WHERE voucher_code LIKE 'TEST_%'

UNION ALL

SELECT 
    'Transactions', 
    COUNT(*),
    'Test transactions cleaned'
FROM transactions 
WHERE transaction_id LIKE 'TXN_TEST_%';

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

SELECT 'Specific test data cleanup completed successfully!' as status;
