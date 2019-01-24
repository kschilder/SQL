--OPDRACHT 2.1
--Selecteer alle klanten (CUSTOMERID, COMPANYNAME) die in London wonen en minder dan 5 orders hebben gedaan. 
--Orden het resultaat op aantal geplaatste orders.

USE [Northwind]
GO

SELECT Orders.CustomerID, CompanyName, Count(OrderID) as Total_Orders
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID

WHERE Orders.CustomerID IN (SELECT CustomerID FROM Customers WHERE City = 'London') 
GROUP BY Orders.CustomerID, Customers.CompanyName
HAVING Count(OrderID) <5
ORDER BY Total_Orders
GO

--Opdracht 2.2
--Selecteer alle orders voor “Pavlova” met een salesresultaat van minstens 800.

SELECT OrderID, ProductID, (Quantity * UnitPrice * (1-Discount)) as SalesTotal
FROM [Order Details] 

WHERE ProductID IN (SELECT ProductID FROM Products WHERE ProductName = 'Pavlova') 
AND (Quantity * UnitPrice * (1-Discount)) >= 800
ORDER BY OrderID
GO

--Opdracht 2.3 
--Selecteer alle regio’s (REGIONDESCRIPTION) waarin het product “Chocolade” is verkocht.
-- RegionID in Regions naar TerritoryID in Territories naar EmployeeID in EmployeeTerritories naar Orders van OrderID naar Order Details van ProductID naar Products

SELECT RegionDescription
FROM Region
WHERE RegionID IN (SELECT RegionID FROM Territories WHERE TerritoryID in
	(SELECT TerritoryID FROM EmployeeTerritories WHERE EmployeeID in
	(SELECT EmployeeID FROM Orders WHERE OrderID in
	(SELECT OrderID FROM [Order Details] WHERE ProductID in
	(SELECT ProductID FROM Products WHERE ProductName = 'Chocolade'
	)))))

--Opdracht 2.4
--Selecteer alle orders (ORDERID, CUSTOMER.COMPANYNAME) voor het product “Tofu” waar de ‘freight’ kosten tussen 25 en 50 waren.
-- Product onder Products via ProductID naar Order Details via OrderID naar Orders. Freight staat in Orders

SELECT OrderID, Customers.CompanyName
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE OrderID IN(SELECT OrderID FROM [Order Details] WHERE ProductID in
	(SELECT ProductID FROM Products WHERE ProductName = 'Tofu'))
	AND Freight BETWEEN 25 AND 50

--Opdracht 2.5
--Selecteer de plaatsnamen waarin zowel klanten als werknemers wonen. Gebruik een subquery voor deze opdracht.
--Employees heeft City, Customers heeft City

SELECT DISTINCT City 
FROM Employees
WHERE City IN(SELECT City FROM Customers)

--Opdracht 2.6
--Welke producten (PRODUCTID, PRODUCTNAME) zijn het meest verkocht (aantal) voor Duitse klanten, 
--en welke werknemers (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE) hebben deze producten verkocht? 
--Orden het resultaat op aantal. Toon alleen de top 5 resultaten.

SELECT DISTINCT Products.ProductID, Products.ProductName, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
FROM Orders
JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
JOIN Products ON Products.ProductID = [Order Details].ProductID
JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE Products.ProductID in
(
SELECT TOP 5 [Order Details].ProductID
FROM [Order Details]
JOIN Orders ON Orders.OrderID = [Order Details].OrderID
JOIN Products ON Products.ProductID = [Order Details].ProductID
JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.Country = 'Germany'
GROUP BY [Order Details].ProductID
ORDER BY SUM(Quantity) desc) AND Customers.Country = 'Germany'
ORDER BY Products.ProductID

--Opdracht 2.7
--Welke producten (PRODUCTID, PRODUCTNAME) zorgden voor de hoogste salesresultaten (SALESRESULT) voor Duitse klanten, 
--en welke werknemers (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE) hebben deze producten verkocht. 
--Orden op sales resultaat. Toon alleen de top 5 resultaten.

SELECT Products.ProductID, Products.ProductName, CONVERT(Decimal (10, 2),SUM(Quantity * [Order Details].UnitPrice * (1-Discount))) as SalesResult, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
FROM [Order Details]
JOIN Orders ON Orders.OrderID = [Order Details].OrderID
JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
JOIN Products ON Products.ProductID = [Order Details].ProductID
JOIN Customers ON Customers.CustomerID = Orders.CustomerID

WHERE Products.ProductID in
(
SELECT TOP 5 Products.ProductID
FROM [Order Details]
JOIN Orders ON Orders.OrderID = [Order Details].OrderID
JOIN Products ON Products.ProductID = [Order Details].ProductID
JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.Country = 'Germany'
GROUP BY Products.ProductID
ORDER BY SUM(Quantity * [Order Details].UnitPrice * (1-Discount)) desc) AND Customers.Country = 'Germany'
GROUP BY Products.ProductID, Products.ProductName, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
ORDER BY Products.ProductID

--Opdracht 2.8
--Join de tabellen Products en Suppliers. Inner Join, left join, right join, full join
SELECT *, Suppliers.*
FROM Products
INNER JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID 
SELECT *, Suppliers.*
FROM Products
LEFT JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID 
SELECT *, Suppliers.*
FROM Products
RIGHT JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID 
SELECT *, Suppliers.*
FROM Products
JOIN Suppliers ON Suppliers.SupplierID = Products.SupplierID 

--Opdracht 2.9
--Geef het gemiddelde resultaat van elke werknemer (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, AVARAGE_SALESRESULT). Orden op salesresultaat.
SELECT Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, CONVERT(Decimal (10, 2), AVG(Quantity * UnitPrice * (1-Discount))) as AverageSalesResult
FROM Orders
JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
GROUP BY Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title
ORDER BY AverageSalesResult desc



