# 🐳 Docker Deployment Guide

## Overview
This guide provides step-by-step instructions for deploying the Gift Box Backend System using Docker Compose.

## Prerequisites
- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)
- At least 4GB RAM available for Docker
- Ports 5432, 6379, 9092, 8081-8086 available

## Quick Start

### 1. Deploy the System
```bash
# Navigate to the backend directory
cd backend

# Run the deployment script
scripts\docker-deploy.bat
```

### 2. Check Status
```bash
# Check all services status
scripts\docker-status.bat
```

## Manual Deployment Steps

### Step 1: Build All Services
```bash
docker-compose build
```

### Step 2: Start Infrastructure Services
```bash
# Start PostgreSQL, Redis, and Kafka
docker-compose up -d postgres redis zookeeper kafka

# Wait for infrastructure to be ready (about 30 seconds)
```

### Step 3: Start All Microservices
```bash
# Start all services
docker-compose up -d
```

### Step 4: Verify Deployment
```bash
# Check container status
docker-compose ps

# Check logs
docker-compose logs -f
```

## Service Endpoints

Once deployed, the following services will be available:

| Service | Port | Health Check | Description |
|---------|------|--------------|-------------|
| User Service | 8081 | `/user-service/api/v1/users/health` | User management and authentication |
| Merchant Service | 8082 | `/merchant-service/api/v1/merchants/health` | Merchant management |
| Voucher Service | 8083 | `/voucher-service/api/v1/vouchers/health` | Voucher and gift box management |
| Transaction Service | 8084 | `/transaction-service/api/v1/transactions/health` | Transaction processing |
| Payment Service | 8085 | `/payment-service/api/v1/payments/health` | Payment processing |
| Corporate Service | 8086 | `/corporate-service/api/v1/corporate/health` | Corporate client management |

## Infrastructure Services

| Service | Port | Description |
|---------|------|-------------|
| PostgreSQL | 5432 | Main database |
| Redis | 6379 | Caching and session storage |
| Kafka | 9092 | Event streaming |
| Zookeeper | 2181 | Kafka coordination |

## Useful Commands

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f user-service

# Last 100 lines
docker-compose logs --tail=100 user-service
```

### Restart Services
```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart user-service
```

### Scale Services
```bash
# Scale user service to 3 instances
docker-compose up -d --scale user-service=3
```

### Stop Services
```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Troubleshooting

### Common Issues

1. **Port Already in Use**
   - Check if ports 5432, 6379, 9092, 8081-8086 are available
   - Stop conflicting services or change ports in docker-compose.yml

2. **Services Not Starting**
   - Check Docker Desktop is running
   - Ensure sufficient memory (4GB+)
   - Check logs: `docker-compose logs [service-name]`

3. **Database Connection Issues**
   - Wait for PostgreSQL to fully start (about 30 seconds)
   - Check PostgreSQL logs: `docker-compose logs postgres`

4. **Kafka Issues**
   - Ensure Zookeeper is running first
   - Check Kafka logs: `docker-compose logs kafka`

### Health Checks

All services include health checks. You can monitor them:

```bash
# Check health status
docker-compose ps

# Manual health check
curl http://localhost:8081/user-service/api/v1/users/health
```

## Development Mode

For development, you can run services individually:

```bash
# Start only infrastructure
docker-compose up -d postgres redis zookeeper kafka

# Run specific service locally
cd services/user-service
mvn spring-boot:run
```

## Production Considerations

1. **Environment Variables**: Use `.env` file for production secrets
2. **Resource Limits**: Set memory and CPU limits in docker-compose.yml
3. **Logging**: Configure centralized logging
4. **Monitoring**: Add monitoring and alerting
5. **Security**: Use secrets management for sensitive data
6. **Backup**: Implement database backup strategies

## Cleanup

To completely remove the deployment:

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: This will delete all data)
docker-compose down -v

# Remove images
docker-compose down --rmi all
```

## Support

If you encounter issues:

1. Check the logs: `docker-compose logs -f`
2. Verify Docker Desktop is running
3. Ensure ports are available
4. Check system resources (RAM, disk space)
5. Review the troubleshooting section above

---

**Happy Deploying! 🚀**
