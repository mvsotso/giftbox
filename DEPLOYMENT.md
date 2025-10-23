# Gift Box Backend Deployment Guide

This guide provides comprehensive instructions for deploying the Gift Box backend system in different environments.

## 🚀 **Quick Deployment**

### **Windows Development Environment**

1. **Prerequisites Setup**
   ```bash
   # Ensure you have:
   # - Java 17+
   # - Maven 3.9+
   # - PostgreSQL 18
   # - Redis (optional)
   # - Kafka (optional)
   ```

2. **Complete System Setup**
   ```bash
   scripts\setup-complete-system.bat
   ```

3. **Start All Services**
   ```bash
   scripts\start-all-services.bat
   ```

4. **Health Check**
   ```bash
   scripts\health-check.bat
   ```

## 🐳 **Docker Deployment**

### **Using Docker Compose**

1. **Start Infrastructure Services**
   ```bash
   docker-compose up -d postgres redis kafka
   ```

2. **Build and Start Services**
   ```bash
   # Build all services
   mvn clean install -DskipTests

   # Start services individually
   docker-compose up -d user-service
   docker-compose up -d merchant-service
   docker-compose up -d voucher-service
   docker-compose up -d transaction-service
   docker-compose up -d payment-service
   docker-compose up -d corporate-service
   ```

### **Individual Service Docker Deployment**

1. **Build Service Image**
   ```bash
   cd services/user-service
   docker build -t giftbox-user-service .
   ```

2. **Run Service Container**
   ```bash
   docker run -d -p 8081:8081 \
     -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/giftbox_user \
     -e SPRING_DATASOURCE_USERNAME=postgres \
     -e SPRING_DATASOURCE_PASSWORD=abc123ABC!@# \
     giftbox-user-service
   ```

## ☁️ **Cloud Deployment**

### **AWS Deployment**

1. **EC2 Instance Setup**
   ```bash
   # Launch EC2 instance with:
   # - Ubuntu 20.04 LTS
   # - t3.medium or larger
   # - Security groups for ports 8081-8086
   ```

2. **Install Dependencies**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y

   # Install Java 17
   sudo apt install openjdk-17-jdk -y

   # Install Maven
   sudo apt install maven -y

   # Install PostgreSQL
   sudo apt install postgresql postgresql-contrib -y

   # Install Redis
   sudo apt install redis-server -y
   ```

3. **Database Setup**
   ```bash
   # Create databases
   sudo -u postgres psql -c "CREATE DATABASE giftbox_user;"
   sudo -u postgres psql -c "CREATE DATABASE giftbox_merchant;"
   sudo -u postgres psql -c "CREATE DATABASE giftbox_voucher;"
   sudo -u postgres psql -c "CREATE DATABASE giftbox_transaction;"
   sudo -u postgres psql -c "CREATE DATABASE giftbox_payment;"
   sudo -u postgres psql -c "CREATE DATABASE giftbox_corporate;"

   # Apply schemas
   sudo -u postgres psql -d giftbox_user -f database/01-user-service-schema.sql
   sudo -u postgres psql -d giftbox_merchant -f database/02-merchant-service-schema.sql
   sudo -u postgres psql -d giftbox_voucher -f database/03-voucher-service-schema.sql
   sudo -u postgres psql -d giftbox_transaction -f database/04-transaction-service-schema.sql
   sudo -u postgres psql -d giftbox_payment -f database/05-payment-service-schema.sql
   sudo -u postgres psql -d giftbox_corporate -f database/06-corporate-service-schema.sql
   ```

4. **Deploy Services**
   ```bash
   # Clone repository
   git clone <repository-url>
   cd giftbox/backend

   # Build all services
   mvn clean install -DskipTests

   # Start services
   nohup java -jar services/user-service/target/user-service-1.0.0.jar &
   nohup java -jar services/merchant-service/target/merchant-service-1.0.0.jar &
   nohup java -jar services/voucher-service/target/voucher-service-1.0.0.jar &
   nohup java -jar services/transaction-service/target/transaction-service-1.0.0.jar &
   nohup java -jar services/payment-service/target/payment-service-1.0.0.jar &
   nohup java -jar services/corporate-service/target/corporate-service-1.0.0.jar &
   ```

### **Azure Deployment**

1. **Azure App Service Setup**
   ```bash
   # Create App Service plans for each service
   az appservice plan create --name giftbox-plan --resource-group giftbox-rg --sku B1

   # Create App Services
   az webapp create --name giftbox-user-service --resource-group giftbox-rg --plan giftbox-plan
   az webapp create --name giftbox-merchant-service --resource-group giftbox-rg --plan giftbox-plan
   az webapp create --name giftbox-voucher-service --resource-group giftbox-rg --plan giftbox-plan
   az webapp create --name giftbox-transaction-service --resource-group giftbox-rg --plan giftbox-plan
   az webapp create --name giftbox-payment-service --resource-group giftbox-rg --plan giftbox-plan
   az webapp create --name giftbox-corporate-service --resource-group giftbox-rg --plan giftbox-plan
   ```

2. **Configure Database Connection**
   ```bash
   # Set database connection strings
   az webapp config appsettings set --name giftbox-user-service --resource-group giftbox-rg --settings SPRING_DATASOURCE_URL="jdbc:postgresql://your-db-server:5432/giftbox_user"
   ```

### **Google Cloud Platform Deployment**

1. **Cloud Run Deployment**
   ```bash
   # Build and deploy services
   gcloud builds submit --tag gcr.io/your-project/giftbox-user-service services/user-service
   gcloud run deploy giftbox-user-service --image gcr.io/your-project/giftbox-user-service --platform managed --region us-central1
   ```

## 🔧 **Production Configuration**

### **Environment Variables**

```bash
# Database Configuration
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/giftbox_user
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=your-secure-password

