@echo off
echo Setting up Gift Box databases...

set PGPASSWORD=abc123ABC!@#

echo Creating databases...
psql -U postgres -h localhost -c "CREATE DATABASE giftbox_user;" 2>nul || echo Database giftbox_user may already exist
psql -U postgres -h localhost -c "CREATE DATABASE giftbox_merchant;" 2>nul || echo Database giftbox_merchant may already exist
psql -U postgres -h localhost -c "CREATE DATABASE giftbox_voucher;" 2>nul || echo Database giftbox_voucher may already exist
psql -U postgres -h localhost -c "CREATE DATABASE giftbox_transaction;" 2>nul || echo Database giftbox_transaction may already exist
psql -U postgres -h localhost -c "CREATE DATABASE giftbox_payment;" 2>nul || echo Database giftbox_payment may already exist
psql -U postgres -h localhost -c "CREATE DATABASE giftbox_corporate;" 2>nul || echo Database giftbox_corporate may already exist

echo Running database schemas...
psql -U postgres -h localhost -d giftbox_user -f database/01-user-service-schema.sql
psql -U postgres -h localhost -d giftbox_merchant -f database/02-merchant-service-schema.sql
psql -U postgres -h localhost -d giftbox_voucher -f database/03-voucher-service-schema.sql
psql -U postgres -h localhost -d giftbox_transaction -f database/04-transaction-service-schema.sql
psql -U postgres -h localhost -d giftbox_payment -f database/05-payment-service-schema.sql
psql -U postgres -h localhost -d giftbox_corporate -f database/06-corporate-service-schema.sql

echo Database setup completed!
pause
