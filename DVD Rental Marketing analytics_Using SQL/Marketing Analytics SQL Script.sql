-- Create a new schema
CREATE DATABASE dvd_rentals;

-- Use the dbms_assignment1 database
USE dvd_rentals;

-- Data uploaded via Table Data Import Wizard

SELECT * 
FROM dvd_rentals.rental
LIMIT 10;

SELECT 
  COUNT(*) 
FROM dvd_rentals.rental;

SELECT *
FROM dvd_rentals.rental
WHERE customer_id = 5
LIMIT 5;

SELECT *
FROM dvd_rentals.inventory
LIMIT 10;

SELECT 
  COUNT(*)
FROM dvd_rentals.inventory;

SELECT *
FROM dvd_rentals.inventory
WHERE film_id = 10;

SELECT 
  film_id,
  title,
  description,
  release_year,
  language_id,
  rental_duration,
  rental_rate,
  length,
  replacement_cost,
  rating,
  last_update
FROM dvd_rentals.film
LIMIT 10;

SELECT 
  COUNT(DISTINCT film_id)
FROM dvd_rentals.film;

SELECT * 
FROM dvd_rentals.film_category
LIMIT 10;

SELECT * 
FROM dvd_rentals.category
LIMIT 10;

SELECT 
  COUNT(DISTINCT category_id)
FROM dvd_rentals.category;

SELECT *
FROM dvd_rentals.film_actor
WHERE actor_id = 45
LIMIT 5;

SELECT *
FROM dvd_rentals.actor
LIMIT 5;

SELECT
  COUNT(DISTINCT actor_id)
FROM dvd_rentals.actor;

SELECT 
  COUNT(DISTINCT inventory_id)
FROM dvd_rentals.rental;

SELECT 
  COUNT(DISTINCT inventory_id)
FROM dvd_rentals.inventory;

-- first we generate group by counts on the target_column_values
WITH counts_base AS (
SELECT 
  inventory_id AS target_column_values,
  COUNT(*) AS row_count
FROM dvd_rentals.rental
GROUP BY target_column_values
)

-- we then group by again on the row_count to summarize our results
SELECT
  row_count,
  COUNT(target_column_values) AS count_of_target_values
FROM counts_base
GROUP BY row_count
ORDER BY row_count;

-- first we generate group by counts on the target_column_values
WITH counts_base AS (
SELECT 
  film_id AS target_column_values,
  COUNT(*) AS row_count
FROM dvd_rentals.inventory
GROUP BY target_column_values
)

-- we then group by again on the row_count to summarize our results
SELECT
  row_count,
  COUNT(target_column_values) AS count_of_target_values
FROM counts_base
GROUP BY row_count
ORDER BY row_count;

-- first we generate group by counts on the target_column_values
WITH counts_base AS (
SELECT 
  inventory_id AS target_column_values,
  COUNT(*) AS row_count
FROM dvd_rentals.rental
GROUP BY target_column_values
)

-- we then group by again on the row_count to summarize our results
SELECT
  row_count,
  COUNT(target_column_values) AS count_of_target_values
FROM counts_base
GROUP BY row_count
ORDER BY row_count;

-- first we generate group by counts on the target_column_values
WITH counts_base AS (
SELECT 
  inventory_id AS target_column_values,
  COUNT(*) AS row_count
FROM dvd_rentals.inventory
GROUP BY target_column_values
)

-- we then group by again on the row_count to summarize our results
SELECT
  row_count,
  COUNT(target_column_values) AS count_of_target_values
FROM counts_base
GROUP BY row_count
ORDER BY row_count;

SELECT
  COUNT(DISTINCT inventory_id) 
FROM dvd_rentals.rental
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.inventory
  WHERE rental.inventory_id = inventory.inventory_id
);

SELECT
  COUNT(DISTINCT inventory_id) 
FROM dvd_rentals.inventory
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.rental
  WHERE rental.inventory_id = inventory.inventory_id
);

