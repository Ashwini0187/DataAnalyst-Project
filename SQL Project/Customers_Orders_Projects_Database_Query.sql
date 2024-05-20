USE coachx_training


CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100)
);

INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');


  ----------------------------------------------------------------------

  CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT
);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);

  -------------------------------------------------------------------------------------------

  CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);

  -------------------------------------------------------------
  ----------------------------Task 1---------------------------------------
 

  --1.	Write a query to retrieve all records from the Customers table

  SELECT * FROM Customers;

 -- 2.	Write a query to retrieve the names and email addresses of customers whose names start with 'J'.

   SELECT Name, Email
	FROM Customers
	WHERE Name LIKE 'J%';


	--3.	Write a query to retrieve the order details (OrderID, ProductName, Quantity) for all orders..

	SELECT o.OrderID, o.ProductName, o.Quantity
	FROM Orders o
	JOIN Products p ON o.ProductName = p.ProductName;

	--4.	Write a query to calculate the total quantity of products ordered.

	SELECT SUM(Quantity) AS TotalQuantity
	FROM Orders;

	--5.	Write a query to retrieve the names of customers who have placed an order.

	SELECT DISTINCT c.Name
	FROM Customers c
	INNER JOIN Orders o ON c.CustomerID = o.CustomerID;

	--6.	Write a query to retrieve the products with a price greater than $10.00.

	SELECT *
	FROM Products
	WHERE Price > 10.00;

	--7.	Write a query to retrieve the customer name and order date for all orders placed on or after '2023-07-05'.

	SELECT c.Name AS CustomerName, o.OrderDate
	FROM Customers c
	INNER JOIN Orders o ON c.CustomerID = o.CustomerID
	WHERE o.OrderDate >= '2023-07-05';

	--8.	Write a query to calculate the average price of all products.

	SELECT AVG(Price) AS AveragePrice
	FROM Products;

	--9.	Write a query to retrieve the customer names along with the total quantity of products they have ordered.

	SELECT c.Name AS CustomerName, SUM(o.Quantity) AS TotalQuantity
	FROM Customers c
	JOIN Orders o ON c.CustomerID = o.CustomerID
	GROUP BY c.Name;

	--10.	Write a query to retrieve the products that have not been ordered.
	SELECT p.*
	FROM Products p
	LEFT JOIN Orders o ON p.ProductName = o.ProductName
	WHERE o.ProductName IS NULL;

	-----------------------------------------------------------------------------------------------------
	--------------------------------------------------Task 2----------------------------------------------

	--1.	Write a query to retrieve the top 5 customers who have placed the highest total quantity of orders.

	SELECT  c.Name AS CustomerName, SUM(o.Quantity) AS TotalQuantity
	FROM Customers c
	JOIN Orders o ON c.CustomerID = o.CustomerID
	GROUP BY c.Name
	ORDER BY TotalQuantity DESC 
	LIMIT 5


	-- 2.	Write a query to calculate the average price of products for each product category.

	SELECT p.ProductCategory, AVG(p.Price) AS AveragePrice
	FROM Products p
	GROUP BY p.ProductCategory;

