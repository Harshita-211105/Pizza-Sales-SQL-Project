CREATE SCHEMA IF NOT EXISTS pizza_place_sales;
USE pizza_place_sales;

-- BASIC METRICS
-- Total number of orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders; 

-- Total pizza items sold
SELECT SUM(quantity) AS total_pizza_sold
FROM order_details; 

-- Distinct pizza sizes
SELECT DISTINCT size
FROM pizzas;

-- Total revenue
SELECT ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM order_details o
JOIN pizzas p ON p.pizza_id = o.pizza_id;

-- CATEGORY AND PRODUCT ANALYSIS
-- Total quantity sold by pizza type
SELECT p.pizza_id, SUM(o.quantity) AS total_quantity
FROM order_details o
JOIN pizzas p ON p.pizza_id = o.pizza_id
GROUP BY p.pizza_id;

-- Total revenue by pizza category
SELECT pt.category, ROUND(SUM(o.quantity * p.price), 2) AS revenue
FROM pizzas p
JOIN order_details o ON o.pizza_id = p.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category;

-- Total revenue by pizza size
SELECT p.size, ROUND(SUM(o.quantity * p.price), 2) AS total_revenue
FROM order_details o
JOIN pizzas p ON p.pizza_id = o.pizza_id
GROUP BY p.size;

-- Most ordered pizza by quantity
SELECT DISTINCT p.pizza_id
FROM order_details o
JOIN pizzas p ON p.pizza_id = o.pizza_id
WHERE quantity = (SELECT MAX(quantity) FROM order_details);

-- ORDER LEVELS
-- Orders that include more than 2 distinct pizza types
SELECT order_id
FROM order_details
GROUP BY order_id
HAVING COUNT(DISTINCT pizza_id) > 2;

-- For each order, compute total value and total items
SELECT order_id, ROUND(SUM(quantity * price),2) AS total_value, SUM(quantity) AS total_items
FROM order_details o
JOIN pizzas p ON p.pizza_id = o.pizza_id
GROUP BY order_id;

-- Label orders by value with case
WITH order_summary AS (
  SELECT o.order_id, ROUND(SUM(o.quantity * p.price), 2) AS total_value
  FROM order_details o
  JOIN pizzas p ON p.pizza_id = o.pizza_id
  GROUP BY o.order_id
)
SELECT order_id, total_value,
       CASE
         WHEN total_value < 20 THEN 'low'
         WHEN total_value BETWEEN 20 AND 50 THEN 'medium'
         ELSE 'high'
       END AS revenue_category
FROM order_summary;

-- TIME BASED TRENDS
-- Monthly revenue trend
WITH monthly_sale AS 
(
  SELECT MONTHNAME(o.date) AS month_name,
         COUNT(od.order_id) AS monthly_count,
         ROUND(SUM(od.quantity * p.price), 2) AS monthly_revenue
  FROM order_details od
  JOIN orders o ON o.order_id = od.order_id
  JOIN pizzas p ON p.pizza_id = od.pizza_id
  GROUP BY MONTHNAME(o.date)
)
SELECT month_name, monthly_count, monthly_revenue
FROM monthly_sale
ORDER BY monthly_revenue DESC
LIMIT 3;
-- top 3 months by revenue : july, may, march

-- Requires MySQL 8.0+ (due to use of window functions like ROW_NUMBER)
-- Top pizza type by revenue each month
WITH monthly_pizza_revenue AS (
  SELECT MONTHNAME(o.date) AS month_name,
         p.pizza_id,
         COUNT(od.quantity) AS pizza_count,
         ROUND(SUM(od.quantity * p.price), 2) AS revenue
  FROM order_details od
  JOIN orders o ON o.order_id = od.order_id
  JOIN pizzas p ON p.pizza_id = od.pizza_id
  GROUP BY MONTHNAME(o.date), p.pizza_id
)
SELECT month_name,
       pizza_id,
       pizza_count,
       revenue,
       ROW_NUMBER() OVER (PARTITION BY month_name ORDER BY revenue DESC) AS rank
FROM monthly_pizza_revenue;