SELECT *
FROM dvd_rentals.inventory
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.rental
  WHERE rental.inventory_id = inventory.inventory_id
);

SELECT
  COUNT(DISTINCT inventory_id) 
FROM dvd_rentals.rental
WHERE EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.inventory
  WHERE rental.inventory_id = inventory.inventory_id
);

DROP TABLE IF EXISTS left_rental_join;
CREATE TEMPORARY TABLE left_rental_join AS
SELECT
  rental.customer_id,
  rental.inventory_id,
  inventory.film_id
FROM dvd_rentals.rental
LEFT JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id;

DROP TABLE IF EXISTS inner_rental_join;
CREATE TEMPORARY TABLE inner_rental_join AS
SELECT
  rental.customer_id,
  rental.inventory_id,
  inventory.film_id
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id;

SELECT
  'left join' AS join_type,
  COUNT(*) AS record_count,
  COUNT(DISTINCT inventory_id) AS unique_key_values
FROM left_rental_join
  
UNION

SELECT
  'inner join' AS join_type,
  COUNT(*) AS record_count,
  COUNT(DISTINCT inventory_id) AS unique_key_values
FROM inner_rental_join;

WITH base_counts AS (
  SELECT 
    film_id,
    COUNT(*) AS record_count
  FROM dvd_rentals.inventory
  GROUP BY 1
)

SELECT 
  record_count,
  COUNT(DISTINCT film_id) AS unique_film_id_values
FROM base_counts
GROUP BY record_count
ORDER BY record_count;

SELECT
  film_id,
  COUNT(*) AS film_count
FROM dvd_rentals.film
GROUP BY film_id
ORDER BY film_id DESC
LIMIT 5;

SELECT
  COUNT(DISTINCT film_id) AS total_count
FROM dvd_rentals.inventory
WHERE NOT EXISTS(
  SELECT film_id
  FROM dvd_rentals.film
  WHERE inventory.film_id = film.film_id
);

SELECT
  COUNT(DISTINCT film_id) AS total_count
FROM dvd_rentals.film
WHERE NOT EXISTS(
  SELECT film_id
  FROM dvd_rentals.inventory
  WHERE inventory.film_id = film.film_id
);

SELECT
  COUNT(DISTINCT film_id) AS total_count
FROM dvd_rentals.inventory
WHERE EXISTS (
  SELECT film_id
  FROM dvd_rentals.film
  WHERE film.film_id = inventory.film_id
);

DROP TABLE IF EXISTS join_part1_and_part2;
CREATE TEMPORARY TABLE join_part1_and_part2 AS (
SELECT
  rental.customer_id,
  inventory.film_id,
  film.title
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
);

SELECT * 
FROM join_part1_and_part2
ORDER BY customer_id
LIMIT 5;

DROP TABLE IF EXISTS join_part3_and_part4;
CREATE TEMPORARY TABLE join_part3_and_part4 AS (
SELECT 
  film.film_id,
  film_category.category_id,
  category.name AS category_name
FROM dvd_rentals.film
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id
);

SELECT *
FROM join_part3_and_part4
ORDER BY film_id
LIMIT 5;

DROP TABLE IF EXISTS final_table_join_data;
CREATE TEMPORARY TABLE final_table_join_data AS (
SELECT 
  rental.customer_id,
  film.film_id,
  film.title,
  film_category.category_id,
  category.name AS category_name
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id
);

SELECT *
FROM final_table_join_data
LIMIT 10;

DROP TABLE IF EXISTS final_table_join_data;
CREATE TEMPORARY TABLE final_table_join_data AS (
SELECT 
  rental.customer_id,
  film.film_id,
  film.title,
  film_category.category_id,
  category.name AS category_name
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id
);

SELECT *
FROM final_table_join_data
LIMIT 10;

SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count
FROM final_table_join_data
WHERE customer_id IN (1, 2, 3)
GROUP BY 
  customer_id,
  category_name
