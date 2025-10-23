-- Gift Box System - Merchant Service Database Schema
-- PostgreSQL 18 Database Schema for Merchant Management

-- Create database (run this separately)
-- CREATE DATABASE giftbox_merchant;

-- Connect to the database
-- \c giftbox_merchant;

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Merchants table
CREATE TABLE merchants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    business_name VARCHAR(255) NOT NULL,
    business_type VARCHAR(100) NOT NULL,
    business_registration_number VARCHAR(100) UNIQUE,
    tax_id VARCHAR(100),
    contact_email VARCHAR(255) UNIQUE NOT NULL,
    contact_phone VARCHAR(20) NOT NULL,
    contact_person_name VARCHAR(255) NOT NULL,
    contact_person_position VARCHAR(100),
    business_description TEXT,
    business_logo_url TEXT,
    website_url TEXT,
    facebook_url TEXT,
    instagram_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_status VARCHAR(20) DEFAULT 'pending' CHECK (verification_status IN ('pending', 'approved', 'rejected', 'suspended')),
    verification_notes TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    commission_rate DECIMAL(5,2) DEFAULT 5.00, -- Commission percentage
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP WITH TIME ZONE,
    deleted_at TIMESTAMP WITH TIME ZONE
);

-- Merchant addresses table
CREATE TABLE merchant_addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    address_type VARCHAR(20) CHECK (address_type IN ('headquarters', 'branch', 'warehouse')),
    street_address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'Cambodia',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_primary BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Merchant categories table
CREATE TABLE merchant_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Merchant category assignments
CREATE TABLE merchant_category_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES merchant_categories(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(merchant_id, category_id)
);

-- Merchant business hours table
CREATE TABLE merchant_business_hours (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6), -- 0=Sunday, 6=Saturday
    open_time TIME,
    close_time TIME,
    is_closed BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(merchant_id, day_of_week)
);

-- Merchant documents table (for verification)
CREATE TABLE merchant_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    document_type VARCHAR(50) NOT NULL CHECK (document_type IN ('business_license', 'tax_certificate', 'bank_statement', 'id_card', 'other')),
    document_name VARCHAR(255) NOT NULL,
    document_url TEXT NOT NULL,
    file_size BIGINT,
    mime_type VARCHAR(100),
    is_verified BOOLEAN DEFAULT FALSE,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    verified_at TIMESTAMP WITH TIME ZONE
);

-- Merchant reviews table
CREATE TABLE merchant_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    user_id UUID NOT NULL, -- References users table from user service
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255),
    comment TEXT,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(merchant_id, user_id)
);

-- Merchant staff/employees table
CREATE TABLE merchant_staff (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    staff_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    position VARCHAR(100),
    access_level VARCHAR(20) DEFAULT 'staff' CHECK (access_level IN ('admin', 'manager', 'staff')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Merchant settings table
CREATE TABLE merchant_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    setting_key VARCHAR(100) NOT NULL,
    setting_value TEXT,
    setting_type VARCHAR(20) DEFAULT 'string' CHECK (setting_type IN ('string', 'number', 'boolean', 'json')),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(merchant_id, setting_key)
);

-- Create indexes for better performance
CREATE INDEX idx_merchants_email ON merchants(contact_email);
CREATE INDEX idx_merchants_phone ON merchants(contact_phone);
CREATE INDEX idx_merchants_verification_status ON merchants(verification_status);
CREATE INDEX idx_merchants_active ON merchants(is_active);
CREATE INDEX idx_merchants_created_at ON merchants(created_at);

CREATE INDEX idx_merchant_addresses_merchant_id ON merchant_addresses(merchant_id);
CREATE INDEX idx_merchant_addresses_primary ON merchant_addresses(merchant_id, is_primary);
CREATE INDEX idx_merchant_addresses_location ON merchant_addresses(latitude, longitude);

CREATE INDEX idx_merchant_categories_active ON merchant_categories(is_active);
CREATE INDEX idx_merchant_categories_sort_order ON merchant_categories(sort_order);

CREATE INDEX idx_merchant_category_assignments_merchant_id ON merchant_category_assignments(merchant_id);
CREATE INDEX idx_merchant_category_assignments_category_id ON merchant_category_assignments(category_id);

CREATE INDEX idx_merchant_business_hours_merchant_id ON merchant_business_hours(merchant_id);
CREATE INDEX idx_merchant_business_hours_day ON merchant_business_hours(merchant_id, day_of_week);

CREATE INDEX idx_merchant_documents_merchant_id ON merchant_documents(merchant_id);
CREATE INDEX idx_merchant_documents_type ON merchant_documents(document_type);

CREATE INDEX idx_merchant_reviews_merchant_id ON merchant_reviews(merchant_id);
CREATE INDEX idx_merchant_reviews_user_id ON merchant_reviews(user_id);
CREATE INDEX idx_merchant_reviews_rating ON merchant_reviews(rating);
CREATE INDEX idx_merchant_reviews_approved ON merchant_reviews(is_approved);

CREATE INDEX idx_merchant_staff_merchant_id ON merchant_staff(merchant_id);
CREATE INDEX idx_merchant_staff_email ON merchant_staff(email);
CREATE INDEX idx_merchant_staff_active ON merchant_staff(is_active);

CREATE INDEX idx_merchant_settings_merchant_id ON merchant_settings(merchant_id);
CREATE INDEX idx_merchant_settings_key ON merchant_settings(merchant_id, setting_key);

-- Create triggers for updated_at timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_merchants_updated_at BEFORE UPDATE ON merchants
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_merchant_addresses_updated_at BEFORE UPDATE ON merchant_addresses
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_merchant_categories_updated_at BEFORE UPDATE ON merchant_categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_merchant_business_hours_updated_at BEFORE UPDATE ON merchant_business_hours
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_merchant_reviews_updated_at BEFORE UPDATE ON merchant_reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_merchant_staff_updated_at BEFORE UPDATE ON merchant_staff
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_merchant_settings_updated_at BEFORE UPDATE ON merchant_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert default merchant categories
INSERT INTO merchant_categories (name, description, sort_order) VALUES
('Restaurants', 'Food and dining establishments', 1),
('Retail', 'General retail stores and shops', 2),
('Beauty & Wellness', 'Salons, spas, and wellness centers', 3),
('Entertainment', 'Cinemas, gaming, and entertainment venues', 4),
('Health & Fitness', 'Gyms, clinics, and health services', 5),
('Education', 'Schools, training centers, and educational services', 6),
('Travel & Tourism', 'Hotels, travel agencies, and tourism services', 7),
('Automotive', 'Car services, repair shops, and automotive services', 8),
('Technology', 'Electronics stores and tech services', 9),
('Other', 'Other types of businesses', 10);

-- Grant permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO giftbox_merchant;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO giftbox_merchant;
