# Gift Box Database Cleanup Scripts

This directory contains comprehensive SQL scripts and automation tools for cleaning test data from the Gift Box backend system database.

## 📁 Files

- **`cleanup-test-data.sql`** - Comprehensive cleanup script for all test data
- **`cleanup-specific-test.sql`** - Targeted cleanup for specific test scenarios
- **`README.md`** - This documentation file

## 🧹 Cleanup Scripts

### 1. Comprehensive Cleanup (`cleanup-test-data.sql`)

**Purpose**: Removes all test data from the database while preserving production data.

**Features**:
- Cleans up all test-related tables
- Preserves production data
- Includes safety checks
- Provides verification queries
- Resets sequences (optional)

**Tables Cleaned**:
- User-related tables (sessions, preferences, activity logs)
- Merchant-related tables (staff, locations, settings)
- Voucher-related tables (redemptions, assignments, usage history)
- Transaction-related tables (items, payments)
- Corporate-related tables (users, departments, budgets)
- Audit and log tables
- Notification tables
- Integration tables
- Cache and session tables
- Analytics tables

### 2. Specific Test Cleanup (`cleanup-specific-test.sql`)

**Purpose**: Targeted cleanup for specific test scenarios.

**Test Types Covered**:
- User authentication tests
- Merchant testing
- Voucher testing
- Transaction testing
- Payment testing
- Corporate testing
- API testing
- Load testing
- Performance testing
- Security testing
- Integration testing
- Notification testing
- Analytics testing

## 🚀 Usage

### Method 1: Basic Cleanup Script

```bash
# Run the basic cleanup script
.\scripts\cleanup-test-data.bat
```

**Features**:
- Automatic database connection check
- Creates backup before cleanup
- Executes comprehensive cleanup
- Verifies cleanup results
- Provides status reports

### Method 2: Advanced Cleanup Script

```bash
# Run the advanced cleanup script with options
.\scripts\cleanup-test-data-advanced.bat
```

**Options Available**:
1. **Full cleanup** - All test data
2. **User testing cleanup** - User-related test data only
3. **Merchant testing cleanup** - Merchant-related test data only
4. **Voucher testing cleanup** - Voucher-related test data only
5. **Transaction testing cleanup** - Transaction-related test data only
6. **Payment testing cleanup** - Payment-related test data only
7. **Corporate testing cleanup** - Corporate-related test data only
8. **API testing cleanup** - API-related test data only
9. **Load testing cleanup** - Load testing data only
0. **Custom cleanup** - Custom time-based or specific data cleanup

### Method 3: Direct SQL Execution

```bash
# Execute cleanup scripts directly
docker exec -i giftbox-postgres psql -U giftbox_user -d giftbox < database\cleanup-test-data.sql
```

## 🔧 Prerequisites

### Required Services
- PostgreSQL database running
- Docker container `giftbox-postgres` accessible
- Database user `giftbox_user` with appropriate permissions

### Required Permissions
- `DELETE` permission on all tables
- `SELECT` permission for verification queries
- `INSERT` permission for logging

## 📊 Cleanup Criteria

### Test Data Identification

The scripts identify test data using the following criteria:

#### Users
- Username patterns: `testuser%`, `user_%`
- Email patterns: `%@test.com`, `%@example.com`
- Name patterns: `Test%`, `User%`

#### Merchants
- Business name patterns: `%Test%`, `%Demo%`
- Email patterns: `%@test.com`, `%@example.com`
- Contact person patterns: `Test%`

#### Vouchers
- Voucher code patterns: `TEST_%`, `VOUCHER_%`
- Test amounts: `1.00`, `5.00`, `10.00`, `25.00`, `50.00`, `100.00`
- Description patterns: `%test%`, `%Test%`

#### Transactions
- Transaction ID patterns: `TXN_TEST_%`
- Test amounts: `1.00`, `5.00`, `10.00`, `25.00`, `50.00`, `100.00`

#### Payments
- Payment ID patterns: `PAY_TEST_%`
- Test amounts: `1.00`, `5.00`, `10.00`, `25.00`, `50.00`, `100.00`

#### Corporate Accounts
- Company name patterns: `%Test Corp%`, `%Demo Corp%`
- Email patterns: `%@corporate-test.com`