ORDER BY 
  customer_id,
  rental_count DESC;
  
  -- First add the rental_date column from our original rental table into our final one
DROP TABLE IF EXISTS final_table_join_data;
CREATE TEMPORARY TABLE final_table_join_data AS (
SELECT 
  rental.customer_id,
  film.film_id,
  film.title,
  film_category.category_id,
  category.name AS category_name,
  rental.rental_date
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id
);

-- Getting the top categories for customer 3
SELECT 
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM final_table_join_data
WHERE customer_id = 3
GROUP BY
  customer_id,
  category_name
ORDER BY 
  customer_id,
  rental_count DESC,
  latest_rental_date DESC;
  
  WITH aggregated_rental_count AS (
SELECT 
  customer_id,
  category_name,
  COUNT(*) AS rental_count
FROM final_table_join_data
WHERE customer_id IN (1, 2, 3)
GROUP BY
  customer_id,
  category_name
)

SELECT 
  category_name,
  ROUND(
  AVG(rental_count), 
  2) AS average_value
FROM aggregated_rental_count
GROUP BY category_name
ORDER BY category_name;

DROP TABLE IF EXISTS category_rental_count;
CREATE TEMPORARY TABLE category_rental_count AS (
SELECT 
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM final_table_join_data
GROUP BY
  customer_id,
  category_name
);

-- Checking the records for customer_id = 1
SELECT *
FROM category_rental_count
WHERE customer_id = 1
ORDER BY
  rental_count DESC,
  latest_rental_date DESC;
  
  DROP TABLE IF EXISTS customer_total_rentals;
CREATE TEMPORARY TABLE customer_total_rentals AS (
SELECT
  customer_id,
  SUM(rental_count) AS total_rentals
FROM category_rental_count
GROUP BY customer_id
);

-- Display records for the first 5 customers
SELECT *
FROM customer_total_rentals
ORDER BY customer_id
LIMIT 5;

DROP TABLE IF EXISTS average_category_rental_counts;
CREATE TEMPORARY TABLE average_category_rental_counts AS (
SELECT
  category_name,
  ROUND(
  AVG(rental_count),
  2) AS average_rental_value
FROM category_rental_count
GROUP BY category_name
);

-- Display records for the new table
SELECT *
FROM average_category_rental_counts
ORDER BY average_rental_value DESC;

UPDATE average_category_rental_counts
SET average_rental_value = FLOOR(average_rental_value);

SELECT * FROM average_category_rental_counts;

SELECT *
FROM average_category_rental_counts;

SELECT 
  customer_id,
  category_name,
  rental_count,
  PERCENT_RANK() OVER (
    PARTITION BY category_name
    ORDER BY rental_count DESC
  ) AS percentile
FROM category_rental_count
ORDER BY 
  customer_id,
  rental_count DESC
LIMIT 10;

SELECT 
  customer_id,
  category_name,
  rental_count,
  CEILING(
      100 * PERCENT_RANK() OVER (
        PARTITION BY category_name
        ORDER BY rental_count DESC
    )
  ) AS percentile
FROM category_rental_count
ORDER BY 
  customer_id,
  rental_count DESC
LIMIT 10;

DROP TABLE IF EXISTS customer_category_percentiles;
CREATE TEMPORARY TABLE customer_category_percentiles AS (
SELECT 
  customer_id,
  category_name,
  rental_count,
  CEILING(
      100 * PERCENT_RANK() OVER (
        PARTITION BY category_name
        ORDER BY rental_count DESC
    )
  ) AS percentile
FROM category_rental_count
);

SELECT *
FROM customer_category_percentiles
ORDER BY 
  customer_id,
  rental_count DESC
LIMIT 2;

