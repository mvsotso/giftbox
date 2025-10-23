@echo off
echo ========================================
echo Gift Box Backend Docker Deployment
echo ========================================

echo.
echo Step 1: Building all services...
docker-compose build

echo.
echo Step 2: Starting infrastructure services...
docker-compose up -d postgres redis zookeeper kafka

echo.
echo Waiting for infrastructure to be ready...
timeout /t 30 /nobreak > nul

echo.
echo Step 3: Starting all microservices...
docker-compose up -d

echo.
echo Step 4: Checking service status...
docker-compose ps

echo.
echo ========================================
echo Deployment completed!
echo ========================================
echo.
echo Services are starting up. It may take a few minutes for all services to be ready.
echo.
echo You can check the logs with:
echo docker-compose logs -f [service-name]
echo.
echo Or check all logs with:
echo docker-compose logs -f
echo.
echo To stop all services:
echo docker-compose down
echo.
pause
