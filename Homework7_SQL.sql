-- ***********************************************************
-- UC Berkeley Extension Data Analytics Program
-- Homework 7:  SQL
-- By: Alejandro Montesinos
-- Date: April 18, 2019
-- ***********************************************************

USE sakila;

-- -------------------------------------------------------
-- 1a. Display the first and last names of all actors from the table actor.
-- -------------------------------------------------------
SELECT first_name, last_name 
FROM actor;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 1b. Display the first and last name of each actor in a single column 
-- in upper case letters. Name the column Actor Name.
-- -------------------------------------------------------
SELECT CONCAT(first_name, ' ', last_name) 
AS 'actor_name' 
FROM actor;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 2a. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
-- -------------------------------------------------------
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name='JOE';
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 2b. Find all actors whose last name contain the letters GEN:
-- -------------------------------------------------------
SELECT actor_id, first_name, last_name 
FROM actor
WHERE last_name LIKE '%GEN%';
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
-- -------------------------------------------------------
SELECT actor_id, last_name , first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 2d. Using IN, display the country_id and country columns 
-- of the following countries: Afghanistan, Bangladesh, and China:
-- -------------------------------------------------------
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 3a. You want to keep a description of each actor. 
-- You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and 
-- use the data type BLOB (Make sure to research the type BLOB, 
-- as the difference between it and VARCHAR are significant).
-- -------------------------------------------------------
ALTER TABLE actor
ADD description BLOB;
SELECT * FROM actor;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 3b. Very quickly you realize that entering descriptions 
-- for each actor is too much effort. Delete the description column.
-- -------------------------------------------------------
ALTER TABLE actor
DROP COLUMN description;
SELECT * FROM actor;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 4a. List the last names of actors, as well as how many 
-- actors have that last name.
-- -------------------------------------------------------
SELECT last_name, COUNT(*) AS 'Frequency'
FROM actor
GROUP BY last_name;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 4b. List last names of actors and the number of actors 
-- who have that last name, but only for names that are 
-- shared by at least two actors
-- -------------------------------------------------------
SELECT last_name, COUNT(*) AS 'Frequency'
FROM actor
GROUP BY last_name
HAVING COUNT(*) >=2;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 4c. The actor HARPO WILLIAMS was accidentally entered 
-- in the actor table as GROUCHO WILLIAMS. Write a query 
-- to fix the record.
-- -------------------------------------------------------
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name='GROUCHO' AND last_name='WILLIAMS';

UPDATE actor
SET first_name='HARPO'
WHERE actor_id=172; 

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id=172;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, 
-- change it to GROUCHO.
-- -------------------------------------------------------
UPDATE actor
SET first_name='GROUCHO'
WHERE first_name='HARPO'; 
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 5a. You cannot locate the schema of the address table. 
-- Which query would you use to re-create it?
-- -------------------------------------------------------
SHOW CREATE TABLE address;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 6a. Use JOIN to display the first and last names, 
-- as well as the address, of each staff member. 
-- Use the tables staff and address:
-- -------------------------------------------------------
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address
ON(staff.address_id=address.address_id);
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 6b. Use JOIN to display the total amount rung up by each 
-- staff member in August of 2005. Use tables staff and payment.
-- -------------------------------------------------------
SELECT staff.first_name, staff.last_name, SUM(amount) AS 'Total Amount'
FROM payment
JOIN staff
ON(payment.staff_id=staff.staff_id)
WHERE payment_date LIKE '%2005-08%'
GROUP BY staff.staff_id;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 6c. List each film and the number of actors who are listed 
-- for that film. Use tables film_actor and film. Use inner join.
-- -------------------------------------------------------
SELECT film.title, COUNT(*) AS 'Number of Actors'
FROM film_actor
INNER JOIN film
ON(film_actor.film_id=film.film_id)
GROUP BY film_actor.film_id;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 6d. How many copies of the film Hunchback Impossible exist 
-- in the inventory system?
-- -------------------------------------------------------
SELECT COUNT(*) AS 'Number of Copies'
FROM inventory
WHERE film_id IN
(
   SELECT film_id
   FROM film
   WHERE title = 'Hunchback Impossible'
);
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 6e. Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers 
-- alphabetically by last name:
-- -------------------------------------------------------
SELECT customer.last_name, customer.first_name, SUM(amount) AS 'Amount Paid'
FROM customer
JOIN payment
ON (payment.customer_id = customer.customer_id)
GROUP BY payment.customer_id
ORDER BY customer.last_name;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 7a. The music of Queen and Kris Kristofferson have seen 
-- an unlikely resurgence. As an unintended consequence, 
-- films starting with the letters K and Q have also soared 
-- in popularity. Use subqueries to display the titles of movies 
-- starting with the letters K and Q whose language is English.
-- -------------------------------------------------------
SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%' 
AND language_id IN
(
   SELECT language_id
   FROM language
   WHERE name='English' 
);
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 7b. Use subqueries to display all actors who appear in 
-- the film Alone Trip.
-- -------------------------------------------------------
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
   SELECT actor_id
   FROM film_actor
   WHERE film_id IN
   (
      SELECT film_id
      FROM film
      WHERE title='Alone Trip'
   )
);
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 7c. You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of 
-- all Canadian customers. Use joins to retrieve this information.
-- -------------------------------------------------------
SELECT first_name, last_name, email FROM customer WHERE address_id IN
( 
   SELECT address_id FROM address WHERE city_id IN
   (
      SELECT city_id FROM city WHERE country_id IN
      (
         SELECT country_id FROM country WHERE country='Canada'
      )
   )
);
-- -------------------------------------------------------



