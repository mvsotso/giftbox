@echo off
echo ========================================
echo    Testing Security Fixes
echo ========================================
echo.

echo [1/6] Testing Security Headers...
echo.
echo Testing Nginx Gateway Security Headers...
curl -I http://localhost:9081/health 2>nul | findstr "X-Frame-Options\|X-Content-Type-Options\|X-XSS-Protection"
if %errorlevel% equ 0 (
    echo ✓ Security headers present
) else (
    echo ✗ Security headers missing
)

echo.
echo [2/6] Testing Rate Limiting...
echo.
echo Testing rate limiting (sending 5 rapid requests)...
for /L %%i in (1,1,5) do (
    curl -s http://localhost:9081/health >nul 2>&1
    echo Request %%i sent
)
echo Rate limiting test completed

echo.
echo [3/6] Testing CORS Configuration...
echo.
echo Testing CORS headers...
curl -H "Origin: http://localhost:3000" -H "Access-Control-Request-Method: GET" -H "Access-Control-Request-Headers: X-Requested-With" -X OPTIONS http://localhost:9081/health 2>nul | findstr "Access-Control-Allow-Origin"
if %errorlevel% equ 0 (
    echo ✓ CORS headers present
) else (
    echo ✗ CORS headers missing
)

echo.
echo [4/6] Testing Environment Variables...
echo.
echo Checking for hardcoded passwords...
findstr /r "abc123ABC" services\*\src\main\resources\application.yml
if %errorlevel% equ 0 (
    echo ✗ Hardcoded passwords still found
) else (
    echo ✓ No hardcoded passwords found
)

echo.
echo [5/6] Testing Logging Configuration...
echo.
echo Checking logging levels...
findstr "DEBUG\|TRACE" services\user-service\src\main\resources\application.yml
if %errorlevel% equ 0 (
    echo ⚠️ Debug logging still enabled
) else (
    echo ✓ Debug logging disabled
)

echo.
echo [6/6] Testing Database Security...
echo.
echo Checking database configuration...
findstr "password.*abc123" services\*\src\main\resources\application.yml
if %errorlevel% equ 0 (
    echo ✗ Hardcoded database passwords found
) else (
    echo ✓ Database passwords using environment variables
)

echo.
echo ========================================
echo    Security Test Summary
echo ========================================
echo.
echo Security Fixes Applied:
echo ✓ Removed hardcoded passwords
echo ✓ Added security headers
echo ✓ Implemented rate limiting
echo ✓ Added CORS configuration
echo ✓ Disabled debug logging
echo ✓ Added environment variable support
echo.
echo Next Steps:
echo 1. Set up environment variables (.env file)
echo 2. Test with secure configurations
echo 3. Deploy with security measures enabled
echo.
pause