DROP TABLE IF EXISTS customer_category_join_table;
CREATE TEMPORARY TABLE customer_category_join_table AS (
SELECT
  t1.customer_id,
  t1.category_name,
  t1.rental_count,
  t2.total_rentals,
  t3.average_rental_value,
  t4.percentile
FROM category_rental_count AS t1
INNER JOIN customer_total_rentals AS t2
  ON t1.customer_id = t2.customer_id
INNER JOIN average_category_rental_counts as t3
  ON t1.category_name = t3.category_name
INNER JOIN customer_category_percentiles AS t4
  ON t1.customer_id = t4.customer_id
  AND t1.category_name = t4.category_name
);

-- Display the table records for customer_id = 1
SELECT *
FROM customer_category_join_table
WHERE customer_id = 1
ORDER BY percentile;

DROP TABLE IF EXISTS customer_category_join_table;
CREATE TEMPORARY TABLE customer_category_join_table AS (
SELECT
  t1.customer_id,
  t1.category_name,
  t1.rental_count,
  t1.latest_rental_date,
  t2.total_rentals,
  t3.average_rental_value,
  t4.percentile,
  t1.rental_count - t3.average_rental_value AS average_comparison,
  ROUND(100 * t1.rental_count / t2.total_rentals) AS category_percentage
FROM category_rental_count AS t1
INNER JOIN customer_total_rentals AS t2
  ON t1.customer_id = t2.customer_id
INNER JOIN average_category_rental_counts as t3
  ON t1.category_name = t3.category_name
INNER JOIN customer_category_percentiles AS t4
  ON t1.customer_id = t4.customer_id
  AND t1.category_name = t4.category_name
);

-- See the records for customer_id = 1
SELECT *
FROM customer_category_join_table
WHERE customer_id = 1
ORDER BY percentile
LIMIT 5;

DROP TABLE IF EXISTS top_categories_information;
CREATE TEMPORARY TABLE top_categories_information AS (
WITH ordered_customer_join_table AS (
  SELECT 
    customer_id,
    ROW_NUMBER() OVER (
      PARTITION BY customer_id
      ORDER BY rental_count DESC, latest_rental_date DESC
    ) AS category_rank,
    rental_count,
    average_comparison,
    percentile,
    category_percentage
  FROM customer_category_join_table
)

-- Filter out the top 2 ranking categories for each customer
SELECT *
FROM ordered_customer_join_table
WHERE category_rank <= 2
);

SELECT *
FROM top_categories_information
WHERE customer_id IN (1, 2, 3);

DROP TABLE IF EXISTS complete_joint_dataset;
CREATE TEMPORARY TABLE complete_joint_dataset AS (
SELECT
  rental.customer_id,
  inventory.film_id,
  film.title,
  category.name AS category_name,
  rental.rental_date
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_category
  ON film.film_id = film_category.film_id
INNER JOIN dvd_rentals.category
  ON film_category.category_id = category.category_id
);

-- Display sample outputs from the above table
SELECT *
FROM complete_joint_dataset
LIMIT 5;

DROP TABLE IF EXISTS category_counts;
CREATE TEMPORARY TABLE category_counts AS (
SELECT
  customer_id,
  category_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM complete_joint_dataset
GROUP BY 
  customer_id,
  category_name
);

-- Display sample outputs from the above table
SELECT *
FROM category_counts
WHERE customer_id = 1
ORDER BY
  rental_count DESC,
  latest_rental_date DESC;
  
  DROP TABLE IF EXISTS total_counts;
CREATE TEMPORARY TABLE total_counts AS(
SELECT
  customer_id,
  SUM(rental_count) AS total_count
FROM category_counts
GROUP BY customer_id
);

-- Display sample outputs from the above table
SELECT *
FROM total_counts
ORDER BY customer_id
LIMIT 5;

DROP TABLE IF EXISTS top_categories;
CREATE TEMPORARY TABLE top_categories AS (
WITH ranked_cte AS (
  SELECT
    customer_id,
    category_name,
    rental_count,
    DENSE_RANK() OVER (
      PARTITION BY customer_id
      ORDER BY
        rental_count DESC,
        latest_rental_date DESC,
        category_name
    ) AS category_rank
  FROM category_counts
)

SELECT *
FROM ranked_cte
WHERE category_rank <= 2
);

