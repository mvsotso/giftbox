@echo off
echo ========================================
echo    Gift Box APISIX Gateway Deployment
echo ========================================
echo.

echo [1/4] Starting infrastructure services...
docker-compose up -d postgres redis zookeeper kafka etcd
echo.

echo [2/4] Waiting for infrastructure services to be healthy...
timeout /t 30 /nobreak > nul
echo.

echo [3/4] Starting APISIX API Gateway...
docker-compose up -d apisix
echo.

echo [4/4] Waiting for APISIX to be ready...
timeout /t 20 /nobreak > nul
echo.

echo ========================================
echo    APISIX Gateway Status Check
echo ========================================
echo.

echo Checking APISIX Admin API...
curl -s http://localhost:9180/apisix/admin/routes > nul
if %errorlevel% equ 0 (
    echo ✓ APISIX Admin API is running
) else (
    echo ✗ APISIX Admin API is not responding
)

echo.
echo Checking APISIX Gateway...
curl -s http://localhost:9080/health > nul
if %errorlevel% equ 0 (
    echo ✓ APISIX Gateway is running
) else (
    echo ✗ APISIX Gateway is not responding
)

echo.
echo ========================================
echo    Service Endpoints
echo ========================================
echo.
echo Gateway URL: http://localhost:9080
echo Admin API:   http://localhost:9180
echo.
echo Available Routes:
echo   - /api/v1/users/*      → User Service
echo   - /api/v1/merchants/*  → Merchant Service  
echo   - /api/v1/vouchers/*   → Voucher Service
echo   - /api/v1/transactions/* → Transaction Service
echo   - /api/v1/payments/*   → Payment Service
echo   - /api/v1/corporate/*  → Corporate Service
echo   - /health              → Health Check
echo.

echo ========================================
echo    Testing Gateway
echo ========================================
echo.

echo Testing health endpoint through gateway...
curl -s http://localhost:9080/health
echo.
echo.

echo Testing admin API...
curl -s http://localhost:9180/apisix/admin/routes
echo.
echo.

echo ========================================
echo    APISIX Gateway Deployment Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Start microservices: docker-compose up -d user-service merchant-service voucher-service transaction-service payment-service corporate-service
echo 2. Test API endpoints through gateway
echo 3. Monitor gateway logs: docker logs giftbox-apisix
echo.
pause
