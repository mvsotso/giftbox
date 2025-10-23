-- Gift Box System - Payment Service Database Schema
-- PostgreSQL 18 Database Schema for Payment Gateway Management

-- Create database (run this separately)
-- CREATE DATABASE giftbox_payment;

-- Connect to the database
-- \c giftbox_payment;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Payment gateways table
CREATE TABLE payment_gateways (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    gateway_name VARCHAR(50) NOT NULL UNIQUE,
    gateway_type VARCHAR(20) NOT NULL CHECK (gateway_type IN ('aba_pay', 'wing', 'kess', 'stripe', 'paypal', 'other')),
    display_name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    is_test_mode BOOLEAN DEFAULT TRUE,
    api_endpoint_url TEXT,
    webhook_url TEXT,
    supported_currencies VARCHAR(100) DEFAULT 'USD',
    min_amount DECIMAL(15,2) DEFAULT 0.01,
    max_amount DECIMAL(15,2) DEFAULT 10000.00,
    processing_fee_percentage DECIMAL(5,4) DEFAULT 0.0000,
    processing_fee_fixed DECIMAL(15,2) DEFAULT 0.00,
    configuration JSONB, -- Gateway-specific configuration
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Payment transactions table
CREATE TABLE payment_transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_reference VARCHAR(100) UNIQUE NOT NULL,
    gateway_id UUID NOT NULL REFERENCES payment_gateways(id),
    transaction_id UUID NOT NULL, -- References transactions table from transaction service
    user_id UUID NOT NULL, -- References users table from user service
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'processing', 'completed', 'failed', 'cancelled', 'refunded', 'disputed')),
    gateway_transaction_id VARCHAR(255), -- Gateway's transaction ID
    gateway_response JSONB, -- Full gateway response
    failure_reason TEXT,
    failure_code VARCHAR(50),
    processing_fee DECIMAL(15,2) DEFAULT 0.00,
    net_amount DECIMAL(15,2) NOT NULL,
    payment_url TEXT, -- For redirect-based payments
    callback_url TEXT,
    webhook_received BOOLEAN DEFAULT FALSE,
    webhook_processed BOOLEAN DEFAULT FALSE,
    processed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Payment refunds table
CREATE TABLE payment_refunds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    refund_reference VARCHAR(100) UNIQUE NOT NULL,
    payment_transaction_id UUID NOT NULL REFERENCES payment_transactions(id),
    original_transaction_id UUID NOT NULL, -- References transactions table
    refund_amount DECIMAL(15,2) NOT NULL,
    refund_reason TEXT,
    refund_status VARCHAR(20) DEFAULT 'pending' CHECK (refund_status IN ('pending', 'processing', 'completed', 'failed', 'cancelled')),
    gateway_refund_id VARCHAR(255),
    gateway_response JSONB,
    failure_reason TEXT,
    processed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_payment_gateways_active ON payment_gateways(is_active);
CREATE INDEX idx_payment_gateways_type ON payment_gateways(gateway_type);

CREATE INDEX idx_payment_transactions_reference ON payment_transactions(payment_reference);
CREATE INDEX idx_payment_transactions_gateway_id ON payment_transactions(gateway_id);
CREATE INDEX idx_payment_transactions_transaction_id ON payment_transactions(transaction_id);
CREATE INDEX idx_payment_transactions_user_id ON payment_transactions(user_id);
CREATE INDEX idx_payment_transactions_status ON payment_transactions(payment_status);
CREATE INDEX idx_payment_transactions_gateway_transaction_id ON payment_transactions(gateway_transaction_id);
CREATE INDEX idx_payment_transactions_created_at ON payment_transactions(created_at);

CREATE INDEX idx_payment_refunds_reference ON payment_refunds(refund_reference);
CREATE INDEX idx_payment_refunds_payment_transaction_id ON payment_refunds(payment_transaction_id);
CREATE INDEX idx_payment_refunds_original_transaction_id ON payment_refunds(original_transaction_id);
CREATE INDEX idx_payment_refunds_status ON payment_refunds(refund_status);

-- Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_payment_gateways_updated_at BEFORE UPDATE ON payment_gateways
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_transactions_updated_at BEFORE UPDATE ON payment_transactions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_refunds_updated_at BEFORE UPDATE ON payment_refunds
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate payment reference
CREATE OR REPLACE FUNCTION generate_payment_reference()
RETURNS VARCHAR(100) AS $$
DECLARE
    new_reference VARCHAR(100);
    reference_exists BOOLEAN;
BEGIN
    LOOP
        -- Generate a unique payment reference
        new_reference := 'PAY' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || 
                        UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 12));
        
        -- Check if reference already exists
        SELECT EXISTS(SELECT 1 FROM payment_transactions WHERE payment_reference = new_reference) INTO reference_exists;
        
        -- If reference doesn't exist, return it
        IF NOT reference_exists THEN
            RETURN new_reference;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Insert default payment gateways
INSERT INTO payment_gateways (gateway_name, gateway_type, display_name, description, is_active, is_test_mode, supported_currencies) VALUES
('aba_pay', 'aba_pay', 'ABA Pay', 'ABA Bank mobile payment gateway', true, true, 'USD,KHR'),
('wing', 'wing', 'Wing Money', 'Wing mobile payment gateway', true, true, 'USD,KHR'),
('kess', 'kess', 'KESS', 'KESS mobile payment gateway', true, true, 'USD,KHR'),
('stripe', 'stripe', 'Stripe', 'Stripe payment gateway for cards', true, true, 'USD'),
('included', 'other', 'Test Gateway', 'Test payment gateway for development', true, true, 'USD');

-- Grant permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO giftbox_payment;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO giftbox_payment;
