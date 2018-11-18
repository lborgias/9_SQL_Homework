USE sakila;

# 1a. Display the first and last names of all actors from the table actor.

SELECT
a.first_name AS 'First Name'
,a.last_name AS 'Last Name'
FROM actor a
;
# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

SELECT
UPPER(CONCAT(a.first_name ,' ' ,a.last_name)) as 'Actor Name'
FROM actor a
;
#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT
a.actor_id
,a.first_name
,a.last_name
FROM actor a
where a.first_name = 'Joe' -- assuming you want Joe explicitly and not vairations
;
# 2b. Find all actors whose last name contain the letters GEN:

SELECT
a.actor_id
,a.first_name
,a.last_name
FROM actor a
where a.last_name LIKE '%gen%'
;

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT
a.actor_id
,a.first_name
,a.last_name
FROM actor a
where a.last_name LIKE '%LI%'
ORDER by a.last_name, a.first_name
;
# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

SELECT
c.country_id
,c.country
FROM country c
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
;

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD description BLOB;

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor DROP COLUMN  description ;

# 4a. List the last names of actors, as well as how many actors have that last name.

SELECT
a.last_name
,COUNT(a.actor_id) as Cnt
FROM actor a 
GROUP BY a.last_name
;
# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT
a.last_name
,COUNT(a.actor_id) as Cnt
FROM actor a 
GROUP BY a.last_name
HAVING COUNT(a.actor_id)>=2
;
#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
 -- check duplicty of name
SELECT
a.first_name 
,a.last_name
FROM actor a 
WHERE a.first_name = 'GROUCHO'
AND a.last_name = 'WILLIAMS'
;

-- update name 
UPDATE actor
set first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS'
;
-- confirm change
SELECT
a.first_name 
,a.last_name
FROM actor a 
WHERE a.first_name IN  ('GROUCHO','HARPO')
AND a.last_name = 'WILLIAMS'
;

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

 -- check duplicty of name
SELECT
a.first_name 
,a.last_name
FROM actor a 
WHERE a.first_name = 'HARPO'
AND a.last_name = 'WILLIAMS'
;

-- update name 
UPDATE actor
set first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS'
;
-- confirm change
SELECT
a.first_name 
,a.last_name
FROM actor a 
WHERE a.first_name IN  ('GROUCHO','HARPO')
AND a.last_name = 'WILLIAMS'
;

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
DESCRIBE address;

-- also, not sure what you're looking for

SHOW CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT
s.first_name
,s.last_name
,a.address
FROM staff s
JOIN address a on s.address_id = a.address_id
;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

SELECT
s.first_name
,s.last_name
,sum(Amount) AS 'Total'
FROM staff s
JOIN payment p on s.staff_id = p.staff_id
GROUP BY
s.first_name
,s.last_name
;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

SELECT
f.Title
,COUNT(fa.actor_id) AS 'Number of Actors'
from film f
JOIN film_actor fa on f.film_id = fa.film_id
GROUP BY
f.Title
;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?ALTER

SELECT
f.Title
,COUNT(i.inventory_id) AS 'Film Count'
FROM film f
JOIN inventory i on f.film_id = i.film_id
WHERE f.Title = 'Hunchback Impossible'
;

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT
c.First_Name
,c.Last_Name
,SUM(p.Amount) As 'Total Paid'
FROM customer c 
JOIN payment p on p.customer_id = c.customer_id
GROUP BY
c.First_Name
,c.Last_Name

ORDER BY c.Last_Name ASC
;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT
f.Title
FROM film f
WHERE (f.Title LIKE 'Q%' or f.Title LIKE 'K%')
AND f.language_id in (select language_id from language where name = 'English')
;
#7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT
a.First_Name
,a.Last_Name
FROM actor a
WHERE a.actor_id IN (
					SELECT
					fa.actor_id
					FROM film_actor fa
					WHERE fa.film_id IN (
										SELECT
										f.film_id
										FROM film f 
										WHERE f.Title = 'Alone Trip'
										)
					)
 ;

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT
c.First_Name
,c.Last_Name
,c.Email
FROM customer c
JOIN address a on c.address_id = a.address_ID
JOIN city cit on a.city_id = cit.city_id
JOIN country ct on cit.country_id = ct.country_id
WHERE ct.country = 'Canada'
;
#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT
f.Title
FROM film f
JOIN film_category fc on f.film_id = fc.film_id
JOIN category c on fc.category_id = c.category_id
WHERE c.name = 'Family'
;
#7e. Display the most frequently rented movies in descending order.
SELECT
f.Title
,count(r.rental_id) AS 'Rented'
FROM film f
JOIN inventory i on i.film_id = f.film_id
JOIN rental r on i.inventory_id = r.inventory_id
GROUP BY f.Title
ORDER BY 2 DESC
;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT
s.store_id
,concat('$', format(sum(p.amount), 2)) AS 'business'
FROM store s
JOIN inventory i on i.store_id = s.store_id
JOIN rental r on i.inventory_id = r.inventory_id
JOIN payment p on p.rental_id = r.rental_id
GROUP BY s.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT
s.store_id
,c.city
,ct.country
FROM store s 
JOIN address a on a.address_id = s.address_id
JOIN city c on c.city_id = a.city_id
JOIN country ct on ct.country_id = c.country_id
;
#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT 
c.Name AS Category
,SUM(p.Amount) AS GrossRevenue
FROM film f
JOIN film_category fc on f.film_id = fc.film_id
JOIN category c on fc.category_id = c.category_id
JOIN inventory i on f.film_id = i.film_id
JOIN rental  r on i.inventory_id = r.inventory_id
JOIN payment p on p.rental_id = r.rental_id
GROUP BY c.Name
order by 2 DESC
LIMIT 5
;
#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
	CREATE VIEW TopFiveGenre AS 
	SELECT 
	c.Name AS Category
	,SUM(p.Amount) AS GrossRevenue
	FROM film f
	JOIN film_category fc on f.film_id = fc.film_id
	JOIN category c on fc.category_id = c.category_id
	JOIN inventory i on f.film_id = i.film_id
	JOIN rental  r on i.inventory_id = r.inventory_id
	JOIN payment p on p.rental_id = r.rental_id
	GROUP BY c.Name
	order by 2 DESC
	LIMIT 5
	;
#8b. How would you display the view that you created in 8a?
SELECT * FROM TopFiveGenre;
#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW TopFiveGenre;