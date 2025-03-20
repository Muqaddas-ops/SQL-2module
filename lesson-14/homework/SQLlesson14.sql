CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(100),
    Salary DECIMAL(10,2),
    HireDate DATE,
    ManagerID INT NULL,
    DepartmentID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    Region VARCHAR(50),
    Amount DECIMAL(10,2),
    OrderDate DATE
);

WITH EmployeeTenure AS (
    SELECT 
        EmployeeID, 
        EmployeeName, 
        HireDate, 
        DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsWorked
    FROM Employees
)
SELECT EmployeeID, EmployeeName, YearsWorked
FROM EmployeeTenure
WHERE YearsWorked > 5;

WITH NumberSequence AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num + 1 
    FROM NumberSequence
    WHERE Num < 10
)
SELECT Num FROM NumberSequence;

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    DepartmentID INT,
    ProductID INT,
    SaleAmount DECIMAL(10,2),
    SaleDate DATE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


WITH Fibonacci AS (
    SELECT 1 AS Term, 0 AS FibValue
    UNION ALL
    SELECT 2, 1
    UNION ALL
    SELECT Term + 1, FibValue + LAG(FibValue) OVER (ORDER BY Term)
    FROM Fibonacci
    WHERE Term < 20
)
SELECT Term, FibValue FROM Fibonacci;

WITH EmployeeTenure AS (
    SELECT 
        EmployeeID, 
        EmployeeName, 
        HireDate, 
        DATEDIFF(YEAR, HireDate, GETDATE()) AS YearsWorked
    FROM Employees
)
SELECT EmployeeID, EmployeeName, YearsWorked
FROM EmployeeTenure
WHERE YearsWorked > 5;

WITH NumberSequence AS (
    SELECT 1 AS Num
    UNION ALL
    SELECT Num + 1 
    FROM NumberSequence
    WHERE Num < 10
)
SELECT Num FROM NumberSequence;

WITH Fibonacci AS (
    SELECT 1 AS Term, 0 AS FibValue
    UNION ALL
    SELECT 2, 1
    UNION ALL
    SELECT Term + 1, FibValue + LAG(FibValue) OVER (ORDER BY Term)
    FROM Fibonacci
    WHERE Term < 20
)
SELECT Term, FibValue FROM Fibonacci;

SELECT Region, SUM(TotalRevenue) AS TotalSales
FROM (
    SELECT Region, OrderID, SUM(Amount) AS TotalRevenue
    FROM Orders
    GROUP BY Region, OrderID
) AS RevenueByRegion
GROUP BY Region;

WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal FROM Employees
)
SELECT EmployeeID, EmployeeName, Salary
FROM Employees
WHERE Salary > (SELECT AvgSal FROM AvgSalary);

WITH MonthlySales AS (
    SELECT 
        FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth,
        SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY FORMAT(SaleDate, 'yyyy-MM')
)
SELECT 
    m1.SaleMonth, 
    m1.TotalSales, 
    (m1.TotalSales - COALESCE(m2.TotalSales, 0)) AS SalesDifference
FROM MonthlySales m1
LEFT JOIN MonthlySales m2 
ON DATEADD(MONTH, 1, m2.SaleMonth) = m1.SaleMonth;