--SQL PHARMA DATA ASSESSMENT QUESTIONS - PSYLIQ

--1) Retrieve all columns for all records in the dataset.

SELECT * 
FROM Pharma

--2) How many unique countries are represented in the dataset?

SELECT 
COUNT(DISTINCT country)
FROM Pharma

--3) Select the names of all the customers on the 'Retail' channel.

SELECT 
customer_name 
FROM Pharma 
WHERE sub_channel = 'Retail'

--4) Find the total quantity sold for the ' Antibiotics' product class.

SELECT 
SUM(quantity) AS Total_Quantity 
FROM Pharma 
WHERE product_class = 'Antibiotics'

--5) List all the distinct months present in the dataset.

SELECT 
DISTINCT month
FROM Pharma

--6) Calculate the total sales for each year.

SELECT 
year,
SUM(sales) AS Total_Sales
FROM Pharma 
GROUP BY 1

--7) Find the customer with the highest sales value.

SELECT 
customer_name,
SUM(sales) AS Total_Sales 
FROM Pharma 
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 1;

--8) Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'.

SELECT 
DISTINCT name_of_sales_rep AS Employee
FROM Pharma 
WHERE manager = 'James Goodwill'

--9) Retrieve the top 5 cities with the highest sales.

SELECT 
city,
SUM(sales) AS Highest_Sales
FROM Pharma 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--10) Calculate the average price of products in each sub-channel.

SELECT 
sub_channel,
AVG(price) AS Average_Price
FROM Pharma 
GROUP BY 1
ORDER BY 2 DESC;

--11) Join the 'Employees' table with the 'Sales' table to get the name of the Sales Rep and the corresponding sales records.

SELECT 
name_of_sales_rep,
SUM(sales) AS Sales_Record 
FROM Pharma
GROUP BY 1
ORDER BY 2 DESC;

--12) Retrieve all sales made by employees from ' Rendsburg ' in the year 2018.

SELECT 
name_of_sales_rep,
SUM(sales) AS Total_Sales 
FROM Pharma 
WHERE city = 'Rendsburg' AND year = 2018
GROUP BY 1
ORDER BY 2 DESC;

--13) Calculate the total sales for each product class, for each month, and order the results by year, month, and product class.

SELECT 
product_class, 
month, 
year,
SUM(sales) AS Total_Sales 
FROM Pharma 
GROUP BY 1, 2, 3
ORDER BY year, month, product_class;

--14) Find the top 3 sales reps with the highest sales in 2019.

SELECT 
name_of_sales_rep,
SUM(sales) AS Total_Sales 
FROM Pharma 
WHERE year = 2019
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 3;

--15) Calculate the monthly total sales for each sub-channel, and then calculate the average monthly sales for each sub-channel over the years.
	
SELECT 
sub_channel,
month,
year,
SUM(sales) AS Total_Sales,
AVG(SUM(sales)) OVER (PARTITION BY sub_channel, month) AS Average_Sales
FROM Pharma 
GROUP BY 1,2,3
ORDER BY 3,2;

--16) Create a summary report that includes the total sales, average price, and total quantity sold for each product class.

SELECT 
product_class,
SUM(sales) AS Total_Sales, 
AVG(price) AS Average_Price,
SUM(quantity) AS Total_Quantity
FROM pharma
GROUP BY 1

--17) Find the top 5 customers with the highest sales for each year.

WITH TopCustomers AS (
SELECT 
customer_name,
year,
sales,
DENSE_RANK() OVER(PARTITION BY year ORDER BY sales DESC) AS Top5
FROM Pharma)
SELECT 
*
FROM TopCustomers 
WHERE Top5 <= 5

--18) Calculate the year-over-year growth in sales for each country.

SELECT
year,
country,
SUM(sales) AS Total_Sales,
LAG(SUM(sales), 1, 0) OVER(PARTITION BY country ORDER BY year) AS Previous_Year_Sales,
SUM(sales) - LAG(SUM(sales), 1, 0) OVER(PARTITION BY country ORDER BY year) AS YearOverYearGrowth
FROM pharma
GROUP BY 1,2
ORDER BY 2,1;

--19) List the months with the lowest sales for each year

WITH Lowest_Sales AS (
SELECT 
month,
year,
SUM(sales) AS Total_Sales,
DENSE_RANK() OVER(PARTITION BY year ORDER BY SUM(sales) ASC) AS Ranks
FROM pharma
GROUP BY 1,2)
SELECT 
*
FROM Lowest_Sales
WHERE Ranks = 1;

--20) Calculate the total sales for each sub-channel in each country, and then find the country with the highest total sales for each sub-channel.

WITH CTE AS (
SELECT 
sub_channel,
country,
SUM(sales) AS Total_Sales
FROM pharma 
GROUP BY 1,2),

Highest_Total_Sales AS (
SELECT 
*,
DENSE_RANK() OVER (PARTITION BY sub_channel ORDER BY Total_Sales DESC) AS Ranks
FROM CTE)

SELECT *
FROM Highest_Total_Sales 
WHERE Ranks = 1;





