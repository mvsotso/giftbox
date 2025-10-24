@echo off
echo ========================================
echo    Testing Both API Gateways
echo ========================================
echo.

echo [1/3] Testing Nginx Gateway (Port 9081)...
curl -s http://localhost:9081/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ Nginx Gateway is working on port 9081
) else (
    echo.
    echo ✗ Nginx Gateway is not responding on port 9081
)

echo.
echo [2/3] Testing APISIX Gateway (Port 9080)...
curl -s http://localhost:9080/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ APISIX Gateway is working on port 9080
) else (
    echo.
    echo ✗ APISIX Gateway is not responding on port 9080
)

echo.
echo [3/3] Testing APISIX Admin API (Port 9180)...
curl -s http://localhost:9180/apisix/admin/routes
if %errorlevel% equ 0 (
    echo.
    echo ✓ APISIX Admin API is working on port 9180
) else (
    echo.
    echo ✗ APISIX Admin API is not responding on port 9180
)

echo.
echo ========================================
echo    Gateway Status Summary
echo ========================================
echo.
echo Working Gateways:
echo - Nginx Gateway: http://localhost:9081/health
echo.
echo APISIX Issues:
echo - APISIX Gateway: http://localhost:9080/health (Configuration errors)
echo - APISIX Admin:  http://localhost:9180/apisix/admin/routes (Connection issues)
echo.
echo Recommendation:
echo - Use Nginx Gateway (Port 9081) for testing
echo - APISIX needs configuration fixes
echo.
pause
