-------------lab 1 ------------
-- Retrieving Customer Data
select *
from SalesLT.Customer
-- Create List of Customer Contacts
-- select the Title, FirstName, MiddleName, LastName and Suffix columns
-- from the Customer table
SELECT Title, FirstName, MiddleName, LastName, Suffix
FROM SalesLT.Customer
-- finish the query
SELECT Salesperson, Title + ' ' + LastName AS CustomerName, Phone
FROM SalesLT.Customer;
-- retrieving customer and sales data
-- format <Customer ID>: <Company Name> (e.g. 78: Preferred Bikes). 
-- cast the CustomerID column to a VARCHAR and concatenate with the CompanyName column
SELECT CAST(CustomerID AS VARCHAR) + ': ' + CompanyName AS CustomerCompany
FROM SalesLT.Customer;
-- The sales order number and revision number in the format <Order Number> (<Revision>) (e.g. SO71774 (2)).
-- The order date converted to ANSI standard format yyyy.mm.dd (e.g. 2015.01.31).
SELECT SalesOrderNumber + ' (' + STR(RevisionNumber, 1) + ')' AS OrderRevision,
	   CONVERT(NVARCHAR(30), OrderDate, 102) AS OrderDate
FROM SalesLT.SalesOrderHeader;
-- use ISNULL to check for middle names and concatenate with FirstName and LastName
SELECT FirstName + ' ' + ISNULL(MiddleName + ' ', '') + LastName
AS CustomerName
FROM SalesLT.Customer;
-- select the CustomerID, and use COALESCE with EmailAddress and Phone columns
SELECT CustomerID, COALESCE(EmailAddress,Phone) AS PrimaryContact
FROM SalesLT.Customer;
--create new column ShippingStatus for orders with ship date
SELECT SalesOrderID, OrderDate,
  CASE
    WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
    ELSE 'Shipped'
  END AS ShippingStatus
