@echo off
echo ========================================
echo Building Gift Box Services
echo ========================================

echo.
echo Fixing Maven repository issues...
echo.

echo Building User Service...
cd services\user-service
mvn clean install -DskipTests -o
cd ..\..

echo Building Merchant Service...
cd services\merchant-service
mvn clean install -DskipTests -o
cd ..\..

echo Building Voucher Service...
cd services\voucher-service
mvn clean install -DskipTests -o
cd ..\..

echo Building Transaction Service...
cd services\transaction-service
mvn clean install -DskipTests -o
cd ..\..

echo Building Payment Service...
cd services\payment-service
mvn clean install -DskipTests -o
cd ..\..

echo Building Corporate Service...
cd services\corporate-service
mvn clean install -DskipTests -o
cd ..\..

echo.
echo ========================================
echo Build completed!
echo ========================================
echo.
echo Now you can run: scripts\start-services-simple.bat
echo.
pause
