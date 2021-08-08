--task 1
--In the query results, we get the data about the most significant customers (which have maximum sales) through various sales channels
--The query gets the decision result in four steps:
WITH second_table as(
	SELECT * FROM 
		(WITH initial_table AS( --first: we join all needed tables together to take data separately
			SELECT
				s.channel_id,
				c.channel_desc,
				cus.cust_last_name,
				cus.cust_first_name,
				cus.cust_id,
				sum (s.amount_sold) AS ddamount_sold	
			FROM sh.sales s
			JOIN sh.customers cus ON cus.cust_id = s.cust_id
			JOIN sh.channels c ON s.channel_id = c.channel_id 
			GROUP BY
				cus.cust_id, 
				s.channel_id,
				c.channel_desc
			ORDER BY 
				s.channel_id, 
				ddamount_sold DESC,
				cus.cust_id
		)
	SELECT --second: we take initial table results and add calculations of partition by each sales channel.
		*, 
		(ddamount_sold*100)/SUM(ddamount_sold) OVER (PARTITION BY channel_id) AS sales_percentage,--third: we take only first 5 from data sampling
		row_number() OVER (PARTITION BY channel_id) AS rating_in_section
	FROM first_table)
	rowed_table WHERE rating_in_section <= 5 ORDER BY ddamount_sold DESC) 
SELECT --fourth: we get the data we need
	channel_desc, 
	cust_last_name, 
	cust_first_name, 
	ddamount_sold AS amount_sold, 
	to_char(sales_percentage, '            FM9999.99990 %') AS sales_percentage
FROM second_table ORDER BY channel_desc;
--------------------------------------------------------------------------------------
-- Task2
-- Build the query to generate a report about customers who were included into TOP 300 (based on the amount of sales) in 1998, 1999 and 2001. This 
-- report should separate clients by sales channels, and, at the same time, channels should be calculated independently (i.e. only purchases made on 
-- selected channel are relevant).

WITH fourth_table as(
	WITH third_table as(
		WITH second_table as(
			WITH first_table as(
			SELECT *
				FROM sh.sales s
				JOIN sh.products p ON s.prod_id = p.prod_id
				JOIN sh.customers c ON c.cust_id = s.cust_id
				JOIN sh.countries co ON co.country_id = c.country_id
			WHERE 
				co.country_region = 'Asia'
			AND 
				p.prod_category_desc = 'Photo'
			AND
			EXTRACT (YEAR FROM s.time_id) = 2000
			ORDER BY p.prod_name, s.time_id 
			)
			SELECT
				prod_name, 
				extract(quarter from time_id) as quarter,
				sum(amount_sold) AS common_amount
			FROM first_table 
			GROUP BY
				first_table.time_id,
				first_table.prod_name
			ORDER BY 
				first_table.prod_name
			)
		SELECT 
			second_table.prod_name, 
			second_table.quarter, 
			sum(second_table.common_amount) AS common_amount 
			FROM 
			second_table
		GROUP BY 
			second_table.prod_name, 
			second_table.quarter
		)
	SELECT
		prod_name,
		max(case when third_table.quarter in (1) then third_table.common_amount end) as q1,
		max(case when third_table.quarter in (2) then third_table.common_amount end) as q2,
		max(case when third_table.quarter in (3) then third_table.common_amount end) as q3,
		max(case when third_table.quarter in (4) then third_table.common_amount end) as q4
	from third_table
	group by
		prod_name
	order by
		prod_name
	)
 SELECT 
	 *,
	 coalesce (q1,0) + coalesce (q2,0) + coalesce (q3,0) + coalesce (q4,0) AS year_sum FROM fourth_table;
--------------------------------------------------------------------------------------
--task3
-- Build the query to generate a report about customers who were included into TOP 300 (based on the amount of sales) in 1998, 1999 and 2001. This 
-- report should separate clients by sales channels, and, at the same time, channels should be calculated independently (i.e. only purchases made on 
-- selected channel are relevant).
SELECT
	DISTINCT
	ch.channel_desc,
	s.cust_id,
	c.cust_last_name,
	c.cust_first_name,
	SUM(s.amount_sold) OVER (PARTITION BY ch.channel_desc || s.cust_id)
	FROM sh.customers c
JOIN sales s ON c.cust_id = s.cust_id
JOIN channels ch ON s.channel_id = ch.channel_id
WHERE s.cust_id IN (SELECT cust_id 
	FROM (SELECT s.cust_id, sum(s.amount_sold) 
		FROM sales s
			WHERE EXTRACT (YEAR FROM s.time_id) IN (1998, 1999, 2001)
			GROUP BY s.cust_id
			ORDER BY sum(s.amount_sold) DESC LIMIT 300) returned_ids)
ORDER BY cust_id DESC, sum DESC;

--------------------------------------------------------------------------------------
---task4
--Build the query to generate the report about sales in America and Europe:

WITH sales_table AS (SELECT 
	DISTINCT
	t.calendar_month_desc, 
	p.prod_category, 
	cntr.country_region,
	SUM(s.amount_sold) OVER (PARTITION BY p.prod_category||cntr.country_region||t.calendar_month_desc)
FROM sales s
	JOIN times t ON s.time_id = t.time_id
	JOIN products p ON s.prod_id = p.prod_id
	JOIN customers c ON s.cust_id = c.cust_id
	JOIN countries cntr ON c.country_id = cntr.country_id
WHERE t.calendar_month_desc IN ('2000-01','2000-02','2000-03') AND cntr.country_region IN ('Europe','Americas')
ORDER BY p.prod_category)
SELECT
	calendar_month_desc,
	prod_category,
    max(case when sales_table.country_region in ('Americas') then sales_table.sum end) as "Americas SALES",
    max(case when sales_table.country_region in ('Europe') then sales_table.sum end) as "Europe SALES"
from sales_table
group by
    prod_category,
    calendar_month_desc
ORDER BY
	calendar_month_desc,
    prod_category;