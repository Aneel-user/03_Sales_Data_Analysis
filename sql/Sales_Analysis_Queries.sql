
USE Sales_Analysis;
GO

/*========================================================
  SALES DATA ANALYSIS PROJECT
  Database: Sales_Analysis
  Table: dbo.Sales
========================================================*/


/*========================================================
  1. VIEW ALL SALES DATA
========================================================*/
SELECT *
FROM dbo.Sales;


/*========================================================
  2. CHECK TOTAL ROWS
========================================================*/
SELECT COUNT(*) AS Total_Rows
FROM dbo.Sales;


/*========================================================
  3. CHECK FOR MISSING VALUES
========================================================*/
SELECT
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Order_Date,
    SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) AS Missing_Customer,
    SUM(CASE WHEN Product IS NULL THEN 1 ELSE 0 END) AS Missing_Product,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Missing_Category,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS Missing_Unit_Price,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Missing_Region,
    SUM(CASE WHEN Salesperson IS NULL THEN 1 ELSE 0 END) AS Missing_Salesperson,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS Missing_Payment_Method,
    SUM(CASE WHEN Sales_Amount IS NULL THEN 1 ELSE 0 END) AS Missing_Sales_Amount
FROM dbo.Sales;


/*========================================================
  4. CHECK DUPLICATE ORDER IDs
========================================================*/
SELECT
    Order_ID,
    COUNT(*) AS Occurrences
FROM dbo.Sales
GROUP BY Order_ID
HAVING COUNT(*) > 1;


/*========================================================
  5. VERIFY SALES AMOUNT CALCULATION
========================================================*/
SELECT
    Order_ID,
    Product,
    Quantity,
    Unit_Price,
    Sales_Amount,
    Quantity * Unit_Price AS Calculated_Sales,
    Sales_Amount - (Quantity * Unit_Price) AS Difference
FROM dbo.Sales
WHERE ABS(Sales_Amount - (Quantity * Unit_Price)) > 0.01;


/*========================================================
  6. FINAL KPI SUMMARY
========================================================*/
SELECT
    SUM(Sales_Amount) AS Total_Sales,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity,
    CAST(
        SUM(Sales_Amount) * 1.0 /
        NULLIF(COUNT(DISTINCT Order_ID), 0)
        AS DECIMAL(12,2)
    ) AS Average_Order_Value,
    COUNT(DISTINCT Customer_Name) AS Total_Customers,
    COUNT(DISTINCT Product) AS Total_Products,
    COUNT(DISTINCT Region) AS Total_Regions,
    COUNT(DISTINCT Salesperson) AS Total_Salespersons
FROM dbo.Sales;


/*========================================================
  7. SALES BY PRODUCT
========================================================*/
SELECT
    Product,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Product
ORDER BY Total_Sales DESC;


/*========================================================
  8. SALES BY REGION
========================================================*/
SELECT
    Region,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Region
ORDER BY Total_Sales DESC;


/*========================================================
  9. SALES BY CATEGORY
========================================================*/
SELECT
    Category,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Category
ORDER BY Total_Sales DESC;


/*========================================================
  10. SALES BY CUSTOMER
========================================================*/
SELECT
    Customer_Name,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


/*========================================================
  11. SALES BY SALESPERSON
========================================================*/
SELECT
    Salesperson,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Salesperson
ORDER BY Total_Sales DESC;


/*========================================================
  12. SALES BY PAYMENT METHOD
========================================================*/
SELECT
    Payment_Method,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Payment_Method
ORDER BY Total_Sales DESC;


/*========================================================
  13. MONTHLY SALES TREND
========================================================*/
SELECT
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Sales_Year, Sales_Month;


/*========================================================
  14. TOP 10 SALES DAYS
========================================================*/
SELECT TOP 10
    Order_Date,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Order_Date
ORDER BY Total_Sales DESC;


/*========================================================
  15. QUANTITY SOLD BY PRODUCT
========================================================*/
SELECT
    Product,
    SUM(Quantity) AS Total_Quantity
FROM dbo.Sales
GROUP BY Product
ORDER BY Total_Quantity DESC;


/*========================================================
  16. AVERAGE ORDER VALUE BY REGION
========================================================*/
SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales_Amount) AS Total_Sales,
    CAST(
        SUM(Sales_Amount) * 1.0 /
        NULLIF(COUNT(DISTINCT Order_ID), 0)
        AS DECIMAL(12,2)
    ) AS Average_Order_Value
