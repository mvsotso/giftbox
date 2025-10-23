-- Gift Box System - Corporate Service Database Schema
-- PostgreSQL 18 Database Schema for Corporate/B2B Management

-- Create database (run this separately)
-- CREATE DATABASE giftbox_corporate;

-- Connect to the database
-- \c giftbox_corporate;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Corporate clients table
CREATE TABLE corporate_clients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_name VARCHAR(255) NOT NULL,
    company_type VARCHAR(100) NOT NULL CHECK (company_type IN ('private', 'public', 'ngo', 'government', 'educational', 'other')),
    business_registration_number VARCHAR(100) UNIQUE,
    tax_id VARCHAR(100),
    contact_email VARCHAR(255) UNIQUE NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
    contact_person_name VARCHAR(255) NOT NULL,
    contact_person_position VARCHAR(100) NOT NULL,
    billing_email VARCHAR(255),
    billing_phone VARCHAR(20),
    company_description TEXT,
    website_url TEXT,
    company_logo_url TEXT,
    industry VARCHAR(100),
    company_size VARCHAR(20) CHECK (company_size IN ('startup', 'small', 'medium', 'large', 'enterprise')),
    annual_revenue_range VARCHAR(50),
    credit_limit DECIMAL(15,2) DEFAULT 0.00,
    credit_used DECIMAL(15,2) DEFAULT 0.00,
    payment_terms_days INTEGER DEFAULT 30,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_status VARCHAR(20) DEFAULT 'pending' CHECK (verification_status IN ('pending', 'approved', 'rejected', 'suspended')),
    verification_notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    contract_start_date DATE,
    contract_end_date DATE,
    special_discount_rate DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP WITH TIME ZONE,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Corporate bulk orders table
CREATE TABLE corporate_bulk_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_reference VARCHAR(100) UNIQUE NOT NULL,
    client_id UUID NOT NULL REFERENCES corporate_clients(id),
    order_type VARCHAR(20) DEFAULT 'voucher_bulk' CHECK (order_type IN ('voucher_bulk', 'gift_card_bulk', 'custom')),
    total_amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    discount_amount DECIMAL(15,2) DEFAULT 0.00,
    discount_percentage DECIMAL(5,2) DEFAULT 0.00,
    net_amount DECIMAL(15,2) NOT NULL,
    order_status VARCHAR(20) DEFAULT 'pending' CHECK (order_status IN ('pending', 'approved', 'processing', 'completed', 'cancelled', 'refunded')),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'partial', 'completed', 'overdue')),
    payment_terms_days INTEGER DEFAULT 30,
    due_date DATE,
    delivery_method VARCHAR(20) DEFAULT 'email' CHECK (delivery_method IN ('email', 'api', 'manual', 'batch_file')),
    special_instructions TEXT,
    order_notes TEXT,
    approved_by_user_id UUID, -- References users table from user service
    approved_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Corporate order items table
CREATE TABLE corporate_order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES corporate_bulk_orders(id) ON DELETE CASCADE,
    voucher_template_id UUID NOT NULL, -- References voucher templates from voucher service
    merchant_id UUID NOT NULL, -- References merchants table
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    total_price DECIMAL(15,2) NOT NULL,
    discount_amount DECIMAL(15,2) DEFAULT 0.00,
    net_price DECIMAL(15,2) NOT NULL,
    custom_message TEXT,
    delivery_preferences JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Corporate employee distributions table
CREATE TABLE corporate_employee_distributions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_item_id UUID NOT NULL REFERENCES corporate_order_items(id),
    employee_name VARCHAR(255) NOT NULL,
    employee_email VARCHAR(255),
    employee_phone VARCHAR(20),
    employee_id VARCHAR(100), -- Company's internal employee ID
    department VARCHAR(100),
    position VARCHAR(100),
    voucher_amount DECIMAL(15,2) NOT NULL,
    distribution_status VARCHAR(20) DEFAULT 'pending' CHECK (distribution_status IN ('pending', 'sent', 'delivered', 'failed', 'cancelled')),
    delivery_method VARCHAR(20) DEFAULT 'email' CHECK (delivery_method IN ('email', 'sms', 'manual')),
    delivery_date TIMESTAMP WITH TIME ZONE,
    delivery_attempts INTEGER DEFAULT 0,
    delivery_notes TEXT,
    voucher_codes TEXT[], -- Array of generated voucher codes
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_corporate_clients_company_name ON corporate_clients(company_name);
CREATE INDEX idx_corporate_clients_contact_email ON corporate_clients(contact_email);
CREATE INDEX idx_corporate_clients_verification_status ON corporate_clients(verification_status);
CREATE INDEX idx_corporate_clients_active ON corporate_clients(is_active);
CREATE INDEX idx_corporate_clients_created_at ON corporate_clients(created_at);

CREATE INDEX idx_corporate_bulk_orders_reference ON corporate_bulk_orders(order_reference);
CREATE INDEX idx_corporate_bulk_orders_client_id ON corporate_bulk_orders(client_id);
CREATE INDEX idx_corporate_bulk_orders_status ON corporate_bulk_orders(order_status);
CREATE INDEX idx_corporate_bulk_orders_payment_status ON corporate_bulk_orders(payment_status);
CREATE INDEX idx_corporate_bulk_orders_created_at ON corporate_bulk_orders(created_at);

CREATE INDEX idx_corporate_order_items_order_id ON corporate_order_items(order_id);
CREATE INDEX idx_corporate_order_items_merchant_id ON corporate_order_items(merchant_id);

CREATE INDEX idx_corporate_employee_distributions_order_item_id ON corporate_employee_distributions(order_item_id);
CREATE INDEX idx_corporate_employee_distributions_status ON corporate_employee_distributions(distribution_status);
CREATE INDEX idx_corporate_employee_distributions_employee_email ON corporate_employee_distributions(employee_email);

-- Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_corporate_clients_updated_at BEFORE UPDATE ON corporate_clients
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_corporate_bulk_orders_updated_at BEFORE UPDATE ON corporate_bulk_orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_corporate_employee_distributions_updated_at BEFORE UPDATE ON corporate_employee_distributions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate order reference
CREATE OR REPLACE FUNCTION generate_corporate_order_reference()
RETURNS VARCHAR(100) AS $$
DECLARE
    new_reference VARCHAR(100);
    reference_exists BOOLEAN;
BEGIN
    LOOP
        -- Generate a unique order reference
        new_reference := 'CORP' || TO_CHAR(CURRENT_DATE, 'YYYYMMDD') || '-' || 
                        UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 8));
        
        -- Check if reference already exists
        SELECT EXISTS(SELECT 1 FROM corporate_bulk_orders WHERE order_reference = new_reference) INTO reference_exists;
        
        -- If reference doesn't exist, return it
        IF NOT reference_exists THEN
            RETURN new_reference;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Grant permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO giftbox_corporate;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO giftbox_corporate;
