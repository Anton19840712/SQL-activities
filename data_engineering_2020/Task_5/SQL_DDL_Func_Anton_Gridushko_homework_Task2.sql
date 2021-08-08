--2 Task

--1)What operations do the following functions perform: film_in_stock, film_not_in_stock, inventory_in_stock, get_customer_balance,
--inventory_held_by_customer, rewards_report, last_day? You can find these functions in dvd_rental database

--1.1 
--Function shows information about inventory_id relevant to its film number and store number
--Function sets filter parameters and returns the last inventory_id result according to parametrized values: p_film_id, p_store_id

CREATE OR REPLACE FUNCTION public.film_in_stock(p_film_id integer, p_store_id integer, OUT p_film_count integer) -- OUT is an alternative way to return the value
--sets params in and out
--The mode of an argument: IN, OUT, INOUT, or VARIADIC. If omitted, the default is IN. Only OUT arguments can follow a 
--VARIADIC one. Also, OUT and INOUT arguments cannot be used together with the RETURNS TABLE notation

 RETURNS SETOF integer --The SETOF modifier indicates that the function will return a set of items, rather than a single item.
 LANGUAGE sql -- Sets LANGUAGE parameter as sql
			  -- The name of the language that the function is implemented in. It can be sql, c, internal, 
			  -- or the name of a user-defined procedural language, e.g. plpgsql. Enclosing the name 
			  -- in single quotes is deprecated and requires matching case.
AS $function$ -- Selects by conditions query results
     SELECT inventory_id 
     FROM inventory
     WHERE film_id = $1 --is a reference to the first argument of the function
     AND store_id = $2 
     AND inventory_in_stock(inventory_id);
$function$;


--1.2
--function shows information about inventory_id with films not in stock

CREATE OR REPLACE FUNCTION public.film_not_in_stock(p_film_id integer, p_store_id integer, OUT p_film_count integer)
 RETURNS SETOF integer
 LANGUAGE sql
AS $function$
    SELECT inventory_id
    FROM inventory
    WHERE film_id = $1
    AND store_id = $2
    AND NOT inventory_in_stock(inventory_id);
$function$
;

--1.3 
--function counts inventories from rental table
--function sets filter parameter and RETURNS p_inventory_id result according to parametrized values of p_inventory_id

CREATE OR REPLACE FUNCTION public.inventory_in_stock(p_inventory_id integer)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_rentals INTEGER;
    v_out     INTEGER;
BEGIN
    -- AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    -- FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT count(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
	--The USING clause is a shorthand that allows you to take advantage of 
	--the specific situation where both sides of the join use the same name for the 
	--joining column(s). It takes a comma-separated list of the shared column names and 
	--forms a join condition that includes an equality 
	--comparison for each one. For example, joining T1 and T2 with USING (a, b) 
	--produces the join condition ON T1.a = T2.a AND T1.b = T2.b.
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END $function$
;

--1.4 
--function describes the business requirements for calculating the clients balance
--sets filter parameters and returns profit according to parametrized values: p_customer_id integer, p_effective_date timestamp with time zone

CREATE OR REPLACE FUNCTION public.get_customer_balance(p_customer_id integer, p_effective_date timestamp with time zone)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
       --#OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       --#WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       --#   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       --#   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       --#   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       --#   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED
DECLARE
    v_rentfees DECIMAL(5,2); --#FEES PAID TO RENT THE VIDEOS INITIALLY
    v_overfees INTEGER;      --#LATE FEES FOR PRIOR RENTALS
    v_payments DECIMAL(5,2); --#SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN
    SELECT COALESCE(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(CASE 
                           WHEN (rental.return_date - rental.rental_date) > (film.rental_duration * '1 day'::interval)
                           THEN EXTRACT(epoch FROM ((rental.return_date - rental.rental_date) - (film.rental_duration * '1 day'::interval)))::INTEGER / 86400 -- * 1 dollar
						   
                           ELSE 0
                        END),0) 
    INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(payment.amount),0) INTO v_payments
    FROM payment
    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

    RETURN v_rentfees + v_overfees - v_payments;
END
$function$
;


--1.5 
--function shows customer that held concrete inventory item
--function sets p_inventory_id as parameter and returns v_customer_id according to select logic

