INSERT INTO Employees (EmployeeID, EmployeeName, ManagerID) VALUES (1, 'John Doe', NULL), (2, 'Jane Smith', 1), (3, 'Michael Brown', 1), (4, 'Emily Davis', 2), (5, 'Daniel Wilson', 2), (6, 'Olivia Taylor', 3), (7, 'Matthew Anderson', 3), (8, 'Sophia Thomas', 4), (9, 'David Jackson', 4), (10, 'Emma White', 5), (11, 'James Harris', 5), (12, 'Lucas Martin', 6), (13, 'Ava Thompson', 6), (14, 'Alexander Garcia', 7), (15, 'Mia Martinez', 7), (16, 'Elijah Robinson', 8), (17, 'Charlotte Clark', 8), (18, 'Benjamin Lewis', 9), (19, 'Amelia Hall', 9), (20, 'William Allen', 10);

SELECT e.EmployeeID, e.EmployeeName, m.EmployeeName AS ManagerName
FROM Employees e
LEFT JOIN (SELECT EmployeeID, EmployeeName FROM Employees) AS m
ON e.ManagerID = m.EmployeeID;

---Explanation:
--The derived table (m) contains EmployeeID and EmployeeName to represent managers.
--The main query joins Employees (e) with m to fetch manager names.


WITH ManagerCTE AS (
    SELECT EmployeeID, EmployeeName FROM Employees
)
SELECT e.EmployeeID, e.EmployeeName, m.EmployeeName AS ManagerName
FROM Employees e
LEFT JOIN ManagerCTE m
ON e.ManagerID = m.EmployeeID;

--Explanation:
--The CTE (ManagerCTE) stores EmployeeID and EmployeeName.
--It’s then joined with Employees to get the corresponding manager names.

WITH EmployeeHierarchy AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL -- Root level (Top Manager)

    UNION ALL

    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, eh.Level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT * FROM EmployeeHierarchy ORDER BY Level, EmployeeID;


--Explanation:
--The base case starts with employees who have no managers (top-level managers).
--The recursive query finds employees reporting to each manager, increasing the Level.

WITH EmployeeLevels AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, el.Level + 1
    FROM Employees e
    INNER JOIN EmployeeLevels el ON e.ManagerID = el.EmployeeID
)
SELECT Level, COUNT(*) AS EmployeeCount
FROM EmployeeLevels
GROUP BY Level
ORDER BY Level;

--Explanation:
--The recursive CTE builds the employee hierarchy.
--The final query counts employees at each level.

WITH HierarchyDepth AS (
    SELECT EmployeeID, EmployeeName, ManagerID, 1 AS Level
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT e.EmployeeID, e.EmployeeName, e.ManagerID, hd.Level + 1
    FROM Employees e
    INNER JOIN HierarchyDepth hd ON e.ManagerID = hd.EmployeeID
)
SELECT MAX(Level) AS MaxDepth FROM HierarchyDepth;

--Explanation:
--The recursive CTE assigns levels to employees.
--The final query finds the maximum level, which represents the deepest hierarchy.