--	3.	Write a query to retrieve the customers who have not placed any orders.

	SELECT c.CustomerID, c.Name, c.Email
	FROM Customers c
	LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
	WHERE o.OrderID IS NULL

	--4.	Write a query to retrieve the order details (OrderID, ProductName, Quantity) for orders
		--  placed by customers whose names start with 'M'.
	
	SELECT o.OrderID, o.ProductName, o.Quantity
	FROM Orders o
	JOIN Customers c ON o.CustomerID = c.CustomerID
	WHERE c.Name LIKE 'M%';

	--5.	Write a query to calculate the total revenue generated from all orders.

	  SELECT SUM(o.Quantity * p.Price) AS TotalRevenue
	FROM Orders o
	JOIN Products p ON o.ProductName = p.ProductName;

	--6.	Write a query to retrieve the customer names along with the total revenue generated from their orders.

	SELECT
    c.Name AS CustomerName,
    SUM(o.Quantity * p.Price) AS TotalRevenue
	FROM
    Customers c
	JOIN
    Orders o ON c.CustomerID = o.CustomerID
	JOIN
    Products p ON o.ProductName = p.ProductName
	GROUP BY
    c.CustomerID, c.Name;

	-- 7.	Write a query to retrieve the customers who have placed at least one order for each product category.

	SELECT
    c.CustomerID,
    c.Name AS CustomerName
	FROM
    Customers c
	WHERE
    (
        SELECT
            COUNT(DISTINCT p.ProductName)
        FROM
            Products p
        WHERE
            p.ProductName IN (
                SELECT
                    DISTINCT o.ProductName
                FROM
                    Orders o
                WHERE
                    o.CustomerID = c.CustomerID
            )
    ) = (SELECT COUNT(*) FROM Products);


	--8.	Write a query to retrieve the customers who have placed orders on consecutive days.

	SELECT DISTINCT
    c.CustomerID,
    c.Name AS CustomerName
	FROM
    Customers c
	JOIN
    Orders o1 ON c.CustomerID = o1.CustomerID
	JOIN
    Orders o2 ON c.CustomerID = o2.CustomerID
	WHERE
    o1.OrderDate = DATE_SUB(o2.OrderDate, INTERVAL 1 DAY)
    OR o1.OrderDate = DATE_ADD(o2.OrderDate, INTERVAL 1 DAY);

	--9.	Write a query to retrieve the top 3 products with the highest average quantity ordered.

	SELECT
    ProductName,
    AVG(Quantity) AS AverageQuantityOrdered
	FROM
    Orders
	GROUP BY
    ProductName
	ORDER BY
    AverageQuantityOrdered DESC
	LIMIT 3;

	--10.	Write a query to calculate the percentage of orders that have a quantity greater than the average quantity.

	SELECT
    (COUNT(CASE WHEN Quantity > avg_quantity THEN 1 END) / COUNT(*)) * 100 AS PercentageOrders
	FROM
    Orders,
    (SELECT AVG(Quantity) AS avg_quantity FROM Orders) AS avg_table;

-------------------------------------------------------------------------------------------------------
-- -----------  ----------------------------Task 3---------------------------------------
--1.	Write a query to retrieve the customers who have placed orders for all products.

SELECT 
    c.CustomerID,
    c.Name AS CustomerName
FROM 
    Customers c
WHERE 
    NOT EXISTS (
        SELECT 
            p.ProductID 
        FROM 
            Products p
        WHERE 
            NOT EXISTS (
                SELECT 
                    1 
                FROM 
                    Orders o 
                WHERE 
                    o.CustomerID = c.CustomerID AND o.ProductName = p.ProductName
            )
    );


---2.	Write a query to retrieve the products that have been ordered by all customers.

		SELECT 
    p.ProductID,
    p.ProductName
	FROM 
    Products p
	WHERE 
    NOT EXISTS (
        SELECT 
            c.CustomerID
        FROM 
            Customers c
        WHERE 
            NOT EXISTS (
                SELECT 
                    1 
                FROM 
                    Orders o 
                WHERE 
                    o.CustomerID = c.CustomerID AND o.ProductName = p.ProductName
            )
    );

	--3. 	Write a query to calculate the total revenue generated from orders placed in each month.

	SELECT
    DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
    SUM(Quantity * Price) AS TotalRevenue
	FROM
    Orders
	JOIN
    Products ON Orders.ProductName = Products.ProductName
	GROUP BY
    DATE_FORMAT(OrderDate, '%Y-%m')
	ORDER BY
    Month;

	--4.	Write a query to retrieve the products that have been ordered by more than 50% of the customers.

	SELECT
    p.ProductID,
    p.ProductName
	FROM
    Products p
	JOIN
    Orders o ON p.ProductName = o.ProductName
	GROUP BY
    p.ProductID, p.ProductName
	HAVING
    COUNT(DISTINCT o.CustomerID) > (SELECT COUNT(*) * 0.5 FROM Customers);

	--5.	Write a query to retrieve the top 5 customers who have spent the highest amount of money on orders.

	SELECT
    c.CustomerID,
    c.Name AS CustomerName,
    SUM(o.Quantity * p.Price) AS TotalAmountSpent
	FROM
    Customers c
	JOIN
    Orders o ON c.CustomerID = o.CustomerID
	JOIN
    Products p ON o.ProductName = p.ProductName
	GROUP BY
    c.CustomerID, c.Name
	ORDER BY
    TotalAmountSpent DESC
	LIMIT 5;

	--6.	Write a query to calculate the running total of order quantities for each customer.

	SELECT
    CustomerID,
    OrderID,
    ProductName,
    OrderDate,
    Quantity,
    SUM(Quantity) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal
	FROM
    Orders
	ORDER BY
    CustomerID, OrderDate;

	--7.	Write a query to retrieve the top 3 most recent orders for each customer.

	SELECT 
    CustomerID,
    OrderID,
    ProductName,
    OrderDate,
    Quantity
