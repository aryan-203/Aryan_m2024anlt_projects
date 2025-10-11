# Understanding Customer Preferences in a DVD Rental Company
Using MySQL | By Subham Pramanick

## Introduction: 

The world of entertainment is constantly evolving, and the DVD rental industry is no exception. To stay ahead of the curve, companies need to understand their customers' preferences and tailor their offerings accordingly. This project delves into the fascinating world of customer behavior within a DVD rental company, aiming to unlock valuable insights that can drive marketing strategies and improve customer satisfaction.

## Business Problem: Optimizing Recommendations and Targeting Strategies

This project tackles a crucial business problem faced by the DVD rental company: **how to effectively recommend films to customers and optimize marketing campaigns for maximum impact.** By analyzing customer rental data, we aim to answer key questions such as:

* What are the most popular film genres and actor preferences among customers?
* How can we personalize recommendations based on individual viewing habits?
* Which customer segments are most receptive to targeted marketing campaigns?
* What are the most effective combinations of film categories to promote together?

By addressing these questions, we can provide the company with actionable insights to:

* Enhance customer engagement by recommending films that resonate with their preferences.
* Develop targeted marketing campaigns that reach the right audience with the right message.
* Optimize resource allocation and maximize the return on marketing investments.

This project will not only benefit the company but also empower customers to discover hidden gems and enjoy a more personalized movie-watching experience.

# 1. Data Exploration

## 1.1 Rental table

The first table in our database schema is the rental table. Let's take a look at all the columns in the table. We'll limit the output to 10 rows.

```sql
SELECT * 
FROM dvd_rentals.rental
LIMIT 10;
```

*Output:*

| rental_id | rental_date              | inventory_id | customer_id | return_date              | staff_id | last_update              |
|-----------|--------------------------|--------------|-------------|--------------------------|----------|--------------------------|
| 1         | 2005-05-24T22:53:30.000Z | 367          | 130         | 2005-05-26T22:04:30.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 2         | 2005-05-24T22:54:33.000Z | 1525         | 459         | 2005-05-28T19:40:33.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 3         | 2005-05-24T23:03:39.000Z | 1711         | 408         | 2005-06-01T22:12:39.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 4         | 2005-05-24T23:04:41.000Z | 2452         | 333         | 2005-06-03T01:43:41.000Z | 2        | 2006-02-15T21:30:53.000Z |
| 5         | 2005-05-24T23:05:21.000Z | 2079         | 222         | 2005-06-02T04:33:21.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 6         | 2005-05-24T23:08:07.000Z | 2792         | 549         | 2005-05-27T01:32:07.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 7         | 2005-05-24T23:11:53.000Z | 3995         | 269         | 2005-05-29T20:34:53.000Z | 2        | 2006-02-15T21:30:53.000Z |
| 8         | 2005-05-24T23:31:46.000Z | 2346         | 239         | 2005-05-27T23:33:46.000Z | 2        | 2006-02-15T21:30:53.000Z |
| 9         | 2005-05-25T00:00:40.000Z | 2580         | 126         | 2005-05-28T00:22:40.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 10        | 2005-05-25T00:02:21.000Z | 1824         | 399         | 2005-05-31T22:44:21.000Z | 2        | 2006-02-15T21:30:53.000Z |

So, the rental table contains all the details of the films that were rented along with other details such as ```inventory_id```, ```customer_id``` along with ```rental & return date```. So, one customer can rent multiple films from different inventories for an amount of time. Let's explore this table more.

```sql
SELECT 
  COUNT(*) 
FROM dvd_rentals.rental;
```

*Output:*

| count |
|-------|
| 16044 |

Let's see all the records for one customer.

```sql
SELECT *
FROM dvd_rentals.rental
WHERE customer_id = 5
LIMIT 5;
```

*Output:*

| rental_id | rental_date              | inventory_id | customer_id | return_date              | staff_id | last_update              |
|-----------|--------------------------|--------------|-------------|--------------------------|----------|--------------------------|
| 731       | 2005-05-29T07:25:16.000Z | 4124         | 5           | 2005-05-30T05:21:16.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 1085      | 2005-05-31T11:15:43.000Z | 301          | 5           | 2005-06-07T12:02:43.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 1142      | 2005-05-31T19:46:38.000Z | 3998         | 5           | 2005-06-05T14:03:38.000Z | 1        | 2006-02-15T21:30:53.000Z |
| 1502      | 2005-06-15T22:03:14.000Z | 3277         | 5           | 2005-06-23T18:42:14.000Z | 2        | 2006-02-15T21:30:53.000Z |
| 1631      | 2005-06-16T08:01:02.000Z | 2466         | 5           | 2005-06-19T09:04:02.000Z | 1        | 2006-02-15T21:30:53.000Z |

## 1.2 Inventory table

The inventory table consists of all the records of available film copies and the store to which they belong.

```sql
SELECT *
FROM dvd_rentals.inventory
LIMIT 10;
```

*Output:*

| inventory_id | film_id | store_id | last_update              |
|--------------|---------|----------|--------------------------|
| 1            | 1       | 1        | 2006-02-15T05:09:17.000Z |
| 2            | 1       | 1        | 2006-02-15T05:09:17.000Z |
| 3            | 1       | 1        | 2006-02-15T05:09:17.000Z |
| 4            | 1       | 1        | 2006-02-15T05:09:17.000Z |
| 5            | 1       | 2        | 2006-02-15T05:09:17.000Z |
| 6            | 1       | 2        | 2006-02-15T05:09:17.000Z |
| 7            | 1       | 2        | 2006-02-15T05:09:17.000Z |
| 8            | 1       | 2        | 2006-02-15T05:09:17.000Z |
| 9            | 2       | 2        | 2006-02-15T05:09:17.000Z |
| 10           | 2       | 2        | 2006-02-15T05:09:17.000Z |

One film can have multiple copies across the store. Let's take a look at the total number of inventories.

```sql
SELECT 
  COUNT(*)
FROM dvd_rentals.inventory;
```

*Output:*

| count |
|-------|
| 4581  |

Also, let's take a look at inventory records for one particular ```film_id```.

```sql
SELECT *
FROM dvd_rentals.inventory
WHERE film_id = 10;
```

*Output:*

| inventory_id | film_id | store_id | last_update              |
|--------------|---------|----------|--------------------------|
| 46           | 10      | 1        | 2006-02-15T05:09:17.000Z |
| 47           | 10      | 1        | 2006-02-15T05:09:17.000Z |
| 48           | 10      | 1        | 2006-02-15T05:09:17.000Z |
| 49           | 10      | 1        | 2006-02-15T05:09:17.000Z |
| 50           | 10      | 2        | 2006-02-15T05:09:17.000Z |
| 51           | 10      | 2        | 2006-02-15T05:09:17.000Z |
| 52           | 10      | 2        | 2006-02-15T05:09:17.000Z |

## 1.3 Film table

This is the main table containing all the details about the films available.

```sql
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
```

*Output:*

| film_id | title            | description                                                                                                           | release_year | language_id | rental_duration | rental_rate | length | replacement_cost | rating | last_update              |
|---------|------------------|-----------------------------------------------------------------------------------------------------------------------|--------------|-------------|-----------------|-------------|--------|------------------|--------|--------------------------|
| 1       | ACADEMY DINOSAUR | A Epic Drama of a Feminist And a Mad Scientist who must Battle a Teacher in The Canadian Rockies                      | 2006         | 1           | 6               | 0.99        | 86     | 20.99            | PG     | 2006-02-15T05:03:42.000Z |
| 2       | ACE GOLDFINGER   | A Astounding Epistle of a Database Administrator And a Explorer who must Find a Car in Ancient China                  | 2006         | 1           | 3               | 4.99        | 48     | 12.99            | G      | 2006-02-15T05:03:42.000Z |
| 3       | ADAPTATION HOLES | A Astounding Reflection of a Lumberjack And a Car who must Sink a Lumberjack in A Baloon Factory                      | 2006         | 1           | 7               | 2.99        | 50     | 18.99            | NC-17  | 2006-02-15T05:03:42.000Z |
| 4       | AFFAIR PREJUDICE | A Fanciful Documentary of a Frisbee And a Lumberjack who must Chase a Monkey in A Shark Tank                          | 2006         | 1           | 5               | 2.99        | 117    | 26.99            | G      | 2006-02-15T05:03:42.000Z |
| 5       | AFRICAN EGG      | A Fast-Paced Documentary of a Pastry Chef And a Dentist who must Pursue a Forensic Psychologist in The Gulf of Mexico | 2006         | 1           | 6               | 2.99        | 130    | 22.99            | G      | 2006-02-15T05:03:42.000Z |

Let's also take a look at the total number of unique film id we got in the table.

```sql
SELECT 
  COUNT(DISTINCT film_id)
FROM dvd_rentals.film;
```

*Output:*

| count |
|-------|
| 1000  |

So, in total there are 1000 unique films in our ```film``` table.

## 1.4 Film_category table

The film category table maps each film to a ```category_id``` it belongs too.

```sql
SELECT * 
FROM dvd_rentals.film_category
LIMIT 10;
```

