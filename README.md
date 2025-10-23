# Gift Box Backend System

This repository contains the complete backend implementation for the Gift Box platform, built with Spring Boot, PostgreSQL, Redis, and Kafka, following a microservices architecture.

## 🏗️ **Architecture Overview**

The system consists of 6 microservices:

- **User Service** (Port 8081) - User management and authentication
- **Merchant Service** (Port 8082) - Business verification and merchant management
- **Voucher Service** (Port 8083) - Voucher creation, validation, and redemption
- **Transaction Service** (Port 8084) - Transaction logging and reconciliation
- **Payment Service** (Port 8085) - Payment gateway integration (ABA/Wing/KESS)
- **Corporate Service** (Port 8086) - B2B bulk orders and employee distribution

## 📁 **Project Structure**

```
backend/
├── database/                    # PostgreSQL database schemas
│   ├── 01-user-service-schema.sql
│   ├── 02-merchant-service-schema.sql
│   ├── 03-voucher-service-schema.sql
│   ├── 04-transaction-service-schema.sql
│   ├── 05-payment-service-schema.sql
│   └── 06-corporate-service-schema.sql
├── services/                    # Individual Spring Boot microservices
│   ├── user-service/           # Complete User Service implementation
│   ├── merchant-service/       # Complete Merchant Service implementation
│   ├── voucher-service/        # Complete Voucher Service implementation
│   ├── transaction-service/    # Complete Transaction Service implementation
│   ├── payment-service/        # Complete Payment Service implementation
│   └── corporate-service/      # Complete Corporate Service implementation
├── scripts/                    # Deployment and setup scripts
│   ├── setup-databases.bat     # Database setup script
│   ├── setup-complete-system.bat # Complete system setup
│   ├── start-all-services.bat  # Start all services
│   ├── health-check.bat        # Health check script
│   └── [service]-service.bat   # Individual service startup scripts
├── docker-compose.yml          # Docker Compose for infrastructure
└── README.md                   # This guide
```

## 🛠️ **Technologies Used**

- **Spring Boot 3.1.5**: Microservices framework
- **Java 17+**: Programming language
- **PostgreSQL 18**: Primary relational database
- **Redis**: Caching and session management
- **Kafka**: Event streaming for inter-service communication
- **Spring Data JPA**: ORM for database interaction
- **Spring Security**: Authentication and Authorization (JWT)
- **Lombok**: Boilerplate code reduction
- **Docker/Docker Compose**: Containerization and orchestration
- **Maven**: Build automation tool

## 📋 **Prerequisites**

Before you begin, ensure you have the following installed on your Windows 11 system:

- **Java Development Kit (JDK) 17 or higher**
- **Maven 3.9 or higher**
- **PostgreSQL 18** (or use the Dockerized version)
- **Redis** (optional, for caching)
- **Kafka** (optional, for event streaming)

## 🚀 **Quick Start**

### 1. **Complete System Setup**

Run the complete setup script to set up databases and build all services:

```bash
scripts\setup-complete-system.bat
```

### 2. **Start All Services**

Start all backend services:

```bash
scripts\start-all-services.bat
```

### 3. **Health Check**

Verify all services are running:

```bash
scripts\health-check.bat
```

## 🐳 **Docker Deployment (Recommended)**

For easy setup without Maven repository issues, use Docker:

### Quick Docker Setup

```bash
# Complete Docker deployment
scripts\docker-complete-setup.bat
```

### Manual Docker Setup

```bash
# Build and start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### Docker Commands

```bash
# Start infrastructure only
docker-compose up -d postgres redis zookeeper kafka

# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

See [DOCKER-DEPLOYMENT.md](DOCKER-DEPLOYMENT.md) for detailed Docker setup instructions.

## 🔧 **Manual Setup (Step by Step)**

### 1. **Database Setup**

Create PostgreSQL databases and apply schemas:

```bash
# Create databases
psql -U postgres -c "CREATE DATABASE giftbox_user;"
psql -U postgres -c "CREATE DATABASE giftbox_merchant;"
psql -U postgres -c "CREATE DATABASE giftbox_voucher;"
psql -U postgres -c "CREATE DATABASE giftbox_transaction;"
psql -U postgres -c "CREATE DATABASE giftbox_payment;"
psql -U postgres -c "CREATE DATABASE giftbox_corporate;"

# Apply schemas
psql -U postgres -d giftbox_user -f database/01-user-service-schema.sql
psql -U postgres -d giftbox_merchant -f database/02-merchant-service-schema.sql
psql -U postgres -d giftbox_voucher -f database/03-voucher-service-schema.sql
psql -U postgres -d giftbox_transaction -f database/04-transaction-service-schema.sql
psql -U postgres -d giftbox_payment -f database/05-payment-service-schema.sql
psql -U postgres -d giftbox_corporate -f database/06-corporate-service-schema.sql
```

### 2. **Start Individual Services**

Start services individually:

```bash
# User Service
scripts\start-user-service.bat

# Merchant Service
scripts\start-merchant-service.bat

# Voucher Service
scripts\start-voucher-service.bat

# Transaction Service
scripts\start-transaction-service.bat

# Payment Service
scripts\start-payment-service.bat

# Corporate Service
scripts\start-corporate-service.bat
```

## 🌐 **Service Endpoints**

