@echo off
echo ========================================
echo Starting Gift Box Services (Simple Mode)
echo ========================================

echo.
echo Note: Due to Maven repository issues, we'll start services individually.
echo Please ensure you have Java 17+ installed and PostgreSQL running.
echo.

echo Starting User Service...
start "User Service" cmd /k "cd services\user-service && java -jar target\user-service-1.0.0.jar"

echo.
echo Starting Merchant Service...
start "Merchant Service" cmd /k "cd services\merchant-service && java -jar target\merchant-service-1.0.0.jar"

echo.
echo Starting Voucher Service...
start "Voucher Service" cmd /k "cd services\voucher-service && java -jar target\voucher-service-1.0.0.jar"

echo.
echo Starting Transaction Service...
start "Transaction Service" cmd /k "cd services\transaction-service && java -jar target\transaction-service-1.0.0.jar"

echo.
echo Starting Payment Service...
start "Payment Service" cmd /k "cd services\payment-service && java -jar target\payment-service-1.0.0.jar"

echo.
echo Starting Corporate Service...
start "Corporate Service" cmd /k "cd services\corporate-service && java -jar target\corporate-service-1.0.0.jar"

echo.
echo ========================================
echo Services are starting up...
echo ========================================
echo.
echo Service URLs:
echo - User Service: http://localhost:8081/user-service
echo - Merchant Service: http://localhost:8082/merchant-service
echo - Voucher Service: http://localhost:8083/voucher-service
echo - Transaction Service: http://localhost:8084/transaction-service
echo - Payment Service: http://localhost:8085/payment-service
echo - Corporate Service: http://localhost:8086/corporate-service
echo.
echo Note: If you get "jar not found" errors, you need to build the services first.
echo Run: scripts\build-services.bat
echo.
pause
