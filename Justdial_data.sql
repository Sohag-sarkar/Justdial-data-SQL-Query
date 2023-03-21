-- Show table content
SELECT * FROM don.justdial;

-- Finding time gap in and out for everyday
WITH CTE1 AS(
SELECT * ,
CASE
WHEN Attribute = "Incoming" THEN (CAST(Time AS TIME) - CAST(Ideal_time AS TIME))/100
WHEN Attribute = "Outgoing" THEN (((CAST(Ideal_time AS TIME) -CAST(Time AS TIME))/100) - 40)
END AS Time_gap
FROM don.justdial)
SELECT * FROM CTE1;


-- Add above result to a new table
USE don;
CREATE TABLE justdial_attendance AS 
SELECT * ,
CASE
WHEN Attribute = "Incoming" THEN (CAST(Time AS TIME) - CAST(Ideal_time AS TIME))/100
WHEN Attribute = "Outgoing" THEN (((CAST(Ideal_time AS TIME) -CAST(Time AS TIME))/100) - 40)
END AS Time_gap
FROM don.justdial;
SELECT * FROM don.justdial_attendance;


-- Find everyday delay for employee and store it into new table
USE don;
CREATE TABLE justdial_Short_leave AS
SELECT Emp_id, Date, 
CASE
WHEN Time_gap> 5 THEN 1 ELSE 0
END AS Short_leave
FROM don.justdial_attendance;
SELECT * FROM don.justdial_short_leave
ORDER BY Emp_id ASC;


-- Find daily short leave status
USE don;
DROP TABLE IF EXISTS justdial_sl_count;
CREATE TABLE justdial_sl_count AS
SELECT * , SUM(Short_leave) AS sl_count
FROM don.justdial_short_leave
Group by Emp_id, Date
ORDER BY Emp_id ASC;


-- Count of employees having short leave
SELECT COUNT(Emp_id) FROM
(SELECT Emp_id, SUM(Short_leave) as Short_leave_days
FROM don.justdial_sl_count
GROUP BY Emp_id
ORDER BY Emp_id) AS Day_count;


-- Total Short leave of each employee
SELECT Emp_id, SUM(Short_leave) as Short_leave_days
FROM don.justdial_sl_count
GROUP BY Emp_id
ORDER BY Emp_id;