Create database blinkit_db;
use blinkit_db

--- import csv file

select * from blinkit_data;

-- check count
select count(*) from blinkit_data;

--Data cleaning
select * from blinkit_data;

--in 'Item_fat_content' we can see some intries are in lower case and some are in short for.need to fix it

update blinkit_data
set Item_Fat_Content = 
case -- 'case' is similar as 'IF-Else' statement we use it for conditional statement 
when Item_Fat_Content in('LF','low fat') then 'Low Fat' --used 'in instead of =' coz more than 1 intity
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end;

select * from blinkit_data;

select Distinct(item_fat_content) from blinkit_data;

/* KPI Requirements
1. Total Sales: The overall revenue generated from all items sold.
2. Average sales: The average revenue per sales.
3. Number of items: The Total Count of different items sold.
4. Average Rating: The average customer rating for items sold.*/

-- 1st KPI- Total Sales
select SUM(Total_sales) As Total_sales from blinkit_data;
-- if same want to see in millions then can use advance function 'Cast' with fix dicimal numbers

select cast(sum(Total_sales)/1000000 as decimal(10,2)) as Total_sales_millions
from blinkit_data;

-- If Want to see perticular fields sales
-- for example let's see total sales of Low Fat or in perticular year

select cast(sum(Total_sales) as decimal(10,0)) as Total_sales
from blinkit_data
where Item_Fat_Content = 'Low Fat';

select cast(sum(Total_sales) as decimal(10,0)) as Total_sales
from blinkit_data
where Outlet_Establishment_Year = 2022 ;


-- 2nd KPI Average Sales

select AVG(Total_sales) as avg_sales from blinkit_data;

-- if want to see in few decimal point then can use 'CAST' function

select cast(avg(Total_sales) as decimal(10,2)) as Avg_sales from blinkit_data;

-- 3rd KPI Number of Items

select COUNT(*) as No_of_data from blinkit_data;

select COUNT(*) as No_of_data from blinkit_data
where  Outlet_Establishment_Year = 2022;

-- 4th KPI Average rating

select cast(avg(rating) as decimal(10,2)) as avg_rating from blinkit_data;


-- Granual Requirements
/* 1. Total Sales by Fat Content:
	Objective: Analyze the impact of fat content on total sales.
	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) 
    vary with fat content.
2. Total Sales by Item Type:
	Objective: Identify the performance of different item types in terms of total sales.
	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating)
    vary with fat content.
3. Fat Content by Outlet for Total Sales:
	Objective: Compare total sales across different outlets segmented by fat content.
	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) 
    vary with fat content.
4. Total Sales by Outlet Establishment:
	Objective: Evaluate how the age or type of outlet establishment influences total sales.*/


--1st
select item_fat_content, 
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Item_Fat_Content
order by total_sales desc;

--check year wise

select item_fat_content, 
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
where Outlet_Establishment_Year = 2022
group by Item_Fat_Content
order by total_sales desc;

--2nd

select Item_Type, 
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Item_Type
order by total_sales desc;

select Top 5 Item_Type, 
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Item_Type
order by total_sales desc;

--3rd

select Outlet_location_type,item_fat_content,
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Outlet_location_type,item_fat_content
order by total_sales desc;
----------------------------------------------------------------
select outlet_location_type,
       ISNULL([Low fat],0) as low_fat,
	   ISNULL([Regular],0) as Regular
From
(
   select outlet_location_type, item_fat_content,
          cast(sum(total_sales) as decimal(10,2)) as total_sales
   from blinkit_data
   group by Outlet_Location_Type, Item_Fat_Content
) as sourcetable
PIVOT
(
     sum(total_sales)
	 for item_fat_content in([low fat],[regular])
) as piovotTable
order by Outlet_Location_Type;


--4th

select Outlet_Establishment_Year,
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year asc;

select Outlet_Establishment_Year,
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Outlet_Establishment_Year
order by total_sales desc;

--CHART'S REQUIREMENT
/* 1. Percentage of Sales by Outlet Size:
	Objective: Analyze the correlation between outlet size and total sales.
2. Sales by Outlet Location:
	Objective: Assess the geographic distribution of sales across different locations.
3. All Metrics by Outlet Type:
	Objective: Provide a comprehensive view of all key metrics 
	(Total Sales, Average Sales, Number of 	Items, Average Rating) broken down by different outlet types.*/

-->1

SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-->2

select Outlet_Location_Type,
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Outlet_Location_Type
order by total_sales desc;

-->3rd outlet_type

select Outlet_Type,
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
	   cast(avg(Total_sales) as decimal(10,2)) as Avg_sales,
	   COUNT(*) as No_of_data,
	   cast(avg(rating) as decimal(10,2)) as avg_rating
from blinkit_data
group by Outlet_Type
order by total_sales desc; 