FROM SalesLT.SalesOrderHeader;
---------------- lab 2 -------------------
-- select unique cities, and state province
SELECT DISTINCT City, StateProvince
FROM SalesLT.Address;
-- select the top 10 percent from the Name column
SELECT TOP 10 PERCENT Name
FROM SalesLT.Product
-- order by the weight in descending order
Order by Weight DESC;
-- Tweak the query to list the heaviest 100 products not including the ten most heavy ones.
SELECT Name
FROM SalesLT.Product
ORDER BY Weight DESC
-- offset 10 rows and get the next 100
OFFSET 10 ROWS FETCH NEXT 100 ROWS ONLY;
--Retrieving Product Data
-- select the Name, Color, and Size columns
SELECT Name, Color, Size
FROM SalesLT.Product
-- check ProductModelID is 1
WHERE ProductModelID = 1;
-- select the ProductNumber and Name columns
SELECT ProductNumber, Name
FROM SalesLT.Product
-- check that Color is one of 'Black', 'Red' or 'White'
-- check that Size is one of 'S' or 'M'
WHERE Color IN ('Black', 'Red', 'White') AND Size IN ('S','M');
-- select the ProductNumber, Name, and ListPrice columns
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
-- filter for product numbers beginning with BK- using LIKE
WHERE ProductNumber LIKE 'BK-%';
-- select the ProductNumber, Name, and ListPrice columns
SELECT ProductNumber, Name, ListPrice
FROM SalesLT.Product
-- filter for ProductNumbers
WHERE ProductNumber LIKE 'BK-[^R]%-[0-9][0-9]';
--------------Lab3-------------------
--generating Invoice
-- select the CompanyName, SalesOrderId, and TotalDue columns from the appropriate tables
SELECT c.CompanyName,oh.SalesOrderId,oh.TotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
-- join tables based on CustomerID
ON c.CustomerID = oh.CustomerID;
--Extend your customer orders query to include the main office address for each customer, 
--including the full street address, city, state or province, postal code, and country or region.
SELECT c.CompanyName, a.AddressLine1, ISNULL(a.AddressLine2, '') AS AddressLine2, a.City, a.StateProvince, a.PostalCode, a.CountryRegion, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer AS c
-- join the SalesOrderHeader table
JOIN SalesLT.SalesOrderHeader AS oh
ON oh.CustomerID = c.CustomerID
-- join the CustomerAddress table
JOIN SalesLT.CustomerAddress AS ca
-- filter for where the AddressType is 'Main Office'
ON c.CustomerID = ca.CustomerID AND ca.AddressType = 'Main Office'
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID;
-- select the CompanyName, FirstName, LastName, SalesOrderID and TotalDue columns
-- from the appropriate tables
SELECT CompanyName, c.FirstName, c.LastName, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
-- join based on CustomerID
ON c.CustomerID = oh.CustomerID
-- order the SalesOrderIDs from highest to lowest
ORDER by oh.SalesOrderID DESC;
-- query that return list of customers with no address
SELECT c.CompanyName, c.FirstName, c.LastName, c.Phone
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- filter for when the AddressID doesn't exist
WHERE ca.AddressID IS NULL;
--Write a query that returns a column of customer IDs for customers who have never placed an order, 
--and a column of product IDs for products that have never been ordered.
SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
FULL JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
FULL JOIN SalesLT.SalesOrderDetail AS od
-- join based on the SalesOrderID
ON od.SalesOrderID = oh.SalesOrderID
FULL JOIN SalesLT.Product AS p
-- join based on the ProductID
ON p.ProductID= od.ProductID
-- filter for nonexistent SalesOrderIDs
WHERE oh.SalesOrderID IS NULL
ORDER BY ProductID, CustomerID;
--------------lab4---------------------
-- select the CompanyName, AddressLine1 columns
-- alias as per the instructions
SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- join another table
JOIN SalesLT.Address AS a
-- join based on AddressID
ON a.AddressID = ca.AddressID
-- filter for where the correct AddressType
WHERE ca.AddressType = 'Main Office';
-- edit this
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
-- edit this
WHERE ca.AddressType = 'Shipping';
-- Combine the results returned by the two queries
SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
-- edit this as per the instructions
UNION ALL
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName, AddressType;
--Filter the master list of all customer address
--returns the company name of each company that appears in a table of customers with 
--a 'Main Office' address,
-- but not in a table of customers with a 'Shipping' address.
SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- join the CustomerAddress table
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
-- join based on AddressID
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office'
EXCEPT
SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- use the appropriate join to join the CustomerAddress table
LEFT JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- use the appropriate join to join the Address table
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
-- filter for the appropriate AddressType
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;
--using intersect
-- select the CompanyName column
SELECT c.CompanyName
-- from the appropriate table
FROM SalesLT.Customer AS c
-- use the appropriate join with the appropriate table
JOIN SalesLT.CustomerAddress AS ca
-- join based on CustomerID
ON c.CustomerID = ca.CustomerID
-- use the appropriate join with the appropriate table
LEFT JOIN SalesLT.Address AS a
-- join based on AddressID
ON a.AddressID = ca.AddressID
-- filter based on AddressType
WHERE ca.AddressType = 'Main Office'
INTERSECT
-- select the CompanyName column
SELECT c.CompanyName
FROM SalesLT.Customer AS c
-- use the appropriate join with the appropriate table
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
-- join based on AddressID
ON a.AddressID = ca.AddressID
-- filter based on AddressType
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;
------------------- lab 5 ----------------------
-- select ProductID and use the appropriate functions with the appropriate columns
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight
FROM SalesLT.Product;
-----get datename and year
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight,
       -- get the year of the SellStartDate
       YEAR(SellStartDate) as SellStartYear,
       -- get the month datepart of the SellStartDate
       DATENAME (m, SellStartDate) as SellStartMonth
FROM SalesLT.Product;
--column named ProductType that contains the leftmost two characters from the product number. 
SELECT ProductID, UPPER(Name) AS ProductName, ROUND(Weight, 0) AS ApproxWeight,
       YEAR(SellStartDate) as SellStartYear,
       DATENAME(m, SellStartDate) as SellStartMonth,
       -- use the appropriate function to extract substring from ProductNumber
       SUBSTRING( ProductNumber, 1,2) AS ProductType
FROM SalesLT.Product;
-- filter for numeric product size data
WHERE ISNUMERIC(Size) = 1;
-- select CompanyName and TotalDue columns
SELECT CompanyName, TotalDue AS Revenue,
       -- get ranking and order by appropriate column
       RANK() OVER (ORDER BY TotalDue DESC) AS RankByRevenue