-- Display sample outputs from the above table
SELECT *
FROM top_categories
LIMIT 5;

DROP TABLE IF EXISTS average_category_count;
CREATE TEMPORARY TABLE average_category_count AS (
SELECT
  category_name,
  FLOOR(AVG(rental_count)) AS category_count
FROM category_counts
GROUP BY category_name
);

-- Display sample outputs from the above table
SELECT *
FROM average_category_count
ORDER BY category_name;

DROP TABLE IF EXISTS top_category_percentile;
CREATE TEMPORARY TABLE top_category_percentile AS (
WITH calculated_cte AS (
SELECT
  top_categories.customer_id,
  top_categories.category_name AS top_category_name,
  top_categories.rental_count,
  category_counts.category_name,
  top_categories.category_rank,
  PERCENT_RANK() OVER (
    PARTITION BY category_counts.category_name
    ORDER BY category_counts.rental_count DESC
  ) AS raw_percentile_value
FROM top_categories
LEFT JOIN category_counts
  ON top_categories.customer_id = category_counts.customer_id
)

SELECT
  customer_id,
  category_name,
  rental_count,
  CASE
    WHEN ROUND(100 * raw_percentile_value) = 0 THEN 1
    ELSE ROUND(100 * raw_percentile_value)
  END AS percentile
FROM calculated_cte
WHERE category_rank = 1
AND top_category_name = category_name
);

-- Display sample outputs from the above table
SELECT *
FROM top_category_percentile
ORDER BY customer_id
LIMIT 5;

DROP TABLE IF EXISTS first_category_insights;
CREATE TEMPORARY TABLE first_category_insights AS (
SELECT
  t1.customer_id,
  t1.category_name,
  t1.rental_count,
  t1.rental_count - t2.category_count AS average_comparison,
  t1.percentile
FROM top_category_percentile AS t1
LEFT JOIN average_category_count AS t2
  ON t1.category_name = t2.category_name
);

-- Display sample outputs from the above table
SELECT *
FROM first_category_insights
LIMIT 5;

DROP TABLE IF EXISTS second_category_insights;
CREATE TEMPORARY TABLE second_category_insights AS (
  SELECT
    t1.customer_id,
    t1.category_name,
    t1.rental_count,
    ROUND(
      100 * t1.rental_count / t2.total_count,
      2
    ) AS total_percentage
  FROM top_categories AS t1
  LEFT JOIN total_counts AS t2
    ON t1.customer_id = t2.customer_id
  WHERE category_rank = 2
);


SELECT *
FROM second_category_insights
LIMIT 5;

DROP TABLE IF EXISTS film_counts;
CREATE TEMPORARY TABLE film_counts AS (
SELECT DISTINCT
  film_id,
  title,
  category_name,
  COUNT(*) OVER (
    PARTITION BY film_id
  ) AS rental_count
FROM complete_joint_dataset
);

SELECT *
FROM film_counts
ORDER BY rental_count DESC
LIMIT 5;

DROP TABLE IF EXISTS category_film_exclusion;
CREATE TEMPORARY TABLE category_film_exclusion AS (
SELECT DISTINCT
  customer_id,
  film_id,
  title,
  category_name
FROM complete_joint_dataset
);

SELECT *
FROM category_film_exclusion
LIMIT 5;

DROP TABLE IF EXISTS category_recommendations;
CREATE TEMPORARY TABLE category_recommendations AS (
WITH ranked_films_cte AS (
SELECT
  top_categories.customer_id,
  top_categories.category_name,
  top_categories.category_rank,
  film_counts.film_id,
  film_counts.title,
  film_counts.rental_count,
  DENSE_RANK() OVER (
    PARTITION BY 
      top_categories.customer_id,
      top_categories.category_rank
    ORDER BY
      film_counts.rental_count DESC,
      film_counts.title
  ) AS reco_rank
FROM top_categories
INNER JOIN film_counts
  ON top_categories.category_name = film_counts.category_name
WHERE NOT EXISTS (
  SELECT 1
  FROM category_film_exclusion
  WHERE 
    category_film_exclusion.customer_id = top_categories.customer_id AND
    category_film_exclusion.film_id = film_counts.film_id
)
)

SELECT *
FROM ranked_films_cte
WHERE reco_rank <= 3
);

