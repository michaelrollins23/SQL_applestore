-- EXPLORE THE DATA

-- Total apps
SELECT COUNT(DISTINCT(id)) as total_apps
FROM sqlproject-403716.appleproject.applestore


-- Find null values
SELECT *
FROM sqlproject-403716.appleproject.applestore
WHERE id IS NULL or price IS NULL or user_rating IS NULL or prime_genre IS NULL


--Downloads by genre
select prime_genre, count(prime_genre) as genre_total
from sqlproject-403716.appleproject.applestore
group by prime_genre
order by genre_total desc


--Average price of paid apps
SELECT ROUND(AVG(price),2) as average_price, MAX(price) as max_price, MIN(price) as min_price
FROM sqlproject-403716.appleproject.applestore
WHERE price>0


-- Number of free apps vs paid
SELECT free_paid, COUNT(*) as total
FROM (
SELECT CASE
  WHEN price=0 then 'free'
  else 'paid'
  end as free_paid
FROM sqlproject-403716.appleproject.applestore
)
GROUP BY free_paid


--Summary of overall ratings
SELECT MIN(user_rating) AS min_rating, MAX(user_rating) AS max_rating, ROUND(AVG(user_rating),2) as average_rating
from sqlproject-403716.appleproject.applestore


-- Average raiting by genre
SELECT prime_genre, ROUND(AVG(user_rating),2) as average_rating, max(user_rating) AS max_rating, min(user_rating) AS min_rating
FROM sqlproject-403716.appleproject.applestore
GROUP BY prime_genre
ORDER BY average_rating desc


-- Count of ratings by genre
SELECT prime_genre, SUM(rating_count_tot) as number_of_ratings
FROM sqlproject-403716.appleproject.applestore
GROUP BY prime_genre
ORDER BY number_of_ratings DESC


-- Total count of genre by paid/free
SELECT *, COUNT(*) AS total
FROM 
(
  SELECT (prime_genre) as genre, CASE
    WHEN price = 0 THEN 'free'
    ELSE 'paid'
    END AS app_type
  FROM sqlproject-403716.appleproject.applestore
)
GROUP BY genre,app_type
ORDER BY genre, app_type