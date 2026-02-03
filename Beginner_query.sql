-- List of all sales records
SELECT * FROM dbo.chocolate_sales;

-- Show all distinct countries
SELECT DISTINCT(Country) AS Country 
FROM dbo.chocolate_sales;

-- All sales made by a specific Sales Person -> Van Tuxwell
SELECT * FROM dbo.chocolate_sales
WHERE Sales_Person = 'Van Tuxwell'
ORDER BY [Date] DESC;

-- All sales where amount > 10,000
SELECT 
	Sales_Person, 
	[PRODUCT],
	Boxes_Shipped,
	CAST(Amount AS DECIMAL(10,2)) AS Amount
FROM dbo.chocolate_sales
WHERE Amount > 10000
ORDER BY Amount DESC;

-- Sales for a specific Product --> Eclairs
SELECT 
	[Product], 
	[Date], 
	Boxes_Shipped, 
	Amount
FROM dbo.chocolate_sales
WHERE [Product] = 'Eclairs'
ORDER BY [Date] DESC;

-- Total number of sales transactions.
SELECT COUNT(*) AS Number_of_transactions 
FROM dbo.chocolate_sales ;

-- Total boxes shipped
SELECT SUM(Boxes_shipped) AS Total_boxes_shipped 
FROM dbo.chocolate_sales;

-- Sales made in a specific country --> USA
SELECT * FROM dbo.chocolate_sales
WHERE COUNTRY = 'USA';

-- Sales between two dates --> 2023-05-04 -> 2024-08-25
SELECT * FROM dbo.chocolate_sales
WHERE [DATE] BETWEEN '2023-05-04' AND '2024-08-25'
ORDER BY [Date] DESC;