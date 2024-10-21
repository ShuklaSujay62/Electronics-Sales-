-- Creating Database:
CREATE DATABASE ElectronicsStoreDB;
USE ElectronicsStoreDB;

-- Create the Customers Table:
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    loyalty_member VARCHAR(5)
);

-- Create the Products Table:
CREATE TABLE Products (
    sku VARCHAR(20) PRIMARY KEY,
    product_type VARCHAR(50),
    unit_price DECIMAL(10, 2),
    rating INT
);

-- Create the Transactions Table:
CREATE TABLE Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    sku VARCHAR(20),
    order_status VARCHAR(20),
    payment_method VARCHAR(20),
    total_price DECIMAL(10, 2),
    quantity INT,
    purchase_date DATE,
    shipping_type VARCHAR(50),
    add_ons_purchased TEXT,
    add_on_total DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (sku) REFERENCES Products(sku)
);

-- Load Data from Electronics_Sales.csv into MySQL:

-- Load Data into the Customers Table:
LOAD DATA INFILE 'D:\\Books\\Electronics_Sales.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, age, gender, loyalty_member);

-- Load Data into the Products Table:
LOAD DATA INFILE 'D:\\Books\\Electronics_Sales.csv'
INTO TABLE Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sku, product_type, unit_price, rating);

-- Load Data into the Transactions Table:
LOAD DATA INFILE 'D:\\Books\\Electronics_Sales.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, sku, order_status, payment_method, total_price, quantity, purchase_date, shipping_type, add_ons_purchased, add_on_total);


-- 1. Total Sales by Product Type:

SELECT p.product_type, SUM(t.total_price) AS total_sales
FROM Products p
JOIN Transactions t ON p.sku = t.sku
WHERE t.order_status = 'Completed'
GROUP BY p.product_type
ORDER BY total_sales DESC;


-- 2. Average Customer Age by Loyalty Membership:

SELECT loyalty_member, AVG(age) AS avg_age
FROM Customers
GROUP BY loyalty_member;


-- 3. Revenue from Loyalty and Non-Loyalty Members:

SELECT c.loyalty_member, SUM(t.total_price) AS total_revenue
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE t.order_status = 'Completed'
GROUP BY c.loyalty_member;


-- 4. Popular Payment Methods:

SELECT payment_method, COUNT(*) AS count
FROM Transactions
GROUP BY payment_method
ORDER BY count DESC;


-- 5. Revenue by Shipping Type:

SELECT shipping_type, SUM(total_price) AS total_sales
FROM Transactions
WHERE order_status = 'Completed'
GROUP BY shipping_type;


-- 6. Top Spending Customers:

SELECT c.customer_id, SUM(t.total_price) AS total_spent
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE t.order_status = 'Completed'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;


-- 7. Best-Selling Products by Quantity Sold:

SELECT p.product_type, SUM(t.quantity) AS total_units_sold
FROM Products p
JOIN Transactions t ON p.sku = t.sku
WHERE t.order_status = 'Completed'
GROUP BY p.product_type
ORDER BY total_units_sold DESC;


-- 8. Average Order Value (AOV):

SELECT AVG(total_price) AS average_order_value
FROM Transactions
WHERE order_status = 'Completed';


-- 9. Most Commonly Purchased Add-ons:

SELECT add_ons_purchased, COUNT(*) AS occurrences
FROM Transactions
WHERE add_ons_purchased != ''
GROUP BY add_ons_purchased
ORDER BY occurrences DESC;


-- 10. Sales by Payment Method for Each Product Type:

SELECT p.product_type, t.payment_method, SUM(t.total_price) AS total_sales
FROM Products p
JOIN Transactions t ON p.sku = t.sku
WHERE t.order_status = 'Completed'
GROUP BY p.product_type, t.payment_method
ORDER BY p.product_type, total_sales DESC;


-- 11. Customer Retention Rate (Repeat Customers):

SELECT c.customer_id, COUNT(*) AS purchase_count
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id
HAVING purchase_count > 1
ORDER BY purchase_count DESC;


-- 12. Sales of Products with Add-ons vs Without Add-ons:

SELECT 
    CASE 
        WHEN add_ons_purchased != '' THEN 'With Add-ons'
        ELSE 'Without Add-ons'
    END AS add_on_status,
    SUM(total_price) AS total_sales
FROM Transactions
GROUP BY add_on_status
ORDER BY total_sales DESC;


-- 13. Most Active Customers by Number of Transactions:

SELECT c.customer_id, COUNT(t.transaction_id) AS total_transactions
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id
ORDER BY total_transactions DESC
LIMIT 5;


-- 14. Revenue Contribution by Age Group:

SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+' 
    END AS age_group,
    SUM(t.total_price) AS total_revenue
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE t.order_status = 'Completed'
GROUP BY age_group
ORDER BY total_revenue DESC;


-- 15. Sales Trends for Products by Year:

SELECT YEAR(purchase_date) AS sales_year, p.product_type, SUM(t.total_price) AS total_sales
FROM Products p
JOIN Transactions t ON p.sku = t.sku
WHERE t.order_status = 'Completed'
GROUP BY sales_year, p.product_type
ORDER BY sales_year, total_sales DESC;
