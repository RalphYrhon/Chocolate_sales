-- Sales Trend over time (month-over-month growth)
WITH MonthlySales AS (
    SELECT 
        YEAR([Date]) AS SalesYear,
        MONTH([Date]) AS SalesMonth,
        FORMAT([Date], 'MMM') AS SalesMonthName,
        SUM(Amount) AS TotalSales
    FROM dbo.chocolate_sales
    GROUP BY 
        YEAR([Date]),
        MONTH([Date]),
        FORMAT([Date], 'MMM') 
) 
SELECT
    SalesYear,
    SalesMonthName,
    CAST(TotalSales AS DECIMAL(10,2)) AS Total_Sales,
    CAST(LAG(TotalSales) OVER (ORDER BY SalesYear, SalesMonth) AS DECIMAL(10,2)) AS PreviousMonthSales,
    ROUND(
        (TotalSales - LAG(TotalSales) OVER (ORDER BY SalesYear, SalesMonth))
        * 100.0 /
        LAG(TotalSales) OVER (ORDER BY SalesYear, SalesMonth),
    2) AS MoM_Growth_Percent

FROM MonthlySales
ORDER BY SalesYear, SalesMonth;

-- Find underperforming products (lowest total amount)
WITH Ranking AS (
    SELECT
        [Product],
        CAST(SUM(Amount) AS DECIMAL(10,2)) AS Total_Sales_Amount
    FROM dbo.chocolate_sales
    GROUP BY [Product] )

SELECT
    [Product],
    Total_Sales_Amount,
    RANK() OVER (ORDER BY Total_Sales_Amount) AS [Rank]
FROM Ranking
ORDER BY Total_Sales_Amount;

-- Detect outlier transactions (Very high amount values)
SELECT
    *,
    CASE 
        WHEN Amount > AVG(Amount) OVER () 
             + (2 * STDEV(Amount) OVER ())
        THEN 'Outlier'
        ELSE 'Normal'
    END AS TransactionFlag,
    AVG(Amount) OVER() + (2 * STDEV(Amount) OVER ()) AS AV
FROM dbo.chocolate_sales
ORDER BY TransactionFlag DESC

SELECT 
    Amount, 
    [Product],
    AVG(Amount) OVER(PARTITION BY [Product] ORDER BY Amount) AS AV
FROM dbo.chocolate_sales
ORDER BY AV DESC

-- YoY growth per country
WITH YearlySales AS (
    SELECT 
        Country,
        YEAR([Date]) AS YearDate,
        CAST(SUM(Amount) AS DECIMAL(10,2)) AS TotalSales
    FROM dbo.chocolate_sales
    GROUP BY 
        Country,
        YEAR([Date]) )
SELECT 
    Country,
    YearDate,
    TotalSales,
    LAG(Totalsales) OVER(PARTITION BY Country ORDER BY YearDate) AS PrevYearSales,
    CAST(ROUND(
        (TotalSales - LAG(Totalsales) OVER(PARTITION BY Country ORDER BY YearDate))*100/
        LAG(Totalsales) OVER(PARTITION BY Country ORDER BY YearDate), 2 )
        AS DECIMAL(10,2) ) AS YoY_Growth_Percent
FROM YearlySales
ORDER BY Country, YearDate;    

