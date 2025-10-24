@echo off
echo ========================================
echo    Gift Box Advanced Test Data Cleanup
echo ========================================
echo.

echo Select cleanup type:
echo 1. Full cleanup (all test data)
echo 2. User testing cleanup only
echo 3. Merchant testing cleanup only
echo 4. Voucher testing cleanup only
echo 5. Transaction testing cleanup only
echo 6. Payment testing cleanup only
echo 7. Corporate testing cleanup only
echo 8. API testing cleanup only
echo 9. Load testing cleanup only
echo 0. Custom cleanup
echo.

set /p choice="Enter your choice (1-9, 0): "

echo.
echo [1/4] Checking database connection...
docker exec giftbox-postgres pg_isready -U giftbox_user -d giftbox
if %errorlevel% neq 0 (
    echo ✗ Database is not accessible
    echo Please ensure PostgreSQL is running
    pause
    exit /b 1
) else (
    echo ✓ Database is accessible
)

echo.
echo [2/4] Creating database backup...
set timestamp=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timestamp=%timestamp: =0%
docker exec giftbox-postgres pg_dump -U giftbox_user -d giftbox > database\backup-%timestamp%.sql
if %errorlevel% equ 0 (
    echo ✓ Database backup created: database\backup-%timestamp%.sql
) else (
    echo ⚠️ Warning: Could not create backup
)

echo.
echo [3/4] Executing cleanup based on selection...

