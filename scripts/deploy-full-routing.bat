@echo off
echo ========================================
echo    Gift Box Full API Gateway Deployment
echo ========================================
echo.

echo [1/4] Stopping current gateway...
docker-compose stop nginx-gateway
echo.

echo [2/4] Updating to full routing configuration...
copy nginx\nginx-full.conf nginx\nginx.conf
echo.

echo [3/4] Starting full gateway...
docker-compose up -d nginx-gateway
echo.

echo [4/4] Waiting for gateway to be ready...
timeout /t 10 /nobreak > nul
echo.

echo ========================================
echo    Full API Gateway Status Check
echo ========================================
echo.

echo Testing basic routing...
curl -s http://localhost:9080/health
if %errorlevel% equ 0 (
    echo ✓ Basic routing is working
) else (
    echo ✗ Basic routing failed
)
echo.

echo Testing root endpoint...
curl -s http://localhost:9080/
if %errorlevel% equ 0 (
    echo ✓ Root endpoint is working
) else (
    echo ✗ Root endpoint failed
)
echo.

echo ========================================
echo    Full API Gateway Routes
echo ========================================
echo.
echo Gateway URL: http://localhost:9080
echo.
echo Available Routes:
echo   - /health                    → Test Service Health
echo   - /                         → Test Service Root
echo   - /api/v1/users/*           → User Service
echo   - /api/v1/merchants/*       → Merchant Service
echo   - /api/v1/vouchers/*        → Voucher Service
echo   - /api/v1/transactions/*    → Transaction Service
echo   - /api/v1/payments/*        → Payment Service
echo   - /api/v1/corporate/*       → Corporate Service
echo.
echo Features:
echo   ✓ CORS enabled
echo   ✓ Rate limiting (10 req/s)
echo   ✓ Load balancing ready
echo   ✓ Health monitoring
echo.
echo ========================================
echo    Full API Gateway Deployment Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Deploy microservices: docker-compose up -d user-service merchant-service voucher-service transaction-service payment-service corporate-service
echo 2. Test all routes through gateway
echo 3. Monitor gateway performance
echo.
pause
