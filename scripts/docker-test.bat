@echo off
echo ========================================
echo Gift Box Backend Docker Test
echo ========================================

echo.
echo Testing Docker deployment...
echo.

echo 1. Checking Docker containers...
docker-compose ps

echo.
echo 2. Testing User Service registration...
curl -X POST -H "Content-Type: application/json" -d "{\"username\":\"testuser\",\"email\":\"test@example.com\",\"password\":\"Password123!\",\"phoneNumber\":\"+855123456789\"}" http://localhost:8081/user-service/api/v1/users/register

echo.
echo 3. Testing User Service login...
curl -X POST -H "Content-Type: application/json" -d "{\"identifier\":\"testuser\",\"password\":\"Password123!\"}" http://localhost:8081/user-service/api/v1/users/login

echo.
echo 4. Testing Merchant Service health...
curl -s http://localhost:8082/merchant-service/api/v1/merchants/health

echo.
echo 5. Testing Voucher Service health...
curl -s http://localhost:8083/voucher-service/api/v1/vouchers/health

echo.
echo ========================================
echo Docker test completed!
echo ========================================
echo.
echo If you see successful responses above, your Docker deployment is working!
echo.
pause
