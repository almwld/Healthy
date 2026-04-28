-- Sehtak Platform - Database Schema

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  full_name VARCHAR(255) NOT NULL,
  phone VARCHAR(20) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('patient', 'doctor', 'pharmacy')),
  avatar TEXT,
  is_verified BOOLEAN DEFAULT FALSE,
  otp_code VARCHAR(10),
  otp_expires_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User Medical Info
CREATE TABLE IF NOT EXISTS user_medical_info (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  dob DATE,
  gender VARCHAR(10) CHECK (gender IN ('male', 'female')),
  blood_type VARCHAR(5),
  chronic_diseases JSONB DEFAULT '[]',
  allergies JSONB DEFAULT '[]',
  current_medications JSONB DEFAULT '[]',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Doctors table
CREATE TABLE IF NOT EXISTS doctors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  specialization VARCHAR(100) NOT NULL,
  license_number VARCHAR(100) UNIQUE NOT NULL,
  years_experience INTEGER DEFAULT 0,
  bio TEXT,
  professional_card_image TEXT,
  consultation_fee DECIMAL(10,2) DEFAULT 0,
  is_available VARCHAR(20) DEFAULT 'available' CHECK (is_available IN ('available', 'busy', 'offline')),
  rating_avg DECIMAL(2,1) DEFAULT 5.0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Pharmacies table
CREATE TABLE IF NOT EXISTS pharmacies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  pharmacy_name VARCHAR(255) NOT NULL,
  license_number VARCHAR(100) UNIQUE NOT NULL,
  address TEXT NOT NULL,
  address_lat DECIMAL(10,8),
  address_lng DECIMAL(11,8),
  license_image TEXT,
  delivery_range_km INTEGER DEFAULT 10,
  rating_avg DECIMAL(2,1) DEFAULT 5.0,
  is_open BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Consultations table
CREATE TABLE IF NOT EXISTS consultations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID REFERENCES users(id),
  doctor_id UUID REFERENCES users(id),
  symptoms TEXT NOT NULL,
  body_part VARCHAR(50),
  preferred_type VARCHAR(20) CHECK (preferred_type IN ('text', 'audio', 'video')),
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed', 'cancelled')),
  ai_triage_result JSONB,
  urgency_level VARCHAR(20) DEFAULT 'low' CHECK (urgency_level IN ('low', 'medium', 'high')),
  started_at TIMESTAMP,
  ended_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Messages table
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  consultation_id UUID REFERENCES consultations(id) ON DELETE CASCADE,
  sender_id UUID REFERENCES users(id),
  sender_type VARCHAR(20) CHECK (sender_type IN ('patient', 'doctor', 'system')),
  content TEXT NOT NULL,
  attachment_url TEXT,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_read BOOLEAN DEFAULT FALSE
);

-- Prescriptions table
CREATE TABLE IF NOT EXISTS prescriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  consultation_id UUID REFERENCES consultations(id),
  doctor_id UUID REFERENCES users(id),
  patient_id UUID REFERENCES users(id),
  diagnosis TEXT,
  medicines JSONB DEFAULT '[]',
  instructions TEXT,
  digital_signature TEXT,
  issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  prescription_id UUID REFERENCES prescriptions(id),
  pharmacy_id UUID REFERENCES pharmacies(id),
  patient_address TEXT NOT NULL,
  address_lat DECIMAL(10,8),
  address_lng DECIMAL(11,8),
  delivery_fee DECIMAL(10,2) DEFAULT 0,
  total_amount DECIMAL(10,2) NOT NULL,
  payment_method VARCHAR(30) CHECK (payment_method IN ('credit_card', 'mada', 'cash', 'wallet')),
  payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'paid', 'failed')),
  order_status VARCHAR(30) DEFAULT 'ordered' CHECK (order_status IN ('ordered', 'preparing', 'on_the_way', 'nearby', 'delivered', 'cancelled')),
  delivery_person_name VARCHAR(255),
  delivery_person_phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  delivered_at TIMESTAMP
);

-- Order Tracking table
CREATE TABLE IF NOT EXISTS order_tracking (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  status VARCHAR(30) NOT NULL,
  location_lat DECIMAL(10,8),
  location_lng DECIMAL(11,8),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  plan_type VARCHAR(20) NOT NULL CHECK (plan_type IN ('basic', 'premium', 'family')),
  start_date TIMESTAMP NOT NULL,
  end_date TIMESTAMP NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  auto_renew BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  type VARCHAR(50),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
CREATE INDEX IF NOT EXISTS idx_consultations_patient ON consultations(patient_id);
CREATE INDEX IF NOT EXISTS idx_consultations_doctor ON consultations(doctor_id);
CREATE INDEX IF NOT EXISTS idx_consultations_status ON consultations(status);
CREATE INDEX IF NOT EXISTS idx_messages_consultation ON messages(consultation_id);
CREATE INDEX IF NOT EXISTS idx_orders_pharmacy ON orders(pharmacy_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(order_status);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
