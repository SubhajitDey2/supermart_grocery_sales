
--CREATE TABLE Supermart_Grocery_Sales

CREATE TABLE Supermart_Grocery_Sales(
Order_ID VARCHAR(50) NOT NULL,
Customer_Name VARCHAR(50) NOT NULL,
Category VARCHAR(50) NOT NULL,
Sub_Category VARCHAR(50)NOT NULL,
City VARCHAR(50) NOT NULL,
Order_Date DATE NOT NULL,
Region VARCHAR(50) NOT NULL,
Sales INT NOT NULL,
Discount DECIMAL(5,2)NOT NULL, -- can store 0.12 properly
Profit DECIMAL(10,2)NOT NULL,  -- Stores values like 1234.56
State VARCHAR(50) NULL
)

ALTER TABLE Supermart_Grocery_Sales
ALTER COLUMN Discount TYPE DECIMAL USING Discount::DECIMAL(5,2);

--CSV DATA SET IMPORT DONE MANUALLY FROM "IMPORT/EXPORT DATA"

--CHECKED DATASET SUCESSFULY LOAD IN PGSQL
SELECT * FROM Supermart_Grocery_Sales;


--      BUISNESS PROBLEMS

--    	Sales Performance Analysis

--     1. Which product categories and subcategories contribute the most to total sales and profits?

SELECT category, sub_category,
		SUM(sales) AS Total_Sales,
		SUM(profit) AS Total_Profit
FROM 
	Supermart_Grocery_Sales
GROUP BY category,sub_category
ORDER BY Total_Sales DESC, Total_Profit DESC;



--   2. Which regions and cities generate the highest revenue, and which ones underperform?


-- REGION & CITY GENERATE THE HIGHEST REVINUE

SELECT region, city,
		SUM(sales) AS Highest_Revenue 
FROM
	Supermart_Grocery_Sales				
GROUP BY region, City
ORDER BY Highest_Revenue DESC
LIMIT 5; 		                     -- LIMIT TOP 5 REGION & CITY HIGHEST REVINUE


-- UNDERPERFORMING REGION & CITY

SELECT region, city,
		SUM(sales) AS Lowest_Revenue 
FROM
	Supermart_Grocery_Sales				
GROUP BY region, City
ORDER BY Lowest_Revenue ASC
LIMIT 5;							-- LIMIT BUTTOM 5 REGION & CITY LOWEST REVINUE




--   	3. Are higher discounts impacting profit margins negatively?

-- Discount vs. Profit Margin Correlation

SELECT 
    Discount, 
    ROUND(AVG(Profit / Sales) * 100, 2) AS Profit_Margin_Percentage 
FROM Supermart_Grocery_Sales
GROUP BY Discount
ORDER BY Discount DESC;


--    Categories Most Affected by Discounts

SELECT 
    Category, 
    Discount, 
    SUM(Sales) AS Total_Sales, 
    SUM(Profit) AS Total_Profit,
    ROUND(AVG(Profit / Sales) * 100,2) AS Profit_Margin_Percentage
FROM Supermart_Grocery_Sales
GROUP BY Category, Discount
ORDER BY Discount DESC, Profit_Margin_Percentage ASC;


--      4. How does profit vary across different product categories and regions? 

-- Aggregate Profit by Category & Region

SELECT Category, Region,
		SUM(Profit) AS Total_Profits
FROM
	Supermart_Grocery_Sales
Group BY
	Category,Region
ORDER BY 
	Region, Total_Profits DESC;


--		5. Identifying the top customers based on purchase value.

--     TOP 10 CUSTOMER BASED ON TOTAL PURCHASE VALUE

SELECT 
    Customer_Name, 
    SUM(Sales) AS Total_Purchase_Value
FROM Supermart_Grocery_Sales
GROUP BY Customer_Name
ORDER BY Total_Purchase_Value DESC
LIMIT 10;					


--		6. Determining seasonal trends in sales and peak demand periods.

