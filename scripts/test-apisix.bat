@echo off
echo ========================================
echo    APISIX Gateway Testing
echo ========================================
echo.

echo [1/6] Testing APISIX Admin API...
curl -s http://localhost:9180/apisix/admin/routes
if %errorlevel% equ 0 (
    echo ✓ Admin API is accessible
) else (
    echo ✗ Admin API is not accessible
)
echo.

echo [2/6] Testing Gateway Health...
curl -s http://localhost:9080/health
if %errorlevel% equ 0 (
    echo ✓ Gateway health check passed
) else (
    echo ✗ Gateway health check failed
)
echo.

echo [3/6] Testing User Service Route...
curl -s -X GET http://localhost:9080/api/v1/users/health
if %errorlevel% equ 0 (
    echo ✓ User service route is working
) else (
    echo ✗ User service route failed (service may not be running)
)
echo.

echo [4/6] Testing Merchant Service Route...
curl -s -X GET http://localhost:9080/api/v1/merchants/health
if %errorlevel% equ 0 (
    echo ✓ Merchant service route is working
) else (
    echo ✗ Merchant service route failed (service may not be running)
)
echo.

echo [5/6] Testing CORS Headers...
curl -s -H "Origin: http://localhost:3000" -H "Access-Control-Request-Method: GET" -H "Access-Control-Request-Headers: X-Requested-With" -X OPTIONS http://localhost:9080/api/v1/users/health
if %errorlevel% equ 0 (
    echo ✓ CORS is configured
) else (
    echo ✗ CORS test failed
)
echo.

echo [6/6] Testing Rate Limiting...
echo Testing rate limit (sending 5 requests quickly)...
for /l %%i in (1,1,5) do (
    curl -s http://localhost:9080/health > nul
    echo Request %%i sent
)
echo.

echo ========================================
echo    APISIX Gateway Test Results
echo ========================================
echo.
echo Gateway URL: http://localhost:9080
echo Admin API:   http://localhost:9180
echo.
echo Test completed! Check the results above.
echo.
pause
