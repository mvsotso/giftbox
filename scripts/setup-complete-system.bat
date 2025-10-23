@echo off
echo ========================================
echo Gift Box Backend System Setup
echo ========================================

echo.
echo Step 1: Setting up PostgreSQL databases...
call scripts\setup-databases.bat

echo.
echo Step 2: Testing database connections...
call scripts\test-db-connection.bat

echo.
echo Step 3: Building all services...
echo Building User Service...
cd services\user-service
mvn clean install -DskipTests
cd ..\..

echo Building Merchant Service...
cd services\merchant-service
mvn clean install -DskipTests
cd ..\..

echo Building Voucher Service...
cd services\voucher-service
mvn clean install -DskipTests
cd ..\..

echo Building Transaction Service...
cd services\transaction-service
mvn clean install -DskipTests
cd ..\..

echo Building Payment Service...
cd services\payment-service
mvn clean install -DskipTests
cd ..\..

echo Building Corporate Service...
cd services\corporate-service
mvn clean install -DskipTests
cd ..\..

echo.
echo ========================================
echo Setup completed successfully!
echo ========================================
echo.
echo Next steps:
echo 1. Start Redis server
echo 2. Start Kafka server
echo 3. Run start-all-services.bat to start all services
echo.
echo Service URLs will be available at:
echo - User Service: http://localhost:8081/user-service
echo - Merchant Service: http://localhost:8082/merchant-service
echo - Voucher Service: http://localhost:8083/voucher-service
echo - Transaction Service: http://localhost:8084/transaction-service
echo - Payment Service: http://localhost:8085/payment-service
echo - Corporate Service: http://localhost:8086/corporate-service
echo.
pause