-- Extract Month and Year for Sales Trend Analysis

SELECT
	EXTRACT(YEAR FROM Order_Date) AS Year,		-- Extract Year
	EXTRACT(MONTH FROM Order_Date) AS Month, 	-- Extract Month
	ROUND(SUM(Sales) /1000,2) ||'K' AS Total_Sales
FROM 
	Supermart_Grocery_Sales
GROUP BY Year,Month
ORDER BY Year,Month;


-- Quarter-Wise Trends

SELECT 
    EXTRACT(YEAR FROM Order_Date) AS Year, 	-- Extract Year
    EXTRACT(QUARTER FROM Order_Date) AS Quarter, -- Extract Quarter
    ROUND(SUM(Sales) /10000,2) ||'K' AS Total_Sales
FROM 
	Supermart_Grocery_Sales
GROUP BY Year, Quarter
ORDER BY Year, Quarter;


-- Peak Sales Days of the Week

SELECT 
    TO_CHAR(Order_Date, 'Day') AS Day_of_Week, 
    ROUND(SUM(Sales) / 10000,2) || 'K' AS Total_Sales
FROM 
	Supermart_Grocery_Sales
GROUP BY Day_of_Week
ORDER BY Total_Sales DESC;


--		Monthly Sales Trends by Category

SELECT
	CATEGORY,
	EXTRACT(MONTH FROM Order_Date) AS Month,
	SUM(sales) AS Total_Sales
FROM
	Supermart_Grocery_Sales
GROUP BY CATEGORY, Month
ORDER BY CATEGORY, Month;


-- 		7. Understanding which states and cities have the best and worst sales performance.


-- This ranks cities from highest to lowest sales.

SELECT state,city,
		SUM(sales) AS Total_sales
FROM 
	Supermart_Grocery_Sales
GROUP BY State,City
ORDER BY Total_sales DESC;



-- Top 5 Cities sales performance

SELECT city,
		SUM(sales) AS Total_sales
FROM 
	Supermart_Grocery_Sales
GROUP BY City
ORDER BY Total_sales DESC
LIMIT 5;



-- Worst 5 Cities sales performance

SELECT city,
		SUM(sales) AS Total_sales
FROM 
	Supermart_Grocery_Sales
GROUP BY City
ORDER BY Total_sales ASC
LIMIT 5;


--	8. Analyzing which regions require better marketing efforts to boost revenue.

-- Regions with Low Total Sales

SELECT Region,
		SUM(sales) AS Total_sales
FROM 
	Supermart_Grocery_Sales
GROUP BY Region
ORDER BY Total_sales DESC;



-- Regions with Low Profit Margins

SELECT Region,
		SUM(sales) AS Total_Sales,
		SUM(Profit) AS Total_Profits,
		ROUND((SUM(profit) / SUM(sales)) *100,2) AS Ptofit_Margine_Percentage
FROM
	Supermart_Grocery_Sales
GROUP BY Region
ORDER BY Ptofit_Margine_Percentage;




-- Regions Where Discounts Are Too High

SELECT 
    Region, 
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percentage, 
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percentage
FROM Supermart_Grocery_Sales
GROUP BY Region
ORDER BY Avg_Discount_Percentage DESC;

-- Regions with High Order Volume but Low Revenue

SELECT Region,
		COUNT(Order_ID) AS Total_Orders,
		SUM(sales) AS Total_SAles,
		ROUND(AVG(sales), 2) AS Average_Order_Value
FROM
	Supermart_Grocery_Sales
GROUP BY Region
ORDER BY Average_Order_Value ASC;


--the Worst Performing 3 Regions Based on All Metrics

SELECT 
    Region, 
    SUM(Sales) AS Total_Sales, 
    SUM(Profit) AS Total_Profit, 
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percentage, 
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Percentage
FROM Supermart_Grocery_Sales
GROUP BY Region
ORDER BY Total_Sales ASC, Profit_Margin_Percentage ASC
LIMIT 3;


