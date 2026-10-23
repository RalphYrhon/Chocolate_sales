-- Create sales person table
CREATE TABLE dbo.dim_sales_person (
	sales_person_id INT IDENTITY(1,1) PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL
	);

-- Create product table
CREATE TABLE dbo.dim_product (
	product_id INT IDENTITY(1,1) PRIMARY KEY,
	[product] VARCHAR(50) NOT NULL
	);

-- Create country table
CREATE TABLE dbo.dim_country (
	country_id INT IDENTITY(1,1) PRIMARY KEY,
	country VARCHAR(50) NOT NULL,
	country_code VARCHAR(5) NOT NULL
	);

-- Create orders table
CREATE TABLE dbo.fact_orders (
	order_id INT IDENTITY(1,1) PRIMARY KEY,
	Sales_person_id INT,
	Product_id INT,
	Country_id INT,
	[date] DATE,
	amount DECIMAL(12,2),
	boxes_shipped INT

	FOREIGN KEY (Sales_person_id)
		REFERENCES dbo.dim_sales_person(sales_person_id),

	FOREIGN KEY (Product_id)
		REFERENCES dbo.dim_product(product_id),

	FOREIGN KEY (Country_id)
		REFERENCES dbo.dim_country(country_id)
	);

-- Insert data to sales_person table
INSERT INTO dbo.dim_sales_person (first_name, last_name)
SELECT
	DISTINCT LEFT(Sales_Person,CHARINDEX(' ',Sales_Person + ' ') - 1),
	LTRIM(SUBSTRING(Sales_Person,CHARINDEX(' ',Sales_Person + ' ') + 1 ,LEN(Sales_Person)))
FROM dbo.Chocolate_sales
WHERE Sales_Person IS NOT NULL

-- Inser data to product table
INSERT INTO dbo.dim_product ([product])
SELECT
	DISTINCT [Product] 
FROM dbo.Chocolate_Sales

-- Insert data to country table
INSERT INTO dbo.dim_country (country, country_code)
SELECT
	DISTINCT(Country),
	CASE
		WHEN Country = 'USA' THEN 'USA'
		WHEN Country = 'New Zealand' THEN 'NZ'
		WHEN Country = 'Australia' THEN 'AUS'
		WHEN Country = 'India' THEN 'IND'
		WHEN Country = 'UK' THEN 'UK'
		ELSE 'CAN'
	END
FROM dbo.Chocolate_Sales

-- Insert data to orders table
INSERT INTO dbo.fact_orders (Sales_person_id, Product_id, Country_id, [date], amount, boxes_shipped)
SELECT 
	sp.sales_person_id,
	p.product_id,
	c.country_id,
	cs.[date],
	cs.amount,
	cs.boxes_shipped
FROM dbo.Chocolate_Sales AS cs
JOIN dbo.dim_sales_person AS sp
    ON LEFT(cs.Sales_Person, CHARINDEX(' ', cs.Sales_Person + ' ') - 1) = sp.first_name
    AND LTRIM(SUBSTRING(
        cs.Sales_Person,
        CHARINDEX(' ', cs.Sales_Person + ' ') + 1,
        LEN(cs.sales_person)
    )) = sp.last_name
JOIN dbo.[dim_product] p
	ON cs.[Product] = p.[product]	
JOIN dbo.dim_country c
	ON cs.Country = c.country




