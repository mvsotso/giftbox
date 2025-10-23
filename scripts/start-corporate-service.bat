@echo off
echo Starting Gift Box Corporate Service...

cd services\corporate-service

echo Building the application...
mvn clean install -DskipTests

echo Starting Corporate Service...
mvn spring-boot:run

pause