| film_id | category_id | last_update              |
|---------|-------------|--------------------------|
| 1       | 6           | 2006-02-15T05:07:09.000Z |
| 2       | 11          | 2006-02-15T05:07:09.000Z |
| 3       | 6           | 2006-02-15T05:07:09.000Z |
| 4       | 11          | 2006-02-15T05:07:09.000Z |
| 5       | 8           | 2006-02-15T05:07:09.000Z |
| 6       | 9           | 2006-02-15T05:07:09.000Z |
| 7       | 5           | 2006-02-15T05:07:09.000Z |
| 8       | 11          | 2006-02-15T05:07:09.000Z |
| 9       | 11          | 2006-02-15T05:07:09.000Z |
| 10      | 15          | 2006-02-15T05:07:09.000Z |

## 1.5 Category table

This table maps each category_id to its ```name```.

```sql
SELECT * 
FROM dvd_rentals.category
LIMIT 10;
```

*Output:*

| category_id | name        | last_update              |
|-------------|-------------|--------------------------|
| 1           | Action      | 2006-02-15T04:46:27.000Z |
| 2           | Animation   | 2006-02-15T04:46:27.000Z |
| 3           | Children    | 2006-02-15T04:46:27.000Z |
| 4           | Classics    | 2006-02-15T04:46:27.000Z |
| 5           | Comedy      | 2006-02-15T04:46:27.000Z |
| 6           | Documentary | 2006-02-15T04:46:27.000Z |
| 7           | Drama       | 2006-02-15T04:46:27.000Z |
| 8           | Family      | 2006-02-15T04:46:27.000Z |
| 9           | Foreign     | 2006-02-15T04:46:27.000Z |
| 10          | Games       | 2006-02-15T04:46:27.000Z |

Let's see how many categories we have in total.

```sql
SELECT 
  COUNT(DISTINCT category_id)
FROM dvd_rentals.category;
```

*Output:*

| count |
|-------|
|  16   |

## 1.6 Film_actor table

This table links a particular ```film_id``` to multiple ```actors``` as there can be multiple actors working in a film and an actor working in numerous films and it shows a many-to-many relationship.

```sql
SELECT *
FROM dvd_rentals.film_actor
WHERE actor_id = 45
LIMIT 5;
```

*Output:*

| actor_id | film_id | last_update              |
|----------|---------|--------------------------|
| 45       | 18      | 2006-02-15T05:05:03.000Z |
| 45       | 65      | 2006-02-15T05:05:03.000Z |
| 45       | 66      | 2006-02-15T05:05:03.000Z |
| 45       | 115     | 2006-02-15T05:05:03.000Z |
| 45       | 117     | 2006-02-15T05:05:03.000Z |

## 1.7 Actor table

This is the last table containing the actor details, such as name. Let's look at the table along with the total number of actors we got.

```sql
SELECT *
FROM dvd_rentals.actor
LIMIT 5;
```

*Output:*

| actor_id | first_name | last_name    | last_update              |
|----------|------------|--------------|--------------------------|
| 1        | PENELOPE   | GUINESS      | 2006-02-15T04:34:33.000Z |
| 2        | NICK       | WAHLBERG     | 2006-02-15T04:34:33.000Z |
| 3        | ED         | CHASE        | 2006-02-15T04:34:33.000Z |
| 4        | JENNIFER   | DAVIS        | 2006-02-15T04:34:33.000Z |
| 5        | JOHNNY     | LOLLOBRIGIDA | 2006-02-15T04:34:33.000Z |

```sql
SELECT
  COUNT(DISTINCT actor_id)
FROM dvd_rentals.actor;
```

*Output:*

| count |
|-------|
|  200  |

Alright, now that we have explored the data a little bit, let's move ahead with the analysis.

# 2. Data Analysis

## 2.1 Define the final state

Looking back at the email template that we have to work on using SQL, the key columns that we will need to generate include the following data points at a customer_id level:

- ```category_name```: The name of the top 2 ranking categories
- ```rental_count```: How many total films have they watched in this category
- ```average_comparison```: How many more films has the customer watched compared to the average DVD Rental Co customer
- ```percentile```: How does the customer rank in terms of the top X% compared to all other customers in this film category?
- ```category_percentage```: What proportion of total films watched does this category make up?

And the final output should look something like this.

| customer_id  | category_ranking | category_name | rental_count | average_comparison | percentile | category_percentage |
|--------------|------------------|---------------|--------------|--------------------|------------|---------------------|
| 1            | 1                | Classics      | 6            | 4                  | 1          | 19                  |
| 1            | 2                | Comedy        | 5            | 4                  | 2          | 16                  |
| 2            | 1                | Sports        | 5            | 3                  | 7          | 19                  |
| 2            | 2                | Classics      | 4            | 2                  | 11         | 15                  |
| 3            | 1                | Action        | 4            | 2                  | 14         | 15                  |

And so on.....

## 2.2 Reverse Engineering

As we can see from the above output table, the main thing we need is a ```rental_count``` at the customer_id level. The columns like ```average_comparison```, ```percentile``` and  ```category_percentage``` are all dependent on the rental_count.

Also, we need the top two categories for each customer, along with the category name. Something like,

| customer_id  | category_name | rental_count |
|--------------|---------------|--------------|
| 1            | Classics      | 6            |
| 1            | Comedy        | 5            |
| 2            | Sports        | 5            |
| 2            | Action        | 4            |

But, in order to find the average comparison and percentile, we need to find these values for all the customer-watched categories.

## 2.3 Mapping the Joining Journey

Let's select a few columns that are very important for our project. As we have to find the ```rental_value``` at a customer_id level, we'll need the following two columns for that.

1. ```customer_id```
2. ```category_name```

And the first table we should begin with the ```rental``` table as it contains most of the information we need w.r.t rentals and customers along with inventory_id which we then need to map to the film and then based on the film_id extract it's category from the category table.

We will now skip the 6th & 7th tables containing the actor details, which we'll return to later. So, our final version of the joins mapping journey will look something like this.

| Join Journey Part | Start               |  End                |  Foreign Key       |
|-------------------|---------------------|---------------------|--------------------|
| Part 1            | ```rental```        | ```inventory```     | ```inventory_id``` |
| Part 2            | ```inventory```     | ```film```          | ```film_id```      |
| Part 3            | ```film```          | ```film_category``` | ```film_id```      |
| Part 4            | ```film_category``` | ```category```      | ```category_id```  |

## 2.4 Deciding Which Type of Joins to Use

We can define our purpose and come up with some questions that will help us decide the type of joins we should use. For, eg,

> We need to keep all customer rental records from the ```dvd_rentals.rental``` and match each record with its equivalent film_id value from the ```dvd_rentals.inventory``` table.

There are two types of joins we can think of, viz, Left Join and Inner Join. Let's dig up further to decide which join suits our problem-solving more.

### 2.4.1 Key Analytical Questions

We need to look up a few questions before deciding which join to use.

1. How many records exist per ```inventory_id``` value in ```rental``` or ```inventory``` tables?
2. How many overlapping and missing unique foreign key values are between the two tables?

Here comes the 2 phase approach we will use to answer the above questions. First, generating some hypotheses about the data and then try to validate it to see if we are correct.

### 2.4.2 Generating some hypotheses by looking at the data

We have seen that the rental table has records for all the customer's rental history along with the inventory id of the films. A particular film can have multiple copies tied to a unique customer id. Looking at this and the data exploration, we can generate some hypotheses as follows:

1. The number of unique ```inventory_id``` records will be equal in both ```dvd_rentals.rental``` and ```dvd_rentals.inventory``` tables
2. There will be a multiple records per unique ```inventory_id``` in the ```dvd_rentals.rental``` table
3. There will be multiple ```inventory_id``` records per unique ```film_id``` value in the ```dvd_rentals.inventory``` table

Next, we'll try to validate our hypotheses so far for further analysis.

### 2.4.3 Validating the hypotheses using the given data

We can use SQL to solve for the same.

#### 2.4.3.1 Hypothesis 1

> The number of unique ```inventory_id``` records will be equal in both ```dvd_rentals.rental``` and ```dvd_rentals.inventory``` tables

First, we'll check for the unique number of inventory_id present in the rental table.

```sql
SELECT 
  COUNT(DISTINCT inventory_id)
FROM dvd_rentals.rental;
```

*Output:*

| count |
|-------|
| 4580  |

Let's also take a look at the inventory table for the same. As per our hypotheses, it should be the same as the rental table.

```sql
SELECT 
  COUNT(DISTINCT inventory_id)
FROM dvd_rentals.inventory;
```

*Output:*

| count |
|-------|
| 4581  |

As we can see, our first hyptheses seem to fail as we got 1 more unique ```inventory_id``` in the inventory table when compared to the rental table.

#### 2.4.3.2 Hypotheses 2

> There will be a multiple records per unique ```inventory_id``` in the ```dvd_rentals.rental``` table

```sql
-- First we generate a group by counts on the target_column_values
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
```

*Output:*

| row_count | count_of_target_values |
|-----------|------------------------|
| 1         | 4                      |
| 2         | 1126                   |
| 3         | 1151                   |
| 4         | 1160                   |
| 5         | 1139                   |

Hence, we can confirm that there are multiple rows per ```inventory_id``` in our rental table.

Let's move on to check our last hypotheses.

### 2.3.4.3 Hypotheses 3

> There will be multiple ```inventory_id``` records per unique ```film_id``` value in the ```dvd_rentals.inventory``` table

We can use the same approach as above.

```sql
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
```

*Output:*