### **User Service** (Port 8081)
- **Base URL**: http://localhost:8081/user-service
- **Swagger UI**: http://localhost:8081/user-service/swagger-ui.html
- **Health Check**: http://localhost:8081/user-service/api/v1/users/health

### **Merchant Service** (Port 8082)
- **Base URL**: http://localhost:8082/merchant-service
- **Swagger UI**: http://localhost:8082/merchant-service/swagger-ui.html
- **Health Check**: http://localhost:8082/merchant-service/api/v1/merchants/health

### **Voucher Service** (Port 8083)
- **Base URL**: http://localhost:8083/voucher-service
- **Swagger UI**: http://localhost:8083/voucher-service/swagger-ui.html
- **Health Check**: http://localhost:8083/voucher-service/api/v1/vouchers/health

### **Transaction Service** (Port 8084)
- **Base URL**: http://localhost:8084/transaction-service
- **Swagger UI**: http://localhost:8084/transaction-service/swagger-ui.html
- **Health Check**: http://localhost:8084/transaction-service/api/v1/transactions/health

### **Payment Service** (Port 8085)
- **Base URL**: http://localhost:8085/payment-service
- **Swagger UI**: http://localhost:8085/payment-service/swagger-ui.html
- **Health Check**: http://localhost:8085/payment-service/api/v1/payments/health

### **Corporate Service** (Port 8086)
- **Base URL**: http://localhost:8086/corporate-service
- **Swagger UI**: http://localhost:8086/corporate-service/swagger-ui.html
- **Health Check**: http://localhost:8086/corporate-service/api/v1/corporate/health

## 🔐 **Authentication**

All services use JWT-based authentication. To access protected endpoints:

1. **Register a user** via User Service
2. **Login** to get JWT tokens
3. **Include JWT token** in Authorization header: `Bearer <your-jwt-token>`

## 📊 **API Testing**

### **Using Swagger UI**
Each service provides Swagger UI for interactive API testing:
- Navigate to the Swagger UI URL for any service
- Use the "Authorize" button to set JWT tokens
- Test API endpoints directly from the browser

### **Using Postman/Insomnia**
Import the API documentation or use the Swagger JSON endpoints:
- **API Docs**: `{service-url}/api-docs`

## 🐳 **Docker Support**

For containerized deployment, use the provided Docker Compose:

```bash
# Start infrastructure services
docker-compose up -d postgres redis kafka

# Start individual services
docker-compose up -d user-service merchant-service voucher-service
```

## 🔍 **Monitoring and Logs**

### **Health Monitoring**
- Each service provides health check endpoints
- Use the health check script to monitor all services
- Prometheus metrics are available at `/actuator/prometheus`

### **Logging**
- Services log to console and files
- Log levels can be configured in `application.yml`
- Structured logging with timestamps and correlation IDs

## 🚨 **Troubleshooting**

### **Common Issues**

1. **Database Connection Issues**
   - Verify PostgreSQL is running
   - Check database credentials in `application.yml`
   - Ensure databases exist and schemas are applied

2. **Port Conflicts**
   - Check if ports 8081-8086 are available
   - Modify port numbers in `application.yml` if needed

3. **Maven Build Issues**
   - Ensure Java 17+ is installed
   - Check Maven configuration
   - Clear Maven cache: `mvn clean install -U`

4. **Service Startup Issues**
   - Check logs for specific error messages
   - Verify all dependencies are available
   - Ensure required environment variables are set

### **Getting Help**

- Check service logs for detailed error messages
- Use health check endpoints to verify service status
- Review Swagger documentation for API usage
- Check database connections and schema setup

## 📈 **Performance Optimization**

### **Database Optimization**
- Proper indexing on frequently queried columns
- Connection pooling with HikariCP
- Query optimization and monitoring

### **Caching**
- Redis caching for frequently accessed data
- Service-level caching with Spring Cache
- Cache invalidation strategies

### **Monitoring**
- Prometheus metrics collection
- Health check endpoints
- Performance monitoring and alerting

## 🔄 **Development Workflow**

1. **Make changes** to service code
2. **Rebuild service**: `mvn clean install -DskipTests`
3. **Restart service**: Use individual service startup scripts
4. **Test changes** via Swagger UI or API clients
5. **Monitor logs** for any issues

## 📝 **Configuration**

### **Environment Variables**
- Database credentials
- JWT secrets
- Payment gateway API keys
- Redis and Kafka connection details

### **Application Properties**
- Service-specific configurations in `application.yml`
- Database connection settings
- Security configurations
- Logging configurations

## 🎯 **Integration with Flutter App**

The backend services are designed to work seamlessly with your Flutter application:

1. **Authentication Flow**: Flutter app calls User Service for login/registration
2. **API Integration**: Use JWT tokens for secure API access
3. **Real-time Updates**: Kafka events for real-time notifications
4. **Caching**: Redis for improved performance

## 📚 **Additional Resources**

- **Spring Boot Documentation**: https://spring.io/projects/spring-boot
- **PostgreSQL Documentation**: https://www.postgresql.org/docs/
- **Redis Documentation**: https://redis.io/documentation
- **Kafka Documentation**: https://kafka.apache.org/documentation/

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License.

---

**🎉 Congratulations! Your Gift Box backend system is now ready for production use!**