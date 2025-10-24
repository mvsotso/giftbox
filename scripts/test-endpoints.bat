@echo off
echo ========================================
echo    Testing Gift Box API Endpoints
echo ========================================
echo.

echo [1/4] Testing Nginx Gateway (Port 9081)...
curl -s http://localhost:9081/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ Nginx Gateway is working on port 9081
) else (
    echo.
    echo ✗ Nginx Gateway is not responding on port 9081
)

echo.
echo [2/4] Testing Direct Test Service (Port 8080)...
curl -s http://localhost:8080/health
if %errorlevel% equ 0 (
    echo.
    echo ✓ Test Service is working on port 8080
) else (
    echo.
    echo ✗ Test Service is not responding on port 8080
)

echo.
echo [3/4] Testing Root Endpoint...
curl -s http://localhost:9081/
if %errorlevel% equ 0 (
    echo.
    echo ✓ Root endpoint is working
) else (
    echo.
    echo ✗ Root endpoint is not responding
)

echo.
echo [4/4] Port Summary:
echo.
echo Working Endpoints:
echo - Nginx Gateway: http://localhost:9081/health
echo - Test Service:  http://localhost:8080/health
echo - Root Endpoint: http://localhost:9081/
echo.
echo For Postman Testing:
echo - Use base_url: http://localhost:9081
echo - All API requests should go through the gateway
echo.
pause