CREATE OR REPLACE FUNCTION public.inventory_held_by_customer(p_inventory_id integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_customer_id INTEGER;
BEGIN

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END $function$
;

--1.6 
--function forms rewards report
--function sets min_monthly_purchases, min_dollar_amount_purchased parameters
--checks min_monthly_purchases, min_dollar_amount_purchased for null reference exception
--decklares variables
--creates TEMPORARY storage area called tmpCustomer for Customer IDs inside itself and sets customer_id as parameter in itself
--finds all customers meeting the monthly purchase requirements
--executes a part of itself inside
--outputs ALL customer information of matching rewardees, customizes output as needed
--sets tmpSQL parameter as query and executes it for each selection
--returns SETOF customer

CREATE OR REPLACE FUNCTION public.rewards_report(min_monthly_purchases integer, min_dollar_amount_purchased numeric)
 RETURNS SETOF customer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    last_month_start DATE;
    last_month_end DATE;
rr RECORD;
tmpSQL TEXT;
BEGIN

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        RAISE EXCEPTION 'Minimum monthly purchases parameter must be > 0';
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        RAISE EXCEPTION 'Minimum monthly dollar amount purchased parameter must be > $0.00';
    END IF;

    last_month_start := CURRENT_DATE - '3 month'::interval;
    last_month_start := to_date((extract(YEAR FROM last_month_start) || '-' || extract(MONTH FROM last_month_start) || '-01'),'YYYY-MM-DD');
    last_month_end := LAST_DAY(last_month_start);

    /*
    Create a temporary storage area for Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id INTEGER NOT NULL PRIMARY KEY);

    /*
    Find all customers meeting the monthly purchase requirements
    */

    tmpSQL := 'INSERT INTO tmpCustomer (customer_id)
        SELECT p.customer_id
        FROM payment AS p
        WHERE DATE(p.payment_date) BETWEEN '||quote_literal(last_month_start) ||' AND '|| quote_literal(last_month_end) || '
        GROUP BY customer_id
        HAVING SUM(p.amount) > '|| min_dollar_amount_purchased || '
        AND COUNT(customer_id) > ' ||min_monthly_purchases ;

    EXECUTE tmpSQL;

    /*
    Output ALL customer information of matching rewardees.
    Customize output as needed.
    */
    FOR rr IN EXECUTE 'SELECT c.* FROM tmpCustomer AS t INNER JOIN customer AS c ON t.customer_id = c.customer_id' LOOP
        RETURN NEXT rr;
    END LOOP;

    /* Clean up */
    tmpSQL := 'DROP TABLE tmpCustomer';
    EXECUTE tmpSQL;

RETURN;
END
$function$
;


--1.7
--function gets timestamp parameter and calculates year of the last day of concrete period according to its year or month

CREATE OR REPLACE FUNCTION public.last_day(timestamp with time zone)
 RETURNS date
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$
  SELECT CASE
    WHEN EXTRACT(MONTH FROM $1) = 12 THEN
      (((EXTRACT(YEAR FROM $1) + 1) operator(pg_catalog.||) '-01-01')::date - INTERVAL '1 day')::date
    ELSE
      ((EXTRACT(YEAR FROM $1) operator(pg_catalog.||) '-' operator(pg_catalog.||) (EXTRACT(MONTH FROM $1) + 1) operator(pg_catalog.||) '-01')::date - INTERVAL '1 day')::date
    END
$function$
;


--2) Why does ‘rewards_report’ function return 0 rows? Correct and recreate the function, so that it's able to return rows properly.
--FUNCTION DOES NOT RETURN ANYTHING BECAUSE ROWS FOR THE FILTER CONDITION: 'CURRENT DATE - 3 MONTH' ARE EBSENT IN QUERIED TABLE.
--THIS FUNCTION COULD BE REWRITTEN WITHOUT CONSTANTS, FOR INSTANCE:::↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓

CREATE OR REPLACE FUNCTION public.rewards_report(min_monthly_purchases integer, min_dollar_amount_purchased numeric)
 RETURNS SETOF customer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    last_month_start DATE;
    last_month_end DATE;
rr RECORD;
tmpSQL TEXT;
BEGIN
    IF min_monthly_purchases = 0 THEN
        RAISE EXCEPTION 'Minimum monthly purchases parameter must be > 0';
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        RAISE EXCEPTION 'Minimum monthly dollar amount purchased parameter must be > $0.00';
    END IF;
    CREATE TEMPORARY TABLE tmpCustomer (customer_id INTEGER NOT NULL PRIMARY KEY);

    tmpSQL := 'INSERT INTO tmpCustomer (customer_id)
        SELECT p.customer_id
        FROM payment AS p
        GROUP BY customer_id
        HAVING SUM(p.amount) > '|| min_dollar_amount_purchased || '
        AND COUNT(customer_id) > ' ||min_monthly_purchases ;

    EXECUTE tmpSQL;
    FOR rr IN EXECUTE 'SELECT c.* FROM tmpCustomer AS t INNER JOIN customer AS c ON t.customer_id = c.customer_id' LOOP
        RETURN NEXT rr;
    END LOOP;
	
    tmpSQL := 'DROP TABLE tmpCustomer';
    EXECUTE tmpSQL;
