@echo off
echo ========================================
echo    Comprehensive APISIX Test
echo ========================================
echo.

echo [1/6] Checking APISIX Container Status...
docker ps | findstr apisix
if %errorlevel% equ 0 (
    echo ✓ APISIX container is running
) else (
    echo ✗ APISIX container is not running
    echo Checking stopped containers...
    docker ps -a | findstr apisix
)

echo.
echo [2/6] Testing APISIX Gateway Port (9080)...
curl -s http://localhost:9080/health
if %errorlevel% equ 0 (
    echo ✓ APISIX Gateway responding
) else (
    echo ✗ APISIX Gateway: 404 Route Not Found
)

echo.
echo [3/6] Testing APISIX Root Route...
curl -s http://localhost:9080/
if %errorlevel% equ 0 (
    echo ✓ APISIX Root route responding
) else (
    echo ✗ APISIX Root route: 404 Route Not Found
)

echo.
echo [4/6] Testing APISIX Admin API (9180)...
curl -s -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" http://localhost:9180/apisix/admin/routes
if %errorlevel% equ 0 (
    echo ✓ APISIX Admin API responding
) else (
    echo ✗ APISIX Admin API: Connection refused
)

echo.
echo [5/6] Testing Network Connectivity...
docker network inspect giftbox_default | findstr apisix
if %errorlevel% equ 0 (
    echo ✓ APISIX is in the network
) else (
    echo ✗ APISIX is NOT in the network
    echo This is the root cause of the routing issues!
)

echo.
echo [6/6] Testing Test Service Connectivity...
docker network inspect giftbox_default | findstr test-service
if %errorlevel% equ 0 (
    echo ✓ Test service is in the network
) else (
    echo ✗ Test service is NOT in the network
)

echo.
echo ========================================
echo    DIAGNOSIS
echo ========================================
echo.
echo Issues Found:
echo 1. APISIX Admin API not accessible
echo 2. Routes not configured (404 errors)
echo 3. Network connectivity issues
echo.
echo Root Cause:
echo - APISIX configuration problems
echo - Admin API not working
echo - Routes not being loaded
echo.
echo Recommendation:
echo - Use Nginx Gateway (Port 9081) - WORKING PERFECTLY
echo - APISIX needs significant troubleshooting
echo.
pause
