-- MySQL initialization script for Cashlens
-- This script creates tables and inserts demo data

USE cashlens;

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(10),
    color VARCHAR(20),
    type ENUM('income', 'expense') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create cash_flows table
CREATE TABLE IF NOT EXISTS cash_flows (
    id VARCHAR(36) PRIMARY KEY,
    amount DECIMAL(15, 2) NOT NULL,
    date DATE NOT NULL,
    category VARCHAR(100) NOT NULL,
    type ENUM('income', 'outcome') NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_date (date),
    INDEX idx_category (category),
    INDEX idx_type (type),
    INDEX idx_date_type (date, type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert demo categories
INSERT INTO categories (id, name, icon, color, type) VALUES
(UUID(), 'Food & Dining', '🍔', '#FF6B6B', 'expense'),
(UUID(), 'Transportation', '🚗', '#4ECDC4', 'expense'),
(UUID(), 'Shopping', '🛍️', '#FFE66D', 'expense'),
(UUID(), 'Entertainment', '🎬', '#95E1D3', 'expense'),
(UUID(), 'Bills & Utilities', '💡', '#F38181', 'expense'),
(UUID(), 'Healthcare', '🏥', '#AA96DA', 'expense'),
(UUID(), 'Salary', '💰', '#4CAF50', 'income'),
(UUID(), 'Investment', '📈', '#2196F3', 'income');

-- Insert demo cash flows
-- Today's transactions
INSERT INTO cash_flows (id, amount, date, category, type, description) VALUES
(UUID(), 45.50, CURDATE(), 'Food & Dining', 'outcome', 'Lunch at Italian restaurant'),
(UUID(), 12.00, CURDATE(), 'Transportation', 'outcome', 'Uber to office'),
(UUID(), 3500.00, CURDATE(), 'Salary', 'income', 'Monthly salary');

-- Yesterday
INSERT INTO cash_flows (id, amount, date, category, type, description) VALUES
(UUID(), 89.99, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Shopping', 'outcome', 'New shoes'),
(UUID(), 25.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Entertainment', 'outcome', 'Movie tickets');

-- This week
INSERT INTO cash_flows (id, amount, date, category, type, description) VALUES
(UUID(), 150.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 'Bills & Utilities', 'outcome', 'Electricity bill'),
(UUID(), 65.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY), 'Healthcare', 'outcome', 'Pharmacy'),
(UUID(), 200.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY), 'Investment', 'income', 'Dividend payment');

-- Earlier this month
INSERT INTO cash_flows (id, amount, date, category, type, description) VALUES
(UUID(), 120.00, DATE_SUB(CURDATE(), INTERVAL 10 DAY), 'Food & Dining', 'outcome', 'Grocery shopping'),
(UUID(), 45.00, DATE_SUB(CURDATE(), INTERVAL 12 DAY), 'Transportation', 'outcome', 'Gas station'),
(UUID(), 75.50, DATE_SUB(CURDATE(), INTERVAL 15 DAY), 'Food & Dining', 'outcome', 'Dinner with friends'),
(UUID(), 30.00, DATE_SUB(CURDATE(), INTERVAL 18 DAY), 'Entertainment', 'outcome', 'Concert tickets'),
(UUID(), 250.00, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 'Shopping', 'outcome', 'Clothing'),
(UUID(), 500.00, DATE_SUB(CURDATE(), INTERVAL 22 DAY), 'Investment', 'income', 'Freelance project'),
(UUID(), 80.00, DATE_SUB(CURDATE(), INTERVAL 25 DAY), 'Bills & Utilities', 'outcome', 'Internet bill');

-- Print summary
SELECT 
    'Database initialized successfully!' AS message,
    (SELECT COUNT(*) FROM categories) AS total_categories,
    (SELECT COUNT(*) FROM cash_flows) AS total_transactions,
    (SELECT SUM(amount) FROM cash_flows WHERE type = 'income') AS total_income,
    (SELECT SUM(amount) FROM cash_flows WHERE type = 'outcome') AS total_expense;
