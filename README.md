# 🍕 Pizza Sales SQL Analysis

This project explores a fictional pizza sales dataset using **MySQL**. It aims to uncover key insights such as total sales, revenue by category, and order behaviour trends — all through structured SQL queries.

---

## 📂 Dataset Structure

The dataset consists of 4 CSV files:

- `order_details.csv` → Contains order detail IDs, order IDs, pizza IDs and quantities
- `orders.csv` → Contains order IDs and dates
- `pizzas.csv` → Contains pizza IDs, prices, and sizes
- `pizza_types.csv` → Contains pizza type categories and ingredients

---

## 🛠️ Tools & Technologies

- **MySQL Workbench**
- SQL concepts: `JOIN`, `GROUP BY`, `ORDER BY`, `CTE`, `CASE`, `WINDOW FUNCTIONS`

---

## 📊 Key Insights Extracted

### ✅ Basic Metrics
- Total number of orders
- Total quantity of pizzas sold
- Distinct pizza sizes offered
- Total revenue generated

### 🍽️ Product & Category Analysis
- Most ordered pizza types
- Revenue by category (Classic, Supreme, etc.)
- Size-wise performance (S, M, L, XL, XXL)

### 📦 Order-Level Analysis
- Orders with more than 2 distinct pizza types
- Labelled orders by revenue category (Low, Medium, High)

### 📅 Time-Based Trends
- Top 3 months by revenue
- Monthly top-performing pizza types (using `ROW_NUMBER()` — MySQL 8.0+ only)

---
