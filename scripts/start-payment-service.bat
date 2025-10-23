@echo off
echo Starting Gift Box Payment Service...

cd services\payment-service

echo Building the application...
mvn clean install -DskipTests

echo Starting Payment Service...
mvn spring-boot:run

pause
