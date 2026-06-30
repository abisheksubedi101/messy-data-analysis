-- ========================================
-- SALES DATA ANALYSIS QUERIES
-- ========================================

-- 1. TOTAL REVENUE AND TRANSACTION COUNT
SELECT 
    COUNT(*) as Total_Transactions,
    SUM(Total) as Total_Revenue,
    AVG(Total) as Average_Transaction_Value,
    MIN(Total) as Min_Transaction,
    MAX(Total) as Max_Transaction
FROM sales_data_cleaned;

-- 2. REVENUE BY CATEGORY
SELECT 
    Category,
    COUNT(*) as Transaction_Count,
    SUM(Total) as Category_Revenue,
    AVG(Total) as Avg_Transaction_Value,
    ROUND(SUM(Total) * 100.0 / (SELECT SUM(Total) FROM sales_data_cleaned), 2) as Revenue_Percentage
FROM sales_data_cleaned
WHERE Category IS NOT NULL
GROUP BY Category
ORDER BY Category_Revenue DESC;

-- 3. TOP 10 CUSTOMERS BY SPENDING
SELECT 
    TOP 10
    Customer_Name,
    COUNT(*) as Purchase_Count,
    SUM(Total) as Total_Spent,
    AVG(Total) as Avg_Purchase_Value
FROM sales_data_cleaned
WHERE Customer_Name IS NOT NULL AND Customer_Name != 'Unknown Customer'
GROUP BY Customer_Name
ORDER BY Total_Spent DESC;

-- 4. REVENUE BY PAYMENT METHOD
SELECT 
    Payment_Method,
    COUNT(*) as Transaction_Count,
    SUM(Total) as Revenue,
    ROUND(AVG(Total), 2) as Avg_Transaction_Value,
    ROUND(SUM(Total) * 100.0 / (SELECT SUM(Total) FROM sales_data_cleaned), 2) as Revenue_Percentage
FROM sales_data_cleaned
WHERE Payment_Method IS NOT NULL
GROUP BY Payment_Method
ORDER BY Revenue DESC;

-- 5. DAILY SALES TREND
SELECT 
    Date,
    COUNT(*) as Daily_Transactions,
    SUM(Total) as Daily_Revenue,
    ROUND(AVG(Total), 2) as Avg_Daily_Transaction
FROM sales_data_cleaned
WHERE Date IS NOT NULL
GROUP BY Date
ORDER BY Date;

-- 6. TOP 15 PRODUCTS BY SALES
SELECT 
    TOP 15
    Product,
    COUNT(*) as Units_Sold,
    SUM(Quantity) as Total_Quantity,
    SUM(Total) as Total_Revenue,
    ROUND(AVG(Unit_Price), 2) as Avg_Price,
    ROUND(AVG(Total), 2) as Avg_Transaction_Value
FROM sales_data_cleaned
WHERE Product IS NOT NULL AND Product != 'Unknown Product'
GROUP BY Product
ORDER BY Total_Revenue DESC;

-- 7. PRODUCT PERFORMANCE BY CATEGORY
SELECT 
    Category,
    Product,
    COUNT(*) as Sales_Count,
    SUM(Quantity) as Total_Units,
    SUM(Total) as Revenue,
    ROUND(AVG(Unit_Price), 2) as Avg_Price
FROM sales_data_cleaned
WHERE Category IS NOT NULL AND Product IS NOT NULL
GROUP BY Category, Product
ORDER BY Category, Revenue DESC;

-- 8. DATA QUALITY REPORT
SELECT 
    SUM(CASE WHEN Customer_Name IS NULL OR Customer_Name = 'Unknown Customer' THEN 1 ELSE 0 END) as Missing_Customer_Names,
    SUM(CASE WHEN Product IS NULL OR Product = 'Unknown Product' THEN 1 ELSE 0 END) as Missing_Products,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) as Missing_Categories,
    SUM(CASE WHEN Unit_Price IS NULL OR Unit_Price = 0 THEN 1 ELSE 0 END) as Missing_Unit_Prices,
    SUM(CASE WHEN Total IS NULL OR Total = 0 THEN 1 ELSE 0 END) as Missing_Totals,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) as Missing_Payment_Methods,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) as Missing_Dates
FROM sales_data_cleaned;

-- 9. REVENUE COMPARISON BY CATEGORY AND PAYMENT METHOD
SELECT 
    Category,
    Payment_Method,
    COUNT(*) as Transaction_Count,
    SUM(Total) as Revenue
FROM sales_data_cleaned
WHERE Category IS NOT NULL AND Payment_Method IS NOT NULL
GROUP BY Category, Payment_Method
ORDER BY Revenue DESC;

-- 10. AVERAGE ORDER VALUE TREND
SELECT 
    Date,
    COUNT(*) as Orders,
    ROUND(AVG(Total), 2) as Avg_Order_Value,
    SUM(Total) as Daily_Revenue
FROM sales_data_cleaned
WHERE Date IS NOT NULL
GROUP BY Date
ORDER BY Date;
