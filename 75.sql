--1. CREATE DATABASE SYNTAX
CREATE DATABASE SYNTAX;

--2.CREATE SCHEMA SYNTAX
CREATE SCHEMA SYNTAX;

---(3)create table name test and test1 (with column id,  first_name, last_name, school, percentage, status (pass or fail),pin, created_date, updated_date)
---define constraints in it such as Primary Key, Foreign Key, Noit Null...
---apart from this take default value for some column such as cretaed_date"

CREATE TABLE test(
	id bigserial PRIMARY KEY NOT NULL,
	first_name VARCHAR(10) NOT NULL, 
	last_name VARCHAR(10) NOT NULL,
	pin INT 
);
				 
				 
CREATE TABLE test1(
	id bigserial PRIMARY KEY NOT NULL,
	test1_id INT NOT NULL,
	school VARCHAR(50), 
	percentage NUMERIC(2,2),
	status BOOL, 
	pin INT ,
	created_date DATE DEFAULT CURRENT_DATE, 
	updated_date DATE,
	CONSTRAINT fk_test FOREIGN KEY(test1_id) REFERENCES test(id)
);	
				 
--4.Create film_cast table with film_id,title,first_name and last_name of the actor.. (create table from other table)

CREATE TABLE film_cast AS
SELECT film_id, title, first_name, last_name 
FROM film_actor 
JOIN film USING(film_id)
JOIN actor USING(actor_id);

SELECT * FROM film_cast;

--5.DROP TABLE test1
DROP TABLE test1;

--6.create one temp table 
CREATE TEMP TABLE actor_a
AS
SELECT * 
FROM actor
WHERE first_name LIKE 'A%';

SELECT * FROM actor_a;

--7.difference between delete and truncate
/*
The DELETE statement removes rows one at a time and records an entry in the transaction log for each deleted row.
TRUNCATE TABLE removes the data by deallocating the data pages used to store the table data and records only the page deallocations in the transaction log.
*/

--8.rename test table to student table
ALTER TABLE test
RENAME TO student;

--9.add column in test table named city
ALTER TABLE student
ADD COLUMN city varchar(10);

--10.change data type of one of the column of test table
ALTER TABLE student
ALTER COLUMN id TYPE INT;

--11.drop column pin from test table
ALTER TABLE student
DROP COLUMN pin;

--12.rename column city to location in test table
ALTER TABLE student
RENAME COLUMN city 
To location;

--13.Create a Role with read only rights on the database.
CREATE ROLE reader_x;
GRANT CONNECT ON DATABASE sample TO reader_x;
GRANT USAGE ON SCHEMA public TO reader_x;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader_x;

--14.Create a role with all the write permission on the database.
CREATE ROLE writer_x;
GRANT CONNECT ON DATABASE sample TO writer_x;
GRANT USAGE ON SCHEMA public TO writer_x;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO writer_x;

--15.Create a database user who can only read the data from the database.
CREATE ROLE temp_x;
GRANT SELECT ON ALL TABLES IN SCHEMA public To temp_x;

--16.Create a database user who can read as well as write data into database.
CREATE ROLE temp_u;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA public To temp_u;

--17.Create an admin role who is not superuser but can create database and  manage roles.
CREATE ROLE admin WITH NOSUPERUSER CREATEDB;

--18.Create user whoes login credentials can last until 1st June 2023
CREATE ROLE temp_y WITH
LOGIN
PASSWORD 'admin'
VALID UNTIL '2023-06-01';

--19.List all unique film’s name. 
SELECT DISTINCT title
FROM film;

--20.List top 100 customers details.
SELECT * 
FROM customer
LIMIT 100;

--21.List top 10 inventory details starting from the 5th one.
SELECT *
FROM INVENTORY 
LIMIT 10 OFFSET 4;

--22.find the customer's name who paid an amount between 1.99 and 5.99.
SELECT first_name || ' ' || last_name As customer_name
FROM payment p
JOIN customer c USING(customer_id)
WHERE p.amount BETWEEN 1.99 AND 5.99;

--23. List film's name which is staring from the A.
SELECT title
FROM film
WHERE title LIKE 'A%';

--24.List film's name which is end with "a"
SELECT title
FROM film
WHERE title LIKE '%a';