| row_count | count_of_target_values |
|-----------|------------------------|
| 2         | 133                    |
| 3         | 131                    |
| 4         | 183                    |
| 5         | 136                    |
| 6         | 187                    |
| 7         | 116                    |
| 8         | 72                     |

We can confirm that our hypothesis 3 is valid and indeed there are multiple ```inventory_id per``` unique ```film_id```.

### 2.3.5 Returning to our 2 key questions

1. How many records exist per ```inventory_id``` value in ```rental``` or ```inventory``` tables?
2. How many overlapping and missing unique foreign key values are there between the two tables?

For the first question, let's check the number of unique number of inventory_id in both the tables.

> How many records exist per ```inventory_id``` value in ```rental``` or ```inventory``` tables?

**rental distribution analysis on ```inventory_id``` foreign key**

```sql
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
```

*Output:*

| row_count | count_of_target_values |
|-----------|------------------------|
| 1         | 4                      |
| 2         | 1126                   |
| 3         | 1151                   |
| 4         | 1160                   |
| 5         | 1139                   |

Here, we can see that there are multiple records present for a unique ```inventory_id``` in the ```rental``` table which shows a one-to-many relationship.

Also, the output shows that there are 4 unique inventory_id with exactly one-row record, while there are 1126 ```inventory_id``` with 2 row_counts, etc.

**inventory distribution analysis on ```inventory_id``` foreign key**

```sql
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
```

*Output:*

| row_count | count_of_target_values |
|-----------|------------------------|
| 1         | 4581                   |

As compared to the ```rental``` table, the ```inventory``` table contains only 1 row per unique inventory_id showing a one-to-one relationship.

Now, let's move on to the second question.

> How many overlapping and missing unique foreign key values are there between the two tables?

So, let's first find out the number of foreign keys that exist only in the left table or the ```rental``` table.

```sql
SELECT
  COUNT(DISTINCT inventory_id) 
FROM dvd_rentals.rental
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.inventory
  WHERE rental.inventory_id = inventory.inventory_id
);
```

*Output:*

| count |
|-------|
| 0     |

Now, we can confirm that all the foreign keys that are present in the left table i.e. ```rental``` table are present in the ```inventory``` table as well.

Let's also check if it's the same case with the right table i.e. ```inventory``` table.

```sql
SELECT
  COUNT(DISTINCT inventory_id) 
FROM dvd_rentals.inventory
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.rental
  WHERE rental.inventory_id = inventory.inventory_id
);
```

*Output:*

| count |
|-------|
| 1     |

And, we have found one value that only exists in the ```inventory``` table. Let's investigate this further.

```sql
SELECT *
FROM dvd_rentals.inventory
WHERE NOT EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.rental
  WHERE rental.inventory_id = inventory.inventory_id
);
```

*Output:*

| inventory_id | film_id | store_id | last_update              |
|--------------|---------|----------|--------------------------|
| 5            | 1       | 2        | 2006-02-15T05:09:17.000Z |

This is the only record that's odd as compared to the other records. It contains details about an inventory and the film it belongs to. It might be possible that this inventory was never rented out by a customer. The intersection of the foreign keys between the two tables can be found by the following query.

```sql
SELECT
  COUNT(DISTINCT inventory_id) 
FROM dvd_rentals.rental
WHERE EXISTS (
  SELECT inventory_id
  FROM dvd_rentals.inventory
  WHERE rental.inventory_id = inventory.inventory_id
);
```

*Output:*

| count |
|-------|
| 4580  |

Now that we have analyzed and checked, let's move on to the Table Joining part.

# 3. Join Implementation

Take a look at our table joining journey.

| Join Journey Part | Start               |  End                |  Foreign Key       |
|-------------------|---------------------|---------------------|--------------------|
| Part 1            | ```rental```        | ```inventory```     | ```inventory_id``` |
| Part 2            | ```inventory```     | ```film```          | ```film_id```      |
| Part 3            | ```film```          | ```film_category``` | ```film_id```      |
| Part 4            | ```film_category``` | ```category```      | ```category_id```  |

## 3.1 Joins Part 1

After performing the analysis, it's clear that we can choose either of the ```INNER JOIN``` OR ```LEFT JOIN``` as it won't make any difference for our example. We can check this ourself by running the following SQL code.

```sql
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
```

*Output:*

| join_type  | record_count | unique_key_values |
|------------|--------------|-------------------|
| inner join | 16044        | 4580              |
| left join  | 16044        | 4580              |

## 3.2 Join Part 2

### 3.2.1 What is the purpose?

Similar to part 1, now we need to work on joining the table ```inventory``` and ```film```. The purpose for this join can be defined as:
> We want to match the films on ```film_id``` so that we can get the film names.

### 3.2.2 Generating hypotheses from data

Some hypotheses that can be generated by looking at the data are as follows:

1. There is a 1-to-many relationship for ```film_id``` and the rows of the ```dvd_rentals.inventory``` table as one specific film might have multiple copies to be purchased at the rental store.
2. There should be a 1-to-1 relationship for ```film_id``` and the rows of the ```dvd_rentals.film``` table as it doesn’t make sense for there to be duplicates in this ```dvd_rentals.film```.

We can now test our hypothesis using SQL.

### 3.2.3 Validating our Hypotheses

For the first one,

```sql
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
```

*Output:*

| record_count | unique_film_id_values |
|--------------|-----------------------|
| 2            | 133                   |
| 3            | 131                   |
| 4            | 183                   |
| 5            | 136                   |
| 6            | 187                   |
| 7            | 116                   |
| 8            | 72                    |

So, our first hypothesis is valid as we can see there are multiple inventory records for a particular film as one film's copy can be available at multiple stores.

Moving on to check our second hypothesis, we can just do a group by on the ```film_id``` and sort it in descending order to check if there's just one row per unique ```film_id``` or not.

```sql
SELECT
  film_id,
  COUNT(*) AS film_count
FROM dvd_rentals.film
GROUP BY film_id
ORDER BY film_id DESC
LIMIT 5;
```

*Output:*

| film_id | film_count |
|---------|------------|
| 1000    | 1          |
| 999     | 1          |
| 998     | 1          |
| 997     | 1          |
| 996     | 1          |

Thus, we can confirm that there is a one-to-one relationship for ```film_id``` in the ```film``` table.

### 3.2.4 How many unique foreign key values exist in each table?

We can check this using the ANTI JOIN and see if there are any unique ```film_id``` foreign key which is not present in either the left or the right table.

**```inventory``` table foreign key analyisis for ```film_id```**

```sql
SELECT
  COUNT(DISTINCT film_id) AS total_count
FROM dvd_rentals.inventory
WHERE NOT EXISTS(
  SELECT film_id
  FROM dvd_rentals.film
  WHERE inventory.film_id = film.film_id
);
```

*Output:*

| total_count |
|-------------|
| 0           |

Here, we can see that all the ```film_id``` values in the inventory table are present in the ```film``` table.

Now, let's also try to implement the same for the right table ```film`` table.

```sql
SELECT
  COUNT(DISTINCT film_id) AS total_count
FROM dvd_rentals.film
WHERE NOT EXISTS(
  SELECT film_id
  FROM dvd_rentals.inventory
  WHERE inventory.film_id = film.film_id
);
```

*Output:*

| total_count |
|-------------|
| 42          |

Alright, so there is some discrepancy in the number of unique ```film_id``` values between the inventory & film table.

While we are here, let's also check the total number of  foreign key distinct values that would be generated after we do the ```LEFT SEMI JOIN```.

```sql
SELECT
  COUNT(DISTINCT film_id) AS total_count
FROM dvd_rentals.inventory
WHERE EXISTS (
  SELECT film_id
  FROM dvd_rentals.film
  WHERE film.film_id = inventory.film_id
);
```

*Output:*

| total_count |
|-------------|
| 958         |

So, now that we know we have all our foreign key values in the ```inventory``` table, it's time to decide our join, and in this particular example as we have seen before it won't make a difference to choose either INNER or LEFT Join. We can test this by implementing both the joins and comparing the number of unique key values.

<details>
<summary>Click to view SQL code</summary>
<br>

```sql
DROP TABLE IF EXISTS left_join_part_2;
CREATE TEMPORARY TABLE left_join_part_2 AS (
SELECT
  inventory.inventory_id,
  inventory.film_id,
  film.title
FROM dvd_rentals.inventory
LEFT JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
);

DROP TABLE IF EXISTS inner_join_part_2;
CREATE TEMPORARY TABLE inner_join_part_2 AS (
SELECT 
  inventory.inventory_id,
  inventory.film_id,
  film.title
FROM dvd_rentals.inventory
LEFT JOIN dvd_rentals.film
  ON inventory.film_id = film.film_id
);

SELECT 
  'inner join' AS join_type,
  COUNT(*) AS row_counts,
  COUNT(DISTINCT film_id) AS unique_film_values
FROM inner_join_part_2

UNION

SELECT 
  'left join' AS join_type,
  COUNT(*) AS row_counts,
  COUNT(DISTINCT film_id) AS unique_film_values
FROM left_join_part_2;
```

</details>

*Output:*

| join_type  | row_counts | unique_film_values |
|------------|------------|--------------------|
| inner join | 4581       | 958                |
| left join  | 4581       | 958                |

### 3.2.5 Join implementation of part 1 & 2

Now, that we have decided on the type of join that we are going to be using, let's implement a three-table ```INNER JOIN```.

```sql
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
```

*Output:*

