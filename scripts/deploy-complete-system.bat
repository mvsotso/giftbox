@echo off
echo ========================================
echo Gift Box Complete Backend System Deployment
echo ========================================

echo.
echo This script will deploy the complete Gift Box backend system with all 6 microservices.
echo.

echo Step 1: Stopping any existing containers...
docker-compose -f docker-compose-simple.yml down
docker-compose -f docker-compose-complete.yml down

echo.
echo Step 2: Building all services...
docker-compose -f docker-compose-complete.yml build

if %ERRORLEVEL% neq 0 (
    echo Build failed! Please check the logs above.
    pause
    exit /b 1
)

echo.
echo Step 3: Starting infrastructure services...
docker-compose -f docker-compose-complete.yml up -d postgres redis zookeeper kafka

echo.
echo Waiting for infrastructure to be ready...
echo This may take up to 2 minutes...
timeout /t 120 /nobreak > nul

echo.
echo Step 4: Starting all microservices...
docker-compose -f docker-compose-complete.yml up -d

echo.
echo Step 5: Waiting for services to start...
echo This may take up to 3 minutes...
timeout /t 180 /nobreak > nul

echo.
echo Step 6: Checking service status...
docker-compose -f docker-compose-complete.yml ps

echo.
echo Step 7: Testing all service endpoints...
echo.

echo Testing User Service (Port 8081):
curl -s http://localhost:8081/health

echo.
echo Testing Merchant Service (Port 8082):
curl -s http://localhost:8082/health

echo.
echo Testing Voucher Service (Port 8083):
curl -s http://localhost:8083/health

echo.
echo Testing Transaction Service (Port 8084):
curl -s http://localhost:8084/health

echo.
echo Testing Payment Service (Port 8085):
curl -s http://localhost:8085/health

echo.
echo Testing Corporate Service (Port 8086):
curl -s http://localhost:8086/health

echo.
echo ========================================
echo Complete system deployment finished!
echo ========================================
echo.
echo Your Gift Box Backend System is now running with all 6 microservices!
echo.
echo Service URLs:
echo - User Service: http://localhost:8081
echo - Merchant Service: http://localhost:8082
echo - Voucher Service: http://localhost:8083
echo - Transaction Service: http://localhost:8084
echo - Payment Service: http://localhost:8085
echo - Corporate Service: http://localhost:8086
echo.
echo Infrastructure:
echo - PostgreSQL: localhost:5432
echo - Redis: localhost:6379
echo - Kafka: localhost:9092
echo - Zookeeper: localhost:2181
echo.
echo To view logs: docker-compose -f docker-compose-complete.yml logs -f
echo To stop services: docker-compose -f docker-compose-complete.yml down
echo.
pause
