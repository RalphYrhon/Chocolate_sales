-- Top 3 sales person by total amount.
SELECT TOP 3
	Sales_Person,
	CAST(SUM(Amount) AS DECIMAL(10,2)) AS Amount
FROM dbo.chocolate_sales
GROUP BY Sales_Person
ORDER BY Amount DESC;

-- Ranking of countries based on total amount.
SELECT 
	Country,
	CAST(SUM(Amount) AS DECIMAL(10,2)) AS Total_amount,
    DENSE_RANK() OVER (ORDER BY CAST(SUM(Amount) AS DECIMAL(10,2)) DESC) AS [Rank]
FROM dbo.chocolate_sales
GROUP BY Country
ORDER BY Total_amount DESC;

-- Best selling product per country.
WITH 
    total_sales AS (
        SELECT 
            Country, 
            Product, 
            SUM(Amount) AS Total_sales
        FROM dbo.chocolate_sales
        GROUP BY Country, Product ), 

    max_sales AS (
        SELECT 
            Country, 
            MAX(Total_sales) AS Max_sales
        FROM total_sales
        GROUP BY Country )

SELECT 
    t.Country, 
    t.Product, 
    t.Total_sales
FROM total_sales t
JOIN max_sales m
    ON t.Country = m.Country AND t.Total_sales = m.Max_sales;

-- Highest single sale per product.
SELECT 
    [Product],
    MAX(CAST(Amount AS DECIMAL(10,2))) AS Highest_sale
FROM dbo.chocolate_sales
GROUP BY [Product]
ORDER BY Highest_sale DESC;

-- Sales persons who sold more than 1 country.
SELECT
    Sales_Person,
    COUNT(DISTINCT(Country)) AS Countries_sold
FROM dbo.chocolate_sales
GROUP BY Sales_Person
HAVING COUNT(DISTINCT(Country)) > 1;

-- Running total of amoung by date.
SELECT
    Date,
    CAST(Amount AS DECIMAL(10,2)) AS Amount,
    SUM(CAST(Amount AS DECIMAL(10,2))) OVER (ORDER BY Date ASC) AS RunningTotal
FROM dbo.chocolate_sales
ORDER BY Date ASC;

-- Sales where amount is above the average sale amount.
SELECT
    Sales_Person,
    [Product],
    CAST(Amount AS DECIMAL(10,2)) AS Amount
FROM dbo.chocolate_sales
WHERE Amount > (
    SELECT
        AVG(Amount)
    FROM dbo.chocolate_sales )
ORDER BY Amount DESC;

-- Which month has the highest sales.
WITH monthly_sales AS (
    SELECT 
        FORMAT(DATEFROMPARTS(YEAR([Date]), MONTH([Date]), 1), 'MM-yyyy') AS [Month],
        CAST(SUM(Amount) AS DECIMAL(10,2)) AS Amount
    FROM dbo.chocolate_sales
    GROUP BY 
        YEAR(Date),
        MONTH(Date)
    --ORDER BY 
    --    YEAR(Date),
    --    MONTH(Date) 
    )
SELECT TOP 1
    [Month],
    Amount
FROM monthly_sales
ORDER BY Amount;
  
-- Calculate percentage contribution of each Product to total sales.


-- Find duplicate sales records (same Sales Person, Product, Date).
  SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Sales_Person, Product, [Date]
               ORDER BY Amount DESC
           ) AS rn
    FROM dbo.chocolate_sales
) d
WHERE rn > 1
ORDER BY 
    Sales_Person,
    Product,
    [Date];

SELECT 
    Sales_Person,
    Product,
    [Date],
    COUNT(*) AS Duplicate_Count
FROM dbo.chocolate_sales
GROUP BY 
    Sales_Person,
    Product,
    [Date]
HAVING COUNT(*) > 1;
