@echo off
echo ========================================
echo Gift Box Backend System Test
echo ========================================

echo.
echo Testing database connections...
call scripts\test-db-connection.bat

echo.
echo Testing simple Spring Boot service...
cd test-service
echo Building test service...
mvn clean install -DskipTests

echo.
echo Starting test service...
start "Test Service" cmd /k "java -jar target\test-service-1.0.0.jar"

echo.
echo Waiting for service to start...
timeout /t 15 /nobreak > nul

echo.
echo Testing service endpoint...
curl -s http://localhost:8080/health

echo.
echo ========================================
echo System test completed!
echo ========================================
echo.
echo If you see "Test Service is running!" above, your system is working!
echo.
echo Next steps:
echo 1. Fix Maven repository configuration
echo 2. Build the main services
echo 3. Start all services
echo.
pause