FROM dbo.Sales
GROUP BY Region
ORDER BY Average_Order_Value DESC;


/*========================================================
  17. SALESPERSON PERFORMANCE BY REGION
========================================================*/
SELECT
    Region,
    Salesperson,
    SUM(Sales_Amount) AS Total_Sales,
    SUM(Quantity) AS Total_Quantity,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM dbo.Sales
GROUP BY Region, Salesperson
ORDER BY Region, Total_Sales DESC;


/*========================================================
  18. TOP SALESPERSON IN EACH REGION
========================================================*/
WITH RegionalSales AS
(
    SELECT
        Region,
        Salesperson,
        SUM(Sales_Amount) AS Total_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales_Amount) DESC
        ) AS Ranking
    FROM dbo.Sales
    GROUP BY Region, Salesperson
)
SELECT
    Region,
    Salesperson,
    Total_Sales
FROM RegionalSales
WHERE Ranking = 1
ORDER BY Region;


/*========================================================
  19. TOP PAYMENT METHOD IN EACH REGION
========================================================*/
WITH RegionalPayments AS
(
    SELECT
        Region,
        Payment_Method,
        SUM(Sales_Amount) AS Total_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales_Amount) DESC
        ) AS Ranking
    FROM dbo.Sales
    GROUP BY Region, Payment_Method
)
SELECT
    Region,
    Payment_Method,
    Total_Sales
FROM RegionalPayments
WHERE Ranking = 1
ORDER BY Region;


/*========================================================
  20. SALESPERSON QUANTITY PERFORMANCE
========================================================*/
SELECT
    Salesperson,
    SUM(Quantity) AS Total_Quantity,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Salesperson
ORDER BY Total_Quantity DESC;


/*========================================================
  21. MONTHLY SALES WITH PREVIOUS MONTH
========================================================*/
WITH MonthlySales AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(Order_Date),
            MONTH(Order_Date),
            1
        ) AS Sales_Month,
        SUM(Sales_Amount) AS Total_Sales
    FROM dbo.Sales
    GROUP BY
        YEAR(Order_Date),
        MONTH(Order_Date)
)
SELECT
    Sales_Month,
    Total_Sales,
    LAG(Total_Sales) OVER
        (ORDER BY Sales_Month) AS Previous_Month_Sales
FROM MonthlySales
ORDER BY Sales_Month;


/*========================================================
  22. MONTHLY SALES GROWTH PERCENTAGE
========================================================*/
WITH MonthlySales AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(Order_Date),
            MONTH(Order_Date),
            1
        ) AS Sales_Month,
        SUM(Sales_Amount) AS Total_Sales
    FROM dbo.Sales
    GROUP BY
        YEAR(Order_Date),
        MONTH(Order_Date)
),
SalesWithPreviousMonth AS
(
    SELECT
        Sales_Month,
        Total_Sales,
        LAG(Total_Sales) OVER
            (ORDER BY Sales_Month) AS Previous_Month_Sales
    FROM MonthlySales
)
SELECT
    Sales_Month,
    Total_Sales,
    Previous_Month_Sales,
    CAST(
        (Total_Sales - Previous_Month_Sales) * 100.0 /
        NULLIF(Previous_Month_Sales, 0)
        AS DECIMAL(10,2)
    ) AS Growth_Percentage
FROM SalesWithPreviousMonth
ORDER BY Sales_Month;


/*========================================================
  23. BEST-SELLING PRODUCT IN EACH REGION
========================================================*/
WITH RegionalProducts AS
(
    SELECT
        Region,
        Product,
        SUM(Sales_Amount) AS Total_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales_Amount) DESC
        ) AS Ranking
    FROM dbo.Sales
    GROUP BY Region, Product
)
SELECT
    Region,
    Product,
    Total_Sales
FROM RegionalProducts
WHERE Ranking = 1
ORDER BY Region;


/*========================================================
  24. SALES BY REGION AND CATEGORY
========================================================*/
SELECT
    Region,
    Category,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Region, Category
ORDER BY Region, Total_Sales DESC;


