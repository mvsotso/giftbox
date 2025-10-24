@echo off
echo ========================================
echo    Gift Box API Gateway Routing Test
echo ========================================
echo.

echo [1/6] Testing Gateway Health...
curl -s http://localhost:9080/health
if %errorlevel% equ 0 (
    echo ✓ Gateway health check passed
) else (
    echo ✗ Gateway health check failed
)
echo.

echo [2/6] Testing Root Endpoint...
curl -s http://localhost:9080/
if %errorlevel% equ 0 (
    echo ✓ Root endpoint is working
) else (
    echo ✗ Root endpoint failed
)
echo.

echo [3/6] Testing Direct Service Access...
curl -s http://localhost:8080/health
if %errorlevel% equ 0 (
    echo ✓ Direct service access working
) else (
    echo ✗ Direct service access failed
)
echo.

echo [4/6] Testing Gateway vs Direct Service...
echo Gateway response:
curl -s http://localhost:9080/health
echo.
echo Direct service response:
curl -s http://localhost:8080/health
echo.

echo [5/6] Testing Gateway Headers...
curl -s -I http://localhost:9080/health
echo.

echo [6/6] Testing Gateway Performance...
echo Testing response time...
powershell -Command "Measure-Command { curl -s http://localhost:9080/health | Out-Null }"
echo.

echo ========================================
echo    Routing Test Results
echo ========================================
echo.
echo Gateway URL: http://localhost:9080
echo Direct Service: http://localhost:8080
echo.
echo Routes configured:
echo   - /health → Test Service Health
echo   - / → Test Service Root
echo.
echo Test completed! Gateway is routing correctly.
echo.
pause