FROM (
    SELECT 
        CustomerID,
        OrderID,
        ProductName,
        OrderDate,
        Quantity,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RowNum
    FROM 
        Orders
) AS RankedOrders
WHERE 
    RowNum <= 3
ORDER BY 
    CustomerID, OrderDate DESC;

	--8.	Write a query to calculate the total revenue generated by each customer in the last 30 days.

	SELECT
    c.CustomerID,
    c.Name AS CustomerName,
    SUM(o.Quantity * p.Price) AS TotalRevenueLast30Days
FROM
    Customers c
JOIN
    Orders o ON c.CustomerID = o.CustomerID
JOIN
    Products p ON o.ProductName = p.ProductName
WHERE
    o.OrderDate >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY
    c.CustomerID, c.Name;


	--9.	Write a query to retrieve the customers who have placed orders for at least two different product categories.

	SELECT
    c.CustomerID,
    c.Name AS CustomerName
	FROM
    Customers c
	JOIN
    Orders o ON c.CustomerID = o.CustomerID
	JOIN
    Products p ON o.ProductName = p.ProductName
	GROUP BY
    c.CustomerID, c.Name
	HAVING
    COUNT(DISTINCT p.ProductID) >= 2;

	--10.	Write a query to calculate the average revenue per order for each customer.

	SELECT
    o.CustomerID,
    c.Name AS CustomerName,
    SUM(o.Quantity * p.Price) / COUNT(o.OrderID) AS AverageRevenuePerOrder
	FROM
    Orders o
	JOIN
    Customers c ON o.CustomerID = c.CustomerID
	JOIN
    Products p ON o.ProductName = p.ProductName
	GROUP BY
    o.CustomerID, c.Name;

	--11.	Write a query to retrieve the customers who have placed orders for every month of a specific year.

	SELECT 
    c.CustomerID,
    c.Name AS CustomerName
	FROM 
    Customers c
	WHERE 
    (SELECT COUNT(DISTINCT MONTH(OrderDate)) 
     FROM Orders 
     WHERE CustomerID = c.CustomerID 
     AND YEAR(OrderDate) = 'specific_year') = 12;

	 --12.	Write a query to retrieve the customers who have placed orders for a specific product in consecutive months.

	 SELECT
    c.CustomerID,
    c.Name AS CustomerName
	FROM
    Customers c
	WHERE
    EXISTS (
        SELECT 1
        FROM Orders o1
        JOIN Orders o2 ON o1.CustomerID = o2.CustomerID
                     AND o1.ProductName = o2.ProductName
                     AND MONTH(o1.OrderDate) = MONTH(o2.OrderDate) - 1
                     AND YEAR(o1.OrderDate) = YEAR(o2.OrderDate)
        WHERE o1.CustomerID = c.CustomerID
          AND o1.ProductName = 'specific_product'
    );

	--13.	Write a query to retrieve the products that have been ordered by a specific customer at least twice.

	SELECT
    o.ProductName
	FROM
    Orders o
	WHERE
    o.CustomerID = 'specific_customer_id'
	GROUP BY
    o.ProductName
	HAVING
    COUNT(*) >= 2;

