RETURN;
END
$function$

--3)Is there any function that can potentially be removed from the dvd_rental codebase? If so, which one and why?
--THIS FUNCTION COULD POTENTIALLY BE REMOVED - I THINK THERE IS NO BIG BUISNESS VALUE IN IT. WE ARE INTERESTED IN FILMS THAT ARE RENTED BY SOMEONE MORE, THEN THEY ARE NOT

CREATE OR REPLACE FUNCTION public.film_not_in_stock(p_film_id integer, p_store_id integer, OUT p_film_count integer)
 RETURNS SETOF integer
 LANGUAGE sql
AS $function$
    SELECT inventory_id
    FROM inventory
    WHERE film_id = $1
    AND store_id = $2
    AND NOT inventory_in_stock(inventory_id);
$function$
;


--4) The ‘get_customer_balance’ function describes the business requirements for calculating the client balance. Unfortunately, not all of
--them are implemented in this function. Try to change function using the requirements from the comments.

CREATE OR REPLACE FUNCTION public.get_customer_balance(p_customer_id integer, p_effective_date timestamp with time zone)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
       --#OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       --#WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       --#   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       --#   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       --#   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       --#   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED
DECLARE
    v_rentfees DECIMAL(5,2); --#FEES PAID TO RENT THE VIDEOS INITIALLY
    v_overfees INTEGER;      --#LATE FEES FOR PRIOR RENTALS
    v_payments DECIMAL(5,2); --#SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN
    SELECT COALESCE(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(CASE 
						   WHEN (rental.return_date - rental.rental_date) > (film.rental_duration * '2 day'::interval)
                           THEN EXTRACT(epoch FROM ((rental.return_date - rental.rental_date) - (film.rental_duration * '2 day'::interval)))::INTEGER / 86400 -- * 1 dollar
                           ELSE 0
                        END),0) 
    INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

    SELECT COALESCE(SUM(payment.amount),0) INTO v_payments
    FROM payment
    WHERE payment.payment_date <= p_effective_date --# 4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

    AND payment.customer_id = p_customer_id;

    RETURN v_rentfees + v_overfees - v_payments;
END
$function$
;

--5) How do ‘group_concat’ and ‘_group_concat’ functions work? (database creation script might help) Where are they used?

--Function gets text parameters and checks if one of them equals null
--If both not null, then concates them and shows in output result
--In dvdrental is used to cocatenate first and kast names of actors as a rule.

CREATE OR REPLACE FUNCTION public._group_concat(text, text)
 RETURNS text
 LANGUAGE sql
 IMMUTABLE
AS $function$
SELECT CASE
  WHEN $2 IS NULL THEN $1
  WHEN $1 IS NULL THEN $2
  ELSE $1 || ', ' || $2
END
$function$
;
--VS

aggregate_dummy;
--It's hard to tell what it does, because it's not implemented.
--It looks more like a constant, that do nothing and could be also replaced.
--May be this function uses ‘group_concat’ inside.

--6) What does ‘last_updated’ function do? Where is it used?
--FUNCTION is used to set current time
CREATE OR REPLACE FUNCTION public.last_updated()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.last_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END $function$
;

--7) What is tmpSQL variable for in ‘rewards_report’ function? Can this function be recreated without EXECUTE statement and dynamic SQL?
--8) Why?
--This is assigned result of the variable.
--It cannot be recreated without EXECUTE statement and dynamic SQL. Because otherwise it just only could be assigned. 
    tmpSQL := 'INSERT INTO tmpCustomer (customer_id)
        SELECT p.customer_id
        FROM payment AS p
        WHERE DATE(p.payment_date) BETWEEN '||quote_literal(last_month_start) ||' AND '|| quote_literal(last_month_end) || '
        GROUP BY customer_id
        HAVING SUM(p.amount) > '|| min_dollar_amount_purchased || '
        AND COUNT(customer_id) > ' ||min_monthly_purchases ;