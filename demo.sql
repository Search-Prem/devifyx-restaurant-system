-- =======================================================
-- DevifyX Restaurant Ordering System - Demo & Test Script
-- Author: Prem Kumar Garapati
-- Description: All statements work seamlessly with provided schema
-- =======================================================

USE devifyx_restaurant;
SHOW TABLES;
-- 1. View Sample Data
SELECT * FROM Users;
SELECT * FROM MenuItems;
SELECT * FROM RestaurantTables;
SELECT * FROM InventoryItems;

-- 2. Place Order (valid user_id=1, item_id=1 (Latte), table_id=1)
CALL PlaceOrder(1, 'John Doe', 1, 1, 2);
SELECT * FROM Orders ORDER BY order_id DESC LIMIT 1;
SELECT * FROM OrderItems WHERE order_id = LAST_INSERT_ID();

-- 3. Restock Inventory (inventory_id = 1 => Coffee Beans)
CALL RestockInventory(1, 5.5);
SELECT * FROM InventoryItems WHERE inventory_id = 1;

-- 4. Cancel Order Item (make sure an order item with ID = 1 exists)
-- First confirm ID exists:
SELECT * FROM OrderItems;
-- Then cancel:
CALL CancelOrderItem(1);
SELECT * FROM OrderItems WHERE order_item_id = 1;

-- 5. Test Low Inventory Trigger (will trigger error)
-- Warning: this will raise a SIGNAL
UPDATE InventoryItems SET quantity = 1 WHERE inventory_id = 2;

-- 6. Reporting: Daily Sales and Low Stock Items
SELECT * FROM DailySales;
SELECT * FROM LowStockItems;

-- End of Demo Script
-- =======================================================
