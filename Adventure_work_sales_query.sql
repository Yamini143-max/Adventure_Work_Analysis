use sales_data25;

## SQL QUESTIONS BASED ON SALES DATA

## Q1##
## 1. Show all records from the Sales table.

SELECT COUNT(*)
FROM csv_sales3;

## Q2 ##
## 2. List all sales where the amount is greater than 1000.

SELECT *
FROM csv_sales3
WHERE salesamount>1000;

## Q3##
 ## Find total sales by customer.
 
SELECT CustomerName, SUM(SalesAmount) AS TotalSales
FROM csv_sales3
GROUP BY CustomerName;

## Q4 ##
## Show top 5 products by sales amount.

SELECT ProductName, SUM(SalesAmount) AS TotalSales
FROM csv_sales3
GROUP BY ProductName
ORDER BY TotalSales DESC
LIMIT 5;


##Q4## total sales for each month and year, using the OrderDate column in CSV_SALES3 and the DimDate table.
SELECT 
    d.CalendarYear,
    d.EnglishMonthName AS MonthName,
    SUM(s.SalesAmount) AS TotalSales
FROM CSV_SALES3 s
JOIN DimDate_csv1 d 
  ON s.OrderDate = d.FullDateAlternateKey
GROUP BY d.CalendarYear, d.MonthNumberOfYear, d.EnglishMonthName
ORDER BY d.CalendarYear, d.MonthNumberOfYear;


## Q8##  customers who have placed more than 1 order.

SELECT DISTINCT s1.CustomerName
FROM CSV_SALES3 s1
WHERE EXISTS (
    SELECT 1
    FROM CSV_SALES3 s2
    WHERE s1.CustomerName = s2.CustomerName
      AND s1.OrderDate <> s2.OrderDate
);    
    
    
    ## Q7 ##
    ##  Total Sales by Year and Month based on dimcustomer and dimdate table 
    SELECT 
  Year,
  Month,
  SUM(SalesAmount) AS TotalSales
FROM csv_sales3
GROUP BY Year, Month
ORDER BY Year, Month;


    ## Q8##
    ##Join Sales with Customers - Average Sales by Marital Status
    
    
    SELECT 
  c.MaritalStatus,
  AVG(s.SalesAmount) AS AvgSales
FROM csv_sales3 s
JOIN dimcustomer_csvfile c
  ON s.CustomerName = CONCAT(c.FirstName, ' ', c.LastName)
GROUP BY c.MaritalStatus;


## Q9 ## TO CREATE VIEW...View Creation – Sales Summary per Product Category

CREATE VIEW vw_ProductCategorySales AS
SELECT 
  ProductCategoryName,
  SUM(SalesAmount) AS TotalSales,
  SUM(Profit) AS TotalProfit
FROM csv_sales3
GROUP BY ProductCategoryName;

SELECT *
FROM  vw_ProductCategorySales;


## Q10 ##
## Stored Procedure – Sales Summary for a Given Year

CALL GetYearlySalesSummary(2012);



## Q11##
## Highest profit products for married customers
SELECT 
  s.ProductName,
  SUM(s.Profit) AS TotalProfit
FROM csv_sales3 s
JOIN dimcustomer_csvfile c 
  ON s.CustomerName = CONCAT(c.FirstName, ' ', c.LastName)
WHERE c.MaritalStatus = 'M'
GROUP BY s.ProductName
ORDER BY TotalProfit DESC
LIMIT 5;
    
    
    ## Q12##Q:
## to display each customer's order date, sales amount, the previous order amount (using LAG), and the next order 
## amount (using LEAD), ordered by customer and order date.

SELECT 
    CustomerName,
    OrderDate,
    SalesAmount,
    LAG(SalesAmount) OVER (PARTITION BY CustomerName ORDER BY OrderDate) AS PrevOrderAmount,
    LEAD(SalesAmount) OVER (PARTITION BY CustomerName ORDER BY OrderDate) AS NextOrderAmount
FROM 
    CSV_SALES3;
    
    
   ##Q13##Classify each sale  'High', 'Medium', or 'Low' based on the SalesAmount, and count how many sales fall into each category.

 SELECT 
  CASE 
    WHEN SalesAmount >= 1000 THEN 'High'
    WHEN SalesAmount BETWEEN 500 AND 999.99 THEN 'Medium'
    ELSE 'Low'
  END AS SalesCategory,
  COUNT(*) AS NumberOfSales
FROM CSV_SALES3
GROUP BY 
  CASE 
    WHEN SalesAmount >= 1000 THEN 'High'
    WHEN SalesAmount BETWEEN 500 AND 999.99 THEN 'Medium'
    ELSE 'Low'
  END;
    
    SHOW TABLES;
DESCRIBE csv_sales3;
DESCRIBE DimProduct;
DESCRIBE DimProductSubCategory_csv;
DESCRIBE DimProductCategory_csv;

SELECT DISTINCT ProductName FROM csv_sales3 LIMIT 10;
SELECT DISTINCT EnglishProductName FROM DimProduct LIMIT 10;