FROM SalesLT.SalesOrderHeader AS SOH
-- use appropriate join on appropriate table
JOIN SalesLT.Customer AS C
ON SOH.CustomerID = C.CustomerID;
-- select the Name column and use the appropriate function with the appropriate column
SELECT Name, SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
-- use the appropriate join
JOIN SalesLT.Product AS P
-- join based on ProductID
ON SOD.ProductID = P.ProductID
GROUP BY P.Name
ORDER BY TotalRevenue DESC;
--include sales totals for products that have a list price of more than 1000
WHERE P.ListPrice > 1000
-- only include products with total sales > 20000
SELECT Name, SUM(LineTotal) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS SOD
JOIN SalesLT.Product AS P
ON SOD.ProductID = P.ProductID
WHERE P.ListPrice > 1000
GROUP BY P.Name
-- add having clause as per instructions
HAVING SUM(LineTotal) > 20000
ORDER BY TotalRevenue DESC;
---------- lab 6 -----------
-- select the ProductID, Name, and ListPrice columns
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
-- filter based on ListPrice
WHERE ListPrice > 
-- get the average UnitPrice
(SELECT AVG(UnitPrice) FROM SalesLT.SalesOrderDetail)
ORDER BY ProductID;
--listprice>100 and sold<100
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE ProductID IN
  -- select ProductID from the appropriate table
  (SELECT ProductID FROM SalesLT.SalesOrderDetail
   WHERE UnitPrice < 100)
