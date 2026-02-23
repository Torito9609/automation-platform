-- V2__core_tables.sql

-- 1) Tenants: ya existe, solo aseguro unicidad por nombre (opcional)
-- Si no quieres esta parte, la quitamos
-- ALTER TABLE tenants ADD CONSTRAINT uk_tenants_name UNIQUE (name);

-- 2) Users del negocio (para login/roles después)
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  email VARCHAR(180) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(30) NOT NULL, -- OWNER, ADMIN, STAFF
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id),
  CONSTRAINT uk_users_tenant_email UNIQUE (tenant_id, email)
);

-- 3) Customers (clientes del negocio)
CREATE TABLE IF NOT EXISTS customers (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  full_name VARCHAR(180) NOT NULL,
  phone VARCHAR(40),
  email VARCHAR(180),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_customers_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

-- 4) Appointments (citas)
CREATE TABLE IF NOT EXISTS appointments (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  customer_id UUID NOT NULL,
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  status VARCHAR(30) NOT NULL, -- PENDING, CONFIRMED, CANCELED, RESCHEDULED, NO_SHOW
  notes TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_appointments_tenant FOREIGN KEY (tenant_id) REFERENCES tenants(id),
  CONSTRAINT fk_appointments_customer FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Índices útiles (MVP)
CREATE INDEX IF NOT EXISTS idx_customers_tenant ON customers(tenant_id);
CREATE INDEX IF NOT EXISTS idx_appointments_tenant_start ON appointments(tenant_id, start_time);
CREATE INDEX IF NOT EXISTS idx_appointments_customer ON appointments(customer_id);