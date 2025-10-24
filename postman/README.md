# Gift Box APISIX Postman Collection

This directory contains comprehensive Postman collections and environments for testing the Gift Box backend system through the APISIX API Gateway.

## 📁 Files

- **`Gift_Box_APISIX_Collection.json`** - Main Postman collection with all API endpoints
- **`Gift_Box_Environment.json`** - Local development environment variables
- **`Gift_Box_Production_Environment.json`** - Production environment variables
- **`README.md`** - This documentation file

## 🚀 Quick Start

### 1. Import Collection and Environment

1. **Open Postman**
2. **Import Collection**:
   - Click "Import" button
   - Select `Gift_Box_APISIX_Collection.json`
   - Click "Import"

3. **Import Environment**:
   - Click "Import" button
   - Select `Gift_Box_Environment.json` (for local testing)
   - Click "Import"

4. **Set Active Environment**:
   - Click the environment dropdown (top right)
   - Select "Gift Box APISIX Environment"

### 2. Configure Environment Variables

Update the following variables in your environment:

| Variable | Local Value | Production Value | Description |
|----------|-------------|------------------|-------------|
| `base_url` | `http://localhost:9080` | `https://api.giftbox.com` | APISIX Gateway URL |
| `apisix_admin_url` | `http://localhost:9180` | `https://admin-api.giftbox.com` | APISIX Admin API URL |
| `auth_token` | (empty) | (empty) | JWT token for authentication |
| `merchant_id` | `1` | `1` | Test merchant ID |
| `voucher_id` | `1` | `1` | Test voucher ID |
| `transaction_id` | `1` | `1` | Test transaction ID |

## 📋 Collection Structure

### 1. Health Checks
- **APISIX Gateway Health**: Check gateway status
- **Test Service Health**: Verify service routing
- **APISIX Admin API Health**: Check route configuration

### 2. User Service
- **User Registration**: Create new user account
- **User Login**: Authenticate and get JWT token
- **Get User Profile**: Retrieve user information
- **Update User Profile**: Modify user details

### 3. Merchant Service
- **Merchant Registration**: Register new merchant
- **Get All Merchants**: List all merchants
- **Get Merchant by ID**: Retrieve specific merchant
- **Update Merchant**: Modify merchant information

### 4. Voucher Service
- **Create Voucher**: Generate new gift voucher
- **Get User Vouchers**: List user's vouchers
- **Get Voucher by ID**: Retrieve specific voucher
- **Redeem Voucher**: Use voucher at merchant

### 5. Transaction Service
- **Create Transaction**: Process new transaction
- **Get User Transactions**: User transaction history
- **Get Transaction by ID**: Specific transaction details
- **Get Merchant Transactions**: Merchant transaction history

### 6. Payment Service
- **Process Payment**: Handle payment processing
- **Get Payment Status**: Check payment status
- **Refund Payment**: Process payment refund

### 7. Corporate Service
- **Corporate Registration**: Register corporate account
- **Bulk Voucher Creation**: Create multiple vouchers
- **Get Corporate Analytics**: Enterprise reporting

### 8. Load Testing
- **Concurrent Health Checks**: Performance testing
- **Rate Limit Test**: Test rate limiting functionality

## 🔧 Environment Configuration

### Local Development Environment

```json
{
  "base_url": "http://localhost:9080",
  "apisix_admin_url": "http://localhost:9180",
  "auth_token": "",
  "merchant_id": "1",
  "voucher_id": "1",
  "transaction_id": "1"
}
```

### Production Environment

```json
{
  "base_url": "https://api.giftbox.com",
  "apisix_admin_url": "https://admin-api.giftbox.com",
  "auth_token": "",
  "merchant_id": "1",
  "voucher_id": "1",
  "transaction_id": "1"
}
```

## 🧪 Testing Workflow

### 1. Prerequisites
- APISIX gateway running on port 9080
- All microservices deployed and running
- Database and Redis services operational

### 2. Basic Health Check
1. Run "APISIX Gateway Health" request
2. Verify response status is 200
3. Check response time is under 5 seconds

### 3. Authentication Flow
1. **User Registration**: Create test user account
2. **User Login**: Authenticate and capture JWT token
3. **Set Token**: Update `auth_token` variable with received token
4. **Test Protected Endpoints**: Use authenticated requests

