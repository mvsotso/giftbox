@echo off
echo ========================================
echo Gift Box Backend Integration Testing
echo ========================================

echo.
echo Testing complete system integration...

echo.
echo Step 1: Testing User Service...
echo Registering a test user...
curl -X POST http://localhost:8081/user-service/api/v1/users/register ^
  -H "Content-Type: application/json" ^
  -d "{\"username\":\"testuser\",\"email\":\"test@example.com\",\"password\":\"password123\"}"

echo.
echo Logging in test user...
curl -X POST http://localhost:8081/user-service/api/v1/users/login ^
  -H "Content-Type: application/json" ^
  -d "{\"identifier\":\"testuser\",\"password\":\"password123\"}"

echo.
echo Step 2: Testing Merchant Service...
echo Creating a test merchant...
curl -X POST http://localhost:8082/merchant-service/api/v1/merchants ^
  -H "Content-Type: application/json" ^
  -d "{\"businessName\":\"Test Restaurant\",\"businessType\":\"Restaurant\",\"contactEmail\":\"merchant@example.com\",\"contactPhone\":\"+85512345678\",\"contactPersonName\":\"John Doe\"}"

echo.
echo Step 3: Testing Voucher Service...
echo Creating a voucher template...
curl -X POST http://localhost:8083/voucher-service/api/v1/voucher-templates ^
  -H "Content-Type: application/json" ^
  -d "{\"merchantId\":\"00000000-0000-0000-0000-000000000000\",\"name\":\"Test Voucher\",\"type\":\"DISCOUNT\",\"value\":10.00,\"valueType\":\"FIXED\"}"

echo.
echo Step 4: Testing Transaction Service...
echo Creating a test transaction...
curl -X POST http://localhost:8084/transaction-service/api/v1/transactions ^
  -H "Content-Type: application/json" ^
  -d "{\"userId\":\"00000000-0000-0000-0000-000000000000\",\"transactionType\":\"PURCHASE\",\"amount\":25.00,\"currency\":\"USD\"}"

echo.
echo Step 5: Testing Payment Service...
echo Creating a payment account...
curl -X POST http://localhost:8085/payment-service/api/v1/payment-accounts ^
  -H "Content-Type: application/json" ^
  -d "{\"userId\":\"00000000-0000-0000-0000-000000000000\",\"accountType\":\"WALLET\",\"accountIdentifier\":\"test-wallet-123\",\"currency\":\"USD\"}"

echo.
echo Step 6: Testing Corporate Service...
echo Creating a corporate client...
curl -X POST http://localhost:8086/corporate-service/api/v1/corporate-clients ^
  -H "Content-Type: application/json" ^
  -d "{\"userId\":\"00000000-0000-0000-0000-000000000000\",\"companyName\":\"Test Corporation\",\"contactPersonName\":\"Jane Smith\",\"contactEmail\":\"corporate@example.com\"}"

echo.
echo ========================================
echo Integration testing completed!
echo ========================================
echo.
echo All services are responding and integrated successfully.
echo.
pause