--25.List film's name which is start with "M" and ends with "a"
SELECT title
FROM film
WHERE title LIKE 'M%a';

--26.List all customer details which payment amount is greater than 40. (USING EXISTs)
SELECT c.*
FROM customer c
JOIN payment p USING(customer_id)
WHERE EXISTS(
	SELECT 1
	FROM payment
	WHERE amount > 40
);

--THERE IS NO CUSTOMER WHO PAID AMOUNT OF 40+ 

--27.List staff details order by first_name
SELECT * 
FROM staff
ORDER BY first_name;

--28.List customer's payment details (customer_id,payment_id,first_name,last_name,payment_date)
SELECT 
	DISTINCT
	c.customer_id,
	p.payment_id,
	c.first_name,
	c.last_name,
	p.payment_date
FROM customer c
JOIN payment p USING(customer_id);

--29.Display title and it's actor name.
SELECT 
	title, 
	first_name|| ' ' || last_name  AS actor
FROM film_actor 
JOIN film USING(film_id)
JOIN actor USING(actor_id)
ORDER BY title;

--30.List all actor name and find corresponding film id
SELECT 
	film_id, 
	first_name|| ' ' || last_name  AS actor
FROM film_actor 
JOIN film USING(film_id)
JOIN actor USING(actor_id)
ORDER BY film_id;

--31.List all addresses and find corresponding customer's name and phone.
SELECT 
	c.first_name|| ' ' || c.last_name  AS customer,
	a.phone,
	a.address
FROM customer c
JOIN address a USING(address_id);

--32.Find Customer's payment (include null values if not matched from both tables)(customer_id,payment_id,first_name,last_name,payment_date)
SELECT 
	DISTINCT
	c.customer_id,
	p.payment_id,
	c.first_name,
	c.last_name,
	p.payment_date
FROM customer c
LEFT JOIN payment p USING(customer_id)
WHERE payment_id IS NULL;

--EACH CUSTOMER HAS MADE PAYMENT OF SOME AMOUNT, SO THERE ARE NO NULL VALUES.

--33.List customer's address_id. (Not include duplicate id )
SELECT DISTINCT address_id
FROM address;

--34.List customer's address_id. (Include duplicate id )
SELECT address_id
FROM address;

--35.List Individual Customers' Payment total.
SELECT 
	customer_id,
	SUM(amount)
FROM customer c
JOIN payment p USING(customer_id)
GROUP BY customer_id
ORDER BY customer_id;

--36.List Customer whose payment is greater than 80.
SELECT 
	customer_id,
	SUM(amount)
FROM customer c
JOIN payment p USING(customer_id)
GROUP BY customer_id
HAVING SUM(amount) > 80
ORDER BY customer_id;

--37.
UPDATE rental
SET return_date = return_date + INTERVAL '5 DAYS'
WHERE return_date < '2005-06-15';

--38
DELETE FROM customer
WHERE activebool = 'false';

--39.count the number of special_features category wise.... total no.of deleted scenes, Trailers etc....
SELECT UNNEST(special_features), COUNT(*)
FROM film
GROUP BY UNNEST(special_features);

--40.count the numbers of records in film table
SELECT COUNT(*)
FROM film;

--41.count the no.of special fetures which have Trailers alone, Trailers and Deleted Scened both etc....
SELECT special_features, COUNT(*)
FROM film
GROUP BY 
	special_features;

--42.use CASE expression with the SUM function to calculate the number of films in each rating:
SELECT
       SUM(CASE rating
             WHEN 'G' THEN 1 
		     ELSE 0 
		   END) "G",
       SUM(CASE rating
             WHEN 'PG' THEN 1 
		     ELSE 0 
		   END) "PG",
       SUM(CASE rating
             WHEN 'PG-13' THEN 1 
		     ELSE 0 
		   END) "PG-13",
       SUM(CASE rating
             WHEN 'R' THEN 1 
		     ELSE 0 
		   END) "R",
       SUM(CASE rating
             WHEN 'NC-17' THEN 1 
		     ELSE 0 
		   END) "NC-17"
FROM film;

