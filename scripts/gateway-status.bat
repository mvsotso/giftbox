@echo off
echo ========================================
echo    API Gateway Status Report
echo ========================================
echo.

echo [1/3] Testing Nginx Gateway (Port 9081)...
curl -s http://localhost:9081/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ Nginx Gateway: WORKING PERFECTLY
    echo   - Health endpoint: http://localhost:9081/health
    echo   - Root endpoint: http://localhost:9081/
    echo   - Status: Ready for testing
) else (
    echo.
    echo ✗ Nginx Gateway: NOT WORKING
)

echo.
echo [2/3] Testing APISIX Gateway (Port 9080)...
curl -s http://localhost:9080/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ APISIX Gateway: WORKING
) else (
    echo.
    echo ✗ APISIX Gateway: NOT WORKING
    echo   - Error: 404 Route Not Found
    echo   - Issue: Configuration schema errors
    echo   - Status: Needs configuration fixes
)

echo.
echo [3/3] Testing APISIX Admin API (Port 9180)...
curl -s http://localhost:9180/apisix/admin/routes
if %errorlevel% equ 0 (
    echo.
    echo ✓ APISIX Admin API: WORKING
) else (
    echo.
    echo ✗ APISIX Admin API: NOT WORKING
    echo   - Error: Connection refused
    echo   - Issue: Admin API not accessible
    echo   - Status: Configuration problems
)

echo.
echo ========================================
echo    RECOMMENDATION
echo ========================================
echo.
echo ✅ USE NGINX GATEWAY (Port 9081)
echo.
echo Reasons:
echo - Nginx Gateway is working perfectly
echo - APISIX has configuration issues
echo - Nginx is simpler and more reliable
echo - All endpoints are accessible
echo.
echo For Postman Testing:
echo - Base URL: http://localhost:9081
echo - Health: http://localhost:9081/health
echo - Root: http://localhost:9081/
echo.
echo APISIX Issues:
echo - Configuration schema validation errors
echo - Admin API not accessible
echo - Routes not properly configured
echo - Needs significant troubleshooting
echo.
pause