### 4. Complete User Journey
1. **Register User** → Get user ID
2. **Register Merchant** → Get merchant ID
3. **Create Voucher** → Get voucher ID
4. **Create Transaction** → Get transaction ID
5. **Process Payment** → Complete the flow
6. **Verify Results** → Check all data consistency

## 🔍 Test Scripts

### Pre-request Scripts
- Set timestamp for request tracking
- Log request details
- Validate required variables

### Test Scripts
- Response time validation (< 5 seconds)
- Status code validation (not 500)
- Response logging
- Variable extraction for subsequent requests

### Example Test Script
```javascript
// Response time validation
pm.test('Response time is less than 5000ms', function () {
    pm.expect(pm.response.responseTime).to.be.below(5000);
});

// Status code validation
pm.test('Status code is not 500', function () {
    pm.expect(pm.response.code).to.not.equal(500);
});

// Extract token from login response
if (pm.response.code === 200) {
    const responseJson = pm.response.json();
    if (responseJson.token) {
        pm.environment.set('auth_token', responseJson.token);
    }
}
```

## 📊 Performance Testing

### Load Testing
1. **Concurrent Requests**: Use Postman Runner with multiple iterations
2. **Rate Limiting**: Test with rapid successive requests
3. **Response Time**: Monitor average response times
4. **Error Rates**: Track failed requests

### Recommended Settings
- **Iterations**: 10-50 requests
- **Delay**: 100-500ms between requests
- **Concurrent**: 5-10 concurrent requests
- **Timeout**: 30 seconds

## 🚨 Error Handling

### Common Issues
1. **Connection Refused**: Check if APISIX gateway is running
2. **404 Not Found**: Verify route configuration in APISIX
3. **401 Unauthorized**: Check JWT token validity
4. **500 Internal Server Error**: Check microservice logs

### Debugging Steps
1. **Check Gateway Status**: Verify APISIX is running
2. **Check Routes**: Use APISIX Admin API to verify routes
3. **Check Services**: Ensure all microservices are running
4. **Check Logs**: Review APISIX and service logs

## 📈 Monitoring and Analytics

### Key Metrics to Monitor
- **Response Time**: Average response time per endpoint
- **Success Rate**: Percentage of successful requests
- **Error Rate**: Percentage of failed requests
- **Throughput**: Requests per second

### Postman Analytics
- Use Postman Console for detailed logging
- Export test results for analysis
- Set up monitoring alerts for critical endpoints

## 🔐 Security Testing

### Authentication Testing
- Test with invalid tokens
- Test with expired tokens
- Test without authentication headers
- Verify proper error responses

### Authorization Testing
- Test user access to other users' data
- Test merchant access to corporate features
- Test corporate access to admin features

## 📝 Best Practices

### Request Organization
- Group related requests in folders
- Use descriptive names for requests
- Add clear descriptions to each request
- Use consistent naming conventions

### Environment Management
- Use separate environments for different stages
- Keep sensitive data in environment variables
- Use different base URLs for different environments
- Document all environment variables

### Test Automation
- Use Postman Runner for automated testing
- Set up CI/CD integration with Newman
- Create comprehensive test suites
- Implement proper error handling

## 🚀 Advanced Features

### Newman CLI Integration
```bash
# Install Newman
npm install -g newman

# Run collection
newman run Gift_Box_APISIX_Collection.json -e Gift_Box_Environment.json

# Run with reporting
newman run Gift_Box_APISIX_Collection.json -e Gift_Box_Environment.json -r html
```

### CI/CD Integration
- Integrate with Jenkins, GitHub Actions, or Azure DevOps
- Set up automated testing on code changes
- Generate test reports and notifications
- Implement test result tracking

## 📞 Support

For issues with the Postman collection:

1. **Check Environment Variables**: Ensure all required variables are set
2. **Verify Service Status**: Confirm all services are running
3. **Review Logs**: Check APISIX and service logs for errors
4. **Test Connectivity**: Verify network connectivity to services

---

**Last Updated**: December 19, 2024  
**Collection Version**: 1.0  
**Next Review**: January 19, 2025