--43.Display the discount on each product, if there is no discount on product Return 0
SELECT p.id, p.name, COALESCE(discount, 0) as Discount
FROM productX p
JOIN product_segment ps
ON p.segment_id = ps.id;

--44.Return title and it's excerpt, if excerpt is empty or null display last 6 letters of respective body from posts table
SELECT
	id,
	title,
	COALESCE (excerpt, RIGHT(body, 6))
FROM
	posts;
	
--45.Can we know how many distinct users have rented each genre? if yes, name a category with highest and lowest rented number  ..
SELECT
	*
FROM 
	(SELECT * FROM (SELECT c.name AS genre, COUNT(DISTINCT customer_id) AS g_count
	FROM rental
	JOIN inventory i USING(inventory_id)
	JOIN film_category fc USING(film_id)
	JOIN category c USING(category_id)
	JOIN customer cu USING(customer_id)
	GROUP BY c.category_id) AS x
	ORDER BY g_count ASC LIMIT 1) AS max_rented
	
UNION

SELECT
	*
FROM 
	(SELECT * FROM (SELECT c.name AS genre, COUNT(DISTINCT customer_id) AS g_count
	FROM rental
	JOIN inventory i USING(inventory_id)
	JOIN film_category fc USING(film_id)
	JOIN category c USING(category_id)
	JOIN customer cu USING(customer_id)
	GROUP BY c.category_id) AS x
	ORDER BY g_count DESC LIMIT 1) AS min_rented;
	
--46.
--Return film_id,title,rental_date and rental_duration
--according to rental_rate need to define rental_duration 
--such as 
--rental rate  = 0.99 --> rental_duration = 3
--rental rate  = 2.99 --> rental_duration = 4
--rental rate  = 4.99 --> rental_duration = 5
--otherwise  6 

SELECT
	film_id,
	title,
	rental_date,
	CASE
		WHEN rental_rate  = 0.99 THEN 3
		WHEN rental_rate  = 2.99 THEN 3
		WHEN rental_rate  = 4.99 THEN 3
		ELSE 6
	END
FROM rental
JOIN inventory USING (inventory_id)
JOIN film USING (film_id);

--47.Find customers and their email that have rented movies at priced $9.99.
SELECT c.first_name, c.email, p.amount
FROM customer c
JOIN payment p USING(customer_id)
WHERE amount = 9.99;

--48.Find customers in store #1 that spent less than $2.99 on individual rentals, but have spent a total higher than $5.
SELECT customer_id, sum(amount)
FROM
	(SELECT p.customer_id, p.amount
	FROM payment p 
	-- JOIN store st USING(store_id)
	WHERE staff_id = 1) AS x
WHERE amount < 2.99
GROUP BY customer_id
HAVING SUM(amount) > 5
ORDER BY customer_id;

--49.Select the titles of the movies that have the highest replacement cost.
SELECT title, replacement_cost
FROM film
ORDER BY replacement_cost DESC 
LIMIT 1;

--50.list the cutomer who have rented maximum time movie and also display the count of that... (we can add limit here too---> list top 5 customer who rented maximum time)
SELECT c.customer_id, COUNT(*) 
FROM rental
JOIN customer c USING(customer_id)
GROUP BY customer_id
ORDER BY COUNT(*) DESC
LIMIT 5;

--51.Display the max salary for each department
SELECT dept_name, MAX(salary)
FROM employee e
GROUP BY dept_name
ORDER BY MAX(salary) DESC;

--52."Display all the details of employee and add one extra column name max_salary (which shows max_salary dept wise) 
SELECT 
		*,
		MAX(salary) OVER(
			PARTITION BY dept_name
			ORDER BY salary DESC) salary_rank
FROM employee;

--53."Assign a number to the all the employee department wise such as if admin dept have 8 emp then no. goes from 1 to 8, then if finance have 3 then it goes to 1 to 3

SELECT 
		*,
		ROW_NUMBER() OVER(
			PARTITION BY dept_name) salary_rank
FROM employee;

--54.Fetch the first 2 employees from each department to join the company. (assume that emp_id assign in the order of joining)
SELECT *
FROM
	(SELECT 
		*,
		ROW_NUMBER() OVER(
			PARTITION BY dept_name
			ORDER BY emp_id) emp_join
	FROM employee) temp_r
