-- Total sales amount per country.
SELECT
	Country,
	CAST(SUM(Amount) AS DECIMAL(10,2)) AS Total_sales
FROM dbo.chocolate_sales
GROUP BY Country
ORDER BY Total_sales DESC;

-- Total sales per sales person
SELECT 
	Sales_person, 
	COUNT(*) AS Total_sales
FROM dbo.chocolate_sales
GROUP BY Sales_person;

-- Average sale amount per product
SELECT 
	[Product],
	CAST(AVG(AMOUNT) AS DECIMAL(10,2)) AS Average_sale_amoount
FROM dbo.chocolate_sales
GROUP BY [Product];

-- Max sale amount
SELECT 
	Sales_Person, 
	[Product], 
	CAST(Amount AS DECIMAL(10,2)) AS Max_sale_amount
FROM dbo.chocolate_sales
WHERE Amount = (
	SELECT MAX(Amount) FROM dbo.chocolate_sales );

-- Min sale amount
SELECT 
	Sales_Person,
	[Product],
	CAST(Amount AS DECIMAL(10,2)) AS Min_sale_amount
FROM dbo.chocolate_sales
WHERE Amount = (
	SELECT MIN(Amount)
	FROM dbo.chocolate_sales );

-- Number of transactions per product
SELECT 
	[Product],
	COUNT([Product]) AS No_transactions
FROM dbo.chocolate_sales
GROUP BY [Product]
ORDER BY No_transactions DESC;

-- Total boxes shipped per country
SELECT 
	Country,
	SUM(Boxes_Shipped) AS Total_shipped
FROM dbo.chocolate_sales
GROUP BY Country
ORDER BY Total_shipped DESC;

--Total sales per month
SELECT 
    FORMAT(DATEFROMPARTS(YEAR([Date]), MONTH([Date]), 1), 'MMM-yyyy') AS [Month & Yr],
    CAST(SUM(Amount) AS DECIMAL(10,2)) AS Amount
FROM dbo.chocolate_sales
GROUP BY DATEFROMPARTS(YEAR([Date]), MONTH([Date]), 1)
ORDER BY DATEFROMPARTS(YEAR([Date]), MONTH([Date]), 1) DESC;

--Which sales person shipped the most boxes
SELECT 
	Sales_Person,
	SUM(Boxes_Shipped) AS Total_boxes_shipped
FROM dbo.chocolate_sales
GROUP BY Sales_Person
ORDER BY Total_boxes_shipped;

-- Products with total sales greater than 50,000
SELECT 
	[Product],
	CAST(SUM(Amount) AS DECIMAL(10,2)) AS Total_sales
FROM dbo.chocolate_sales
GROUP BY [Product]
HAVING CAST(SUM(Amount) AS DECIMAL(10,2)) > 50000
ORDER BY Total_sales DESC;


