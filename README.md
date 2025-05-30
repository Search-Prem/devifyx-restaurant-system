# DevifyX Restaurant Ordering System (MySQL Only)

![MySQL](https://img.shields.io/badge/database-MySQL-blue.svg)

An advanced backend system that simulates a full-fledged restaurant management and ordering environment using only MySQL. This project covers menu management, order handling, inventory tracking, and more—all through robust schema, stored procedures, triggers, and views.

---

## 🚀 Features

- 🔐 **User & Role Management** (Waiter, Chef, Manager)
- 📋 **Menu Management** with categories and modifiers
- 🍽️ **Order Placement & Tracking** with item-level status
- 🪑 **Table Reservation System** with status tracking
- 🥫 **Inventory Management** with alerts and usage logs
- 🔧 **Kitchen Queue** (planned for extension)
- 📊 **Reporting & Analytics** via SQL views

---

## 🛠️ Tech Stack
- MySQL (Schema, Procedures, Triggers, Views)
- No external programming language required

---

## 🧰 Setup Instructions

1. **Create Database**
```sql
CREATE DATABASE devifyx_restaurant;
USE devifyx_restaurant;
```

2. **Import the SQL Script**
Run the full `restaurant_schema.sql` file in MySQL Workbench.

---

## 📦 Usage Examples (from `demo_script.sql`)

### ➕ Place Order
```sql
CALL PlaceOrder(1, 'John Doe', 1, 1, 2);
```

### 🔄 Restock Inventory
```sql
CALL RestockInventory(1, 5.5);
```

### ❌ Cancel Order Item
```sql
CALL CancelOrderItem(1);
```

---

## 🔍 Views for Reporting

- `DailySales` – Date-wise item sales and revenue
- `LowStockItems` – Inventory below threshold

---

## 🧪 Sample Data
```sql
SELECT * FROM Users;
SELECT * FROM MenuItems;
SELECT * FROM RestaurantTables;
SELECT * FROM InventoryItems;
```
- Users: alice (waiter), bob (chef), carol (manager)
- Items: Latte, Veggie Wrap (with Extra Shot, Add Avocado modifiers)
- Inventory: Coffee Beans, Fresh Vegetables

To reset sample data, truncate relevant tables and re-run the INSERT statements.

---

## 📸 Demo Flow

Follow this flow during your walkthrough:

1. **Database Setup** – Show schema creation
2. **View Sample Data** – Use `SELECT` statements
3. **Place Order** – Call `PlaceOrder` and view inserted rows
4. **Restock Inventory** – Call `RestockInventory`
5. **Cancel Order Item** – Use `CancelOrderItem`
6. **Trigger Low Inventory** – Run an `UPDATE` that raises a SIGNAL
7. **Run Reports** – Query `DailySales` and `LowStockItems`

> ⚠️ Note: The `low inventory` update intentionally triggers a MySQL SIGNAL. Explain that this is expected behavior implemented via a trigger.

---

## 👨‍💻 Author
**Prem Kumar Garapati**
