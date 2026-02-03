-- Database and table creation
CREATE DATABASE ch_sales;

-- Find null values
SELECT * FROM dbo.chocolate_sales
WHERE 
	Sales_Person IS NULL 
	OR
	Country IS NULL	
	OR
	[Product] IS NULL
	OR 
	[Date] IS NULL
	OR 
	Amount IS NULL
	OR 
	Boxes_Shipped IS NULL;

-- Number of sales personnel
SELECT COUNT(DISTINCT Sales_Person) AS Sales_Persons 
FROM dbo.chocolate_sales

-- Sales personnel
SELECT 
	DISTINCT 
	RIGHT(Sales_Person, CHARINDEX(' ', REVERSE(Sales_Person)) - 1) AS Last_name,
	LEFT(Sales_Person, CHARINDEX(' ',Sales_Person) -1) AS First_name
FROM dbo.chocolate_sales
ORDER BY Last_name

-- Number of products
SELECT COUNT(DISTINCT [Product]) AS Number_of_Product
FROM dbo.chocolate_sales

-- List of products
SELECT DISTINCT [Product] AS Sales_Persons 
FROM dbo.chocolate_sales
ORDER BY Sales_Persons

-- Total shipped per countries
SELECT Country, SUM(Boxes_Shipped) AS Total_shipped
FROM dbo.chocolate_sales
GROUP BY Country;

SELECT * FROM dbo.chocolate_sales
ORDER BY [Date] DESC