@echo off
echo ========================================
echo    Testing APISIX
echo ========================================
echo.

echo Waiting for APISIX to be ready...
timeout /t 15 /nobreak > nul

echo.
echo [1/3] Testing APISIX Gateway (Port 9080)...
curl -s http://localhost:9080/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ APISIX Gateway is working
) else (
    echo.
    echo ✗ APISIX Gateway: 404 Route Not Found
)

echo.
echo [2/3] Testing APISIX Root Route...
curl -s http://localhost:9080/
if %errorlevel% equ 0 (
    echo.
    echo ✓ APISIX Root route is working
) else (
    echo.
    echo ✗ APISIX Root route: 404 Route Not Found
)

echo.
echo [3/3] Testing APISIX Admin API...
curl -s -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" http://localhost:9180/apisix/admin/routes
if %errorlevel% equ 0 (
    echo.
    echo ✓ APISIX Admin API is working
) else (
    echo.
    echo ✗ APISIX Admin API: Connection refused
)

echo.
echo ========================================
echo    APISIX Status Summary
echo ========================================
echo.
echo Issues Found:
echo - Routes not configured (404 errors)
echo - Admin API may not be accessible
echo.
echo Next Steps:
echo 1. Configure routes via Admin API
echo 2. Test gateway endpoints
echo 3. Verify routing to test service
echo.
pause