-- Display sample output recommendations for customer_id = 1
SELECT *
FROM category_recommendations
WHERE customer_id = 1;

DROP TABLE IF EXISTS actor_joint_dataset;
CREATE TEMPORARY TABLE actor_joint_dataset AS (
SELECT 
  rental.customer_id,
  rental.rental_id,
  rental.rental_date,
  film.film_id,
  film.title,
  actor.actor_id,
  actor.first_name,
  actor.last_name
FROM dvd_rentals.rental
INNER JOIN dvd_rentals.inventory
  ON rental.inventory_id = inventory.inventory_id
INNER JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
INNER JOIN dvd_rentals.film_actor
  ON film.film_id = film_actor.film_id
INNER JOIN dvd_rentals.actor
  ON film_actor.actor_id = actor.actor_id
);

SELECT *
FROM actor_joint_dataset
LIMIT 5;

SELECT
  COUNT(*) AS total_row_count,
  COUNT(DISTINCT rental_id) AS unique_rental_id,
  COUNT(DISTINCT film_id) AS unique_film_id,
  COUNT(DISTINCT actor_id) AS unique_actor_id,
  COUNT(DISTINCT customer_id) AS unique_customer_id
FROM actor_joint_dataset;

DROP TABLE IF EXISTS top_actor_counts;
CREATE TEMPORARY TABLE top_actor_counts AS (
WITH actor_counts AS (
SELECT 
  customer_id,
  actor_id,
  first_name,
  last_name,
  COUNT(*) AS rental_count,
  MAX(rental_date) AS latest_rental_date
FROM actor_joint_dataset
GROUP BY
  customer_id,
  actor_id,
  first_name,
  last_name
),
ranked_actor_cte AS (
SELECT
  actor_counts.*,
  DENSE_RANK() OVER (
    PARTITION BY customer_id
    ORDER BY
      rental_count DESC,
      latest_rental_date DESC,
      first_name,
      last_name
  ) AS actor_rank
FROM actor_counts
)

SELECT
  customer_id,
  actor_id,
  first_name,
  last_name,
  rental_count
FROM ranked_actor_cte
WHERE actor_rank = 1
);

-- Display a few sample dataset rows
SELECT *
FROM top_actor_counts
LIMIT 5;

DROP TABLE IF EXISTS actor_film_counts;
CREATE TEMPORARY TABLE actor_film_counts AS (
WITH film_counts AS (
SELECT
  film_id,
  COUNT(DISTINCT rental_id) AS rental_count
FROM actor_joint_dataset
GROUP BY film_id
)

SELECT DISTINCT
  t1.film_id,
  t1.actor_id,
  t1.title,
  film_counts.rental_count
FROM actor_joint_dataset AS t1
LEFT JOIN film_counts
  ON t1.film_id = film_counts.film_id
);

-- Display sample row outputs from above table
SELECT *
FROM actor_film_counts
LIMIT 5;

DROP TABLE IF EXISTS actor_film_exclusions;
CREATE TEMPORARY TABLE actor_film_exclusions AS (
SELECT DISTINCT
  customer_id,
  film_id
FROM complete_joint_dataset

UNION

SELECT DISTINCT
  customer_id,
  film_id
FROM category_recommendations
);

SELECT *
FROM actor_film_exclusions
LIMIT 5;