| customer_id | film_id | title                |
|-------------|---------|----------------------|
| 1           | 308     | FERRIS MOTHER        |
| 1           | 243     | DOORS PRESIDENT      |
| 1           | 924     | UNFORGIVEN ZOOLANDER |
| 1           | 480     | JEEPERS WEDDING      |
| 1           | 611     | MUSKETEERS WAIT      |

### 3.2.6 Join implementation of parts 3 & 4

We can follow all the above steps and come up with a purpose, and hypotheses to validate it for the join part 3 & part 4. But, if we go through all of it we'll find that there is a one-to-one relationship for ```film_id``` in both the film & film_category table for part 3. 

Also, for part 4, there is a one-to-many relationship between ```category_id``` in the left table i.e. film_category table and a one-to-one relationship for the category table.

Hence, we will just go ahead with our ```INNER JOIN``` implementation for part 3 and part 4 tables as before.

```sql
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
```

*Output:*

| film_id | category_id | category_name |
|---------|-------------|---------------|
| 1       | 6           | Documentary   |
| 2       | 11          | Horror        |
| 3       | 6           | Documentary   |
| 4       | 11          | Horror        |
| 5       | 8           | Family        |

## 3.3 Final Join implementation

Now, let's create our full final dataset for part 1 up to part 4 using ```INNER JOIN``` using the same implementation as above.

```sql
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
```

*Output:*

| customer_id | film_id | title           | category_id | category_name |
|-------------|---------|-----------------|-------------|---------------|
| 130         | 80      | BLANKET BEVERLY | 8           | Family        |
| 459         | 333     | FREAKY POCUS    | 12          | Music         |
| 408         | 373     | GRADUATE LORD   | 3           | Children      |
| 333         | 535     | LOVE SUICIDES   | 11          | Horror        |
| 222         | 450     | IDOLS SNATCHERS | 3           | Children      |
| 549         | 613     | MYSTIC TRUMAN   | 5           | Comedy        |
| 269         | 870     | SWARM GOLD      | 11          | Horror        |
| 239         | 510     | LAWLESS VISION  | 2           | Animation     |
| 126         | 565     | MATRIX SNOWMAN  | 9           | Foreign       |
| 399         | 396     | HANGING DEEP    | 7           | Drama         |

This is now our final table output such that we can run our aggregations and solve the business problems.

# 4. SQL Problem Solving

## 4.1 Base table

Let's again take a look at our base table that we implemented during our last section after joining the tables.

```sql
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
```

*Output:*

| customer_id | film_id | title           | category_id | category_name |
|-------------|---------|-----------------|-------------|---------------|
| 130         | 80      | BLANKET BEVERLY | 8           | Family        |
| 459         | 333     | FREAKY POCKS    | 12          | Music         |
| 408         | 373     | GRADUATE LORD   | 3           | Children      |
| 333         | 535     | LOVE SUICIDES   | 11          | Horror        |
| 222         | 450     | IDOLS SNATCHERS | 3           | Children      |
| 549         | 613     | MYSTIC TRUMAN   | 5           | Comedy        |
| 269         | 870     | SWARM GOLD      | 11          | Horror        |
| 239         | 510     | LAWLESS VISION  | 2           | Animation     |
| 126         | 565     | MATRIX SNOWMAN  | 9           | Foreign       |
| 399         | 396     | HANGING DEEP    | 7           | Drama         |

## 4.2 Group by count to get a rental count

As we need the rental count for each film watched by the customer based on its category, let's do a group across the above table and get our results.

Now, as per the business requirement, we need to find the top 2 categories for each customer based on the rental count and also calculate some aggregated functions such as percentile, average_count, and percentage_count for each category. But to do that we'll need the values for all customers across all categories and not just the top 2. If we only query the top 2 and do our aggregated functions, the data will be skewed.

Let's first check the output of the group by when ```customer_id``` = 1, 2, 3. The output is segregated based on the id just for easy viewing.

```sql
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
```

**when ```customer_id``` = 1**

*Output:*

| customer_id | category_name | rental_count |
|-------------|---------------|--------------|
| 1           | Classics      | 6            |
| 1           | Comedy        | 5            |
| 1           | Drama         | 4            |
| 1           | Action        | 2            |
| 1           | Music         | 2            |
| 1           | New           | 2            |
| 1           | Sci-Fi        | 2            |
| 1           | Sports        | 2            |
| 1           | Animation     | 2            |
| 1           | Documentary   | 1            |
| 1           | Family        | 1            |
| 1           | Games         | 1            |
| 1           | Travel        | 1            |
| 1           | Foreign       | 1            |

<br>

**when ```customer_id``` = 2**

<details>
<summary>Click to view output</summary>
<br>

| customer_id | category_name | rental_count |
|-------------|---------------|--------------|
| 2           | Sports        | 5            |
| 2           | Classics      | 4            |
| 2           | Animation     | 3            |
| 2           | Action        | 3            |
| 2           | Travel        | 2            |
| 2           | Games         | 2            |
| 2           | New           | 2            |
| 2           | Foreign       | 1            |
| 2           | Children      | 1            |
| 2           | Documentary   | 1            |
| 2           | Family        | 1            |
| 2           | Music         | 1            |
| 2           | Sci-Fi        | 1            |
| 3           | Action        | 4            |
| 3           | Animation     | 3            |
| 3           | Sci-Fi        | 3            |
| 3           | Sports        | 2            |
| 3           | Comedy        | 2            |
| 3           | Games         | 2            |
| 3           | Horror        | 2            |
| 3           | Music         | 2            |
| 3           | New           | 2            |
| 3           | Drama         | 1            |
| 3           | Family        | 1            |
| 3           | Documentary   | 1            |
| 3           | Classics      | 1            |

</details>

<br>

**when ```customer_id``` = 3**

<details>
<summary>Click to view output</summary>
<br>

| customer_id | category_name | rental_count |
|-------------|---------------|--------------|
| 3           | Action        | 4            |
| 3           | Animation     | 3            |
| 3           | Sci-Fi        | 3            |
| 3           | Sports        | 2            |
| 3           | Comedy        | 2            |
| 3           | Games         | 2            |
| 3           | Horror        | 2            |
| 3           | Music         | 2            |
| 3           | New           | 2            |
| 3           | Drama         | 1            |
| 3           | Family        | 1            |
| 3           | Documentary   | 1            |
| 3           | Classics      | 1            |

</details>

## 4.3 Dealing with ties

We know that we need the top 2 categories for each customer based on their rental count, but what if there is a tie. For eg,

When we check the top 3 categories for customer 3, we get the following output.

| customer_id | category_name | rental_count |
|-------------|---------------|--------------|
| 3           | Action        | 4            |
| 3           | Animation     | 3            |
| 3           | Sci-Fi        | 3            |

Here there is a tie because ```rental_count``` = 3 for both Animation and Sci-Fi film categories. So, here we can always sort it alphabetically and select the 1st or 2nd category. This is easy and maybe the least time-consuming option preferred. But, what we can also do is check out the ```rental_date``` column and see which category book the customer bought the last, and based on that, we select the category. Let's check how we can implement it using SQL for customer 3.

```sql
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
```

*Output:*

| customer_id | category_name | rental_count | latest_rental_date       |
|-------------|---------------|--------------|--------------------------|
| 3           | Action        | 4            | 2005-07-29T11:07:04.000Z |
| 3           | Sci-Fi        | 3            | 2005-08-22T09:37:27.000Z |
| 3           | Animation     | 3            | 2005-08-18T14:49:55.000Z |
| 3           | Music         | 2            | 2005-08-23T07:10:14.000Z |
| 3           | Comedy        | 2            | 2005-08-20T06:14:12.000Z |
| 3           | Horror        | 2            | 2005-07-31T11:32:58.000Z |
| 3           | Sports        | 2            | 2005-07-30T13:31:20.000Z |
| 3           | New           | 2            | 2005-07-28T04:46:30.000Z |
| 3           | Games         | 2            | 2005-07-27T04:54:42.000Z |
| 3           | Classics      | 1            | 2005-08-01T14:19:48.000Z |
| 3           | Family        | 1            | 2005-07-31T03:27:58.000Z |
| 3           | Drama         | 1            | 2005-07-30T21:45:46.000Z |
| 3           | Documentary   | 1            | 2005-06-19T08:34:53.000Z |

Now, we can see that the ```Sci-Fi``` category has taken up the second most watched category place for customer 3. Earlier, it was ```Animation```.

## 4.3 Calculating average of all categories

We can calculate the average across categories for the first three customers for now as follows.

```sql
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
```

*Output:*

| category_name | average_value |
|---------------|---------------|
| Action        | 3.00          |
| Animation     | 2.67          |
| Children      | 1.00          |
| Classics      | 3.67          |
| Comedy        | 3.50          |
| Documentary   | 1.00          |
| Drama         | 2.50          |
| Family        | 1.00          |
| Foreign       | 1.00          |
| Games         | 1.67          |
| Horror        | 2.00          |
| Music         | 1.67          |
| New           | 2.00          |
| Sci-Fi        | 2.00          |
| Sports        | 3.00          |
| Travel        | 1.50          |

## 4.4 Data aggregation on the whole dataset

Now that we have seen the aggregation performed for just 3 customers, lets do it across the whole dataset. As said earlier, we do need the top 2 categories but in order to perform the average_rental_count, percentile and percentage_count, we need aggregation on the whole data so let's do it.

