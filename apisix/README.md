# APISIX API Gateway Configuration

This directory contains the configuration files for APISIX API Gateway integration with the Gift Box backend system.

## 📁 Files

- `config.yml` - APISIX main configuration
- `apisix.yaml` - Route definitions and plugins
- `README.md` - This documentation

## 🚀 Features

### **Routing**
- **User Service**: `/api/v1/users/*` → `user-service:8081`
- **Merchant Service**: `/api/v1/merchants/*` → `merchant-service:8082`
- **Voucher Service**: `/api/v1/vouchers/*` → `voucher-service:8083`
- **Transaction Service**: `/api/v1/transactions/*` → `transaction-service:8084`
- **Payment Service**: `/api/v1/payments/*` → `payment-service:8085`
- **Corporate Service**: `/api/v1/corporate/*` → `corporate-service:8086`
- **Health Check**: `/health` → `test-service:8080`

### **Plugins**
- **CORS**: Cross-origin resource sharing enabled
- **Rate Limiting**: 100 requests per minute per route
- **Load Balancing**: Round-robin distribution
- **Health Checks**: Automatic upstream health monitoring

## 🔧 Configuration

### **Ports**
- **Gateway**: `9080` (Main API gateway)
- **Admin API**: `9180` (Management interface)

### **Environment Variables**
- `APISIX_STAND_ALONE`: Set to `true` for standalone mode
- Configuration files mounted as read-only volumes

## 📊 Monitoring

### **Health Check**
```bash
curl http://localhost:9080/health
```

### **Admin API**
```bash
# List all routes
curl http://localhost:9180/apisix/admin/routes

# Get route by ID
curl http://localhost:9180/apisix/admin/routes/1
```

## 🛡️ Security Features

1. **Rate Limiting**: Prevents API abuse
2. **CORS**: Configurable cross-origin policies
3. **Load Balancing**: Distributes traffic evenly
4. **Health Monitoring**: Automatic failover

## 🔄 Load Balancing

- **Algorithm**: Round-robin
- **Health Checks**: Automatic upstream monitoring
- **Failover**: Automatic service discovery

## 📈 Performance

- **High Performance**: Built on OpenResty/Nginx
- **Low Latency**: Direct upstream routing
- **Scalable**: Horizontal scaling support
- **Monitoring**: Built-in metrics and logging

## 🚀 Usage

### **Start APISIX**
```bash
docker-compose up -d apisix
```

### **Test Gateway**
```bash
# Test user service through gateway
curl http://localhost:9080/api/v1/users/health

# Test merchant service through gateway
curl http://localhost:9080/api/v1/merchants/health
```

### **Admin Operations**
```bash
# Check gateway status
curl http://localhost:9180/apisix/admin/routes

# Add new route
curl -X POST http://localhost:9180/apisix/admin/routes \
  -H "Content-Type: application/json" \
  -d '{"uri": "/api/v1/new-service/*", "upstream": {"nodes": {"new-service:8087": 1}}}'
```

## 🔧 Customization

### **Adding New Routes**
1. Edit `apisix.yaml`
2. Add new route configuration
3. Restart APISIX: `docker-compose restart apisix`

### **Modifying Plugins**
1. Update plugin configuration in `apisix.yaml`
2. Restart APISIX: `docker-compose restart apisix`

### **Rate Limiting**
- Per-route: 100 requests/minute
- Global: 1000 requests/minute
- Customizable in route definitions

## 📚 Documentation

- [APISIX Official Docs](https://apisix.apache.org/docs/)
- [Plugin Development](https://apisix.apache.org/docs/apisix/plugin-develop/)
- [Admin API Reference](https://apisix.apache.org/docs/apisix/admin-api/)

---

**Last Updated**: October 24, 2025  
**APISIX Version**: 3.7.0  
**Configuration**: Standalone Mode