DROP TABLE IF EXISTS actor_recommendations;
CREATE TEMPORARY TABLE actor_recommendations AS (
WITH ranked_actor_films_cte AS (
SELECT
  top_actor_counts.customer_id,
  top_actor_counts.first_name,
  top_actor_counts.last_name,
  top_actor_counts.rental_count,
  actor_film_counts.title,
  actor_film_counts.film_id,
  actor_film_counts.actor_id,
  DENSE_RANK() OVER (
    PARTITION BY 
      top_actor_counts.customer_id
    ORDER BY
      actor_film_counts.rental_count DESC,
      actor_film_counts.title
  ) AS reco_rank
FROM top_actor_counts
INNER JOIN actor_film_counts
  ON top_actor_counts.actor_id = actor_film_counts.actor_id
WHERE NOT EXISTS (
  SELECT 1
  FROM actor_film_exclusions
  WHERE
    actor_film_exclusions.customer_id = top_actor_counts.customer_id AND
    actor_film_exclusions.film_id = actor_film_counts.film_id
  )
)

SELECT *
FROM ranked_actor_films_cte
WHERE reco_rank <= 3
);

-- Display sample output rows for customer_id = 1
SELECT *
FROM actor_recommendations
WHERE customer_id = 1;

SELECT *
FROM first_category_insights
LIMIT 5;

SELECT *
FROM second_category_insights
LIMIT 5;

SELECT *
FROM top_actor_counts
LIMIT 5;

SELECT *
FROM category_recommendations
WHERE customer_id = 3;

SELECT *
FROM actor_recommendations
WHERE customer_id = 3;

DROP TABLE IF EXISTS final_data_asset;
CREATE TEMPORARY TABLE final_data_asset AS (
WITH first_category AS (
SELECT 
  customer_id,
  category_name,
  CONCAT(
    'You''ve watched ', rental_count, ' ', category_name, ' films, that''s ', 
    average_comparison, ' more than the DVD Rental Co average and puts you in the top ', 
    percentile, '% of ', category_name, ' gurus!'
  ) AS insights
FROM first_category_insights
),

second_category AS (
SELECT
  customer_id,
  category_name,
  CONCAT(
    'You''ve watched ', rental_count, ' ', category_name, ' films, making up ', 
    total_percentage, '% of your entire viewing history!'
  ) AS insights
FROM second_category_insights
),

top_actor AS (
SELECT
  customer_id,
  CONCAT(INITCAP(first_name), ' ', INITCAP(last_name)) AS actor_name,
  CONCAT(
    'You''ve watched ', rental_count, ' films featuring ',
    INITCAP(first_name), ' ', INITCAP(last_name), '! Here are some other films ', 
    INITCAP(first_name), ' stars in that might interest you!'
  ) AS insights
FROM top_actor_counts
),

adjusted_title_case_category_recommendations AS (
SELECT
  customer_id,
  INITCAP(title) AS title,
  category_rank,
  reco_rank
FROM category_recommendations
),

wide_category_recommendations AS (
SELECT
  customer_id,
  MAX(CASE WHEN category_rank = 1 AND reco_rank = 1 
    THEN title END) AS cat_1_reco_1,
  MAX(CASE WHEN category_rank = 1 AND reco_rank = 2 
    THEN title END) AS cat_1_reco_2,
  MAX(CASE WHEN category_rank = 1 AND reco_rank = 3 
    THEN title END) AS cat_1_reco_3,
  MAX(CASE WHEN category_rank = 2 AND reco_rank = 1 
    THEN title END) AS cat_2_reco_1,
  MAX(CASE WHEN category_rank = 2 AND reco_rank = 2 
    THEN title END) AS cat_2_reco_2,
  MAX(CASE WHEN category_rank = 2 AND reco_rank = 3 
    THEN title END) AS cat_2_reco_3
FROM adjusted_title_case_category_recommendations
GROUP BY customer_id
),

adjusted_title_case_actor_recommendations AS (
SELECT
  customer_id,
  INITCAP(title) AS title,
  reco_rank
FROM actor_recommendations
),

wide_actor_recommendations AS (
SELECT
  customer_id,
  MAX(CASE WHEN reco_rank = 1 THEN title END) AS actor_reco_1,
  MAX(CASE WHEN reco_rank = 2 THEN title END) AS actor_reco_2,
  MAX(CASE WHEN reco_rank = 3  THEN title END) AS actor_reco_3
FROM adjusted_title_case_actor_recommendations
GROUP BY customer_id
),

final_output AS (
SELECT
  t1.customer_id,
  t1.category_name AS cat_1,
  t1.insights AS cat_1_insights,
  t4.cat_1_reco_1,
  t4.cat_1_reco_2,
  t4.cat_1_reco_3,
  t2.category_name AS cat_2,
  t2.insights AS cat_2_insights,
  t4.cat_2_reco_1,
  t4.cat_2_reco_2,
  t4.cat_2_reco_3,
  t3.actor_name AS actor,
  t3.insights AS actor_insights,
  t5.actor_reco_1,
  t5.actor_reco_2,
  t5.actor_reco_3
FROM first_category AS t1
INNER JOIN second_category AS t2
  ON t1.customer_id = t2.customer_id
INNER JOIN top_actor AS t3
  ON t1.customer_id = t3.customer_id
INNER JOIN wide_category_recommendations AS t4
  ON t1.customer_id = t4.customer_id
INNER JOIN wide_actor_recommendations AS t5
  ON t1.customer_id = t5.customer_id
)

SELECT * FROM final_output
);