AND ListPrice >= 100
ORDER BY ProductID;
-- get the average UnitPrice
(SELECT AVG(UnitPrice)
 -- from the appropriate table, aliased as SOD
 FROM SalesLT.SalesOrderDetail AS SOD
 -- filter when the appropriate ProductIDs are equal
 WHERE P.ProductID = SOD.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS P
ORDER BY P.ProductID;
 --include only products where the cost is higher than the average selling price
 SELECT ProductID, Name, StandardCost, ListPrice,
(SELECT AVG(UnitPrice)
 FROM SalesLT.SalesOrderDetail AS SOD
 WHERE P.ProductID = SOD.ProductID) AS AvgSellingPrice
FROM SalesLT.Product AS P
-- filter based on StandardCost
WHERE StandardCost >
-- get the average UnitPrice
(SELECT AVG(UnitPrice)
 -- from the appropriate table aliased as SOD
 FROM SalesLT.SalesOrderDetail AS SOD
 -- filter when the appropriate ProductIDs are equal
 WHERE P.ProductID = SOD.ProductID)
ORDER BY P.ProductID;
-- select SalesOrderID, CustomerID, FirstName, LastName, TotalDue from the appropriate tables
SELECT SOH.SalesOrderID, SOH.CustomerID, CI.FirstName, CI.LastName, SOH.TotalDue
FROM SalesLT.SalesOrderHeader AS SOH
-- cross apply as per the instructions
CROSS APPLY dbo.ufnGetCustomerInformation(SOH.CustomerID) AS CI
-- finish the clause
ORDER by SOH.SalesOrderID;
-- select the CustomerID, FirstName, LastName, Addressline1, and City columns from the appropriate tables
SELECT CA.CustomerID, CI.FirstName, CI.LastName, A.Addressline1,A.City 
FROM SalesLT.Address AS A
JOIN SalesLT.CustomerAddress AS CA
-- join based on AddressID
ON A.AddressID = CA.AddressID
-- cross apply as per instructions
CROSS APPLY dbo.ufnGetCustomerInformation(CA.CustomerID) AS CI
ORDER BY CA.CustomerID;
--------------- lab 7 ------------------
-- Retrieveproduct name, product model name, and product model summary for each product from the SalesLT.Product table 
--and the SalesLT.vProductModelCatalogDescription view.
-- select the appropriate columns from the appropriate tables
SELECT P.ProductID, P.Name AS ProductName, PM.Name AS ProductModel, PM.Summary
FROM SalesLT.Product AS P
JOIN SalesLT.vProductModelCatalogDescription AS PM
-- join based on ProductModelID
ON P.ProductModelID = PM.ProductModelID
ORDER BY ProductID;
--declare table
DECLARE @Colors AS TABLE (Color NVARCHAR(15));

INSERT INTO @Colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT ProductID, Name, Color
FROM SalesLT.Product
WHERE Color IN (SELECT Color FROM @Colors);
--- parent category and their own category with function
SELECT C.ParentProductCategoryName AS ParentCategory,
       C.ProductCategoryName AS Category,
       P.ProductID, P.Name AS ProductName
FROM SalesLT.Product AS P
JOIN dbo.ufnGetAllCategories() AS C
ON P.ProductCategoryID = C.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName;
---create list of Company(Contact) and total rev by customer
--using sub-tables, CTEs
SELECT CompanyContact, SUM(SalesAmount) AS Revenue
FROM
	(SELECT CONCAT(c.CompanyName, CONCAT(' (' + c.FirstName + ' ', c.LastName + ')')), SOH.TotalDue
	 FROM SalesLT.SalesOrderHeader AS SOH
	 JOIN SalesLT.Customer AS c
	 ON SOH.CustomerID = c.CustomerID) AS CustomerSales(CompanyContact, SalesAmount)
GROUP BY CompanyContact
ORDER BY CompanyContact;
-------------- lab 8 ----------
--grand total for all sales revenue and a subtotal for each country/region 
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh
ON c.CustomerID = soh.CustomerID
-- Modify GROUP BY to use ROLLUP
GROUP BY ROLLUP ( a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;
--add level hierarchy
SELECT a.CountryRegion, a.StateProvince,
IIF(GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1, 'Total', IIF(GROUPING_ID(a.StateProvince) = 1, a.CountryRegion + ' Subtotal', a.StateProvince + ' Subtotal')) AS Level,
SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh
ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;
--adding city and useing"CHOOSE" instead "IIF"
SELECT a.CountryRegion, a.StateProvince, a.City,
CHOOSE (1 + GROUPING_ID(a.City) + GROUPING_ID(a.StateProvince) + GROUPING_ID(a.CountryRegion),
        a.City + ' Subtotal', a.StateProvince + ' Subtotal',
        a.CountryRegion + ' Subtotal', 'Total') AS Level,
SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c
ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh
ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP(a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;
--use pivot to get new table for each catogory and the sales
SELECT * FROM
(SELECT cat.ParentProductCategoryName, CompanyName, LineTotal
 FROM SalesLT.SalesOrderDetail AS sod
 JOIN SalesLT.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
 JOIN SalesLT.Customer AS cust ON cust.CustomerID = soh.CustomerID
 JOIN SalesLT.Product AS prod ON prod.ProductID = sod.ProductID
 JOIN SalesLT.vGetAllCategories AS cat ON prod.ProductcategoryID = cat.ProductCategoryID) AS catsales
PIVOT (SUM(LineTotal) FOR ParentProductCategoryName
IN ([Accessories], [Bikes], [Clothing], [Components])) AS pivotedsales
ORDER BY CompanyName;
-------------------- lab 9 -----------------------
--insert new data and use IDENTITY
-- Finish the INSERT statement
INSERT INTO SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE() );

-- Get last identity value that was inserted
SELECT SCOPE_IDENTITY();

-- Finish the SELECT statement
SELECT * FROM SalesLT.Product
WHERE ProductID = SCOPE_IDENTITY();
-- Insert product category
INSERT INTO SalesLT.ProductCategory (ParentProductCategoryID, Name)
VALUES
(4, 'Bells and Horns');

-- Insert 2 products
INSERT INTO SalesLT.Product (Name, ProductNumber,StandardCost, ListPrice, ProductCategoryID, SellStartDate)
VALUES
('Bicycle Bell', 'BB-RING', 2.47, 4.99, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE()),
('Bicycle Horn', 'BB-PARP', 1.29, 3.75, IDENT_CURRENT('SalesLT.ProductCategory'), GETDATE());
--updating products
-- Update the SalesLT.Product table
UPDATE SalesLT.Product
SET ListPrice = ListPrice * 1.1
WHERE ProductCategoryID =
  (SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');
  -- Finish the UPDATE query
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductCategoryID = 37 AND ProductNumber <> 'LT-L123';
--DELETING
--Delete the records for the Bells and Horns category and its products. 
-- Delete records from the SalesLT.Product table
DELETE  SalesLT.Product
WHERE ProductCategoryID =
	(SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');

-- Delete records from the SalesLT.ProductCategory table
DELETE  SalesLT.ProductCategory
WHERE ProductCategoryID =
	(SELECT ProductCategoryID FROM SalesLT.ProductCategory WHERE Name = 'Bells and Horns');
------------------ lab 10 ----------------------
--reusable scripts that make it easy to insert sales orders. 

DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;

INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID , ShipMethod)
VALUES (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');

PRINT SCOPE_IDENTITY();

-- Code from previous exercise
DECLARE @OrderDate datetime = GETDATE();
DECLARE @DueDate datetime = DATEADD(dd, 7, GETDATE());
DECLARE @CustomerID int = 1;
INSERT INTO SalesLT.SalesOrderHeader (OrderDate, DueDate, CustomerID, ShipMethod)
VALUES (@OrderDate, @DueDate, @CustomerID, 'CARGO TRANSPORT 5');
DECLARE @OrderID int = SCOPE_IDENTITY();

-- Additional script to complete
DECLARE @ProductID int = 760;
DECLARE @Quantity int = 1;
DECLARE @UnitPrice money = 782.99;

IF EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
BEGIN
	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice)
	VALUES (@OrderID, @Quantity, @ProductID, @UnitPrice)
END
ELSE
BEGIN
	PRINT 'The order does not exist'
END
---increase avg list price 10% until max(listprice) reach market price
DECLARE @MarketAverage money = 2000;
DECLARE @MarketMax money = 5000;
DECLARE @AWMax money;
DECLARE @AWAverage money;

SELECT @AWAverage = AVG(ListPrice), @AWMax = MAX(ListPrice)
FROM SalesLT.Product
WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

WHILE @AWAverage < @MarketAverage
BEGIN
   UPDATE SalesLT.Product
   SET ListPrice = ListPrice * 1.1
   WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

	SELECT @AWAverage = AVG(ListPrice), @AWMax = MAX(ListPrice)
	FROM SalesLT.Product
	WHERE ProductCategoryID IN
	(SELECT DISTINCT ProductCategoryID
	 FROM SalesLT.vGetAllCategories
	 WHERE ParentProductCategoryName = 'Bikes');

   IF @AWMax >= @MarketMax
      BREAK
   ELSE
      CONTINUE
END

PRINT 'New average bike price:' + CONVERT(VARCHAR, @AWAverage);
PRINT 'New maximum bike price:' + CONVERT(VARCHAR, @AWMax);
------------------- lab 11 ---------------
--logging error
-- check if it exists before deleting 
DECLARE @OrderID int = 0

-- Declare a custom error if the specified order doesn't exist
DECLARE @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
BEGIN
  THROW 50001, @error, 0;
END
ELSE
BEGIN
  DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID;
  DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
 END
 --begin try and catch
 DECLARE @OrderID int = 71774
DECLARE @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

-- Wrap IF ELSE in a TRY block
BEGIN TRY
  IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
  BEGIN
    THROW 50001, @error, 0
  END
  ELSE
  BEGIN
    DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @OrderID;
    DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID;
  END
END TRY
-- Add a CATCH block to print out the error
BEGIN CATCH
  PRINT ERROR_MESSAGE();
END CATCH
-- adding both into one transaction
DECLARE @OrderID int = 0
DECLARE @error VARCHAR(30) = 'Order #' + cast(@OrderID as VARCHAR) + ' does not exist';

BEGIN TRY
  IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @OrderID)
  BEGIN
    THROW 50001, @error, 0
  END
  ELSE
  BEGIN
    BEGIN TRANSACTION
    DELETE FROM SalesLT.SalesOrderDetail
    WHERE SalesOrderID = @OrderID;
    DELETE FROM SalesLT.SalesOrderHeader
    WHERE SalesOrderID = @OrderID;
    COMMIT TRANSACTION
  END
END TRY
BEGIN CATCH
  IF @@TRANCOUNT > 0
  BEGIN
    ROLLBACK TRANSACTION;
  END
  ELSE
  BEGIN
    PRINT ERROR_MESSAGE();
  END
END CATCH
------------- exam ---------------
--Q1
SELECT * FROM dbo.Products
--Q2
SELECT DISTINCT CategoryID 
FROM dbo.Products
--Q3
SELECT ProductName
FROM dbo.Products
WHERE UnitsInStock > 20;
--Q4
SELECT TOP 10 ProductID, ProductName, UnitPrice
FROM dbo.Products
ORDER BY UnitPrice DESC;
--Q5
SELECT ProductID, ProductName, QuantityPerUnit
FROM dbo.Products
ORDER BY ProductName;
--Q6
SELECT ProductID, ProductName, UnitPrice
FROM dbo.Products
ORDER BY UnitsInStock DESC
OFFSET 10 ROWS
FETCH NEXT 5 ROWS ONLY
--Q7 WRONG!
SELECT FirstName + 'has an EmployeeID of'+ STR(EmployeeID, 2) +  ' and was born '+ CONVERT(NVARCHAR(30), BirthDate, 126)
FROM dbo.Employees
--Q8
SELECT ShipName + ' is from '+ COALESCE(ShipCity, ShipRegion,  ShipCountry)
FROM dbo.Orders;
--Q9
SELECT ShipName, ISNULL(ShipPostalCode, 'unknown') AS ShipPostalCode
FROM dbo.Orders;
--Q10
SELECT CompanyName,
CASE
    WHEN Fax IS NULL THEN 'modern'
    ELSE 'outdated'
  END AS Status
FROM dbo.Suppliers;
--section2
--Q1
SELECT o.OrderID, od.UnitPrice
FROM dbo.Orders AS o
JOIN dbo.[Order Details] AS od
ON o.OrderID = od.OrderID;
--Q2
SELECT o.OrderID, e.FirstName
FROM dbo.Orders AS o
JOIN dbo.Employees AS e
ON o.EmployeeID = e.EmployeeID;
--Q3
SELECT e.EmployeeID,t.TerritoryDescription
FROM dbo.EmployeeTerritories AS et
JOIN dbo.Employees AS e
ON e.EmployeeID = et.EmployeeID
JOIN dbo.Territories AS t
ON et.TerritoryID = t.TerritoryID
--Q4
SELECT Country FROM dbo.Customers AS c
UNION
SELECT Country FROM dbo.Suppliers AS s
--Q5
SELECT Country FROM dbo.Customers AS c
UNION ALL
SELECT Country FROM dbo.Suppliers AS s
--Q6
SELECT ROUND(UnitPrice,0)
FROM dbo.Products;
--Q7
SELECT SUM(UnitsInStock)
FROM dbo.Products
--Q8
SELECT OrderID, YEAR(OrderDate)
FROM dbo.Orders
--Q9
SELECT OrderID, DATENAME(m,OrderDate) AS OrderMonth
FROM dbo.Orders
--Q10
SELECT LEFT(RegionDescription,2)
FROM dbo.Region
--Q11
SELECT City, PostalCode
FROM dbo.Suppliers
WHERE ISNUMERIC(PostalCode)= 1;
--Q12
SELECT UPPER(LEFT(RegionDescription,1))
FROM dbo.Region
--Section3
--Q1
--Q2
--Q3 WRONG!
CREATE TABLE #ProductNames (
    ProductName VARCHAR(40));

INSERT INTO #ProductNames
SELECT Products.ProductName 
FROM dbo.Products AS Products;

SELECT* FROM #ProductNames;
--Section4
--Q1
SELECT OrderID, ShippedDate,
CHOOSE (MONTH(o.ShippedDate), 'Winter', 'Winter', 'Spring', 'Spring', 'Spring', 'Summer', 'Summer', 'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter') AS ShippedSeason
FROM dbo.Orders AS o
WHERE o.ShippedDate IS NOT NULL
--Q2 WRONG!!
SELECT CompanyName, IIF (Fax = NULL ,'modern', 'outdated') AS Status
FROM dbo.Suppliers ;
--Q8 WRONG!
DECLARE @region NVARCHAR(25) = 'Space';
IF NOT EXISTS (SELECT * FROM dbo.Region AS Region WHERE RegionDescription = @region)
BEGIN
  THROW 50001, 'Error!', 0;
END
ELSE
BEGIN
  SELECT * FROM Region WHERE RegionDescription = @region
END











































