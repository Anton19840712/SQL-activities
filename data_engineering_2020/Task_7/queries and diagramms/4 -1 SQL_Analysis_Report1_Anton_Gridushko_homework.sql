4. 
-- Prepare sql queries to resolve each of these questions. 
-- Visualize the results using any tool (e.g. Microsoft Excel).
-- • Present the result as a single sql file (name of the sql file should be SQL_Analysis_Name_Surname_homework)
-- • Present the visualization also as a single file

--1. Is your cash flow positive each month?

WITH
first_table AS(
SELECT
	time_id, 
	(unit_price - unit_cost)*quantity_sold AS plus
FROM sh.profits
ORDER BY 
	time_id)
,
second_table AS(
SELECT
	time_id,
	sum(plus) AS plus
FROM first_table
GROUP BY 
	first_table.time_id
ORDER BY time_id)
SELECT 
	DATE_TRUNC('month', time_id), 
	sum(plus) AS plus
FROM second_table
GROUP BY DATE_TRUNC('month', time_id)
ORDER BY DATE_TRUNC('month', time_id);