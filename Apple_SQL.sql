-- EXPLORE THE DATA

-- Total apps
SELECT COUNT(DISTINCT(id)) AS total_apps
FROM appstore

-- Find null values
SELECT *
FROM appstore
WHERE id IS NULL OR price IS NULL OR user_rating IS NULL OR prime_genre IS NULL

--Downloads by genre
SELECT prime_genre, COUNT(prime_genre) AS genre_total
FROM appstore
GROUP BY prime_genre
ORDER BY genre_total DESC

--Average price of paid apps
SELECT ROUND(AVG(price),2) AS average_price, MAX(price) AS MAX_price, MIN(price) AS min_price
FROM appstore
WHERE price>0

-- Number of free apps vs paid
SELECT free_paid, COUNT(*) AS total
FROM (
SELECT CASE
  WHEN price=0 THEN 'free'
  ELSE 'paid'
  END AS free_paid
FROM appstore
)
GROUP BY free_paid

--Summary of overall ratings
SELECT MIN(user_rating) AS min_rating, MAX(user_rating) AS MAX_rating, ROUND(AVG(user_rating),2) AS average_rating
FROM appstore

-- Average raiting by genre
SELECT prime_genre, ROUND(AVG(user_rating),2) AS average_rating, MAX(user_rating) AS MAX_rating, min(user_rating) AS min_rating
FROM appstore
GROUP BY prime_genre
ORDER BY average_rating DESC

-- COUNT of ratings by genre
SELECT prime_genre, SUM(rating_COUNT_tot) AS number_of_ratings
FROM appstore
GROUP BY prime_genre
ORDER BY number_of_ratings DESC

-- Total COUNT of genre by paid/free
SELECT *, COUNT(*) AS total
FROM 
(
  SELECT (prime_genre) AS genre, CASE
    WHEN price = 0 THEN 'free'
    ELSE 'paid'
    END AS app_type
  FROM appstore
)
GROUP BY genre,app_type
ORDER BY genre, app_type


--INSIGHTS INTO THE DATA

--Avaerage rating app type (free/paid)
SELECT app_type, ROUND(AVG(user_rating),2) AS average_rating
FROM
  (
  SELECT user_rating, CASE
    WHEN price=0 then 'Free'
    ELSE 'Paid'
    END AS app_type
  FROM appstore
  )
GROUP BY app_type

--Supported languages impact on ratings
SELECT CASE
  WHEN lang_num < 10 THEN 'Less than 10'
  WHEN lang_num BETWEEN 10 AND 20 THEN 'Between 10 and 20'
  WHEN lang_num BETWEEN 21 AND 30 THEN 'Between 21 and 30'
  ELSE 'More than 30'
  END AS language_bucket,ROUND(AVG(user_rating),2) AS average_rating
FROM appstore
GROUP BY language_bucket
ORDER BY average_rating DESC

-- Check genres with low ratings
SELECT prime_genre, ROUND(AVG(user_rating),2) AS average_user_rating
FROM appstore
GROUP BY prime_genre
ORDER BY average_user_rating
LIMIT 10

-- Average user rating by description length
SELECT ROUND(AVG(s.user_rating),2) AS average_user_rating, CASE
  WHEN length(d.app_desc) < 500 THEN 'Short'
  WHEN LENGTH(d.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
  ELSE 'Long'
  END AS description_length_bucket
FROM appdescription AS d
JOIN appstore AS s ON d.id=s.id
GROUP BY description_length_bucket

--Apps by content rating and their average user_rating
SELECT cont_rating, ROUND(AVG(user_rating)) AS average_user_rating, SUM(rating_count_tot) AS total_num_ratings
FROM appstore
GROUP BY cont_rating
ORDER BY total_num_ratings DESC, average_user_rating DESC

-- Highest rated apps by rating count then user_rating
SELECT track_name, user_rating, rating_count_tot
FROM appstore
WHERE prime_genre='Social Networking'
ORDER BY rating_count_tot desc, rating_count_tot desc

-- Highest reated app with most ratings per category with rating count > 100000
SELECT track_name, prime_genre, user_rating, rating_count_tot
FROM
(
  SELECT track_name, prime_genre, user_rating, rating_count_tot,
  RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS top_rating
  FROM appstore
  WHERE rating_count_tot>100000
) AS sub
WHERE sub.top_rating=1
ORDER BY prime_genre

-- Rating compared to number of bytes
WITH app_size_bucket AS
(
SELECT CASE
  WHEN d.size_bytes BETWEEN 589824 AND 1076850687 THEN 'Small App'
  WHEN d.size_bytes BETWEEN 1076850688 AND 2067703391 THEN 'Medium App'
  WHEN d.size_bytes BETWEEN 2067703392 AND 3058556095 THEN 'Large App'
  WHEN D.size_bytes BETWEEN 3058556096 AND 4025969664 THEN 'XL App'
  END AS size_bucket,
  COUNT(*) as app_count, ROUND(AVG(s.user_rating),2) as average_user_rating
FROM appstore AS s
JOIN appdescription AS d ON s.id=d.id
GROUP BY size_bucket
)

SELECT *, ROUND(app_count/7195*100,2) as percent_of_total
FROM app_size_bucket
order by percent_of_total desc



