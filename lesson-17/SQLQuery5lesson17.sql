

SELECT s1.* 
FROM staff s1
WHERE s1.salary > (
    SELECT AVG(s2.salary) 
    FROM staff s2 
    WHERE s2.division_id = s1.division_id
)
AND s1.salary < (
    SELECT MAX(s3.salary) 
    FROM staff s3 
    WHERE s3.division_id = s1.division_id
);

SELECT DISTINCT i.*
FROM items i
WHERE i.item_id IN (
    SELECT od.item_id
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    WHERE o.client_id IN (
        SELECT client_id
        FROM orders
        GROUP BY client_id
        HAVING COUNT(order_id) > 5
    )
);

SELECT * 
FROM staff
WHERE age > (SELECT AVG(age) FROM staff)
AND salary > (SELECT AVG(salary) FROM staff);

SELECT s1.*
FROM staff s1
WHERE s1.division_id IN (
    SELECT s2.division_id
    FROM staff s2
    WHERE s2.salary > 100000
    GROUP BY s2.division_id
    HAVING COUNT(s2.staff_id) > 5
);