-- -------------------------------------------------------
-- 7d. Sales have been lagging among young families, and you 
-- wish to target all family movies for a promotion. Identify 
-- all movies categorized as family films.
-- -------------------------------------------------------
SELECT title FROM film WHERE film_id IN
(
   SELECT film_id FROM film_category WHERE category_id IN
   (
      SELECT category_id FROM category WHERE name='Family'
   )
);
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 7e. Display the most frequently rented movies in descending order.
-- -------------------------------------------------------
DROP VIEW IF EXISTS inventory_count; 
CREATE VIEW inventory_count AS
SELECT inventory_id, COUNT(*) AS 'inv_count' 
FROM rental GROUP BY inventory_id;

DROP VIEW IF EXISTS film_count; 
CREATE VIEW film_count AS
SELECT i.film_id, SUM(c.inv_count) AS rent_count
FROM inventory AS i
JOIN inventory_count AS c
ON (i.inventory_id = c.inventory_id)
GROUP BY i.film_id;

SELECT f.title, c.rent_count
FROM film AS f
JOIN film_count AS c
ON (f.film_id = c.film_id)
ORDER BY c.rent_count DESC;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 7f. Write a query to display how much business, 
-- in dollars, each store brought in.
-- -------------------------------------------------------
DROP VIEW IF EXISTS rental_amount;  
CREATE VIEW rental_amount AS
SELECT rental_id, SUM(amount) AS 'rental_amount' 
FROM payment GROUP BY rental_id;

DROP VIEW IF EXISTS inventory_amount; 
CREATE VIEW inventory_amount AS
SELECT r.inventory_id, SUM(a.rental_amount) AS inventory_amount
FROM rental AS r
JOIN rental_amount AS a
ON (r.rental_id = a.rental_id)
GROUP BY r.inventory_id;

DROP VIEW IF EXISTS store_amount; 
CREATE VIEW store_amount AS
SELECT i.store_id, SUM(a.inventory_amount) AS store_amount
FROM inventory AS i
JOIN inventory_amount AS a
ON (i.inventory_id = a.inventory_id)
GROUP BY i.store_id;
SELECT * FROM store_amount;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 7g. Write a query to display for each store its store ID, 
-- city, and country.
-- -------------------------------------------------------
SELECT d.store_id, a.city, b.country
FROM city AS a
JOIN country AS b
ON (a.country_id=b.country_id)
JOIN address AS c
ON(a.city_id=c.city_id)
JOIN store AS d
ON (c.address_id=d.address_id);
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, 
-- inventory, payment, and rental.)
-- -------------------------------------------------------
DROP VIEW IF EXISTS film_amount; 
CREATE VIEW film_amount AS
SELECT i.film_id, SUM(a.inventory_amount) AS film_amount
FROM inventory AS i
JOIN inventory_amount AS a
ON (i.inventory_id = a.inventory_id)
GROUP BY i.film_id;

DROP VIEW IF EXISTS category_amount; 
CREATE VIEW category_amount AS
SELECT c.category_id, n.name, SUM(f.film_amount) AS category_amount
FROM film_category AS c
JOIN film_amount AS f
ON (c.film_id = f.film_id)
JOIN category AS n
ON (c.category_id = n.category_id)
GROUP BY c.category_id;

SELECT name, category_amount 
FROM category_amount
ORDER BY category_amount DESC
LIMIT 5;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 8a. In your new role as an executive, you would like to have 
-- an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
-- -------------------------------------------------------
DROP VIEW IF EXISTS top_five_genres; 
CREATE VIEW top_five_genres AS
SELECT name, category_amount 
FROM category_amount
ORDER BY category_amount DESC
LIMIT 5;
-- -------------------------------------------------------


-- -------------------------------------------------------
-- 8b. How would you display the view that you created in 8a?
-- -------------------------------------------------------
-- A:
-- VIEWs are virtual tables so I would display it as a regular table":
SELECT * FROM top_five_genres;
-- -------------------------------------------------------

-- -------------------------------------------------------
-- 8c. You find that you no longer need the view top_five_genres. 
-- Write a query to delete it.
-- -------------------------------------------------------
DROP VIEW IF EXISTS top_five_genres; 
-- -------------------------------------------------------


-- ***********************************************************
-- END OF CODE
-- ***********************************************************