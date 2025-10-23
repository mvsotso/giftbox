@echo off
echo Starting Gift Box Merchant Service...

cd services\merchant-service

echo Building the application...
mvn clean install -DskipTests

echo Starting Merchant Service...
mvn spring-boot:run

pause
