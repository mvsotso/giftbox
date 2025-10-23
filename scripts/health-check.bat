@echo off
echo ========================================
echo Gift Box Backend Health Check
echo ========================================

echo.
echo Checking service health endpoints...

echo.
echo User Service Health Check...
curl -s http://localhost:8081/user-service/api/v1/users/health || echo "User Service is not responding"

echo.
echo Merchant Service Health Check...
curl -s http://localhost:8082/merchant-service/api/v1/merchants/health || echo "Merchant Service is not responding"

echo.
echo Voucher Service Health Check...
curl -s http://localhost:8083/voucher-service/api/v1/vouchers/health || echo "Voucher Service is not responding"

echo.
echo Transaction Service Health Check...
curl -s http://localhost:8084/transaction-service/api/v1/transactions/health || echo "Transaction Service is not responding"

echo.
echo Payment Service Health Check...
curl -s http://localhost:8085/payment-service/api/v1/payments/health || echo "Payment Service is not responding"

echo.
echo Corporate Service Health Check...
curl -s http://localhost:8086/corporate-service/api/v1/corporate/health || echo "Corporate Service is not responding"

echo.
echo ========================================
echo Health check completed!
echo ========================================
echo.
pause
