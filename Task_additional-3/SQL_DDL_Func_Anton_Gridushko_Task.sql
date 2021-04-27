--DROP FUNCTION get_customers_rental_activity;
CREATE OR REPLACE FUNCTION get_customers_rental_activity (IN i_client_id INTEGER, i_left_boundary DATE, i_right_boundary DATE) 
RETURNS TABLE ("metric_name#" TEXT, "metric_value#"  TEXT) 
	LANGUAGE plpgsql
AS $$
BEGIN
	RETURN query
WITH first_table AS(
SELECT
	p.payment_id,
	f.film_id, 
	f.title,
	p.amount,
	p.customer_id
 FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON f.film_id = i.film_id
    WHERE r.rental_date >= (i_left_boundary::DATE)
    AND r.rental_date <= (i_right_boundary::DATE)
    AND p.customer_id = i_client_id)
SELECT 'customer''s info#' AS "name", first_name || ', ' || last_name || ', ' || email AS "value" FROM customer c WHERE customer_id = i_client_id
	UNION ALL
SELECT 'num.of films rented#' AS "name", COUNT(first_table.film_id)::VARCHAR(5)  AS "value" FROM first_table
	UNION ALL
SELECT 'rented film''s titles#' AS "name", array_to_string(array_agg(DISTINCT first_table.title), ', ') AS "value" FROM first_table
	UNION ALL
SELECT 'num.of payments#' AS "name", count(first_table.payment_id)::VARCHAR(5) AS "value" FROM first_table
	UNION ALL
SELECT 'payment''s amount#' AS "name", sum(first_table.amount)::varchar(5) AS "value" FROM first_table;
end;$$
--SELECT * FROM get_customers_rental_activity(60, '2005-05-03', '2017-05-03');
