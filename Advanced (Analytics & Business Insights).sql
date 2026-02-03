-- Top 3 sales person by total amount
SELECT TOP 3
	Sales_Person,
	CAST(SUM(Amount) AS DECIMAL(10,2)) AS Amount
FROM dbo.chocolate_sales
GROUP BY Sales_Person
ORDER BY Amount DESC;

-- Ranking of countries based on total amount
SELECT 
	Country,
	CAST(SUM(Amount) AS DECIMAL(10,2)) AS Total_amount
FROM dbo.chocolate_sales
GROUP BY Country
ORDER BY Total_amount;

-- Best selling product per country
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

