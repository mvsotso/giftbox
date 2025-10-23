@echo off
echo ========================================
echo Gift Box Backend Complete Docker Setup
echo ========================================

echo.
echo This script will:
echo 1. Build all Docker images
echo 2. Start infrastructure services
echo 3. Start all microservices
echo 4. Run health checks
echo 5. Test the system
echo.

echo Starting Docker deployment...
echo.

echo Step 1: Building all services...
docker-compose build

if %ERRORLEVEL% neq 0 (
    echo Build failed! Please check the logs above.
    pause
    exit /b 1
)

echo.
echo Step 2: Starting infrastructure services...
docker-compose up -d postgres redis zookeeper kafka

echo.
echo Waiting for infrastructure to be ready...
echo This may take up to 2 minutes...
timeout /t 120 /nobreak > nul

echo.
echo Step 3: Starting all microservices...
docker-compose up -d

echo.
echo Step 4: Waiting for services to start...
echo This may take up to 3 minutes...
timeout /t 180 /nobreak > nul

echo.
echo Step 5: Checking service status...
docker-compose ps

echo.
echo Step 6: Running health checks...
call scripts\docker-status.bat

echo.
echo Step 7: Running integration test...
call scripts\docker-test.bat

echo.
echo ========================================
echo Complete Docker setup finished!
echo ========================================
echo.
echo Your Gift Box Backend System is now running!
echo.
echo Service URLs:
echo - User Service: http://localhost:8081/user-service
echo - Merchant Service: http://localhost:8082/merchant-service
echo - Voucher Service: http://localhost:8083/voucher-service
echo - Transaction Service: http://localhost:8084/transaction-service
echo - Payment Service: http://localhost:8085/payment-service
echo - Corporate Service: http://localhost:8086/corporate-service
echo.
echo To view logs: docker-compose logs -f
echo To stop services: docker-compose down
echo.
pause