# JWT Configuration
APP_JWT_SECRET=your-super-secure-jwt-secret-key
APP_JWT_ACCESS_TOKEN_EXPIRATION_MS=3600000
APP_JWT_REFRESH_TOKEN_EXPIRATION_MS=604800000

# Redis Configuration
SPRING_REDIS_HOST=localhost
SPRING_REDIS_PORT=6379

# Kafka Configuration
SPRING_KAFKA_BOOTSTRAP_SERVERS=localhost:9092

# Payment Gateway Configuration
ABA_PAY_API_KEY=your-aba-pay-api-key
ABA_PAY_SECRET_KEY=your-aba-pay-secret-key
WING_API_KEY=your-wing-api-key
WING_SECRET_KEY=your-wing-secret-key
```

### **Security Configuration**

1. **SSL/TLS Setup**
   ```bash
   # Generate SSL certificates
   keytool -genkeypair -alias giftbox -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore giftbox.p12 -validity 3650
   ```

2. **Firewall Configuration**
   ```bash
   # Allow only necessary ports
   ufw allow 8081:8086/tcp
   ufw allow 5432/tcp
   ufw allow 6379/tcp
   ufw allow 9092/tcp
   ```

### **Monitoring and Logging**

1. **Application Monitoring**
   ```bash
   # Enable Prometheus metrics
   management.endpoints.web.exposure.include=health,info,metrics,prometheus
   ```

2. **Log Management**
   ```bash
   # Configure log rotation
   logback-spring.xml
   ```

## 📊 **Performance Optimization**

### **Database Optimization**

1. **Connection Pooling**
   ```yaml
   spring:
     datasource:
       hikari:
         maximum-pool-size: 20
         minimum-idle: 5
         connection-timeout: 30000
   ```

2. **Query Optimization**
   ```sql
   -- Create indexes for frequently queried columns
   CREATE INDEX idx_users_email ON users(email);
   CREATE INDEX idx_merchants_status ON merchants(status);
   ```

### **Caching Strategy**

1. **Redis Configuration**
   ```yaml
   spring:
     redis:
       lettuce:
         pool:
           max-active: 8
           max-idle: 8
           min-idle: 0
   ```

2. **Application Caching**
   ```java
   @Cacheable(value = "users", key = "#id")
   public UserDTO getUserById(UUID id) {
       // Implementation
   }
   ```

## 🔍 **Health Monitoring**

### **Health Check Endpoints**

- **User Service**: `http://localhost:8081/user-service/api/v1/users/health`
- **Merchant Service**: `http://localhost:8082/merchant-service/api/v1/merchants/health`
- **Voucher Service**: `http://localhost:8083/voucher-service/api/v1/vouchers/health`
- **Transaction Service**: `http://localhost:8084/transaction-service/api/v1/transactions/health`
- **Payment Service**: `http://localhost:8085/payment-service/api/v1/payments/health`
- **Corporate Service**: `http://localhost:8086/corporate-service/api/v1/corporate/health`

### **Monitoring Tools**

1. **Prometheus Metrics**
   ```bash
   # Access metrics
   curl http://localhost:8081/user-service/actuator/prometheus
   ```

2. **Health Dashboard**
   ```bash
   # Create health check script
   scripts/health-check.bat
   ```

## 🚨 **Troubleshooting**

### **Common Issues**

1. **Service Won't Start**
   ```bash
   # Check logs
   tail -f logs/application.log
   
   # Check port availability
   netstat -tulpn | grep :8081
   ```

2. **Database Connection Issues**
   ```bash
   # Test database connection
   psql -h localhost -U postgres -d giftbox_user -c "SELECT 1;"
   ```

3. **Memory Issues**
   ```bash
   # Increase JVM memory
   java -Xmx2g -Xms1g -jar user-service-1.0.0.jar
   ```

### **Log Analysis**

1. **Application Logs**
   ```bash
   # View service logs
   tail -f services/user-service/logs/application.log
   ```

2. **Error Tracking**
   ```bash
   # Search for errors
   grep -i error logs/application.log
   ```

## 📈 **Scaling**

### **Horizontal Scaling**

1. **Load Balancer Setup**
   ```bash
   # Use Nginx as load balancer
   upstream user_service {
       server localhost:8081;
       server localhost:8082;
   }
   ```

2. **Service Replication**
   ```bash
   # Run multiple instances
   java -jar user-service-1.0.0.jar --server.port=8081
   java -jar user-service-1.0.0.jar --server.port=8082
   ```

### **Vertical Scaling**

1. **Resource Allocation**
   ```bash
   # Increase JVM memory
   java -Xmx4g -Xms2g -jar user-service-1.0.0.jar
   ```

2. **Database Optimization**
   ```bash
   # Optimize PostgreSQL settings
   shared_buffers = 256MB
   effective_cache_size = 1GB
   ```

## 🔄 **Backup and Recovery**

### **Database Backup**

1. **Automated Backup**
   ```bash
   # Create backup script
   pg_dump -h localhost -U postgres giftbox_user > backup_user_$(date +%Y%m%d).sql
   ```

2. **Recovery Process**
   ```bash
   # Restore from backup
   psql -h localhost -U postgres giftbox_user < backup_user_20231201.sql
   ```

### **Application Backup**

1. **Configuration Backup**
   ```bash
   # Backup configuration files
   tar -czf config_backup_$(date +%Y%m%d).tar.gz services/*/src/main/resources/
   ```

2. **Code Backup**
   ```bash
   # Backup source code
   git archive --format=tar.gz --output=code_backup_$(date +%Y%m%d).tar.gz HEAD
   ```

---

**🎉 Your Gift Box backend system is now ready for production deployment!**
