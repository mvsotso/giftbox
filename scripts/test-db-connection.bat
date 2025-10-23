@echo off
echo Testing PostgreSQL connection...

set PGPASSWORD=abc123ABC!@#

echo Testing connection to giftbox_user database...
psql -U postgres -h localhost -d giftbox_user -c "SELECT 'Connection successful!' as status;"

echo Testing connection to giftbox_merchant database...
psql -U postgres -h localhost -d giftbox_merchant -c "SELECT 'Connection successful!' as status;"

echo Testing connection to giftbox_voucher database...
psql -U postgres -h localhost -d giftbox_voucher -c "SELECT 'Connection successful!' as status;"

echo Database connection test completed!
pause