if "%choice%"=="1" (
    echo Running full cleanup...
    docker exec -i giftbox-postgres psql -U giftbox_user -d giftbox < database\cleanup-test-data.sql
    if %errorlevel% equ 0 (
        echo ✓ Full cleanup completed successfully
    ) else (
        echo ✗ Full cleanup failed
    )
) else if "%choice%"=="2" (
    echo Running user testing cleanup...
    docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
    DELETE FROM user_sessions WHERE user_id IN (SELECT id FROM users WHERE username LIKE 'testuser%');
    DELETE FROM users WHERE username LIKE 'testuser%' OR email LIKE '%@testuser.com' OR email LIKE '%@test.com';
    "
    if %errorlevel% equ 0 (
        echo ✓ User testing cleanup completed successfully
    ) else (
        echo ✗ User testing cleanup failed
    )
) else if "%choice%"=="3" (
    echo Running merchant testing cleanup...
    docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
    DELETE FROM merchant_staff WHERE merchant_id IN (SELECT id FROM merchants WHERE business_name LIKE '%Test Store%');
    DELETE FROM merchants WHERE business_name LIKE '%Test Store%' OR business_name LIKE '%Demo Store%' OR email LIKE '%@merchant-test.com';
    "
    if %errorlevel% equ 0 (
        echo ✓ Merchant testing cleanup completed successfully
    ) else (
        echo ✗ Merchant testing cleanup failed
    )
) else if "%choice%"=="4" (
    echo Running voucher testing cleanup...
    docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
    DELETE FROM voucher_redemptions WHERE voucher_id IN (SELECT id FROM vouchers WHERE voucher_code LIKE 'TEST_%');
    DELETE FROM vouchers WHERE voucher_code LIKE 'TEST_%' OR voucher_code LIKE 'VOUCHER_%' OR amount IN (1.00, 5.00, 10.00, 25.00, 50.00, 100.00);
    "
    if %errorlevel% equ 0 (
        echo ✓ Voucher testing cleanup completed successfully
    ) else (
        echo ✗ Voucher testing cleanup failed
    )
) else if "%choice%"=="5" (
    echo Running transaction testing cleanup...
    docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
    DELETE FROM transaction_items WHERE transaction_id IN (SELECT id FROM transactions WHERE transaction_id LIKE 'TXN_TEST_%');
    DELETE FROM transactions WHERE transaction_id LIKE 'TXN_TEST_%' OR amount IN (1.00, 5.00, 10.00, 25.00, 50.00, 100.00);
    "
    if %errorlevel% equ 0 (
        echo ✓ Transaction testing cleanup completed successfully
    ) else (
        echo ✗ Transaction testing cleanup failed
    )
) else if "%choice%"=="6" (
    echo Running payment testing cleanup...
    docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
    DELETE FROM payments WHERE payment_id LIKE 'PAY_TEST_%' OR amount IN (1.00, 5.00, 10.00, 25.00, 50.00, 100.00);
    "
    if %errorlevel% equ 0 (
        echo ✓ Payment testing cleanup completed successfully
    ) else (
        echo ✗ Payment testing cleanup failed
    )
) else if "%choice%"=="7" (
    echo Running corporate testing cleanup...
    docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
    DELETE FROM corporate_users WHERE corporate_id IN (SELECT id FROM corporate_accounts WHERE company_name LIKE '%Test Corp%');
    DELETE FROM corporate_accounts WHERE company_name LIKE '%Test Corp%' OR company_name LIKE '%Demo Corp%' OR email LIKE '%@corporate-test.com';
    "
    if %errorlevel% equ 0 (
        echo ✓ Corporate testing cleanup completed successfully
    ) else (
        echo ✗ Corporate testing cleanup failed
    )
) else if "%choice%"=="8" (
    echo Running API testing cleanup...
    docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
    DELETE FROM api_logs WHERE endpoint LIKE '%/test%' OR endpoint LIKE '%/demo%' OR user_agent LIKE '%Postman%' OR user_agent LIKE '%curl%';
    "
    if %errorlevel% equ 0 (
        echo ✓ API testing cleanup completed successfully
    ) else (
        echo ✗ API testing cleanup failed
    )
) else if "%choice%"=="9" (
    echo Running load testing cleanup...
    docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
    DELETE FROM users WHERE created_at >= NOW() - INTERVAL '1 hour' AND (username LIKE 'loadtest_%' OR email LIKE '%@loadtest.com');
    DELETE FROM transactions WHERE created_at >= NOW() - INTERVAL '1 hour' AND amount BETWEEN 0.01 AND 1.00;
    "
    if %errorlevel% equ 0 (
        echo ✓ Load testing cleanup completed successfully
    ) else (
        echo ✗ Load testing cleanup failed
    )
) else if "%choice%"=="0" (
    echo Custom cleanup options:
    echo 1. Clean data older than 1 hour
    echo 2. Clean data older than 1 day
    echo 3. Clean data older than 1 week
    echo 4. Clean specific user data
    echo 5. Clean specific merchant data
    echo.
    set /p custom_choice="Enter custom choice (1-5): "
    
    if "%custom_choice%"=="1" (
        echo Cleaning data older than 1 hour...
        docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
        DELETE FROM users WHERE created_at >= NOW() - INTERVAL '1 hour';
        DELETE FROM merchants WHERE created_at >= NOW() - INTERVAL '1 hour';
        DELETE FROM vouchers WHERE created_at >= NOW() - INTERVAL '1 hour';
        DELETE FROM transactions WHERE created_at >= NOW() - INTERVAL '1 hour';
        DELETE FROM payments WHERE created_at >= NOW() - INTERVAL '1 hour';
        "
    ) else if "%custom_choice%"=="2" (
        echo Cleaning data older than 1 day...
        docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
        DELETE FROM users WHERE created_at >= NOW() - INTERVAL '1 day';
        DELETE FROM merchants WHERE created_at >= NOW() - INTERVAL '1 day';
        DELETE FROM vouchers WHERE created_at >= NOW() - INTERVAL '1 day';
        DELETE FROM transactions WHERE created_at >= NOW() - INTERVAL '1 day';
        DELETE FROM payments WHERE created_at >= NOW() - INTERVAL '1 day';
        "
    ) else if "%custom_choice%"=="3" (
        echo Cleaning data older than 1 week...
        docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
        DELETE FROM users WHERE created_at >= NOW() - INTERVAL '1 week';
        DELETE FROM merchants WHERE created_at >= NOW() - INTERVAL '1 week';
        DELETE FROM vouchers WHERE created_at >= NOW() - INTERVAL '1 week';
        DELETE FROM transactions WHERE created_at >= NOW() - INTERVAL '1 week';
        DELETE FROM payments WHERE created_at >= NOW() - INTERVAL '1 week';
        "
    ) else (
        echo Invalid custom choice
    )
) else (
    echo Invalid choice. Please run the script again.
    pause
    exit /b 1
)

echo.
echo [4/4] Verifying cleanup results...
echo.

echo Checking remaining data counts:
docker exec giftbox-postgres psql -U giftbox_user -d giftbox -c "
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
"

echo.
echo ========================================
echo    Cleanup Complete!
echo ========================================
echo.
echo Test data cleanup has been completed.
echo.
echo Backup file created: database\backup-%timestamp%.sql
echo.
echo Next steps:
echo 1. Verify the cleanup results above
echo 2. Run your tests again with clean data
echo 3. Use the backup file if you need to restore data
echo.
pause