We will split our aggregations and create temporary tables for each of them.

### 4.4.1 Customer Rental count

Let's first aggregate the ```rental_count``` for each customer's record for each category. Here, we'll also select the ```latest_rental_date``` for that category which will be useful for us in sorting as seen earlier.

```sql
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
```

*Output:*

| customer_id | category_name | rental_count | latest_rental_date       |
|-------------|---------------|--------------|--------------------------|
| 1           | Classics      | 6            | 2005-08-19T09:55:16.000Z |
| 1           | Comedy        | 5            | 2005-08-22T19:41:37.000Z |
| 1           | Drama         | 4            | 2005-08-18T03:57:29.000Z |
| 1           | Animation     | 2            | 2005-08-22T20:03:46.000Z |
| 1           | Sci-Fi        | 2            | 2005-08-21T23:33:57.000Z |
| 1           | New           | 2            | 2005-08-19T13:56:54.000Z |
| 1           | Action        | 2            | 2005-08-17T12:37:54.000Z |
| 1           | Music         | 2            | 2005-07-09T16:38:01.000Z |
| 1           | Sports        | 2            | 2005-07-08T07:33:56.000Z |
| 1           | Family        | 1            | 2005-08-02T18:01:38.000Z |
| 1           | Documentary   | 1            | 2005-08-01T08:51:04.000Z |
| 1           | Foreign       | 1            | 2005-07-28T16:18:23.000Z |
| 1           | Travel        | 1            | 2005-07-11T10:13:46.000Z |
| 1           | Games         | 1            | 2005-07-08T03:17:05.000Z |

### 4.4.2 Total customer rentals

Now, in order to find the ```category_percentage``` i.e. the total proportion of films watched by the customer in that category , we need the total rental counts for each customer.

```sql
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
```

*Output:*

| customer_id | total_rentals |
|-------------|---------------|
| 1           | 32            |
| 2           | 27            |
| 3           | 26            |
| 4           | 22            |
| 5           | 38            |

### 4.4.3 Average category rental counts

Finally, we can calculate the ```AVG``` of all rentals across categories for all customers.

```sql
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
```

*Output:*

| category_name | average_rental_value |
|---------------|----------------------|
| Animation     | 2.33                 |
| Sports        | 2.27                 |
| Family        | 2.19                 |
| Action        | 2.18                 |
| Sci-Fi        | 2.17                 |
| Documentary   | 2.17                 |
| Drama         | 2.12                 |
| Foreign       | 2.10                 |
| Games         | 2.04                 |
| Classics      | 2.01                 |
| New           | 2.01                 |
| Children      | 1.96                 |
| Comedy        | 1.90                 |
| Travel        | 1.89                 |
| Horror        | 1.88                 |
| Music         | 1.86                 |

It will be awkward though to tell our customers that your average is 6.27 more than the dvd rental co average in this category. So, let's just floor these values and we can do that by updating the table.

```sql
UPDATE average_category_rental_counts
SET average_rental_value = FLOOR(average_rental_value)
RETURNING *;
```

*Output:*

| category_name | average_rental_value |
|---------------|----------------------|
| Sports        | 2                    |
| Classics      | 2                    |
| New           | 2                    |
| Family        | 2                    |
| Comedy        | 1                    |
| Animation     | 2                    |
| Travel        | 1                    |
| Music         | 1                    |
| Horror        | 1                    |
| Drama         | 2                    |
| Sci-Fi        | 2                    |
| Games         | 2                    |
| Documentary   | 2                    |
| Foreign       | 2                    |
| Action        | 2                    |
| Children      | 1                    |

We can check out the new updated table to confirm if our update was successful.

```sql
SELECT *
FROM average_category_rental_counts;
```

*Output:*

Same as above!

### 4.4.4 Percentile rank

We need to display the percentile rank of the customer in terms of top X% based on that particular category. We can implement this by using the ```PERCENT_RANK``` window function. 

```sql
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
```

*Output:*

| customer_id | category_name | rental_count | percentile            |
|-------------|---------------|--------------|-----------------------|
| 1           | Classics      | 6            | 0.0021413276231263384 |
| 1           | Comedy        | 5            | 0.006072874493927126  |
| 1           | Drama         | 4            | 0.03                  |
| 1           | Sports        | 2            | 0.34555984555984554   |
| 1           | Sci-Fi        | 2            | 0.30039525691699603   |
| 1           | Music         | 2            | 0.2040358744394619    |
| 1           | Animation     | 2            | 0.38877755511022044   |
| 1           | New           | 2            | 0.2676659528907923    |
| 1           | Action        | 2            | 0.33398821218074654   |
| 1           | Foreign       | 1            | 0.6178861788617886    |

Here, the percentile values are shown from range 0 to 1 which will not be useful for us so lets multiply it by 100 and take the ceiling value of it.

```sql
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
```

*Output:*

| customer_id | category_name | rental_count | percentile |
|-------------|---------------|--------------|------------|
| 1           | Classics      | 6            | 1          |
| 1           | Comedy        | 5            | 1          |
| 1           | Drama         | 4            | 3          |
| 1           | Sports        | 2            | 35         |
| 1           | Sci-Fi        | 2            | 31         |
| 1           | Music         | 2            | 21         |
| 1           | Animation     | 2            | 39         |
| 1           | New           | 2            | 27         |
| 1           | Action        | 2            | 34         |
| 1           | Foreign       | 1            | 62         |

Now, these percentile values look reasonable. Lets store these values in another temp table.

```sql
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
```

*Output:*

| customer_id | category_name | rental_count | percentile |
|-------------|---------------|--------------|------------|
| 1           | Classics      | 6            | 1          |
| 1           | Comedy        | 5            | 1          |

## 4.5 Joining temporary tables

So, now that we have created multiple temporary tables for different aggregations, we can join them in a same as before using ```INNER JOIN```. 

```sql
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
```

*Output:*

| customer_id | category_name | rental_count | total_rentals | average_rental_value | percentile |
|-------------|---------------|--------------|---------------|----------------------|------------|
| 1           | Classics      | 6            | 32            | 2                    | 1          |
| 1           | Comedy        | 5            | 32            | 1                    | 1          |
| 1           | Drama         | 4            | 32            | 2                    | 3          |
| 1           | Music         | 2            | 32            | 1                    | 21         |
| 1           | New           | 2            | 32            | 2                    | 27         |
| 1           | Sci-Fi        | 2            | 32            | 2                    | 31         |
| 1           | Action        | 2            | 32            | 2                    | 34         |
| 1           | Sports        | 2            | 32            | 2                    | 35         |
| 1           | Animation     | 2            | 32            | 2                    | 39         |
| 1           | Travel        | 1            | 32            | 1                    | 58         |
| 1           | Games         | 1            | 32            | 2                    | 61         |
| 1           | Foreign       | 1            | 32            | 2                    | 62         |
| 1           | Documentary   | 1            | 32            | 2                    | 65         |
| 1           | Family        | 1            | 32            | 2                    | 66         |

Therefore, only thing remaining wrt categories are the calculated fields such as ```avg_comparison``` and ```category_percentage```. Lets work on that next.

## 4.6 Adding calculated fields

Two fields remaining are ```avg_comparison``` which the comparison between customers rental_count & average of all customers across the data and ```category_percentage``` displaying how much % does a category contribute to for a particular user.

```sql
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
```

*Output:*

| customer_id | category_name | rental_count | latest_rental_date       | total_rentals | average_rental_value | percentile | average_comparison | category_percentage |
|-------------|---------------|--------------|--------------------------|---------------|----------------------|------------|--------------------|---------------------|
| 1           | Comedy        | 5            | 2005-08-22T19:41:37.000Z | 32            | 1                    | 1          | 4                  | 16                  |
| 1           | Classics      | 6            | 2005-08-19T09:55:16.000Z | 32            | 2                    | 1          | 4                  | 19                  |
| 1           | Drama         | 4            | 2005-08-18T03:57:29.000Z | 32            | 2                    | 3          | 2                  | 13                  |
| 1           | Music         | 2            | 2005-07-09T16:38:01.000Z | 32            | 1                    | 21         | 1                  | 6                   |
| 1           | New           | 2            | 2005-08-19T13:56:54.000Z | 32            | 2                    | 27         | 0                  | 6                   |

Now, we have the required columns which are category-based for all our customers and across all categories.

## 4.7 Adding a row_number() and filtering top 2 categories

Here, we will use the ```ROW_NUMBER``` window function which will give us a row number based on the rental_count and latest_rental_date for each of our customer. Then, we can filter out the top two rows as required to solve the case study.

```sql
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
```

Lets check the output of the table for our first 3 customers.

```sql
SELECT *
FROM top_categories_information
WHERE customer_id IN (1, 2, 3);
```

*Output:*

| customer_id | category_rank | rental_count | average_comparison | percentile | category_percentage |
|-------------|---------------|--------------|--------------------|------------|---------------------|
| 1           | 1             | 6            | 4                  | 1          | 19                  |
| 1           | 2             | 5            | 4                  | 1          | 16                  |
| 2           | 1             | 5            | 3                  | 3          | 19                  |
| 2           | 2             | 4            | 2                  | 2          | 15                  |
| 3           | 1             | 4            | 2                  | 5          | 15                  |
| 3           | 2             | 3            | 1                  | 15         | 12                  |

