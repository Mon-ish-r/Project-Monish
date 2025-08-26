
-- Task 2: Simple SQL Practice for Online Store
-- PostgreSQL

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

-- Step 2: Insert sample data
INSERT INTO Customers(NAME, EMAIL, PHONE, ADDRESS) VALUES
('Alice Smith', 'alice@example.com', '1234567890', '123 Apple St'),
('Bob Johnson', 'bob@example.com', '2345678901', '456 Orange Ave'),
('Charlie Brown', 'charlie@example.com', '3456789012', '789 Banana Blvd');

INSERT INTO Products(PRODUCT_NAME, CATEGORY, PRICE, STOCK) VALUES
('Laptop', 'Electronics', 900.00, 5),
('Smartphone', 'Electronics', 500.00, 0),
('Headphones', 'Electronics', 50.00, 20),
('T-shirt', 'Clothing', 20.00, 15);

INSERT INTO Orders(CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) VALUES
(1, 1, 1, '2025-01-15'),
(1, 3, 2, '2025-02-10'),
(2, 2, 1, '2025-03-05'),
(2, 4, 3, '2025-04-12'),
(3, 3, 1, '2025-05-01');

-- Step 3: Queries

-- a) Retrieve all orders placed by a specific customer (Alice Smith)
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

-- d) Retrieve top customers by total purchase amount
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
