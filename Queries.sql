CREATE DATABASE salesdb;
USE salesdb;

SELECT * FROM salesdb;

CREATE TABLE Customers (
	CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);
SELECT * FROM Customers;

CREATE TABLE Products (
	ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);
SELECT * FROM Products;

CREATE TABLE Regions (
	RegionID INT PRIMARY KEY,
    City VARCHAR(50),
    Country VARCHAR(50),
    FullName VARCHAR(100)
);

SELECT * FROM Regions;

ALTER TABLE Regions ADD  FullName VARCHAR(100) NOT NULL;

CREATE TABLE Orders (
    OrderID VARCHAR(20),
    OrderDate VARCHAR(20) NOT NULL,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    RegionID INT NOT NULL,
    Channel VARCHAR(50) NOT NULL,
    CurrencyCode CHAR(3) NOT NULL,
    WarehouseCode VARCHAR(10) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
    LineTotal DECIMAL(12,2) NOT NULL,
    TotalUnitCost DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Orders_Products FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID),
    CONSTRAINT FK_Orders_Regions FOREIGN KEY (RegionID)
        REFERENCES Regions(RegionID)
);

SELECT * FROM Orders;


ALTER TABLE Orders
MODIFY  OrderID VARCHAR(20);

ALTER TABLE orders
MODIFY OrderDate VARCHAR(20);

ALTER TABLE Regions
DROP COLUMN RegionName;

-- 🧩 Validate Data Using SQL Queries ===


USE salesdb;
SELECT * FROM Orders;

-- Join Check ===

SELECT 
    o.OrderID,
    c.CustomerName,
    p.ProductName,
    o.LineTotal
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Products p ON o.ProductID = p.ProductID;


-- 🔹 Total Sales by Product ===

SELECT p.ProductName, SUM(o.LineTotal) AS TotalSales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY ProductName
ORDER BY TotalSales DESC;


-- 🔹 Sales by Region ===

SELECT r.FullName, SUM(o.LineTotal) AS Sales
FROM Orders o
JOIN Regions r ON o.RegionID = r.RegionID
GROUP BY r.FullName;


-- 🔹 Top 10 Products ====

SELECT p.ProductName, SUM(o.LineTotal) AS Sales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.ProductName, o.LineTotal
ORDER BY o.LineTotal DESC
LIMIT 10;
