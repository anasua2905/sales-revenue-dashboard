CREATE DATABASE superstore;
USE superstore;

USE superstore;
CREATE TABLE sales (
    Row_ID        INT,
    Order_ID      VARCHAR(20),
    Order_Date    DATE,
    Ship_Date     DATE,
    Ship_Mode     VARCHAR(30),
    Customer_ID   VARCHAR(20),
    Customer_Name VARCHAR(50),
    Segment       VARCHAR(20),
    Country       VARCHAR(30),
    City          VARCHAR(50),
    State         VARCHAR(50),
    Postal_Code   VARCHAR(10),
    Region        VARCHAR(20),
    Product_ID    VARCHAR(20),
    Category      VARCHAR(30),
    Sub_Category  VARCHAR(30),
    Product_Name  VARCHAR(200),
    Sales         DECIMAL(10,2),
    Quantity      INT,
    Discount      DECIMAL(5,2),
    Profit        DECIMAL(10,2)
);
USE superstore;
SELECT COUNT(*) AS Total_Rows FROM sales;

#              Query 1 — Overall Business KPI Summary
-- Business Question: How is the overall business performing?
USE superstore;
SELECT
    COUNT(DISTINCT Order_ID)             AS Total_Orders,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct,
    ROUND(AVG(Sales), 2)                 AS Avg_Order_Value
FROM sales;
               # Query 2 — Revenue by Region
-- Business Question: Which region makes the most money?
SELECT
    Region,
    COUNT(DISTINCT Order_ID)             AS Total_Orders,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM sales
GROUP BY Region
ORDER BY Total_Revenue DESC;

               # Query 3 — Top 10 Products by Revenue
-- Business Question: Which products make the most money?
SELECT
    Product_Name,
    Category,
    Sub_Category,
    COUNT(*)                             AS Times_Ordered,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM sales
GROUP BY Product_Name, Category, Sub_Category
ORDER BY Total_Revenue DESC
LIMIT 10;
                #Query 4 — Most Profitable Category
-- Business Question: Which category is most profitable?
SELECT
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct,
    COUNT(DISTINCT Order_ID)             AS Total_Orders
FROM sales
GROUP BY Category, Sub_Category
ORDER BY Category, Total_Profit DESC;


-- Check min and max profit values
SELECT 
    MIN(Profit) AS Min_Profit,
    MAX(Profit) AS Max_Profit,
    COUNT(*) AS Total_Rows
FROM sales;

-- See actual profit values
SELECT Order_ID, Sales, Profit 
FROM sales 
LIMIT 10;
                 #Query 5 — Loss Making Orders
-- Business Question: Which orders lost money and why?
SELECT
    Order_ID,
    Product_Name,
    Category,
    Region,
    ROUND(Sales, 2)            AS Sales,
    ROUND(Discount, 2)         AS Discount,
    ROUND(Profit, 2)           AS Profit,
    ROUND(Profit/Sales*100, 2) AS Margin_Pct
FROM sales
WHERE Profit < 0
ORDER BY Profit ASC
LIMIT 15;

		    #Query 6 — Discount Impact on Profit
-- Business Question: Are discounts destroying our margins?
SELECT
    CASE
        WHEN Discount = 0     THEN 'No Discount'
        WHEN Discount <= 0.10 THEN 'Low (1-10%)'
        WHEN Discount <= 0.20 THEN 'Medium (11-20%)'
        ELSE                       'High (20%+)'
    END                                  AS Discount_Band,
    COUNT(*)                             AS Total_Orders,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM sales
GROUP BY Discount_Band
ORDER BY Profit_Margin_Pct DESC;


            #Query 7 — Top 10 Customers by Revenue
-- Business Question: Who are our most valuable customers?
SELECT
    Customer_Name,
    Segment,
    Region,
    COUNT(DISTINCT Order_ID)             AS Total_Orders,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM sales
GROUP BY Customer_Name, Segment, Region
ORDER BY Total_Revenue DESC
LIMIT 10;
              #Query 8 — Year on Year Sales Growth
-- Business Question: Is the business growing every year?
SELECT
    YEAR(Order_Date)                     AS Year,
    COUNT(DISTINCT Order_ID)             AS Total_Orders,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM sales
GROUP BY YEAR(Order_Date)
ORDER BY Year ASC;
                  #Query 9 — Sub-Categories Losing Money
-- Business Question: Which sub-categories should we reconsider?
SELECT
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct,
    COUNT(*)                             AS Total_Orders
FROM sales
GROUP BY Category, Sub_Category
HAVING Total_Profit < 0
ORDER BY Total_Profit ASC;

                #Query 10 — Average Order Value by Segment
                
-- Business Question: Which customer segment spends the most per order?
SELECT
    Segment,
    COUNT(DISTINCT Order_ID)             AS Total_Orders,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(AVG(Sales), 2)                 AS Avg_Order_Value,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM sales
GROUP BY Segment
ORDER BY Avg_Order_Value DESC;
-- ================================================
-- Query 11: Which customer segment spends the most
--           and generates the best margin?
-- ================================================
SELECT
    Segment,
    COUNT(DISTINCT Order_ID)             AS Total_Orders,
    ROUND(SUM(Sales), 2)                 AS Total_Revenue,
    ROUND(SUM(Profit), 2)                AS Total_Profit,
    ROUND(AVG(Sales), 2)                 AS Avg_Order_Value,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM sales
GROUP BY Segment
ORDER BY Total_Revenue DESC;