SELECT *
FROM final_data_asset
LIMIT 5;

WITH all_recommended_films AS (
SELECT
  title
FROM category_recommendations

UNION ALL

SELECT 
  title
FROM actor_recommendations
)

SELECT 
  title,
  COUNT(*) AS reco_count
FROM all_recommended_films
GROUP BY title
ORDER BY reco_count DESC
LIMIT 5;

SELECT
  COUNT(DISTINCT customer_id) AS total_customers
FROM final_data_asset;

WITH all_recommended_films AS (
SELECT
  title
FROM category_recommendations
UNION 
SELECT 
  title
FROM actor_recommendations
),

recommendations AS (
SELECT COUNT(DISTINCT title) AS total_recommended_count
FROM all_recommended_films
),

all_films AS (
SELECT COUNT(DISTINCT title) AS total_film_count
FROM dvd_rentals.film
)

SELECT
  ROUND(
    100 * t1.total_recommended_count / t2.total_film_count
  ) AS coverage_percentage
FROM recommendations AS t1
CROSS JOIN all_films AS t2;

SELECT
  category_name,
  COUNT(*) AS total_count
FROM first_category_insights
GROUP BY category_name
ORDER BY total_count DESC;

WITH ranked_cte AS (
SELECT
  category_name,
  COUNT(*) AS total_count,
  ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS cat_rank
FROM first_category_insights
GROUP BY category_name
)

SELECT *
FROM ranked_cte
WHERE cat_rank=4;

SELECT
  ROUND(CAST(AVG(percentile) AS DECIMAL(10,2)), 2) AS average_percentile
FROM first_category_insights;


SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_percentage) AS median
FROM second_category_insights;


SELECT
  PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY rental_count) AS _80th_percentile_films
FROM top_actor_counts;

SELECT
  ROUND(AVG(total_count)) AS average_films_watched
FROM total_counts;

SELECT
  cat_1,
  cat_2,
  COUNT(*) AS freq_count
FROM final_data_asset
GROUP BY
  cat_1,
  cat_2
ORDER BY freq_count DESC
LIMIT 5;

SELECT
  actor,
  COUNT(*) AS freq_count
FROM final_data_asset
GROUP BY actor
ORDER BY freq_count DESC
LIMIT 1;

SELECT 
  ROUND(AVG(rental_count)) AS avg_count
FROM top_actor_counts;

SELECT
  LEAST(cat_1, cat_2) AS category_1,
  GREATEST(cat_1, cat_2) AS category_2,
  COUNT(*) AS freq_count
FROM final_data_asset
GROUP BY
  category_1,
  category_2
ORDER BY freq_count DESC
LIMIT 5;
