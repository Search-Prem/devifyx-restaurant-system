-- =======================================================
-- DevifyX Restaurant Ordering System - Optimized SQL Setup
-- Author: Prem Kumar Garapati
-- Description: Full schema, data, procedures, triggers & test cases
-- =======================================================

CREATE DATABASE IF NOT EXISTS devifyx_restaurant;
USE devifyx_restaurant;

-- =============================
-- 1. User & Role Management
-- =============================
CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

INSERT INTO Roles (role_name) VALUES ('waiter'), ('chef'), ('manager');
INSERT INTO Users (username, password_hash, role_id) VALUES
('alice', 'hash1', 1),
('bob', 'hash2', 2),
('carol', 'hash3', 3);

-- =============================
-- 2. Menu Management
-- =============================
CREATE TABLE MenuCategories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE MenuItems (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES MenuCategories(category_id)
);

CREATE TABLE ItemModifiers (
    modifier_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    name VARCHAR(100) NOT NULL,
    price_change DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

INSERT INTO MenuCategories (category_name) VALUES ('Drinks'), ('Food');
INSERT INTO MenuItems (name, description, price, category_id) VALUES
('Latte', 'Freshly brewed coffee with milk', 3.99, 1),
('Veggie Wrap', 'Healthy tortilla wrap with fresh vegetables', 5.49, 2);
INSERT INTO ItemModifiers (item_id, name, price_change) VALUES
(1, 'Extra Shot', 0.75),
(2, 'Add Avocado', 1.00);

-- =============================
-- 3. Inventory Management
-- =============================
CREATE TABLE InventoryItems (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    unit VARCHAR(20) NOT NULL,
    quantity DECIMAL(10,2) DEFAULT 0 CHECK (quantity >= 0),
    low_stock_threshold DECIMAL(10,2) DEFAULT 5
);

INSERT INTO InventoryItems (name, unit, quantity, low_stock_threshold) VALUES
('Coffee Beans', 'kg', 20, 3),
('Fresh Vegetables', 'kg', 25, 5);

-- =============================
-- 4. Table Management
-- =============================
CREATE TABLE RestaurantTables (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_number VARCHAR(10) NOT NULL UNIQUE,
    capacity INT NOT NULL,
    location VARCHAR(100),
    status ENUM('available', 'occupied', 'reserved', 'cleaning') DEFAULT 'available'
);

INSERT INTO RestaurantTables (table_number, capacity, location) VALUES
('T1', 4, 'Main Hall'),
('T2', 2, 'Balcony');

-- =============================
-- 5. Orders
-- =============================
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    table_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    status ENUM('pending', 'confirmed', 'preparing', 'ready', 'served', 'cancelled', 'refunded') DEFAULT 'pending',
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES RestaurantTables(table_id),
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);

CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    status ENUM('pending', 'preparing', 'ready', 'served', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

CREATE TABLE OrderModifiers (
    order_modifier_id INT AUTO_INCREMENT PRIMARY KEY,
    order_item_id INT,
    modifier_id INT,
    FOREIGN KEY (order_item_id) REFERENCES OrderItems(order_item_id),
    FOREIGN KEY (modifier_id) REFERENCES ItemModifiers(modifier_id)
);

-- =============================
-- 6. Stored Procedures
-- =============================
DELIMITER //

CREATE PROCEDURE PlaceOrder (
    IN p_table_id INT,
    IN p_customer_name VARCHAR(100),
    IN p_created_by INT,
    IN p_item_id INT,
    IN p_quantity INT
)
BEGIN
    INSERT INTO Orders (table_id, customer_name, created_by)
    VALUES (p_table_id, p_customer_name, p_created_by);
    SET @order_id = LAST_INSERT_ID();
    INSERT INTO OrderItems (order_id, item_id, quantity)
    VALUES (@order_id, p_item_id, p_quantity);
END;//

CREATE PROCEDURE CancelOrderItem (
    IN p_order_item_id INT
)
BEGIN
    UPDATE OrderItems
    SET status = 'cancelled'
    WHERE order_item_id = p_order_item_id;
END;//

CREATE PROCEDURE RestockInventory (
    IN p_inventory_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    UPDATE InventoryItems
    SET quantity = quantity + p_amount
    WHERE inventory_id = p_inventory_id;
END;//

DELIMITER ;

-- =============================
-- 7. Triggers
-- =============================
DELIMITER //

CREATE TRIGGER trg_decrease_inventory
AFTER INSERT ON OrderItems
FOR EACH ROW
BEGIN
    UPDATE InventoryItems
    SET quantity = quantity - NEW.quantity
    WHERE name = (SELECT name FROM MenuItems WHERE item_id = NEW.item_id);
END;//

CREATE TRIGGER trg_low_inventory_flag
AFTER UPDATE ON InventoryItems
FOR EACH ROW
BEGIN
    IF NEW.quantity < NEW.low_stock_threshold THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inventory low! Restock required.';
    END IF;
END;//

DELIMITER ;

-- =============================
-- 8. Views (Optional for demo)
-- =============================
CREATE VIEW DailySales AS
SELECT o.created_at AS sale_time,
       mi.name AS item_name,
       oi.quantity,
       (oi.quantity * mi.price) AS total_price
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN MenuItems mi ON oi.item_id = mi.item_id;

CREATE VIEW LowStockItems AS
SELECT name, quantity, low_stock_threshold
FROM InventoryItems
WHERE quantity < low_stock_threshold;

-- =============================
-- End of File
-- =============================
