@echo off
echo ========================================
echo    OWASP Security Remediation Script
echo ========================================
echo.

echo [1/5] Creating secure configuration templates...
echo.

echo Creating environment variable template...
(
echo # Database Configuration
echo POSTGRES_DB=giftbox_user
echo POSTGRES_USER=giftbox_user
echo POSTGRES_PASSWORD=CHANGE_ME_STRONG_PASSWORD
echo.
echo # Redis Configuration  
echo REDIS_PASSWORD=CHANGE_ME_STRONG_PASSWORD
echo.
echo # JWT Configuration
echo JWT_SECRET=CHANGE_ME_STRONG_JWT_SECRET
echo JWT_EXPIRATION=86400
) > .env.template

echo ✓ Environment template created

echo.
echo [2/5] Creating secure application.yml template...
echo.

echo Creating secure application.yml...
(
echo spring:
echo   datasource:
echo     url: jdbc:postgresql://localhost:5432/giftbox_user
echo     username: ${POSTGRES_USER:postgres}
echo     password: ${POSTGRES_PASSWORD:default_password}
echo     driver-class-name: org.postgresql.Driver
echo   jpa:
echo     show-sql: false
echo     properties:
echo       hibernate:
echo         dialect: org.hibernate.dialect.PostgreSQLDialect
echo         format_sql: false
echo logging:
echo   level:
echo     org.hibernate.SQL: WARN
echo     org.springframework.security: INFO
) > backend/services/application-secure.yml

echo ✓ Secure application.yml created

echo.
echo [3/5] Creating security headers configuration...
echo.

echo Creating Nginx security configuration...
(
echo events {
echo     worker_connections 1024;
echo }
echo.
echo http {
echo     # Security Headers
echo     add_header X-Frame-Options DENY always;
echo     add_header X-Content-Type-Options nosniff always;
echo     add_header X-XSS-Protection "1; mode=block" always;
echo     add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
echo     add_header Referrer-Policy "strict-origin-when-cross-origin" always;
echo.
echo     # Rate Limiting
echo     limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
echo.
echo     upstream test-service {
echo         server test-service:8080;
echo     }
echo.
echo     server {
echo         listen 9080;
echo         server_name _;
echo.
echo         # Apply rate limiting
echo         limit_req zone=api burst=20 nodelay;
echo.
echo         location /health {
echo             proxy_pass http://test-service/health;
echo             proxy_set_header Host $host;
echo             proxy_set_header X-Real-IP $remote_addr;
echo             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
echo             proxy_set_header X-Forwarded-Proto $scheme;
echo         }
echo.
echo         location / {
echo             proxy_pass http://test-service/;
echo             proxy_set_header Host $host;
echo             proxy_set_header X-Real-IP $remote_addr;
echo             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
echo             proxy_set_header X-Forwarded-Proto $scheme;
echo         }
echo     }
echo }
) > nginx/nginx-secure.conf

echo ✓ Secure Nginx configuration created

echo.
echo [4/5] Creating security logging configuration...
echo.

echo Creating security logging configuration...
(
echo logging:
echo   level:
echo     com.giftbox: INFO
echo     org.springframework.security: WARN
echo     org.hibernate.SQL: WARN
echo     org.hibernate.type.descriptor.sql.BasicBinder: WARN
echo   pattern:
echo     console: "%%d{yyyy-MM-dd HH:mm:ss} [%%thread] %%-5level %%logger{36} - %%msg%%n"
echo     file: "%%d{yyyy-MM-dd HH:mm:ss} [%%thread] %%-5level %%logger{36} - %%msg%%n"
echo   file:
echo     name: logs/security.log
echo     max-size: 10MB
echo     max-history: 30
) > backend/services/logging-secure.yml

echo ✓ Security logging configuration created

echo.
echo [5/5] Creating security checklist...
echo.

echo Creating security implementation checklist...
(
echo # OWASP Security Implementation Checklist
echo.
echo ## Critical Issues - Fix Immediately
echo [ ] Remove hardcoded passwords from all configuration files
echo [ ] Disable debug mode in production configurations
echo [ ] Add security headers to all API responses
echo [ ] Implement proper logging levels for production
echo.
echo ## High Priority - Fix Within 1 Week
echo [ ] Implement CORS configuration for all services
echo [ ] Add rate limiting at API gateway level
echo [ ] Implement comprehensive security logging
echo [ ] Configure SSL/TLS for all connections
echo.
echo ## Medium Priority - Fix Within 1 Month
echo [ ] Implement dependency vulnerability scanning
echo [ ] Add input validation on all endpoints
echo [ ] Implement proper session management
echo [ ] Add security monitoring and alerting
echo.
echo ## Security Testing
echo [ ] Run OWASP ZAP security scan
echo [ ] Perform penetration testing
echo [ ] Implement automated security testing
echo [ ] Conduct security code review
) > SECURITY_CHECKLIST.md

echo ✓ Security checklist created

echo.
echo ========================================
echo    Security Remediation Complete
echo ========================================
echo.
echo Files Created:
echo - .env.template (Environment variables template)
echo - application-secure.yml (Secure application configuration)
echo - nginx-secure.conf (Secure Nginx configuration)
echo - logging-secure.yml (Security logging configuration)
echo - SECURITY_CHECKLIST.md (Implementation checklist)
echo.
echo Next Steps:
echo 1. Review and customize the generated configurations
echo 2. Implement the security checklist items
echo 3. Test the secure configurations
echo 4. Deploy with security measures enabled
echo.
pause
