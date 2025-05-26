# DevifyX Restaurant Ordering System (MySQL Only)

![MySQL](https://img.shields.io/badge/database-MySQL-blue.svg)

An advanced backend system that simulates a full-fledged restaurant management and ordering environment using only MySQL. This project covers menu management, order handling, inventory tracking, and more—all through robust schema, stored procedures, triggers, and views.

---

## 🚀 Features

* 🔐 **User & Role Management** (Waiter, Chef, Manager)
* 📋 **Menu Management** with categories and modifiers
* 🍽️ **Order Placement & Tracking** with item-level status
* 🪑 **Table Reservation System** with status tracking
* 🥫 **Inventory Management** with alerts and usage logs
* 🔧 **Kitchen Queue** routing and prioritization
* 📊 **Reporting & Analytics** via SQL views

---

## 🛠️ Tech Stack

* MySQL (Schema, Procedures, Triggers, Views)
* No external programming language required

---

## 🧰 Setup Instructions

1. **Create Database**

```sql
CREATE DATABASE devifyx_restaurant;
USE devifyx_restaurant;
```

2. **Import the SQL Script**
   Run the contents of `restaurant_schema.sql` using MySQL Workbench or any SQL client.

---

## 📦 Usage Examples

### ➕ Place Order

```sql
CALL PlaceOrder(1, 'John Doe', 1);
```

### 🔄 Restock Inventory

```sql
CALL RestockInventory(1, 20, 1);
```

### ❌ Cancel Order Item

```sql
CALL CancelOrderItem(1);
```

---

## 🔍 Views for Reporting

* `DailySales` – Date-wise sales summary by item
* `LowStockItems` – Real-time low inventory view

---

## 🧪 Sample Data

```sql
SELECT * FROM Users;
SELECT * FROM MenuItems;
SELECT * FROM RestaurantTables;
```

* Users: alice (waiter), bob (chef), carol (manager)
* Items: Coke, Burger (modifier: Extra Cheese)
* Tables: T1 (Main Hall), T2 (Balcony)

---

## 📸 Demo Suggestions

If recording a walkthrough:

1. Show database setup
2. Insert sample data
3. Place and modify orders
4. Trigger low inventory alert
5. Query views for reports

---

## 📄 License

This project is for educational and demonstration purposes only.

---

## 👨‍💻 Author

**Prem Kumar Garapati**
