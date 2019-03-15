USE sakila;
SELECT * FROM sakila.actor;

# * 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name,last_name 
FROM sakila.actor;

# * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT CONCAT(first_name,' ',last_name) AS 'Actor Name'
FROM sakila.actor ;

# * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id AS 'ID number',
	first_name AS 'first name',
    last_name AS 'last name'
FROM sakila.actor 
WHERE first_name = 'Joe';

# * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT * 
FROM sakila.actor
WHERE last_name LIKE '%gen%';

# * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name AS 'last name',
		first_name AS 'first name'
FROM sakila.actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name,first_name;

# * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM sakila.country
WHERE country IN ('Afghanistan','Bangladesh','China') ;

# * 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE sakila.actor
ADD description BLOB;

# * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE sakila.actor
DROP COLUMN description;

# * 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,COUNT(*) as actor_count
FROM sakila.actor
GROUP BY last_name;

# * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,COUNT(*) as actor_count2
FROM sakila.actor
GROUP BY last_name
HAVING actor_count2 >1 ;

# * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE sakila.actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

# * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE sakila.actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';
# * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE sakila.address;

#   * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)

# * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT first_name,last_name,address
FROM sakila.staff
JOIN sakila.address ON staff.address_id = address.address_id;

# * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT staff.staff_id,first_name,last_name,SUM(amount) as 'total amount rung up'
FROM sakila.staff
JOIN sakila.payment ON staff.staff_id = payment.staff_id
WHERE payment_date LIKE '2005-08-%'
GROUP BY staff.staff_id;

# * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title,COUNT(actor_id) as 'actor count'
FROM sakila.film
JOIN sakila.film_actor ON film.film_id = film_actor.film_id
GROUP BY title;

# * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title,COUNT(inventory.film_id) as 'inventory count'
FROM sakila.film
JOIN sakila.inventory ON film.film_id = inventory.film_id
WHERE title = 'Hunchback Impossible';

# * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT customer.first_name,customer.last_name, SUM(payment.amount) as total_paid
FROM sakila.customer
JOIN sakila.payment ON customer.customer_id = payment.customer_id
GROUP BY last_name
ORDER BY last_name;

# * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
#As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title,language_id
FROM sakila.film
WHERE title LIKE 'K%' 
	OR title LIKE 'Q%' 
	AND language_id = (
						SELECT language_id 
						FROM sakila.language 
                        WHERE name = 'English'
                        );

SELECT *
FROM sakila.actor;

# * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name,last_name
FROM sakila.actor
WHERE actor_id IN (
					SELECT actor_id 
                    FROM sakila.film_actor 
                    WHERE film_id = (
										SELECT film_id 
                                        FROM sakila.film
                                        WHERE title = 'Alone Trip'
										)
					);

# * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name,last_name,email,country.country
FROM sakila.customer
JOIN sakila.address ON customer.address_id = address.address_id
JOIN sakila.city ON address.city_id = city.city_id
JOIN sakila.country ON country.country_id = city.country_id
WHERE country.country = 'Canada';

# * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT title,category.name
FROM sakila.film
JOIN sakila.film_category ON film.film_id = film_category.film_id
JOIN sakila.category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

# * 7e. Display the most frequently rented movies in descending order.
SELECT title,COUNT(inventory.film_id) as rental_counts
FROM sakila.payment
JOIN sakila.rental ON payment.rental_id = rental.rental_id
JOIN sakila.inventory ON rental.inventory_id = inventory.inventory_id
JOIN sakila.film ON inventory.film_id = film.film_id
GROUP BY inventory.film_id
ORDER BY rental_counts DESC;

# * 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store_id,SUM(amount) as total_sales
FROM sakila.payment
JOIN sakila.staff ON payment.staff_id = staff.staff_id
GROUP BY store_id;

# * 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id,city.city,country.country
FROM sakila.store
JOIN sakila.address ON store.address_id = address.address_id
JOIN sakila.city ON address.city_id = city.city_id
JOIN sakila.country ON country.country_id = city.country_id;

# * 7h. List the top five genres in gross revenue in descending order. 
SELECT category.name,SUM(payment.amount) as gross_revenue
FROM sakila.payment
JOIN sakila.rental ON payment.rental_id = rental.rental_id
JOIN sakila.inventory ON rental.inventory_id = inventory.inventory_id
JOIN sakila.film ON inventory.film_id = film.film_id
JOIN sakila.film_category ON film.film_id = film_category.film_id
JOIN sakila.category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY gross_revenue DESC
LIMIT 5;

# * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_genres AS SELECT category.name,SUM(payment.amount) as gross_revenue
FROM sakila.payment
JOIN sakila.rental ON payment.rental_id = rental.rental_id
JOIN sakila.inventory ON rental.inventory_id = inventory.inventory_id
JOIN sakila.film ON inventory.film_id = film.film_id
JOIN sakila.film_category ON film.film_id = film_category.film_id
JOIN sakila.category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY gross_revenue DESC
LIMIT 5;

# * 8b. How would you display the view that you created in 8a?
SELECT *
FROM sakila.top_5_genres;
# * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW sakila.top_5_genres;
