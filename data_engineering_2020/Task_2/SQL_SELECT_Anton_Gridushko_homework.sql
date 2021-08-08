--1.1
--All comedy movies released between 2000 and 2004, alphabetical

SELECT  f.title AS comedy_movies_list_2000_2004, 
		f.release_year
FROM film f
RIGHT JOIN film_category fc 
ON f.film_id = fc.film_id
WHERE fc.category_id = 5
AND f.release_year >=2000
AND f.release_year <=2004
ORDER BY fc.film_id;

--1.2
--Revenue of every rental store for year 2017 (columns: address and address2 – as one column, revenue)

WITH revenue_by_store AS(
SELECT
		c.store_id, --take stores for all customers
		CONCAT(a.address, a.address2) AS composite_address,
		SUM(p.amount) AS revenue
FROM customer c
		LEFT JOIN address a ON a.address_id = c.address_id --take addresses where customers made their payments
		LEFT JOIN payment p ON c.customer_id = p.customer_id --identify all payments of each customer by address and store
		WHERE EXTRACT (YEAR FROM p.payment_date) = 2017 --and for 2017 year
		GROUP BY c.customer_id, composite_address
		ORDER BY c.store_id, c.address_id)
SELECT 
		*, 
		ROUND(SUM(revenue) OVER (PARTITION BY store_id),0) AS sum_by_each_store_id --then show amount by each store, by each street separately in the last column, 
		-- but we could also use group by function to show only two rows by store id smth like: select store_id, sum(revenue) from revenue_by_store group by store_id.
		-- but I think my variant detalizes data better.
FROM revenue_by_store;

--1.3
--Top-3 actors by number of movies they took part in (columns: first_name, last_name, number_of_movies, sorted by
--number_of_movies in descending order)

SELECT  a.first_name,
		a.last_name,
		COUNT(fa.actor_id) AS number_of_movies
FROM film_actor fa
RIGHT JOIN actor a ON fa.actor_id = a.actor_id 
GROUP BY fa.actor_id, a.actor_id
ORDER BY number_of_movies desc
FETCH FIRST 3 ROWS ONLY;

--1.4 
--Number of comedy, horror and action movies per year (columns: release_year, number_of_action_movies,
--number_of_horror_movies, number_of_comedy_movies), sorted by release year in descending order

SELECT 	release_year,
		SUM(CASE WHEN category_id = 1 THEN 1 ELSE 0 END) AS number_of_action_movies,
		SUM(CASE WHEN category_id = 5 THEN 1 ELSE 0 END) AS number_of_comedy_movies,
		SUM(CASE WHEN category_id = 11 THEN 1 ELSE 0 END) AS number_of_horror_movies
		FROM 
		(SELECT f.film_id, fc.category_id, f.release_year
		 FROM film f 
		 RIGHT JOIN film_category fc ON f.film_id = fc.film_id
		 RIGHT JOIN category c ON fc.category_id = c.category_id
		 WHERE c.category_id IN ('11','5', '1')
		 ) AS ff
GROUP BY release_year
ORDER BY release_year desc;

--2.1
--Which staff members made the highest revenue for each store and deserve a bonus for 2017 year?

WITH revenue_by_stuff_on_store as(
  SELECT s.staff_id AS id_that_deserved_money_bonus, s.store_id, SUM (p.amount) AS revenue
	FROM staff s
	LEFT JOIN payment p ON s.staff_id = p.staff_id
	WHERE EXTRACT (YEAR FROM p.payment_date) = 2017 --for 2017 year
	GROUP BY s.staff_id, s.store_id
	ORDER BY s.staff_id)
SELECT * FROM revenue_by_stuff_on_store
WHERE (revenue_by_stuff_on_store.store_id, revenue_by_stuff_on_store.revenue) IN 
	(SELECT revenue_by_stuff_on_store.store_id, MAX(revenue_by_stuff_on_store.revenue) AS maxrevenue_for_group
	 FROM revenue_by_stuff_on_store
	 GROUP BY revenue_by_stuff_on_store.store_id);

--2.2
--Which 5 movies were rented more than others and what's expected audience age for those movies?

WITH ss as(
			SELECT  f.film_id, 
					f.title, 
					f.rental_duration, 
					f.rental_rate, 
					f.rating, 
					r.rental_id, 
					i.inventory_id
			FROM film f, rental r, inventory i
			WHERE f.film_id = i.film_id
			AND r.inventory_id = i.inventory_id
			ORDER BY f.rental_rate, f.rental_duration)
SELECT 	ss.film_id, 
		ss.title AS film_name, 
		ss.rating AS age_rating, 
		count(ss.rental_id) AS number_of_rents,
		CASE
		    WHEN ss.rating = 'PG' THEN 'Parents might not like for their young children'
		    WHEN ss.rating = 'PG-13' THEN 'For children <=12 years old '
		    WHEN ss.rating = 'NC-17' THEN 'For people => 18 years old'
		END AS expected_age_audience
