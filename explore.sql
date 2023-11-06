-- EXPLORE THE DATA

-- Total apps
SELECT COUNT(DISTINCT(id)) AS total_apps
FROM applestore

-- Find null values
SELECT *
FROM applestore
WHERE id IS NULL or price IS NULL or user_rating IS NULL OR prime_genre IS NULL

--Downloads by genre
SELECT prime_genre, COUNT(prime_genre) AS genre_total
FROM applestore
GROUP BY prime_genre
ORDER BY genre_total DESC

--Average price of paid apps
SELECT ROUND(AVG(price),2) AS average_price, MAX(price) AS MAX_price, MIN(price) AS MIN_price
FROM applestore
WHERE price>0

-- Number of free apps vs paid
SELECT free_paid, COUNT(*) AS total
FROM (
SELECT CASE
  WHEN price=0 THEN 'free'
  ELSE 'paid'
  END AS free_paid
FROM applestore
)
GROUP BY free_paid

--Summary of overall ratings
SELECT MIN(user_rating) AS MIN_rating, MAX(user_rating) AS MAX_rating, ROUND(AVG(user_rating),2) AS average_rating
from applestore

-- Average raiting by genre
SELECT prime_genre, ROUND(AVG(user_rating),2) AS average_rating, MAX(user_rating) AS MAX_rating, MIN(user_rating) AS MIN_rating
FROM applestore
GROUP BY prime_genre
ORDER BY average_rating DESC

-- Count of ratings by genre
SELECT prime_genre, SUM(rating_count_tot) AS number_of_ratings
FROM applestore
GROUP BY prime_genre
ORDER BY number_of_ratings DESC

-- Total count of genre by paid/free
SELECT *, COUNT(*) AS total
FROM 
(
  SELECT (prime_genre) AS genre, CASE
    WHEN price = 0 THEN 'free'
    ELSE 'paid'
    END AS app_type
  FROM applestore
)
GROUP BY genre,app_type
ORDER BY genre, app_type

