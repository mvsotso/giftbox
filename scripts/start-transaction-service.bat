@echo off
echo Starting Gift Box Transaction Service...

cd services\transaction-service

echo Building the application...
mvn clean install -DskipTests

echo Starting Transaction Service...
mvn spring-boot:run

pause