FROM ss 
GROUP BY ss.film_id, ss.title, ss.rating
ORDER BY count(ss.rental_id) DESC
LIMIT 5;


--2.3 
--Which actors/actresses didn't act for a longer period of time than others?

WITH first_tabe AS( --take all films due to person's id
SELECT  a.actor_id, 
		a.first_name, 
		a.last_name,
		fa.film_id,
		f.release_year
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
ORDER BY a.actor_id, f.release_year
)
, 
second_table AS( --then from the first_table we take LAG and calculate difference between years
				SELECT *, 
				release_year - LAG(release_year,1) OVER (ORDER BY actor_id) actor_downtime_diffYears 
				FROM first_tabe
				)
SELECT  second_table.actor_id, 
		CONCAT (second_table.first_name, ' ',second_table.last_name) AS actor, 
		max(second_table.actor_downtime_diffYears) AS actor_downtime_in_years --we take max value among all diff years by person's id
		FROM second_table 
GROUP BY second_table.actor_id,second_table.first_name, second_table.last_name
ORDER BY actor_downtime_in_years DESC;

--	↓	↓	↓	↓ THE SAME TASK, BUT WITHOUT WINDOW FUNCTION CALLED LAG	↓	↓	↓	↓
--2.3 
--Which actors/actresses didn't act for a longer period of time than others?

WITH first_tabe AS( --take all films due to person's id
SELECT  a.actor_id, 
		a.first_name, 
		a.last_name,
		fa.film_id,
		f.release_year
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
ORDER BY a.actor_id, f.release_year
)
, 
second_table AS( --then from the first_table we take LAG and calculate difference between years
				SELECT *,
				release_year,
				release_year-max(release_year) over(order by actor_id rows between 1 preceding and 1 preceding) actor_downtime_diffYears
				FROM first_tabe
				)
SELECT  second_table.actor_id, 
		CONCAT (second_table.first_name, ' ',second_table.last_name) AS actor, 
		max(second_table.actor_downtime_diffYears) AS actor_downtime_in_years --we take max value among all diff years by person's id
		FROM second_table 
GROUP BY second_table.actor_id,second_table.first_name, second_table.last_name
ORDER BY actor_downtime_in_years DESC;



--	↓	↓	↓	↓ THE SAME TASK, BUT INCLUDE ALL POSSIBLE VARIANTS OF DOWNTIME OF ACTOR, BECAUSE IT WAS INTERESTING TO ME	↓	↓	↓	↓
--2.3 
--Which actors/actresses didn't act for a longer period of time than others?

WITH first_tabe AS( --take all films due to person's id
SELECT  a.actor_id, 
		a.first_name, 
		a.last_name,
		fa.film_id,
		f.release_year
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON f.film_id = fa.film_id
ORDER BY a.actor_id, f.release_year
)
, 
second_table AS( --then from the first_table we take LAG and calculate difference between years
		SELECT *,
		release_year,
		(date_part('year', CURRENT_DATE) - release_year) AS diffyear,
		release_year-max(release_year) over(order by actor_id rows between 1 preceding and 1 preceding) actor_downtime_diffYears
		FROM first_tabe
				)
, 
third_table AS(
SELECT      second_table.actor_id,
		CONCAT (second_table.first_name, ' ',second_table.last_name) AS actor,		
		max(second_table.actor_downtime_diffYears) AS the_longest_actor_downtime_in_years,
		max(second_table.diffyear) AS sum_of_all_actors_downtime_for_career,
		sum(case when actor_downtime_diffYears > 0 then actor_downtime_diffYears END) AS curr_dif
		FROM second_table
		GROUP BY (second_table.actor_id, second_table.first_name, second_table.last_name)
ORDER BY the_longest_actor_downtime_in_years DESC
)
SELECT 
		third_table.actor_id,
		third_table.actor,
		third_table.the_longest_actor_downtime_in_years,
		third_table.sum_of_all_actors_downtime_for_career,
		CASE
		    WHEN third_table.sum_of_all_actors_downtime_for_career-third_table.curr_dif = 0 THEN 'acted in film this year '
		    WHEN third_table.sum_of_all_actors_downtime_for_career-third_table.curr_dif = 1 THEN 'acted in film ' 
		    || third_table.sum_of_all_actors_downtime_for_career-third_table.curr_dif
		    || ' year ago'
		    WHEN third_table.sum_of_all_actors_downtime_for_career-third_table.curr_dif > 1 THEN 'acted in film ' 
		    || third_table.sum_of_all_actors_downtime_for_career-third_table.curr_dif
		    || ' years ago'
		END AS years_last_acted_ago
FROM third_table ORDER BY third_table.the_longest_actor_downtime_in_years DESC;
