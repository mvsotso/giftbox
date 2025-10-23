@echo off
echo Starting Gift Box User Service...

cd services\user-service

echo Building the application...
mvn clean install -DskipTests

echo Starting User Service...
mvn spring-boot:run

pause