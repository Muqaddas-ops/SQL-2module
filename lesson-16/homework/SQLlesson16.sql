

-- Staff Table
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Department NVARCHAR(50),
    Salary DECIMAL(10,2)
);

-- Items Table
CREATE TABLE Items (
    ItemID INT PRIMARY KEY,
    ItemName NVARCHAR(100),
    Price DECIMAL(10,2),
    Quantity INT
);

-- Clients Table
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Email NVARCHAR(100)
);

-- Purchases Table
CREATE TABLE Purchases (
    PurchaseID INT PRIMARY KEY,
    ClientID INT,
    ItemID INT,
    Quantity INT,
    PurchaseDate DATE,
    TotalPrice DECIMAL(10,2),
    Status NVARCHAR(50),
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

-- Sales Table (Revenue Data)
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    StaffID INT,
    ItemID INT,
    QuantitySold INT,
    SaleAmount DECIMAL(10,2),
    SaleDate DATE,
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

-- Delivery Table (For stock updates)
CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY,
    ItemID INT,
    QuantityReceived INT,
    DeliveryDate DATE,
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);
CREATE VIEW vwStaff AS
SELECT * FROM Staff;

CREATE TABLE #TempPurchases (
    PurchaseID INT PRIMARY KEY,
    ClientID INT,
    ItemID INT,
    Quantity INT,
    PurchaseDate DATE
);

INSERT INTO #TempPurchases (PurchaseID, ClientID, ItemID, Quantity, PurchaseDate)
VALUES (1, 101, 1, 3, '2025-03-20'),
       (2, 102, 2, 5, '2025-03-21');

	   DECLARE @currentRevenue DECIMAL(10,2);
SET @currentRevenue = (SELECT SUM(SaleAmount) FROM Sales WHERE MONTH(SaleDate) = MONTH(GETDATE()));

PRINT @currentRevenue;

CREATE FUNCTION fnSquare(@num INT)
RETURNS INT
AS
BEGIN
    RETURN @num * @num;
END;

CREATE PROCEDURE spGetClients
AS
BEGIN
    SELECT * FROM Clients;
END;

MERGE INTO Purchases AS target
USING Clients AS source
ON target.ClientID = source.ClientID
WHEN MATCHED THEN 
    UPDATE SET target.Status = 'Completed'
WHEN NOT MATCHED THEN
    INSERT (ClientID, ItemID, Quantity, PurchaseDate, TotalPrice, Status)
    VALUES (source.ClientID, 1, 2, GETDATE(), 50.00, 'New');

	CREATE PROCEDURE spMonthlyRevenue (@year INT, @month INT)
AS
BEGIN
    SELECT SUM(SaleAmount) AS TotalRevenue
    FROM Sales
    WHERE YEAR(SaleDate) = @year AND MONTH(SaleDate) = @month;
END;
