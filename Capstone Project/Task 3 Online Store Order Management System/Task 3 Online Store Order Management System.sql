
-- Task 3: Online Store Order Management System

-- Step 1: Create tables

CREATE TABLE Customers (
    CUSTOMER_ID SERIAL PRIMARY KEY,
    NAME TEXT NOT NULL,
    EMAIL TEXT UNIQUE NOT NULL,
    PHONE TEXT,
    ADDRESS TEXT
);

CREATE TABLE Products (
    PRODUCT_ID SERIAL PRIMARY KEY,
    PRODUCT_NAME TEXT NOT NULL,
    CATEGORY TEXT NOT NULL,
    PRICE NUMERIC(10,2) NOT NULL,
    STOCK INT NOT NULL
);

CREATE TABLE Orders (
    ORDER_ID SERIAL PRIMARY KEY,
    CUSTOMER_ID INT REFERENCES Customers(CUSTOMER_ID),
    PRODUCT_ID INT REFERENCES Products(PRODUCT_ID),
    QUANTITY INT NOT NULL,
    ORDER_DATE DATE NOT NULL
);

-- ===============================
-- Step 2: Insert sample data (exact same as previously provided)
-- ===============================

-- Customers
INSERT INTO Customers(NAME, EMAIL, PHONE, ADDRESS) VALUES
('Alice Smith', 'alice@example.com', '1234567890', '123 Apple St'),
('Bob Johnson', 'bob@example.com', '2345678901', '456 Orange Ave'),
('Charlie Brown', 'charlie@example.com', '3456789012', '789 Banana Blvd'),
('Diana Prince', 'diana@example.com', '4567890123', '101 Grape Rd'),
('Evan Davis', 'evan@example.com', '5678901234', '202 Mango Ln');

-- Products
INSERT INTO Products(PRODUCT_NAME, CATEGORY, PRICE, STOCK) VALUES
('Laptop', 'Electronics', 900.00, 5),
('Smartphone', 'Electronics', 500.00, 0),
('Headphones', 'Electronics', 50.00, 20),
('T-shirt', 'Clothing', 20.00, 15),
('Jeans', 'Clothing', 40.00, 0),
('Coffee Maker', 'Home Appliances', 80.00, 10);

-- Orders
INSERT INTO Orders(CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) VALUES
(1, 1, 1, '2025-01-15'),
(1, 3, 2, '2025-02-10'),
(2, 2, 1, '2025-03-05'),
(2, 4, 3, '2025-04-12'),
(3, 5, 2, '2025-05-01'),
(4, 6, 1, '2025-06-20'),
(4, 3, 1, '2025-07-18'),
(5, 1, 1, '2025-08-05');

-- ===============================
-- ORDER MANAGEMENT QUERIES
-- ===============================

-- a) Retrieve all orders placed by a specific customer (e.g., Alice Smith)
SELECT o.ORDER_ID, c.NAME AS CUSTOMER, p.PRODUCT_NAME, o.QUANTITY, o.ORDER_DATE
FROM Orders o
JOIN Customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
WHERE c.NAME = 'Alice Smith';

-- b) Find products that are out of stock
SELECT PRODUCT_NAME, CATEGORY, PRICE, STOCK
FROM Products
WHERE STOCK = 0;

-- c) Calculate total revenue generated per product
SELECT p.PRODUCT_NAME, SUM(o.QUANTITY * p.PRICE) AS total_revenue
FROM Orders o
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY p.PRODUCT_NAME;

-- d) Retrieve top 5 customers by total purchase amount
SELECT c.NAME AS CUSTOMER, SUM(o.QUANTITY * p.PRICE) AS total_spent
FROM Orders o
JOIN Customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY c.NAME
ORDER BY total_spent DESC
LIMIT 5;

-- e) Find customers who placed orders in at least two different product categories
SELECT c.NAME AS CUSTOMER
FROM Orders o
JOIN Customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY c.CUSTOMER_ID, c.NAME
HAVING COUNT(DISTINCT p.CATEGORY) >= 2;

-- ===============================
-- ANALYTICS QUERIES
-- ===============================

-- a) Find the month with the highest total sales
SELECT TO_CHAR(o.ORDER_DATE, 'YYYY-MM') AS month, SUM(o.QUANTITY * p.PRICE) AS total_sales
FROM Orders o
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY TO_CHAR(o.ORDER_DATE, 'YYYY-MM')
ORDER BY total_sales DESC
LIMIT 1;

-- b) Identify products with no orders in the last 6 months
SELECT PRODUCT_NAME
FROM Products p
WHERE p.PRODUCT_ID NOT IN (
    SELECT DISTINCT PRODUCT_ID
    FROM Orders
    WHERE ORDER_DATE >= (CURRENT_DATE - INTERVAL '6 months')
);

-- c) Retrieve customers who have never placed an order
SELECT NAME
FROM Customers c
WHERE c.CUSTOMER_ID NOT IN (
    SELECT DISTINCT CUSTOMER_ID FROM Orders
);

-- d) Calculate the average order value across all orders
SELECT AVG(o.QUANTITY * p.PRICE) AS avg_order_value
FROM Orders o
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID;