WHERE emp_join < 3;

--55.Fetch the top 3 employees in each department earning the max salary.
SELECT *
FROM
	(SELECT 
		*,
		ROW_NUMBER() OVER(
			PARTITION BY dept_name
			ORDER BY salary DESC) salary_rank
	FROM employee) temp_r
WHERE salary_rank < 4;

--56.write a query to display if the salary of an employee is higher, lower or equal to the previous employee.
WITH cte AS (
	SELECT
		*, 
		LAG(salary,1) OVER (
			ORDER BY emp_id
		) previous_year_salary
	FROM
		employee
)	
SELECT 
	*,
	(CASE
		 WHEN salary > COALESCE(previous_year_salary, 0) 
	 	 	THEN 'Greater'
		 WHEN salary < COALESCE(previous_year_salary, 0) 
			THEN 'Lower'
		 ELSE
			 'Equal'
	 END
	) salary_cmp
FROM 
	cte;
	
--57.Get all title names those are released on may DATE
SELECT title, TO_CHAR(rental_date, 'Month') AS Month
FROM film
JOIN inventory USING(film_id)
JOIN rental r USING(inventory_id)
WHERE EXTRACT(MONTH FROM rental_date) = 05;

--58.get all Payments Related Details from Previous week
SELECT *
FROM payment
WHERE payment_date BETWEEN '2007-03-20'::date - INTERVAL '7 Days' AND '2007-03-20'::date
ORDER BY payment_date;

--59.Get all customer related Information from Previous Year
SELECT *
FROM payment
WHERE payment_date BETWEEN '2007-03-20'::date - INTERVAL '1 Year' AND '2007-03-20'::date
ORDER BY payment_date;

--60.What is the number of rentals per month for each store?
SELECT 
	staff_id Store,
	EXTRACT(MONTH FROM rental_date) AS Month, 
	COUNT(*) AS number_of_rentals
FROM rental
GROUP BY EXTRACT(MONTH FROM rental_date), staff_id
ORDER BY staff_id, Month;

--61.Replace Title 'Date speed' to 'Data speed' whose Language 'English'
UPDATE film
SET title = 'Data Speed'
WHERE 
	LOWER(title) = 'date speed'
	AND
	language_id = 1;
	
--62.Remove Starting Character "A" from Description Of film
UPDATE film
SET description = overlay(description placing '' from 1 for 1)
WHERE description LIKE 'A%';

--63.if end Of string is 'Italian'then Remove word from Description of Title
UPDATE film
SET description = overlay(description placing '' from 1 for 1)
WHERE description LIKE '%italian';

--64.Who are the top 5 customers with email details per total sales
SELECT c.customer_id, email, SUM(amount)
FROM customer c
JOIN payment p USING(customer_id)
GROUP BY customer_id
ORDER BY SUM(amount) DESC LIMIT 5;

--65.Display the movie titles of those movies offered in both stores at the same time.
SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 1

INTERSECT

SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 2

ORDER BY film_id;

--66.Display the movies offered for rent in store_id 1 and not offered in store_id 2.
SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 1

EXCEPT

SELECT DISTINCT film_id
FROM inventory
WHERE store_id = 2

ORDER BY film_id;

--67.Show the number of movies each actor acted in
SELECT actor_id, COUNT(*)
FROM film_actor
GROUP BY actor_id
ORDER BY actor_id;

--68.Find all customers with at least three payments whose amount is greater than 9 dollars
SELECT customer_id, COUNT(*), SUM(amount)
FROM payment
WHERE amount > 9
GROUP BY customer_id
HAVING COUNT(*) > 3
ORDER BY customer_id;

--69.find out the lastest payment date of each customer
SELECT customer_id, payment_date
FROM
	(SELECT 
		*,
		ROW_NUMBER() OVER(
			PARTITION BY customer_id
			ORDER BY payment_date DESC) latest_payment
	FROM payment) temp_r
WHERE latest_payment = 1;

--70.Create a trigger that will delete a customer’s reservation record once the customer’s rents the DVD
CREATE OR REPLACE FUNCTION del_reservation()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$ 

