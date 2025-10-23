@echo off
echo ========================================
echo Gift Box Backend Docker Status Check
echo ========================================

echo.
echo Checking Docker containers status...
docker-compose ps

echo.
echo Checking service health endpoints...
echo.

echo User Service (Port 8081):
curl -s http://localhost:8081/user-service/api/v1/users/health || echo "Service not ready yet"

echo.
echo Merchant Service (Port 8082):
curl -s http://localhost:8082/merchant-service/api/v1/merchants/health || echo "Service not ready yet"

echo.
echo Voucher Service (Port 8083):
curl -s http://localhost:8083/voucher-service/api/v1/vouchers/health || echo "Service not ready yet"

echo.
echo Transaction Service (Port 8084):
curl -s http://localhost:8084/transaction-service/api/v1/transactions/health || echo "Service not ready yet"

echo.
echo Payment Service (Port 8085):
curl -s http://localhost:8085/payment-service/api/v1/payments/health || echo "Service not ready yet"

echo.
echo Corporate Service (Port 8086):
curl -s http://localhost:8086/corporate-service/api/v1/corporate/health || echo "Service not ready yet"

echo.
echo ========================================
echo Status check completed!
echo ========================================
pause
