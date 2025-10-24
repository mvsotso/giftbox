@echo off
echo ========================================
echo    Configuring APISIX Routes
echo ========================================
echo.

echo Waiting for APISIX to start...
timeout /t 20 /nobreak > nul

echo.
echo [1/3] Testing APISIX Admin API...
curl -s -X GET "http://localhost:9180/apisix/admin/routes" -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1"
if %errorlevel% equ 0 (
    echo.
    echo ✓ APISIX Admin API is accessible
) else (
    echo.
    echo ✗ APISIX Admin API is not accessible
    echo Trying alternative approach...
)

echo.
echo [2/3] Creating Health Route...
curl -s -X PUT "http://localhost:9180/apisix/admin/routes/1" ^
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" ^
  -H "Content-Type: application/json" ^
  -d "{\"uri\": \"/health\", \"upstream\": {\"type\": \"roundrobin\", \"nodes\": {\"test-service:8080\": 1}}}"

echo.
echo [3/3] Creating Root Route...
curl -s -X PUT "http://localhost:9180/apisix/admin/routes/2" ^
  -H "X-API-KEY: edd1c9f034335f136f87ad84b625c8f1" ^
  -H "Content-Type: application/json" ^
  -d "{\"uri\": \"/\", \"upstream\": {\"type\": \"roundrobin\", \"nodes\": {\"test-service:8080\": 1}}}"

echo.
echo ========================================
echo    Testing Configured Routes
echo ========================================
echo.

echo Testing Health Route...
curl -s http://localhost:9080/health
echo.

echo Testing Root Route...
curl -s http://localhost:9080/
echo.

echo.
echo Configuration complete!
pause