BEGIN
	DELETE FROM reservation r
	WHERE NEW.inventory_id = r.inventory_id AND
	NEW.customer_id = r.customer_id;
	RETURN NULL;
END $$;


CREATE TRIGGER res_del
AFTER INSERT
ON rental
FOR EACH ROW
EXECUTE PROCEDURE del_reservation();

INSERT INTO rental(rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES('2022-06-12'::DATE ,12, 1, NOW(), 1);

--71.Create a trigger that will help me keep track of all operations performed on the reservation table. I want to record whether an insert, delete or update occurred on the reservation table and store that log in reservation_audit table.
CREATE OR REPLACE FUNCTION res_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$

BEGIN
	IF TG_OP = 'INSERT' THEN
		INSERT INTO reservation_audit
		VALUES('I', NOW(), NEW.customer_id, NEW.inventory_id, CURRENT_DATE);
		RETURN NULL;
		
	ELSIF TG_OP = 'UPDATE' THEN
		INSERT INTO reservation_audit
		VALUES('U', NOW(), NEW.customer_id, NEW.inventory_id, CURRENT_DATE);
		RETURN NULL;
		
	ELSIF TG_OP = 'DELETE' THEN
		INSERT INTO reservation_audit
		VALUES('D', NOW(), OLD.customer_id, OLD.inventory_id, CURRENT_DATE);
		RETURN NULL;
		
	END IF;
END $$;

INSERT INTO reservation(customer_id, inventory_id, reserve_date)
VALUES(6, 14, CURRENT_DATE);

DELETE FROM reservation
WHERE customer_id = 6;

--72.Create trigger to prevent a customer for reserving more than 3 DVD’s.
CREATE OR REPLACE FUNCTION dvd_max()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$ 

BEGIN
	IF (
		SELECT COUNT(customer_id)
	   	FROM reservation
		WHERE NEW.customer_id = reservation.customer_id
		) = 3
	THEN
		RAISE NOTICE 'Customer Can''t Rent More Than 3 DVD''s At a Time';
	ELSE
		RETURN NEW;
	END IF;
END $$;

CREATE TRIGGER max_dvd
BEFORE INSERT
ON reservation
FOR EACH ROW
EXECUTE PROCEDURE dvd_max();

INSERT INTO reservation(customer_id, inventory_id, reserve_date)
VALUES(2, 14, CURRENT_DATE);

--73.create a function which takes year as a argument and return the concatenated result of title which contain 'ful' in it and release year like this (title:release_year) --> use cursor in function
CREATE OR REPLACE FUNCTION get_film_titles(p_year INT)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
	titles TEXT DEFAULT '';
	rec record;
	cur_films CURSOR(p_year INT)
			FOR SELECT title, release_year
				FROM film
				WHERE release_year = p_year;
BEGIN
	OPEN cur_films(p_year);
	
	LOOP
		FETCH cur_films into rec;
		
		EXIT WHEN NOT FOUND;
		
		IF rec.title ILIKE '%ful%' THEN 
			IF titles != '' THEN
				titles = titles || ', ' || rec.title || ' - ' || rec.release_year;
			ELSE
				titles = rec.title || ' - ' || rec.release_year;
			END IF;
		END IF;
	END LOOP;
	
	CLOSE cur_films;
	
	RETURN titles;
END $$;

SELECT get_film_titles(2006) AS films;

--74.Find top 10 shortest movies using for loop
DO
$$
DECLARE
    f record;
BEGIN
    FOR f IN SELECT title, length 
	       FROM film 
	       ORDER BY length
	       LIMIT 10 
    LOOP
	RAISE NOTICE '% - % mins', f.title, f.length;
    END LOOP;
END $$;


--75.Write a function using for loop to derive value of 6th field in fibonacci series (fibonacci starts like this --> 1,1,.....)
CREATE OR REPLACE FUNCTION fibonaci(n integer)
RETURNS int
LANGUAGE plpgsql
AS
$$
DECLARE
	a INT = 0;
	b INT = 1;
	temp INT;
	n INT = n;
	i INT;
BEGIN
	FOR i IN 2..n
	LOOP
		temp:= a + b;
		a := b;
		b := temp;
	END LOOP;
	RETURN b;
END $$;
 
SELECT fibonaci(6);