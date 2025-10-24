@echo off
echo ========================================
echo    Running Postman Tests for Gift Box
echo ========================================
echo.

echo [1/4] Checking prerequisites...
where newman >nul 2>&1
if %errorlevel% neq 0 (
    echo ✗ Newman CLI is not installed
    echo.
    echo Please install Newman CLI:
    echo npm install -g newman
    echo.
    echo Or install Node.js and npm first:
    echo https://nodejs.org/
    pause
    exit /b 1
) else (
    echo ✓ Newman CLI is installed
)

echo.
echo [2/4] Checking Postman collection files...
if not exist "postman\Gift_Box_APISIX_Collection.json" (
    echo ✗ Postman collection not found
    echo Please ensure the collection file exists at: postman\Gift_Box_APISIX_Collection.json
    pause
    exit /b 1
) else (
    echo ✓ Postman collection found
)

if not exist "postman\Gift_Box_Environment.json" (
    echo ✗ Environment file not found
    echo Please ensure the environment file exists at: postman\Gift_Box_Environment.json
    pause
    exit /b 1
) else (
    echo ✓ Environment file found
)

echo.
echo [3/4] Checking APISIX gateway...
curl -s http://localhost:9080/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️ APISIX gateway not responding on localhost:9080
    echo Please ensure the gateway is running before running tests
    echo.
    echo To start the gateway:
    echo docker-compose up -d nginx-gateway
    echo.
    set /p continue="Continue anyway? (y/n): "
    if /i not "%continue%"=="y" (
        echo Tests cancelled
        pause
        exit /b 1
    )
) else (
    echo ✓ APISIX gateway is responding
)

echo.
echo [4/4] Running Postman tests...
echo.

echo Running basic health checks...
newman run postman\Gift_Box_APISIX_Collection.json -e postman\Gift_Box_Environment.json --folder "Health Checks" --reporters cli,html --reporter-html-export postman\test-results\health-checks.html

if %errorlevel% equ 0 (
    echo.
    echo ✓ Health checks completed successfully
) else (
    echo.
    echo ✗ Health checks failed
    echo Please check the APISIX gateway and services
)

echo.
echo Running user service tests...
newman run postman\Gift_Box_APISIX_Collection.json -e postman\Gift_Box_Environment.json --folder "User Service" --reporters cli,html --reporter-html-export postman\test-results\user-service.html

if %errorlevel% equ 0 (
    echo.
    echo ✓ User service tests completed successfully
) else (
    echo.
    echo ✗ User service tests failed
)

echo.
echo Running merchant service tests...
newman run postman\Gift_Box_APISIX_Collection.json -e postman\Gift_Box_Environment.json --folder "Merchant Service" --reporters cli,html --reporter-html-export postman\test-results\merchant-service.html

if %errorlevel% equ 0 (
    echo.
    echo ✓ Merchant service tests completed successfully
) else (
    echo.
    echo ✗ Merchant service tests failed
)

echo.
echo Running voucher service tests...
newman run postman\Gift_Box_APISIX_Collection.json -e postman\Gift_Box_Environment.json --folder "Voucher Service" --reporters cli,html --reporter-html-export postman\test-results\voucher-service.html

if %errorlevel% equ 0 (
    echo.
    echo ✓ Voucher service tests completed successfully
) else (
    echo.
    echo ✗ Voucher service tests failed
)

echo.
echo Running transaction service tests...
newman run postman\Gift_Box_APISIX_Collection.json -e postman\Gift_Box_Environment.json --folder "Transaction Service" --reporters cli,html --reporter-html-export postman\test-results\transaction-service.html

if %errorlevel% equ 0 (
    echo.
    echo ✓ Transaction service tests completed successfully
) else (
    echo.
    echo ✗ Transaction service tests failed
)

echo.
echo Running payment service tests...
newman run postman\Gift_Box_APISIX_Collection.json -e postman\Gift_Box_Environment.json --folder "Payment Service" --reporters cli,html --reporter-html-export postman\test-results\payment-service.html

if %errorlevel% equ 0 (
    echo.
    echo ✓ Payment service tests completed successfully
) else (
    echo.
    echo ✗ Payment service tests failed
)

echo.
echo Running corporate service tests...
newman run postman\Gift_Box_APISIX_Collection.json -e postman\Gift_Box_Environment.json --folder "Corporate Service" --reporters cli,html --reporter-html-export postman\test-results\corporate-service.html

if %errorlevel% equ 0 (
    echo.
    echo ✓ Corporate service tests completed successfully
) else (
    echo.
    echo ✗ Corporate service tests failed
)

echo.
echo Running load tests...
newman run postman\Gift_Box_APISIX_Collection.json -e postman\Gift_Box_Environment.json --folder "Load Testing" --reporters cli,html --reporter-html-export postman\test-results\load-testing.html

if %errorlevel% equ 0 (
    echo.
    echo ✓ Load tests completed successfully
) else (
    echo.
    echo ✗ Load tests failed
)

echo.
echo ========================================
echo    Test Execution Complete!
echo ========================================
echo.
echo Test results have been saved to:
echo postman\test-results\
echo.
echo You can view the HTML reports in your browser.
echo.
echo Next steps:
echo 1. Review the test results
echo 2. Check any failed tests
echo 3. Verify service functionality
echo 4. Update tests if needed
echo.
pause
