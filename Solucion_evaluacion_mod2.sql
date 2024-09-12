USE sakila;


/* Para este ejerccio utilizaremos la BBDD Sakila que hemos estado utilizando durante el repaso de SQL. 
Es una base de datos de ejemplo que simula una tienda de alquiler de películas. Contiene tablas como film (películas), actor (actores),
customer (clientes), rental (alquileres), category (categorías), entre otras. Estas tablas contienen información sobre películas, 
actores, clientes, alquileres y más, y se utilizan para realizar consultas y análisis de datos en el contexto de una tienda de alquiler
 de películas. */
 
 
 
--  1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT title
FROM film;


-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT DISTINCT title
FROM film
WHERE rating = "PG-13";

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT title
FROM film
WHERE description LIKE '%amazing%';


-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT DISTINCT title
FROM film
WHERE length > 120;


-- 5. Recupera los nombres de todos los actores.

SELECT first_name,last_name
FROM actor;


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

SELECT first_name,last_name
FROM actor
WHERE last_name = "Gibson" ;


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT first_name,last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;


-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT title
FROM film
WHERE NOT rating = "PG-13"
AND NOT rating = "R" ;

-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento

SELECT DISTINCT rating AS Clasificacion , COUNT(title) AS cantidad_peliculas
FROM film 
GROUP BY rating;

/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas.*/

SELECT r.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS TotalPeliculasAlquiladas
FROM rental AS r
INNER JOIN customer AS c
ON c.customer_id = r.customer_id
GROUP BY r.customer_id;

/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el 
recuento de alquileres.*/

SELECT c.name AS nombre , COUNT(r.rental_id) AS Total_Alquiladas
FROM category AS c
LEFT JOIN film_category AS fc ON c.category_id = fc.category_id
LEFT JOIN inventory AS i ON i.film_id = fc.film_id
LEFT JOIN rental AS r ON i.inventory_id= r.inventory_id
GROUP BY nombre;

/* 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
 clasificación junto con el promedio de duración. */

SELECT rating, AVG(length) AS Promedio_duracion
FROM film
GROUP BY rating;


-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT a.first_name, a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa ON  fa.actor_id = a.actor_id
INNER JOIN film AS f ON f.film_id = fa.film_id
WHERE f.title = "Indian Love" AND f.film_id = 458;


-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT title, description
FROM film 
WHERE description REGEXP '(dog|cat)';

-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
-- opcion 1 
SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
);

-- opcion 2
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS  NULL;


-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT title, release_year
FROM film 
WHERE release_year BETWEEN 2005 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT c.name AS nombre_categoria , title
FROM category AS c
INNER JOIN film_category AS fc ON fc.category_id = c.category_id
INNER JOIN film AS f ON f.film_id = fc.film_id
WHERE c.name = "Family";

-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name , a.last_name
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film AS f ON f.film_id = fa.film_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 10;

 
-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT title
FROM film
WHERE rating LIKE '%R%' AND length > 120;

/* 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de 
la categoría junto con el promedio de duración. */


SELECT c.name, AVG(f.length) AS promedio
FROM category AS c
INNER JOIN film_category AS fc ON fc.category_id = c.category_id
INNER JOIN film AS f ON f.film_id = fc.film_id
GROUP BY c.name
HAVING AVG(f.length) > 120;

/* 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas 
en las que han actuado. */

SELECT a.first_name, a.last_name, COUNT(f.film_id) AS cantidad_peliculas
FROM actor AS a
INNER JOIN film_actor AS f ON f.actor_id = a.actor_id
GROUP BY a.first_name, a.last_name
HAVING COUNT(f.film_id) >= 5;


/* 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar
 los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */
 
        
SELECT DISTINCT f.title
FROM film  AS f
JOIN inventory AS i ON f.film_id = i.film_id				-- Unimos con inventory y film, ya que rental tiene inventory_id
JOIN rental AS r ON r.inventory_id = i.inventory_id 		-- Unimos con rental para poder realizar la subconsulta
WHERE r.rental_id IN (       								-- Hacemos subconsulta sobre cantidad de rentas que duraron más de 5 días
		SELECT rental_id 
        FROM rental 
        WHERE (r.return_date - r.rental_date) > 5);
        
	


/* 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos 
de la lista de actores. */


SELECT a.first_name, a.last_name											-- Obtenemos nombre de actores
FROM actor AS a
WHERE (a.first_name, a.last_name)NOT IN (  
			SELECT 															-- Hacemos subconsulta de acuerdo a lo solicitado en el ejercicios es decir primero identificar actores que hann actudado en peliculas de Horror y despues excluirlos 
			a.first_name, a.last_name
			FROM actor AS a
			JOIN film_actor AS fa ON fa.actor_id = a.actor_id
			JOIN film_category AS fc ON fc.film_id = fa.film_id
			JOIN category AS c ON c.category_id = fc.category_id
			WHERE c.name ='Horror')
;
            

/* 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film. */