Amazing, and that's why we want to fill in a few of our business requirements from the email template.

# 5. Final Solution

Now that we have identified the key columns and performed all our table analysis, lets start implementing the final solution to get all the answers required by the business team for sending the email template.

## 5.1 Category Insights

Let's start creating temporary tables for each of the requirements one by one and then merge them later into a single SQL script.

### 5.1.1 Create Base Dataset

We first create a ```complete_joint_dataset``` implementing all the required joins as seen before. Let's also include the ```rental_date``` column for each rental by the customer. This will help us break any ties if any for choosing the top 2 categories of each customer.

```sql
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

--Display sample outputs from the above table
SELECT *
FROM complete_joint_dataset
LIMIT 5;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | film_id | title           | category_name | rental_date         |
|-------------|---------|-----------------|---------------|---------------------|
| 130         | 80      | BLANKET BEVERLY | Family        | 2005-05-24T22:53:30 |
| 459         | 333     | FREAKY POCUS    | Music         | 2005-05-24T22:54:33 |
| 408         | 373     | GRADUATE LORD   | Children      | 2005-05-24T23:03:39 |
| 333         | 535     | LOVE SUICIDES   | Horror        | 2005-05-24T23:04:41 |
| 222         | 450     | IDOLS SNATCHERS | Children      | 2005-05-24T23:05:21 |

</details>

### 5.1.2 Category Counts

Now, that we have the total dataset table containing records for each customer's rental along with its category, let's calculate the category count for each customer's rental records. Also, let's take a look at the records when ```customer_id = 1```.

```sql
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

--Display sample outputs from the above table
SELECT *
FROM category_counts
WHERE customer_id = 1
ORDER BY
  rental_count DESC,
  latest_rental_date DESC;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | category_name | rental_count | latest_rental_date  |
|-------------|---------------|--------------|---------------------|
| 1           | Classics      | 6            | 2005-08-19T09:55:16 |
| 1           | Comedy        | 5            | 2005-08-22T19:41:37 |
| 1           | Drama         | 4            | 2005-08-18T03:57:29 |
| 1           | Animation     | 2            | 2005-08-22T20:03:46 |
| 1           | Sci-Fi        | 2            | 2005-08-21T23:33:57 |
| 1           | New           | 2            | 2005-08-19T13:56:54 |
| 1           | Action        | 2            | 2005-08-17T12:37:54 |
| 1           | Music         | 2            | 2005-07-09T16:38:01 |
| 1           | Sports        | 2            | 2005-07-08T07:33:56 |
| 1           | Family        | 1            | 2005-08-02T18:01:38 |
| 1           | Documentary   | 1            | 2005-08-01T08:51:04 |
| 1           | Foreign       | 1            | 2005-07-28T16:18:23 |
| 1           | Travel        | 1            | 2005-07-11T10:13:46 |
| 1           | Games         | 1            | 2005-07-08T03:17:05 |

</details>

### 5.1.3 Total Counts

Since we later need to calculate the percentage of each category it counts to the customers viewing history, lets create a ```total_counts``` table from the above table.

```sql
DROP TABLE IF EXISTS total_counts;
CREATE TEMPORARY TABLE total_counts AS(
SELECT
  customer_id,
  SUM(rental_count) AS total_count
FROM category_counts
GROUP BY customer_id
);

--Display sample outputs from the above table
SELECT *
FROM total_counts
ORDER BY customer_id
LIMIT 5;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | total_count |
|-------------|-------------|
| 1           | 32          |
| 2           | 27          |
| 3           | 26          |
| 4           | 22          |
| 5           | 38          |

</details>

### 5.1.4 Top Categories

Now, let's filter out the top 2 categories for each customer based on their rental_count, and to avoid any ties, order the categories by their name and the ```latest_rental_date``` in that category.

```sql
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

--Display sample outputs from the above table
SELECT *
FROM top_categories
LIMIT 5;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | category_name | rental_count | category_rank |
|-------------|---------------|--------------|---------------|
| 1           | Classics      | 6            | 1             |
| 1           | Comedy        | 5            | 2             |
| 2           | Sports        | 5            | 1             |
| 2           | Classics      | 4            | 2             |
| 3           | Action        | 4            | 1             |

</details>

### 5.1.5 Average Category Counts

Here, we calculate the average rental count for each category. This will help us in filling one of the requirements.

```sql
DROP TABLE IF EXISTS average_category_count;
CREATE TEMPORARY TABLE average_category_count AS (
SELECT
  category_name,
  FLOOR(AVG(rental_count)) AS category_count
FROM category_counts
GROUP BY category_name
);

--Display sample outputs from the above table
SELECT *
FROM average_category_count
ORDER BY category_name;
```

<details>
<summary>Click to view output.</summary>
<br>

| category_name | category_count |
|---------------|----------------|
| Action        | 2              |
| Animation     | 2              |
| Children      | 1              |
| Classics      | 2              |
| Comedy        | 1              |
| Documentary   | 2              |
| Drama         | 2              |
| Family        | 2              |
| Foreign       | 2              |
| Games         | 2              |
| Horror        | 1              |
| Music         | 1              |
| New           | 2              |
| Sci-Fi        | 2              |
| Sports        | 2              |
| Travel        | 1              |

</details>

### 5.1.6 Top Category Percentile

Here, we compare each customer's top category ```rental_count``` to all the other customers. In short, we calculate what percentile the customer fits in for their top category.

```sql
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

--Display sample outputs from the above table
SELECT *
FROM top_category_percentile
ORDER BY customer_id
LIMIT 5;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | category_name | rental_count | percentile |
|-------------|---------------|--------------|------------|
| 1           | Classics      | 6            | 1          |
| 2           | Sports        | 5            | 2          |
| 3           | Action        | 4            | 4          |
| 4           | Horror        | 3            | 8          |
| 5           | Classics      | 7            | 1          |

</details>

### 5.1.7 First Category Insights

For the top category, we require ```average_comparison``` and ```percentile``` for each customer. Let's compile both of these requirements into a single table.

```sql
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

--Display sample outputs from the above table
SELECT *
FROM first_category_insights
LIMIT 5;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | category_name | rental_count | average_comparison | percentile |
|-------------|---------------|--------------|--------------------|------------|
| 323         | Action        | 7            | 5                  | 1          |
| 506         | Action        | 7            | 5                  | 1          |
| 151         | Action        | 6            | 4                  | 1          |
| 410         | Action        | 6            | 4                  | 1          |
| 126         | Action        | 6            | 4                  | 1          |

</details>

### 5.1.8 Second Category Insights

And for the second category, we need to calculate its ```total_percentage``` that it contains when compared to a customer's total rental watching history.

```sql
DROP TABLE IF EXISTS second_category_insights;
CREATE TEMPORARY TABLE second_category_insights AS (
SELECT
  t1.customer_id,
  t1.category_name,
  t1.rental_count,
  ROUND(
    100 * t1.rental_count::NUMERIC / t2.total_count
  ) AS total_percentage
FROM top_categories AS t1
LEFT JOIN total_counts AS t2
  ON t1.customer_id = t2.customer_id
WHERE category_rank = 2
);

SELECT *
FROM second_category_insights
LIMIT 5;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | category_name | rental_count | total_percentage |
|-------------|---------------|--------------|------------------|
| 184         | Drama         | 3            | 13               |
| 87          | Sci-Fi        | 3            | 10               |
| 477         | Travel        | 3            | 14               |
| 273         | New           | 4            | 11               |
| 550         | Drama         | 4            | 13               |

</details>

## 5.2 Category Recommendations

### 5.2.1 Film Counts

First, we will calculate the total ```rental_count``` which is how many times a particular film has been rented by customers. This will help us in recommending new films to customers which they haven't watched yet.

```sql
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
```

<details>
<summary>Click to view output.</summary>
<br>

| film_id | title               | category_name | rental_count |
|---------|---------------------|---------------|--------------|
| 103     | BUCKET BROTHERHOOD  | Travel        | 34           |
| 738     | ROCKETEER MOTHER    | Foreign       | 33           |
| 767     | SCALAWAG DUCK       | Music         | 32           |
| 730     | RIDGEMONT SUBMARINE | New           | 32           |
| 331     | FORWARD TEMPLE      | Games         | 32           |

</details>

### 5.2.2 Category Film Exclusions

We now make a list of all the films every customer has watched along with the ```film_id``` so it helps us in recommending unwatched films to customers. This can be used by performing an ```ANTI JOIN``` later with the ```film_counts``` table. 

```sql
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
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | film_id | title                  | category_name |
|-------------|---------|------------------------|---------------|
| 194         | 264     | DWARFS ALTER           | Games         |
| 293         | 902     | TRADING PINOCCHIO      | Sports        |
| 64          | 366     | GOLDFINGER SENSIBILITY | Drama         |
| 329         | 886     | THEORY MERMAID         | Animation     |
| 172         | 154     | CLASH FREDDY           | Animation     |

</details>

### 5.2.3 Final Category Recommendations

Finally, we find out the 3 films that we can recommend to each customer based on their top two categories. Here, we use a ```LEFT JOIN``` with the ```film_counts``` table and rank films of each category depending on the ```rental_count``` of that film across all the customers and later we use an ```ANTI JOIN``` with the ```category_film_exclusion``` to exclude film that has been already watched from the recommendation list.

