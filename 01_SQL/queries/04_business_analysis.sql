
--1. Who are our top-spending high-value customers?
WITH CustomerSpend AS (
    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(s.Quantity * s.UnitPrice * (1 - s.DiscountPercent/100.0)) AS TotalSpend
    FROM Brightmart_OverallSales s
    INNER JOIN Brightmart_Customers c ON s.CustomerID = c.CustomerID
    GROUP BY c.CustomerID, c.CustomerName
),
RankedCustomers AS (
    SELECT 
        CustomerID, CustomerName, TotalSpend,
        RANK() OVER (ORDER BY TotalSpend DESC) AS SpendRank		--other option can be using top
    FROM CustomerSpend
)
SELECT CustomerID, CustomerName, TotalSpend, SpendRank
FROM RankedCustomers
WHERE SpendRank <= 5;



--2. Which product categories drive the highest profit margins?
WITH CategoryProfit AS (
    SELECT
        p.Category,
        SUM(s.UnitPrice - p.CostPrice) AS TotalProfit,
        SUM(s.UnitPrice) AS TotalRevenue
    FROM Brightmart_OverallSales s
    INNER JOIN Brightmart_Products p ON s.ProductID = p.ProductID
    GROUP BY p.Category
)
SELECT
    Category,
    TotalProfit,
    TotalRevenue,
    TotalProfit * 100.0 / TotalRevenue AS ProfitMarginPct
FROM CategoryProfit
ORDER BY TotalProfit DESC;




--3. What do monthly sales trends look like over time?
SELECT
    YEAR(OrderDate) AS SalesYear,
    MONTH(OrderDate) AS SalesMonth,
    SUM(Quantity * UnitPrice * (1 - DiscountPercent/100.0)) AS MonthlyRevenue
FROM Sales
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY SalesYear, SalesMonth;




--4. Which geographic cities are outperforming expectations?
WITH CityAOV AS (
    SELECT 
        c.City,
        AVG(s.Quantity * s.UnitPrice * (1 - s.DiscountPercent/100.0)) AS AvgOrderValue
    FROM Sales s
    INNER JOIN Customers c ON s.CustomerID = c.CustomerID
    GROUP BY c.City
),
OverallAOV AS (
    SELECT AVG(Quantity * UnitPrice * (1 - DiscountPercent/100.0)) AS OverallAvg
    FROM Sales
)
SELECT 
    ca.City, ca.AvgOrderValue, oa.OverallAvg
FROM CityAOV ca
CROSS JOIN OverallAOV oa
WHERE ca.AvgOrderValue > oa.OverallAvg
ORDER BY ca.AvgOrderValue DESC





--5. What is the average order value across customer segments?
SELECT
    c.CustomerSegment,
    AVG(s.Quantity * s.UnitPrice * (1 - s.DiscountPercent/100.0)) AS AvgOrderValue
FROM Sales s
INNER JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerSegment
ORDER BY AvgOrderValue DESC;
















