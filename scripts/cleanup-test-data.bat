@echo off
echo ========================================
echo    Gift Box Test Data Cleanup
echo ========================================
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
echo [2/4] Creating database backup before cleanup...
docker exec giftbox-postgres pg_dump -U giftbox_user -d giftbox > database\backup-before-cleanup.sql
if %errorlevel% equ 0 (
    echo ✓ Database backup created: database\backup-before-cleanup.sql
) else (
    echo ⚠️ Warning: Could not create backup
)

echo.
echo [3/4] Executing test data cleanup...
echo.

echo Running comprehensive cleanup...
docker exec -i giftbox-postgres psql -U giftbox_user -d giftbox < database\cleanup-test-data.sql

if %errorlevel% equ 0 (
    echo ✓ Comprehensive cleanup completed successfully
) else (
    echo ✗ Comprehensive cleanup failed
    echo Please check the database logs
)

echo.
echo Running specific test cleanup...
docker exec -i giftbox-postgres psql -U giftbox_user -d giftbox < database\cleanup-specific-test.sql

if %errorlevel% equ 0 (
    echo ✓ Specific test cleanup completed successfully
) else (
    echo ✗ Specific test cleanup failed
    echo Please check the database logs
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
echo Test data has been cleaned from the database.
echo.
echo Backup file created: database\backup-before-cleanup.sql
echo.
echo Next steps:
echo 1. Verify the cleanup results above
echo 2. Run your tests again with clean data
echo 3. Use the backup file if you need to restore data
echo.
pause
