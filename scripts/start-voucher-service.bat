@echo off
echo Starting Gift Box Voucher Service...

cd services\voucher-service

echo Building the application...
mvn clean install -DskipTests

echo Starting Voucher Service...
mvn spring-boot:run

pause