```sql
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
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | category_name | category_rank | film_id | title               | rental_count | reco_rank |
|-------------|---------------|---------------|---------|---------------------|--------------|-----------|
| 1           | Classics      | 1             | 891     | TIMBERLAND SKY      | 31           | 1         |
| 1           | Classics      | 1             | 358     | GILMORE BOILED      | 28           | 2         |
| 1           | Classics      | 1             | 951     | VOYAGE LEGALLY      | 28           | 3         |
| 1           | Comedy        | 2             | 1000    | ZORRO ARK           | 31           | 1         |
| 1           | Comedy        | 2             | 127     | CAT CONEHEADS       | 30           | 2         |
| 1           | Comedy        | 2             | 638     | OPERATION OPERATION | 27           | 3         |

</details>

## 5.3 Actor Insights

### 5.3.1 Actor Joint Table

Here, we create a similar base table as ```complete_joint_dataset``` but this time we join the tables ```film_actor``` and ```actor``` along with the ```rental``` table. This will give us a list of all the customer's rentals along with all the actors that starred in it.

```sql
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
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | rental_id | rental_date              | film_id | title           | actor_id | first_name | last_name |
|-------------|-----------|--------------------------|---------|-----------------|----------|------------|-----------|
| 130         | 1         | 2005-05-24T22:53:30.000Z | 80      | BLANKET BEVERLY | 200      | THORA      | TEMPLE    |
| 130         | 1         | 2005-05-24T22:53:30.000Z | 80      | BLANKET BEVERLY | 193      | BURT       | TEMPLE    |
| 130         | 1         | 2005-05-24T22:53:30.000Z | 80      | BLANKET BEVERLY | 173      | ALAN       | DREYFUSS  |
| 130         | 1         | 2005-05-24T22:53:30.000Z | 80      | BLANKET BEVERLY | 16       | FRED       | COSTNER   |
| 459         | 2         | 2005-05-24T22:54:33.000Z | 333     | FREAKY POCUS    | 147      | FAY        | WINSLET   |

</details>

Let's also check out the distinct values count for a few columns.

```sql
SELECT
  COUNT(*) AS total_row_count,
  COUNT(DISTINCT rental_id) AS unique_rental_id,
  COUNT(DISTINCT film_id) AS unique_film_id,
  COUNT(DISTINCT actor_id) AS unique_actor_id,
  COUNT(DISTINCT customer_id) AS unique_customer_id
FROM actor_joint_dataset;
```

*Output:*

| total_row_count | unique_rental_id | unique_film_id | unique_actor_id | unique_customer_id |
|-----------------|------------------|----------------|-----------------|--------------------|
| 87980           | 16004            | 955            | 200             | 599                |

### 5.3.2 Top Actor Counts

Now, based on the ```actor_joint_dataset```, we calculate the count of the total number of actors film a customer has watched and then select the top actor based on the ```DENSE_RANK()``` window function value. This will take care of our first actor insights requirement for the email template.

```sql
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

--Display a few sample dataset rows
SELECT *
FROM top_actor_counts
LIMIT 5;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | actor_id | first_name | last_name | rental_count |
|-------------|----------|------------|-----------|--------------|
| 1           | 37       | VAL        | BOLGER    | 6            |
| 2           | 107      | GINA       | DEGENERES | 5            |
| 3           | 150      | JAYNE      | NOLTE     | 4            |
| 4           | 102      | WALTER     | TORN      | 4            |
| 5           | 12       | KARL       | BERRY     | 4            |

</details>

## 5.4 Actor Recommendations

### 5.4.1 Actor Film Counts

We first calculate the actor-film rental counts which will help us in recommending the films to the customer later.

```sql
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

--Display sample row outputs from the above table
SELECT *
FROM actor_film_counts
LIMIT 5;
```

<details>
<summary>Click to view output.</summary>
<br>

| film_id | actor_id | title            | rental_count |
|---------|----------|------------------|--------------|
| 1       | 1        | ACADEMY DINOSAUR | 23           |
| 1       | 10       | ACADEMY DINOSAUR | 23           |
| 1       | 20       | ACADEMY DINOSAUR | 23           |
| 1       | 30       | ACADEMY DINOSAUR | 23           |
| 1       | 40       | ACADEMY DINOSAUR | 23           |

</details>

### 5.4.2 Actor Film Exclusions

Now, we will create a table of films that should be excluded while recommending based on the customer's most watched actor films. This will be a combination of the films that the customer has already watched along with the films that we have recommended in their top 2 category recommendation sections.

```sql
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
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | film_id |
|-------------|---------|
| 493         | 567     |
| 114         | 789     |
| 596         | 103     |
| 176         | 121     |
| 459         | 724     |

</details>

### 5.4.3 Final Actor Recommendations

Finally, we create a table containing all the film recommendations for the customer based on their most watched actor from the ```top_actor_counts``` table. We will use the ```ANTI JOIN``` to make sure to exclude the films which the customer has already watched and we have already recommended in the top 2 category section.

```sql
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

--Display sample output rows for customer_id = 1
SELECT *
FROM actor_recommendations
WHERE customer_id = 1;
```

<details>
<summary>Click to view output.</summary>
<br>

| customer_id | first_name | last_name | rental_count | title           | film_id | actor_id | reco_rank |
|-------------|------------|-----------|--------------|-----------------|---------|----------|-----------|
| 1           | VAL        | BOLGER    | 6            | PRIMARY GLASS   | 697     | 37       | 1         |
| 1           | VAL        | BOLGER    | 6            | ALASKA PHANTOM  | 12      | 37       | 2         |
| 1           | VAL        | BOLGER    | 6            | METROPOLIS COMA | 572     | 37       | 3         |

</details>

## 5.5 Key Table Outputs

Let's identify our main table outputs here which are the important ones to fulfill our business requirements.

### 5.5.1 Customer Level Insights

> 1. ```first_category_insights```

<details>
<summary>Click to view output.</summary>
<br>

```sql
SELECT *
FROM first_category_insights
LIMIT 5;
```

*Output:*

| customer_id | category_name | rental_count | average_comparison | percentile |
|-------------|---------------|--------------|--------------------|------------|
| 323         | Action        | 7            | 5                  | 1          |
| 506         | Action        | 7            | 5                  | 1          |
| 151         | Action        | 6            | 4                  | 1          |
| 410         | Action        | 6            | 4                  | 1          |
| 126         | Action        | 6            | 4                  | 1          |

</details>

> 2. ```second_category_insights```

<details>
<summary>Click to view output.</summary>
<br>

```sql
SELECT *
FROM second_category_insights
LIMIT 5;
```

*Output:*

| customer_id | category_name | rental_count | total_percentage |
|-------------|---------------|--------------|------------------|
| 184         | Drama         | 3            | 13               |
| 87          | Sci-Fi        | 3            | 10               |
| 477         | Travel        | 3            | 14               |
| 273         | New           | 4            | 11               |
| 550         | Drama         | 4            | 13               |

</details>

> 3. ```top_actor_counts```

<details>
<summary>Click to view output.</summary>
<br>

```sql
SELECT *
FROM top_actor_counts
LIMIT 5;
```

*Output:*

| customer_id | actor_id | first_name | last_name | rental_count |
|-------------|----------|------------|-----------|--------------|
| 1           | 37       | VAL        | BOLGER    | 6            |
| 2           | 107      | GINA       | DEGENERES | 5            |
| 3           | 150      | JAYNE      | NOLTE     | 4            |
| 4           | 102      | WALTER     | TORN      | 4            |
| 5           | 12       | KARL       | BERRY     | 4            |

</details>

### 5.5.2 Recommendations

> 1. ```category_recommendations```

<details>
<summary>Click to view output.</summary>
<br>

```sql
SELECT *
FROM category_recommendations
WHERE customer_id = 3;
```

*Output:*

| customer_id | category_name | category_rank | film_id | title               | rental_count | reco_rank |
|-------------|---------------|---------------|---------|---------------------|--------------|-----------|
| 3           | Action        | 1             | 748     | RUGRATS SHAKESPEARE | 30           | 1         |
| 3           | Action        | 1             | 869     | SUSPECTS QUILLS     | 30           | 2         |
| 3           | Action        | 1             | 395     | HANDICAP BOONDOCK   | 28           | 3         |
| 3           | Sci-Fi        | 2             | 369     | GOODFELLAS SALUTE   | 31           | 1         |
| 3           | Sci-Fi        | 2             | 285     | ENGLISH BULWORTH    | 30           | 2         |
| 3           | Sci-Fi        | 2             | 374     | GRAFFITI LOVE       | 30           | 3         |

</details>

> 2. ```actor_recommendations```

<details>
<summary>Click to view output.</summary>
<br>

```sql
SELECT *
FROM actor_recommendations
WHERE customer_id = 3;
```

*Output:*

| customer_id | first_name | last_name | rental_count | title                | film_id | actor_id | reco_rank |
|-------------|------------|-----------|--------------|----------------------|---------|----------|-----------|
| 3           | JAYNE      | NOLTE     | 4            | SWEETHEARTS SUSPECTS | 873     | 150      | 1         |
| 3           | JAYNE      | NOLTE     | 4            | DANCING FEVER        | 206     | 150      | 2         |
| 3           | JAYNE      | NOLTE     | 4            | INVASION CYCLONE     | 468     | 150      | 3         |

</details>

## 5.6 Final Output Table

Finally, let's create the output table that the marketing business table can use directly to fulfill the business requirements of the email marketing template.

