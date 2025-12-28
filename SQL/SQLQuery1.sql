USE Blinkitdb;

SELECT * FROM Blinkit_data
UPDATE Blinkit_data
SET Item_Fat_Content =
CASE
WHEN Item_Fat_Content IN ('LF','low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END;

SELECT DISTINCT Item_Fat_Content FROM Blinkit_data;

--1.Total Sales: The overall revenue generated from all items sold.

SELECT CAST(SUM(Total_Sales)/ 1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions 
FROM Blinkit_data
WHERE Outlet_Establishment_Year = 2022

--2.Average Sales: The average revenue per sale.

SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales
FROM Blinkit_data
WHERE Outlet_Establishment_Year = 2022

--3.Number of Items: The total count of different items sold.

SELECT COUNT(*) AS No_of_items FROM Blinkit_data
WHERE Outlet_Establishment_Year = 2022

--4.Average Rating: The average customer rating for items sold. 

SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating FROM Blinkit_data

-- 5.Total Sales by Fat Content:
-- Objective: Analyze the impact of fat content on total sales.
-- Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

SELECT * FROM Blinkit_data

SELECT Item_Fat_Content, 
        CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating 
FROM Blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC

-- 6.Total Sales by Item Type:
-- Objective: Identify the performance of different item types in terms of total sales.
-- Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

SELECT Top 5 Item_Type, 
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating 
FROM Blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC

-- 7.Fat Content by Outlet for Total Sales:
-- Objective: Compare total sales across different outlets segmented by fat content.
-- Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.

SELECT Outlet_Location_Type,
       ISNULL([Low Fat], 0) AS Low_Fat,
       ISNULL([Regular], 0) AS Regular
FROM
(
    SELECT Outlet_Location_Type, Item_Fat_Content,
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM Blinkit_data
    GROUP BY  Outlet_Location_Type, Item_Fat_Content
) AS SourceTable 
PIVOT
(
     SUM(Total_Sales) 
     FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable 
ORDER BY Outlet_Location_Type;


-- 8.Total Sales by Outlet Establishment:
-- Objective: Evaluate how the age or type of outlet establishment influences total sales.

SELECT Outlet_Establishment_Year,
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating 
FROM Blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC

-- 9.Percentage of Sales by Outlet Size:
-- Objective: Analyze the correlation between outlet size and total sales.

SELECT 
      Outlet_Size,
      CAST(SUM(Total_sales) AS DECIMAL(10,2)) AS Total_Sales,
      CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM Blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC

-- 10.Sales by Outlet Location:
-- Objective: Assess the geographic distribution of sales across different locations.

SELECT Outlet_Location_Type,
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating 
FROM Blinkit_data
WHERE Outlet_Establishment_Year = 2022
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC


-- 11.All Metrics by Outlet Type:
-- Objective: Provide a comprehensive view of all key metrics (Total Sales, Average Sales, Number of 	Items, Average Rating) broken down by different outlet types.

SELECT Outlet_Type,
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating 
FROM Blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC
