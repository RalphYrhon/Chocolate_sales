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
ORDER BY Date DESC;
