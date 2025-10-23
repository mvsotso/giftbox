@echo off
echo ========================================
echo Starting Gift Box Backend Services
echo ========================================

echo.
echo Starting infrastructure services...
start "Redis" cmd /k "redis-server"
start "Kafka" cmd /k "kafka-server-start.bat config\server.properties"

echo.
echo Waiting for infrastructure to start...
timeout /t 10 /nobreak > nul

echo.
echo Starting User Service...
start "User Service" cmd /k "cd services\user-service && mvn spring-boot:run"

echo.
echo Starting Merchant Service...
start "Merchant Service" cmd /k "cd services\merchant-service && mvn spring-boot:run"

echo.
echo Starting Voucher Service...
start "Voucher Service" cmd /k "cd services\voucher-service && mvn spring-boot:run"

echo.
echo Starting Transaction Service...
start "Transaction Service" cmd /k "cd services\transaction-service && mvn spring-boot:run"

echo.
echo Starting Payment Service...
start "Payment Service" cmd /k "cd services\payment-service && mvn spring-boot:run"

echo.
echo Starting Corporate Service...
start "Corporate Service" cmd /k "cd services\corporate-service && mvn spring-boot:run"

echo.
echo ========================================
echo All services are starting up...
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
echo Swagger Documentation:
echo - User Service: http://localhost:8081/user-service/swagger-ui.html
echo - Merchant Service: http://localhost:8082/merchant-service/swagger-ui.html
echo - Voucher Service: http://localhost:8083/voucher-service/swagger-ui.html
echo - Transaction Service: http://localhost:8084/transaction-service/swagger-ui.html
echo - Payment Service: http://localhost:8085/payment-service/swagger-ui.html
echo - Corporate Service: http://localhost:8086/corporate-service/swagger-ui.html
echo.
echo Press any key to continue...
pause > nul
