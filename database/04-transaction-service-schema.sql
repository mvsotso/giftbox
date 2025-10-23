-- Gift Box System - Transaction Service Database Schema
-- PostgreSQL 18 Database Schema for Transaction Management

-- Create database (run this separately)
-- CREATE DATABASE giftbox_transaction;

-- Connect to the database
-- \c giftbox_transaction;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Transactions table
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_reference VARCHAR(100) UNIQUE NOT NULL,
    transaction_type VARCHAR(50) NOT NULL CHECK (transaction_type IN ('voucher_purchase', 'voucher_redemption', 'refund', 'commission_payment', 'settlement', 'wallet_topup', 'wallet_withdrawal')),
    user_id UUID NOT NULL, -- References users table from user service
    merchant_id UUID, -- References merchants table from merchant service
    voucher_id UUID, -- References vouchers table from voucher service
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    fee_amount DECIMAL(15,2) DEFAULT 0.00,
    commission_amount DECIMAL(15,2) DEFAULT 0.00,
    net_amount DECIMAL(15,2) NOT NULL, -- amount - fee_amount
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled', 'refunded')),
    payment_method VARCHAR(50) CHECK (payment_method IN ('aba_pay', 'wing', 'kess', 'credit_card', 'debit_card', 'bank_transfer', 'cash', 'wallet')),
    payment_reference VARCHAR(100),
    description TEXT,
    metadata JSONB, -- Additional transaction data
    failure_reason TEXT,
    processed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Transaction settlements table
CREATE TABLE transaction_settlements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL, -- References merchants table
    settlement_period_start DATE NOT NULL,
    settlement_period_end DATE NOT NULL,
    total_transactions INTEGER NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    total_commission DECIMAL(15,2) NOT NULL,
    net_settlement_amount DECIMAL(15,2) NOT NULL,
    settlement_status VARCHAR(20) DEFAULT 'pending' CHECK (settlement_status IN ('pending', 'processing', 'completed', 'failed')),
    payment_reference VARCHAR(100),
    payment_date DATE,
    payment_method VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(merchant_id, settlement_period_start, settlement_period_end)
);

-- Commission rates table
CREATE TABLE commission_rates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID, -- NULL for default rates
    category_id UUID, -- References merchant categories
    rate_type VARCHAR(20) NOT NULL CHECK (rate_type IN ('fixed_percentage', 'fixed_amount', 'tiered')),
    rate_value DECIMAL(5,2) NOT NULL, -- Percentage or fixed amount
    min_amount DECIMAL(15,2) DEFAULT 0.00,
    max_amount DECIMAL(15,2),
    effective_date DATE NOT NULL,
    expiry_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_transactions_reference ON transactions(transaction_reference);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_merchant_id ON transactions(merchant_id);
CREATE INDEX idx_transactions_voucher_id ON transactions(voucher_id);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_payment_method ON transactions(payment_method);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);
CREATE INDEX idx_transactions_amount ON transactions(amount);

CREATE INDEX idx_transaction_settlements_merchant_id ON transaction_settlements(merchant_id);
CREATE INDEX idx_transaction_settlements_period ON transaction_settlements(settlement_period_start, settlement_period_end);
CREATE INDEX idx_transaction_settlements_status ON transaction_settlements(settlement_status);

CREATE INDEX idx_commission_rates_merchant_id ON commission_rates(merchant_id);
CREATE INDEX idx_commission_rates_category_id ON commission_rates(category_id);
CREATE INDEX idx_commission_rates_active ON commission_rates(is_active);
CREATE INDEX idx_commission_rates_effective_date ON commission_rates(effective_date);

-- Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transaction_settlements_updated_at BEFORE UPDATE ON transaction_settlements
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_commission_rates_updated_at BEFORE UPDATE ON commission_rates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate transaction reference
CREATE OR REPLACE FUNCTION generate_transaction_reference()
RETURNS VARCHAR(100) AS $$
DECLARE
    new_reference VARCHAR(100);
    reference_exists BOOLEAN;
BEGIN
    LOOP
        -- Generate a unique transaction reference
        new_reference := 'TXN' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || 
                        UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12));
        
        -- Check if reference already exists
        SELECT EXISTS(SELECT 1 FROM transactions WHERE transaction_reference = new_reference) INTO reference_exists;
        
        -- If reference doesn't exist, return it
        IF NOT reference_exists THEN
            RETURN new_reference;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Insert default commission rates
INSERT INTO commission_rates (merchant_id, rate_type, rate_value, effective_date) VALUES
(NULL, 'fixed_percentage', 5.00, CURRENT_DATE); -- Default 5% commission

-- Grant permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO giftbox_transaction;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO giftbox_transaction;
