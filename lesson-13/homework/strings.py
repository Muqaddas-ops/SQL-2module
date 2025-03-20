---String Functions in SQL Server
--1. LEN vs. DATALENGTH
--LEN(): Returns the number of characters in a string (excluding trailing spaces).
--DATALENGTH(): Returns the storage size in bytes (includes trailing spaces).
--2. CHARINDEX Usage
--Finds the position of a substring within a string.
--Useful for searching specific words or characters.
--3. CONCAT vs. + Operator
--CONCAT(): Automatically handles NULL values.
--+ Operator: Returns NULL if any operand is NULL.
--4. REPLACE Function Usage
--Used to replace occurrences of a substring within a string.
--Example: Replacing old product names with new ones in a dataset.
--5. SUBSTRING Function
--Extracts a portion of a string based on start position and length.
--Useful for extracting domain names from emails.
--Mathematical Functions in SQL Server
--6. ROUND Function
--Rounds a number to a specified decimal place.
--Used in financial calculations to format monetary values.
--7. ABS Function
--Returns the absolute (positive) value of a number.
--Example: ABS(-10) → 10
--8. POWER vs. EXP
--POWER(x, y): Computes x raised to the power of y.
--EXP(x): Computes e raised to the power of x (natural exponent).
--9. CEILING vs. FLOOR
--CEILING(): Rounds up to the next integer.
--FLOOR(): Rounds down to the nearest integer.
--Date and Time Functions in SQL Server
--10. GETDATE Function
--Returns the current system date and time.
--11. DATEDIFF Function
--Calculates the difference between two dates in specified units (days, months, years).
--12. DATEADD Function
--Adds/subtracts a specified interval to/from a date.
--Example: DATEADD(DAY, 10, '2025-03-19') → '2025-03-29'
--13. FORMAT Function
--Formats date/time values into a specified format.
--Example: FORMAT(GETDATE(), 'yyyy-MM-dd')
--Query Examples
--14. String Functions Query
--SELECT CHARINDEX('SQL', 'SQL Server'), REPLACE('Hello SQL', 'SQL', 'Database');
--Finds "SQL" in a string and replaces "SQL" with "Database".
--15. Mathematical Functions Query
--SELECT ROUND(123.456, 2), ABS(-50), POWER(2, 3);
--Rounds, gets absolute value, and computes exponentiation.
--16. Date/Time Functions Query
--SELECT GETDATE(), DATEADD(DAY, 5, GETDATE()), DATEDIFF(DAY, '2025-01-01', GETDATE());
--Retrieves the current date, adds 5 days, and finds the difference in days.
--Use Cases and Performance in SQL Server
--17. Performance Considerations
--Excessive function use in WHERE clauses can slow queries by preventing index usage.
--18. Query Optimization with Functions
--LEN() in data validation, ROUND() in financial reports, DATEDIFF() in age calculations.
--19. When to Avoid Functions
--Avoid in WHERE clauses for indexed columns to improve performance.
--Avoid FORMAT() in large datasets due to its high CPU usage.

CREATE TABLE CountSpaces ( texts VARCHAR(100) );
INSERT INTO CountSpaces(texts) 
VALUES 
    ('P Q R S '), 
    (' L M N O 0 0 '), 
    ('I am here only '), 
    (' Welcome to the new world '), 
    (' Hello world program'), 
    (' Are u nuts ');
	SELECT * FROM CountSpaces;
SELECT texts, 
       LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

SELECT texts, 
       (DATALENGTH(texts) - DATALENGTH(REPLACE(texts, ' ', ''))) / DATALENGTH(' ') AS SpaceCount
FROM CountSpaces;

SELECT texts, 
       COUNT(*) - 1 AS SpaceCount
FROM CountSpaces
CROSS APPLY STRING_SPLIT(texts, ' ')
GROUP BY texts;

WITH CTE AS (
    SELECT texts, 
           CHARINDEX(' ', texts) AS pos, 
           1 AS count
    FROM CountSpaces
    WHERE CHARINDEX(' ', texts) > 0
    UNION ALL
    SELECT texts, 
           CHARINDEX(' ', texts, pos + 1), 
           count + 1
    FROM CTE
    WHERE CHARINDEX(' ', texts, pos + 1) > 0
)
SELECT texts, MAX(count) AS SpaceCount
FROM CTE
GROUP BY texts;
