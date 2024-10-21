# **Electronics Store Sales Analysis Using MySQL**

## **Project Overview**
This project involves analyzing sales data from an electronics store using MySQL. The dataset contains customer information, product details, and transaction records. The goal is to derive insights into customer behavior, sales trends, and product performance through structured queries.

---

## **Table of Contents**
- [Technologies Used](#technologies-used)
- [Database Design](#database-design)
- [Dataset Description](#dataset-description)
- [Getting Started](#getting-started)
- [Database Setup](#database-setup)
- [Data Import](#data-import)
- [SQL Queries for Data Analysis](#sql-queries-for-data-analysis)
- [License](#license)

---

## **Technologies Used**
- **MySQL**: Database management system used for data storage and analysis
- **CSV**: Data format for inputting sales data (`Electronics_Sales.csv`)

---

## **Database Design**
The project is structured around three main tables to organize customer, product, and transaction data.

### **1. Customers Table**
Stores customer demographic details.

```sql
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    loyalty_member VARCHAR(5)
);
```

### **2. Products Table**
Holds information about products available in the store.

```sql
CREATE TABLE Products (
    sku VARCHAR(20) PRIMARY KEY,
    product_type VARCHAR(50),
    unit_price DECIMAL(10, 2),
    rating INT
);
```

### **3. Transactions Table**
Records transaction details, linking customers and products.

```sql
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
```

---

## **Dataset Description**
The dataset, `Electronics_Sales.csv`, includes the following fields:

| Column              | Description                                           |
|---------------------|-------------------------------------------------------|
| `customer_id`       | Unique identifier for each customer                   |
| `age`               | Age of the customer                                   |
| `gender`            | Gender of the customer (Male/Female)                 |
| `loyalty_member`    | Indicates if the customer is a loyalty program member |
| `sku`               | Stock Keeping Unit (product code)                     |
| `product_type`      | Type of product purchased                              |
| `unit_price`        | Price per unit of the product                         |
| `rating`            | Customer rating for the product                       |
| `order_status`      | Status of the order (Completed/Cancelled)             |
| `payment_method`    | Payment method used (e.g., Credit Card)               |
| `total_price`       | Total amount of the order                             |
| `quantity`          | Quantity of products purchased                        |
| `purchase_date`     | Date of purchase                                      |
| `shipping_type`     | Shipping method (Standard/Express)                    |
| `add_ons_purchased` | Additional products or services purchased             |
| `add_on_total`      | Total cost of add-ons                                 |

---

## **Getting Started**

### **Prerequisites**
- **MySQL Server**: Ensure you have MySQL installed and running on your machine.
- **CSV File**: Place the `Electronics_Sales.csv` file in a directory accessible by MySQL.

---

## **Database Setup**

To set up the database, run the following SQL commands in your MySQL environment:

```sql
-- Creating Database
CREATE DATABASE ElectronicsStoreDB;
USE ElectronicsStoreDB;

-- Create Tables
-- Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    loyalty_member VARCHAR(5)
);

-- Products Table
CREATE TABLE Products (
    sku VARCHAR(20) PRIMARY KEY,
    product_type VARCHAR(50),
    unit_price DECIMAL(10, 2),
    rating INT
);

-- Transactions Table
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
```

---

## **Data Import**

To load data from the CSV file into the MySQL tables, use the following commands. Make sure the path to your CSV file is correctly specified.

### **Load Data into the Customers Table**

```sql
LOAD DATA INFILE 'D:\\Books\\Electronics_Sales.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, age, gender, loyalty_member);
```

### **Load Data into the Products Table**

```sql
LOAD DATA INFILE 'D:\\Books\\Electronics_Sales.csv'
INTO TABLE Products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(sku, product_type, unit_price, rating);
```

### **Load Data into the Transactions Table**

```sql
LOAD DATA INFILE 'D:\\Books\\Electronics_Sales.csv'
INTO TABLE Transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, sku, order_status, payment_method, total_price, quantity, purchase_date, shipping_type, add_ons_purchased, add_on_total);
```

---

## **SQL Queries for Data Analysis**

Here are several SQL queries used to analyze the sales data:

### **1. Total Sales by Product Type**

```sql
SELECT p.product_type, SUM(t.total_price) AS total_sales
FROM Products p
JOIN Transactions t ON p.sku = t.sku
WHERE t.order_status = 'Completed'
GROUP BY p.product_type
ORDER BY total_sales DESC;
```

### **2. Average Customer Age by Loyalty Membership**

```sql
SELECT loyalty_member, AVG(age) AS avg_age
FROM Customers
GROUP BY loyalty_member;
```

### **3. Revenue from Loyalty and Non-Loyalty Members**

```sql
SELECT c.loyalty_member, SUM(t.total_price) AS total_revenue
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE t.order_status = 'Completed'
GROUP BY c.loyalty_member;
```

### **4. Popular Payment Methods**

```sql
SELECT payment_method, COUNT(*) AS count
FROM Transactions
GROUP BY payment_method
ORDER BY count DESC;
```

### **5. Revenue by Shipping Type**

```sql
SELECT shipping_type, SUM(total_price) AS total_sales
FROM Transactions
WHERE order_status = 'Completed'
GROUP BY shipping_type;
```

### **6. Top Spending Customers**

```sql
SELECT c.customer_id, SUM(t.total_price) AS total_spent
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
WHERE t.order_status = 'Completed'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

### **7. Best-Selling Products by Quantity Sold**

```sql
SELECT p.product_type, SUM(t.quantity) AS total_units_sold
FROM Products p
JOIN Transactions t ON p.sku = t.sku
WHERE t.order_status = 'Completed'
GROUP BY p.product_type
ORDER BY total_units_sold DESC;
```

### **8. Average Order Value (AOV)**

```sql
SELECT AVG(total_price) AS average_order_value
FROM Transactions
WHERE order_status = 'Completed';
```

### **9. Most Commonly Purchased Add-ons**

```sql
SELECT add_ons_purchased, COUNT(*) AS occurrences
FROM Transactions
WHERE add_ons_purchased != ''
GROUP BY add_ons_purchased
ORDER BY occurrences DESC;
```

### **10. Sales by Payment Method for Each Product Type**

```sql
SELECT p.product_type, t.payment_method, SUM(t.total_price) AS total_sales
FROM Products p
JOIN Transactions t ON p.sku = t.sku
WHERE t.order_status = 'Completed'
GROUP BY p.product_type, t.payment_method
ORDER BY p.product_type, total_sales DESC;
```

### **11. Customer Retention Rate (Repeat Customers)**

```sql
SELECT c.customer_id, COUNT(*) AS purchase_count
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id
HAVING purchase_count > 1
ORDER BY purchase_count DESC;
```

### **12. Sales of Products with Add-ons vs Without Add-ons**

```sql
SELECT 
    CASE 
        WHEN add_ons_purchased != '' THEN 'With Add-ons'
        ELSE 'Without Add-ons'
    END AS add_on_status,
    SUM(total_price) AS total_sales
FROM Transactions
GROUP BY add_on_status
ORDER BY total_sales DESC;
```

### **13. Most Active

 Customers by Number of Transactions**

```sql
SELECT c.customer_id, COUNT(t.transaction_id) AS total_transactions
FROM Customers c
JOIN Transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id
ORDER BY total_transactions DESC
LIMIT 5;
```

### **14. Revenue Contribution by Age Group**

```sql
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
```

### **15. Sales Trends for Products by Year**

```sql
SELECT YEAR(purchase_date) AS sales_year, p.product_type, SUM(t.total_price) AS total_sales
FROM Products p
JOIN Transactions t ON p.sku = t.sku
WHERE t.order_status = 'Completed'
GROUP BY sales_year, p.product_type
ORDER BY sales_year, total_sales DESC;
```

Here’s a conclusion section you can add to the **README.md** for your Electronics Store Sales Data Analysis project. This section summarizes the project’s purpose and findings, providing users with a final perspective on the analysis:

---

## **Conclusion**

This project provides a comprehensive analysis of customer transactions within the electronics store, leveraging MySQL for data manipulation and insights generation. By organizing data into structured tables, we facilitate efficient queries that reveal valuable trends and patterns.

### **Key Insights:**
1. **Sales Performance**: The analysis of total sales by product type highlights which categories generate the most revenue, aiding inventory and marketing strategies.
2. **Customer Demographics**: Understanding the average age of loyalty members versus non-members helps in tailoring marketing campaigns and enhancing customer retention.
3. **Payment Trends**: Insights into popular payment methods inform the store’s payment processing strategy, optimizing customer convenience and satisfaction.
4. **Shipping Preferences**: Evaluating revenue by shipping type enables the store to assess shipping efficiency and customer preferences, leading to improved logistics.
5. **Customer Engagement**: Identifying top-spending and most active customers provides a basis for targeted promotions, fostering customer loyalty and repeat business.

---