```sql
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
```

Let's check a few sample rows of our final output table.

```sql
SELECT *
FROM final_data_asset
LIMIT 5;
```

*Output:*

| customer_id | cat_1    | cat_1_insights                                                                                                              | cat_1_reco_1        | cat_1_reco_2      | cat_1_reco_3      | cat_2     | cat_2_insights                                                                  | cat_2_reco_1      | cat_2_reco_2     | cat_2_reco_3        | actor          | actor_insights                                                                                                    | actor_reco_1         | actor_reco_2          | actor_reco_3           |
|-------------|----------|-----------------------------------------------------------------------------------------------------------------------------|---------------------|-------------------|-------------------|-----------|---------------------------------------------------------------------------------|-------------------|------------------|---------------------|----------------|-------------------------------------------------------------------------------------------------------------------|----------------------|-----------------------|------------------------|
| 1           | Classics | You've watched 6 Classics films, that's 4 more than the DVD Rental Co average and puts you in the top 1% of Classics gurus! | Timberland Sky      | Gilmore Boiled    | Voyage Legally    | Comedy    | You've watched 5 Comedy films, making up 16% of your entire viewing history!    | Zorro Ark         | Cat Coneheads    | Operation Operation | Val Bolger     | You've watched 6 films featuring Val Bolger! Here are some other films Val stars in that might interest you!      | Primary Glass        | Alaska Phantom        | Metropolis Coma        |
| 2           | Sports   | You've watched 5 Sports films, that's 3 more than the DVD Rental Co average and puts you in the top 2% of Sports gurus!     | Gleaming Jawbreaker | Talented Homicide | Roses Treasure    | Classics  | You've watched 4 Classics films, making up 15% of your entire viewing history!  | Frost Head        | Gilmore Boiled   | Voyage Legally      | Gina Degeneres | You've watched 5 films featuring Gina Degeneres! Here are some other films Gina stars in that might interest you! | Goodfellas Salute    | Wife Turn             | Dogma Family           |
| 3           | Action   | You've watched 4 Action films, that's 2 more than the DVD Rental Co average and puts you in the top 4% of Action gurus!     | Rugrats Shakespeare | Suspects Quills   | Handicap Boondock | Sci-Fi    | You've watched 3 Sci-Fi films, making up 12% of your entire viewing history!    | Goodfellas Salute | English Bulworth | Graffiti Love       | Jayne Nolte    | You've watched 4 films featuring Jayne Nolte! Here are some other films Jayne stars in that might interest you!   | Sweethearts Suspects | Dancing Fever         | Invasion Cyclone       |
| 4           | Horror   | You've watched 3 Horror films, that's 2 more than the DVD Rental Co average and puts you in the top 8% of Horror gurus!     | Pulp Beverly        | Family Sweet      | Swarm Gold        | Drama     | You've watched 2 Drama films, making up 9% of your entire viewing history!      | Hobbit Alien      | Harry Idaho      | Witches Panic       | Walter Torn    | You've watched 4 films featuring Walter Torn! Here are some other films Walter stars in that might interest you!  | Curtain Videotape    | Lies Treatment        | Nightmare Chill        |
| 5           | Classics | You've watched 7 Classics films, that's 5 more than the DVD Rental Co average and puts you in the top 1% of Classics gurus! | Timberland Sky      | Frost Head        | Gilmore Boiled    | Animation | You've watched 6 Animation films, making up 16% of your entire viewing history! | Juggler Hardly    | Dogma Family     | Storm Happiness     | Karl Berry     | You've watched 4 films featuring Karl Berry! Here are some other films Karl stars in that might interest you!     | Virginian Pluto      | Stagecoach Armageddon | Telemark Heartbreakers |

Alright, now we have our final output solution table. This should be sufficient for the marketing team to run their email marketing campaign and hopefully attract some customers to rent a new recommended film.

# 6. Business Questions

## Overview

The following questions are part of the final case study quiz - these are example questions the Marketing team might be interested in!

### 1. Which film title was the most recommended for all customers?

```sql
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
```

*Output:*

| title               | reco_count |
|---------------------|------------|
| **DOGMA FAMILY**    | **126**    |
| JUGGLER HARDLY      | 123        |
| STORM HAPPINESS     | 111        |
| HANDICAP BOONDOCK   | 109        |
| GLEAMING JAWBREAKER | 106        |

So, ```DOGMA FAMILY``` was the most recommended film among all the customers.

<hr>

### 2. How many customers were included in the email campaign?

```sql
SELECT
  COUNT(DISTINCT customer_id) AS total_customers
FROM final_data_asset;
```

*Output:*

| total_customers |
|-----------------|
| 599             |

In total, ```599``` customers were included in the email marketing campaign.

<hr>

### 3. Out of all the possible films - what percentage coverage do we have in our recommendations?

```sql
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
    100 * t1.total_recommended_count::NUMERIC / t2.total_film_count
  ) AS coverage_percentage
FROM recommendations AS t1
CROSS JOIN all_films AS t2;
```

*Output:*

| coverage_percentage |
|---------------------|
| 25                  |

Out of all the films available in the dataset, a ```25%``` of them were in the recommendation list.

<hr>

### 4. What is the most popular top category?

```sql
SELECT
  category_name,
  COUNT(*) AS total_count
FROM first_category_insights
GROUP BY category_name
ORDER BY total_count DESC;
```

*Output:*

| category_name | total_count |
|---------------|-------------|
| **Sports**    | **67**      |
| Action        | 60          |
| Sci-Fi        | 58          |
| Animation     | 50          |
| Foreign       | 43          |
| Drama         | 38          |
| Documentary   | 38          |
| New           | 35          |
| Family        | 34          |
| Games         | 31          |
| Classics      | 30          |
| Travel        | 27          |
| Horror        | 23          |
| Music         | 22          |
| Comedy        | 22          |
| Children      | 21          |

```Sports``` is the most popular top category among all the customers.

<hr>

### 5. What is the 4th most popular top category?

```sql
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
```

*Output:*

| category_name | total_count | cat_rank |
|---------------|-------------|----------|
| Animation     | 50          | 4        |

The 4th most popular top category among all the customers is ```Animation```.

<hr>

### 6. What is the average percentile ranking for each customer in their top category rounded to the nearest 2 decimal places?

```sql
SELECT
  ROUND(CAST(AVG(percentile) AS NUMERIC), 
  2
  ) AS average_percentile
FROM first_category_insights;
```

*Output:*

| average_percentile |
|--------------------|
| 5.10               |

The average percentile ranking for each customer in their top category is ```5.10```.

<hr>

### 7. What is the median of the second category percentage of entire viewing history?

```sql
SELECT
  PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY total_percentage) AS median
FROM second_category_insights;
```

*Output:*

| median |
|--------|
| 13     |

The median of the second category percentage of entire viewing history is ```13```.

<hr>

### 8. What is the 80th percentile of films watched featuring each customer’s favorite actor?

```sql
SELECT
  PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY rental_count) AS _80th_percentile_films
FROM top_actor_counts;
```

*Output:*

| _80th_percentile_films |
|------------------------|
| 5                      |

<hr>

### 9. What was the average number of films watched by each customer?

```sql
SELECT
  ROUND(AVG(total_count)) AS average_films_watched
FROM total_counts;
```

*Output:*

| average_films_watched |
|-----------------------|
| 27                    |

The average number of films watched by each customer is around ```27```.

<hr>

### 10. What is the top combination of the top 2 categories and how many customers if the order is relevant (e.g. Horror and Drama is a different combination to Drama and Horror)

```sql
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
```

*Output:*

| cat_1      | cat_2         | freq_count |
|------------|---------------|------------|
| **Sports** | **Animation** | **11**     |
| Action     | Documentary   | 9          |
| Animation  | Drama         | 9          |
| Sci-Fi     | Family        | 8          |
| Animation  | Family        | 7          |

The top combination of categories is ```Sports``` & ```Animation``` and ```11``` customers have it has their top two categories when the order of the categories matters.

<hr>

### 11. Which actor was the most popular for all customers?

```sql
SELECT
  actor,
  COUNT(*) AS freq_count
FROM final_data_asset
GROUP BY actor
ORDER BY freq_count DESC
LIMIT 1;
```

*Output:*

| actor       | freq_count |
|-------------|------------|
| Walter Torn | 13         |

The most popular actor among all the customers is ```Walter Torn```.

<hr>

### 12. How many films on average had customers already seen that feature their favorite actor rounded to closest integer?

```sql
SELECT 
  ROUND(AVG(rental_count)) AS avg_count
FROM top_actor_counts;
```

*Output:*

| avg_count |
|-----------|
| 4         |

On average, customers had already watched ```4``` films that featured their favorite actor.

<hr>

### 13. What is the most common top categories combination if the order was irrelevant and how many customers have this combination? (e.g. Horror and Drama is a the same as Drama and Horror)

```sql
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
```

*Output:*

| category_1    | category_2  | freq_count |
|---------------|-------------|------------|
| **Animation** | **Sports**  | **14**     |
| Action        | Documentary | 12         |
| Family        | Sci-Fi      | 12         |
| Animation     | Family      | 12         |
| Documentary   | Drama       | 12         |

The top combination of categories is ```Animation``` & ```Sports``` and ```14``` customers have it has their top two categories when the order of the categories doesn't matter.

# Thank you, hope you liked it!