/*========================================================
  25. TOP CUSTOMER IN EACH REGION
========================================================*/
WITH RegionalCustomers AS
(
    SELECT
        Region,
        Customer_Name,
        SUM(Sales_Amount) AS Total_Sales,
        ROW_NUMBER() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales_Amount) DESC
        ) AS Ranking
    FROM dbo.Sales
    GROUP BY Region, Customer_Name
)
SELECT
    Region,
    Customer_Name,
    Total_Sales
FROM RegionalCustomers
WHERE Ranking = 1
ORDER BY Region;


/*========================================================
  26. SALES BY PAYMENT METHOD AND REGION
========================================================*/
SELECT
    Region,
    Payment_Method,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Region, Payment_Method
ORDER BY Region, Total_Sales DESC;


/*========================================================
  27. ORDER COUNT BY REGION
========================================================*/
SELECT
    Region,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Region
ORDER BY Total_Orders DESC;


/*========================================================
  28. TOP 5 CUSTOMERS OVERALL
========================================================*/
SELECT TOP 5
    Customer_Name,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


/*========================================================
  29. TOP 5 PRODUCTS BY QUANTITY
========================================================*/
SELECT TOP 5
    Product,
    SUM(Quantity) AS Total_Quantity
FROM dbo.Sales
GROUP BY Product
ORDER BY Total_Quantity DESC;


/*========================================================
  30. CUSTOMER ORDER FREQUENCY
========================================================*/
SELECT
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Customer_Name
ORDER BY Total_Orders DESC;


/*========================================================
  31. CUSTOMER AVERAGE ORDER VALUE
========================================================*/
SELECT
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales_Amount) AS Total_Sales,
    CAST(
        SUM(Sales_Amount) * 1.0 /
        NULLIF(COUNT(DISTINCT Order_ID), 0)
        AS DECIMAL(12,2)
    ) AS Average_Order_Value
FROM dbo.Sales
GROUP BY Customer_Name
ORDER BY Average_Order_Value DESC;


/*========================================================
  32. FREQUENT CUSTOMERS (10 OR MORE ORDERS)
========================================================*/
SELECT
    Customer_Name,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Customer_Name
HAVING COUNT(DISTINCT Order_ID) >= 10
ORDER BY Total_Orders DESC;


/*========================================================
  33. SALES CONTRIBUTION BY REGION
========================================================*/
SELECT
    Region,
    SUM(Sales_Amount) AS Total_Sales,
    CAST(
        SUM(Sales_Amount) * 100.0 /
        NULLIF((SELECT SUM(Sales_Amount) FROM dbo.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Sales_Percentage
FROM dbo.Sales
GROUP BY Region
ORDER BY Total_Sales DESC;


/*========================================================
  34. SALES CONTRIBUTION BY PRODUCT
========================================================*/
SELECT
    Product,
    SUM(Sales_Amount) AS Total_Sales,
    CAST(
        SUM(Sales_Amount) * 100.0 /
        NULLIF((SELECT SUM(Sales_Amount) FROM dbo.Sales), 0)
        AS DECIMAL(10,2)
    ) AS Sales_Percentage
FROM dbo.Sales
GROUP BY Product
ORDER BY Total_Sales DESC;


/*========================================================
  35. SALESPERSON AVERAGE ORDER VALUE
========================================================*/
SELECT
    Salesperson,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Sales_Amount) AS Total_Sales,
    CAST(
        SUM(Sales_Amount) * 1.0 /
        NULLIF(COUNT(DISTINCT Order_ID), 0)
        AS DECIMAL(12,2)
    ) AS Average_Order_Value
FROM dbo.Sales
GROUP BY Salesperson
ORDER BY Total_Sales DESC;


/*========================================================
  36. BEST OVERALL SALESPERSON
========================================================*/
SELECT TOP 1
    Salesperson,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Salesperson
ORDER BY Total_Sales DESC;


/*========================================================
  37. BEST-SELLING PRODUCT OVERALL
========================================================*/
SELECT TOP 1
    Product,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Product
ORDER BY Total_Sales DESC;


/*========================================================
  38. BEST SALES REGION
========================================================*/
SELECT TOP 1
    Region,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Region
ORDER BY Total_Sales DESC;


/*========================================================
  39. BEST CUSTOMER OVERALL
========================================================*/
SELECT TOP 1
    Customer_Name,
    SUM(Sales_Amount) AS Total_Sales
FROM dbo.Sales
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


/*========================================================
  END OF SALES ANALYSIS QUERIES
========================================================*/