## 🛡️ Safety Features

### Backup Creation
- Automatic backup before cleanup
- Timestamped backup files
- Backup location: `database\backup-YYYYMMDD_HHMMSS.sql`

### Foreign Key Handling
- Temporarily disables foreign key checks
- Re-enables foreign key checks after cleanup
- Prevents constraint violations

### Verification
- Post-cleanup data count verification
- Status reporting
- Error handling and logging

## 📈 Performance Considerations

### Large Dataset Handling
- Uses efficient DELETE statements
- Batches operations for large datasets
- Includes VACUUM and ANALYZE operations

### Memory Usage
- Optimized queries to minimize memory usage
- Efficient index usage
- Proper transaction handling

## 🔍 Monitoring and Logging

### Cleanup Logging
- System log entries for cleanup operations
- Error logging for failed operations
- Performance metrics logging

### Verification Queries
- Data count verification after cleanup
- Status reporting
- Error detection and reporting

## 🚨 Important Notes

### Production Safety
- **NEVER** run cleanup scripts on production databases
- Always create backups before cleanup
- Test cleanup scripts in development environment first

### Data Recovery
- Backup files are created automatically
- Use backup files to restore data if needed
- Backup files are timestamped for easy identification

### Performance Impact
- Cleanup operations may take time on large datasets
- Consider running during low-traffic periods
- Monitor database performance during cleanup

## 🔧 Customization

### Adding New Cleanup Criteria
1. Edit the SQL scripts to add new patterns
2. Update the batch scripts to include new options
3. Test thoroughly in development environment

### Modifying Cleanup Logic
1. Update the WHERE clauses in DELETE statements
2. Add new table cleanup sections
3. Update verification queries

### Adding New Cleanup Types
1. Add new options to the advanced script
2. Create corresponding SQL cleanup logic
3. Update documentation

## 📞 Troubleshooting

### Common Issues

#### Database Connection Failed
```
✗ Database is not accessible
```
**Solution**: Ensure PostgreSQL container is running
```bash
docker ps | findstr postgres
```

#### Permission Denied
```
ERROR: permission denied for table users
```
**Solution**: Ensure database user has DELETE permissions
```sql
GRANT DELETE ON ALL TABLES IN SCHEMA public TO giftbox_user;
```

#### Foreign Key Constraint Violation
```
ERROR: update or delete on table "users" violates foreign key constraint
```
**Solution**: The script handles this automatically by disabling foreign key checks

#### Backup Creation Failed
```
⚠️ Warning: Could not create backup
```
**Solution**: Check disk space and permissions
```bash
docker exec giftbox-postgres df -h
```

### Debug Mode
Enable debug mode for detailed logging:
```bash
# Set debug environment variable
set DEBUG=1
.\scripts\cleanup-test-data.bat
```

## 📋 Best Practices

### Before Cleanup
1. **Create backup** - Always backup before cleanup
2. **Verify environment** - Ensure you're in the correct environment
3. **Check dependencies** - Ensure no active processes are using the data
4. **Plan timing** - Run during low-traffic periods

### During Cleanup
1. **Monitor progress** - Watch for errors and warnings
2. **Check logs** - Monitor database logs for issues
3. **Verify results** - Use verification queries to confirm cleanup

### After Cleanup
1. **Verify data** - Check that only test data was removed
2. **Test functionality** - Ensure system still works correctly
3. **Update documentation** - Record any issues or changes
4. **Archive backups** - Keep backups for future reference

## 🔄 Automation

### Scheduled Cleanup
Set up automated cleanup using cron jobs or Windows Task Scheduler:

```bash
# Daily cleanup at 2 AM
0 2 * * * /path/to/cleanup-test-data.bat
```

### CI/CD Integration
Integrate cleanup into your CI/CD pipeline:

```yaml
# GitHub Actions example
- name: Cleanup Test Data
  run: |
    docker exec -i giftbox-postgres psql -U giftbox_user -d giftbox < database/cleanup-test-data.sql
```

## 📚 Additional Resources

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [SQL Best Practices](https://www.postgresql.org/docs/current/sql.html)

---

**Last Updated**: December 19, 2024  
**Version**: 1.0  
**Next Review**: January 19, 2025
