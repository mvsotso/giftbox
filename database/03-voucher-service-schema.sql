-- Gift Box System - Voucher Service Database Schema
-- PostgreSQL 18 Database Schema for Voucher Management

-- Create database (run this separately)
-- CREATE DATABASE giftbox_voucher;

-- Connect to the database
-- \c giftbox_voucher;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Voucher templates table
CREATE TABLE voucher_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL, -- References merchants table from merchant service
    template_name VARCHAR(255) NOT NULL,
    template_description TEXT,
    voucher_type VARCHAR(20) NOT NULL CHECK (voucher_type IN ('fixed_amount', 'percentage', 'service')),
    face_value DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    minimum_purchase_amount DECIMAL(15,2) DEFAULT 0.00,
    maximum_discount_amount DECIMAL(15,2),
    expiry_days INTEGER DEFAULT 365, -- Days from purchase
    terms_and_conditions TEXT,
    image_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Vouchers table (individual voucher instances)
CREATE TABLE vouchers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_id UUID NOT NULL REFERENCES voucher_templates(id),
    voucher_code VARCHAR(50) UNIQUE NOT NULL,
    qr_code_data TEXT UNIQUE NOT NULL,
    purchaser_user_id UUID NOT NULL, -- References users table from user service
    recipient_user_id UUID, -- For gift vouchers
    recipient_email VARCHAR(255),
    recipient_phone VARCHAR(20),
    gift_message TEXT,
    face_value DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    purchase_price DECIMAL(15,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'used', 'expired', 'cancelled', 'refunded')),
    purchase_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expiry_date TIMESTAMP WITH TIME ZONE NOT NULL,
    used_date TIMESTAMP WITH TIME ZONE,
    used_at_merchant_id UUID, -- References merchants table
    used_amount DECIMAL(15,2),
    is_gift BOOLEAN DEFAULT FALSE,
    is_scheduled_gift BOOLEAN DEFAULT FALSE,
    scheduled_delivery_date TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Voucher redemptions table
CREATE TABLE voucher_redemptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    voucher_id UUID NOT NULL REFERENCES vouchers(id),
    merchant_id UUID NOT NULL, -- References merchants table
    redemption_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    redemption_amount DECIMAL(15,2) NOT NULL,
    transaction_reference VARCHAR(100),
    redeemed_by_staff_id UUID, -- References merchant_staff table
    redemption_method VARCHAR(20) DEFAULT 'qr_scan' CHECK (redemption_method IN ('qr_scan', 'manual', 'api')),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Voucher categories table
CREATE TABLE voucher_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon_url TEXT,
    color_code VARCHAR(7), -- Hex color code
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Voucher template category assignments
CREATE TABLE voucher_template_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    template_id UUID NOT NULL REFERENCES voucher_templates(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES voucher_categories(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(template_id, category_id)
);

-- Create indexes for better performance
CREATE INDEX idx_voucher_templates_merchant_id ON voucher_templates(merchant_id);
CREATE INDEX idx_voucher_templates_active ON voucher_templates(is_active);
CREATE INDEX idx_voucher_templates_featured ON voucher_templates(is_featured);
CREATE INDEX idx_voucher_templates_type ON voucher_templates(voucher_type);

CREATE INDEX idx_vouchers_template_id ON vouchers(template_id);
CREATE INDEX idx_vouchers_code ON vouchers(voucher_code);
CREATE INDEX idx_vouchers_qr_code ON vouchers(qr_code_data);
CREATE INDEX idx_vouchers_purchaser ON vouchers(purchaser_user_id);
CREATE INDEX idx_vouchers_recipient ON vouchers(recipient_user_id);
CREATE INDEX idx_vouchers_status ON vouchers(status);
CREATE INDEX idx_vouchers_expiry_date ON vouchers(expiry_date);
CREATE INDEX idx_vouchers_purchase_date ON vouchers(purchase_date);
CREATE INDEX idx_vouchers_gift ON vouchers(is_gift);
CREATE INDEX idx_vouchers_scheduled ON vouchers(is_scheduled_gift, scheduled_delivery_date);

CREATE INDEX idx_voucher_redemptions_voucher_id ON voucher_redemptions(voucher_id);
CREATE INDEX idx_voucher_redemptions_merchant_id ON voucher_redemptions(merchant_id);
CREATE INDEX idx_voucher_redemptions_date ON voucher_redemptions(redemption_date);

CREATE INDEX idx_voucher_categories_active ON voucher_categories(is_active);
CREATE INDEX idx_voucher_categories_sort_order ON voucher_categories(sort_order);

CREATE INDEX idx_voucher_template_categories_template_id ON voucher_template_categories(template_id);
CREATE INDEX idx_voucher_template_categories_category_id ON voucher_template_categories(category_id);

-- Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_voucher_templates_updated_at BEFORE UPDATE ON voucher_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vouchers_updated_at BEFORE UPDATE ON vouchers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_voucher_categories_updated_at BEFORE UPDATE ON voucher_categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate unique voucher codes
CREATE OR REPLACE FUNCTION generate_voucher_code()
RETURNS VARCHAR(50) AS $$
DECLARE
    new_code VARCHAR(50);
    code_exists BOOLEAN;
BEGIN
    LOOP
        -- Generate a random code (adjust format as needed)
        new_code := 'GB' || UPPER(SUBSTRING(MD5(RANDOM()::TEXT), 1, 8));
        
        -- Check if code already exists
        SELECT EXISTS(SELECT 1 FROM vouchers WHERE voucher_code = new_code) INTO code_exists;
        
        -- If code doesn't exist, return it
        IF NOT code_exists THEN
            RETURN new_code;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Insert default voucher categories
INSERT INTO voucher_categories (name, description, color_code, sort_order) VALUES
('Food & Dining', 'Restaurants, cafes, and food services', '#FF6B6B', 1),
('Shopping', 'Retail stores and shopping centers', '#4ECDC4', 2),
('Beauty & Spa', 'Beauty salons, spas, and wellness', '#45B7D1', 3),
('Entertainment', 'Movies, games, and entertainment', '#96CEB4', 4),
('Health & Fitness', 'Gyms, clinics, and health services', '#FFEAA7', 5),
('Travel', 'Hotels, travel, and tourism', '#DDA0DD', 6),
('Technology', 'Electronics and tech services', '#98D8C8', 7),
('Education', 'Learning and educational services', '#F7DC6F', 8),
('Automotive', 'Car services and automotive', '#BB8FCE', 9),
('Other', 'Other services and categories', '#85C1E9', 10);

-- Grant permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO giftbox_voucher;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO giftbox_voucher;
