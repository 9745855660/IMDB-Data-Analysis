-- drop database imdb_top100;
create database imdb_top100;
select * from imdb_movie_data;
ALTER TABLE imdb_movie_data RENAME COLUMN `Moive Name` TO Movie_Name;
ALTER TABLE imdb_movie_data RENAME COLUMN `PG Rating` TO PG_Rating;
ALTER TABLE imdb_movie_data RENAME COLUMN `Meta Score` TO Meta_Score;


# 1.find out the top 10 movies names, rating,genre of movies that Leonardo DiCaprio  have acted in and sort then by rating 

select Movie_Name ,Rating,Genre From imdb_movie_data
where Cast Like '%Leonardo DiCaprio%'
order by Rating desc
limit 10;

#2 ,find out which Genre of movie was the most Released ?
CREATE VIEW Genre_Count AS
SELECT Genre, COUNT(*) AS MovieCount
FROM imdb_movie_data 
GROUP BY Genre;
SELECT *
FROM Genre_Count
WHERE MovieCount = (SELECT MAX(MovieCount) FROM Genre_Count);

# 3 Find out which director has made the most amount of films with a Meta score 90 and above
create view Rating2 as
Select Director,Count(*) As Film_count from imdb_movie_data where Meta_score>=90 
group by Director; 
Select * from Rating2 where Film_count = (select max(Film_count) from Rating2);

#4 find the top 3 directors with the highest average ratings for their movies, 
#Include the average rating and the number of movies directed by each of them.

select Director,avg(Rating) as Avg_rating,Count(*) as Film_count  
from imdb_movie_data
group by Director
order by Film_count desc
limit 3;

#5 the earliest released movie listed in the IMDb movie , along with its title and release year?
select Movie_Name,Year from  imdb_movie_data
where Year=(SELECT MIN(Year) from imdb_movie_data);

#6.  Which movies directed by Steven Spielberg are listed in the IMDb movie ?
select Movie_Name,Year
from imdb_movie_data
where director = 'Steven Spielberg';

#7.Counting the movies released in 2023 and rating greater than 8?
select count(Movie_Name) from imdb_movie_data
where year=2023 and Rating>8;

#8. What are the top five PG rating categories based on the number of movies in the IMDb ?
SELECT PG_Rating,COUNT(*) AS movies
FROM imdb_movie_data
GROUP BY PG_Rating
ORDER BY PG_Rating  LIMIT 5 ;

-- 9. Details and ratings of Comedy movies released in 2020:

SELECT movie_name,year,Genre,Rating,votes,Cast,Director 
FROM imdb_movie_data
WHERE year = 2020 AND Genre LIKE '%Comedy%';

-- 10.Check if a movie is suitable for children:

SELECT movie_name,Genre, 
CASE 
	WHEN PG_Rating like 'G' THEN 'Yes'
	when PG_Rating like 'PG' then 'Under parental guidence' 
	ELSE 'No' 
END AS SuitableForChildren 
FROM 
	imdb_movie_data;



-- 11)Who are the most frequent directors in the dataset?-- 
SELECT
  director,
  COUNT(*) AS movie_count
FROM
  imdb_movie_data
GROUP BY
  director
ORDER BY
  movie_count DESC;

-- 12)Count of movies in each decade-- 
SELECT CONCAT(FLOOR(year / 10) * 10, 's') AS decade,
	COUNT(*) AS movies_count
FROM imdb_movie_data
WHERE year >= 1940
GROUP BY CONCAT(FLOOR(year / 10) * 10, 's')
ORDER BY decade;

-- 13)Identify directors who have worked in multiple genres and count the distinct genres for each:
  SELECT
  director,
  COUNT(DISTINCT genre) AS distinct_genre_count
FROM
  imdb_movie_data
GROUP BY
  director
HAVING
  COUNT(DISTINCT genre) > 1
ORDER BY
  distinct_genre_count DESC;

-- 14)Which combination of genre and director produces the highest-rated movies?-- 
SELECT
  genre,
  director,
  AVG(rating) AS avg_rating
FROM
  imdb_movie_data
GROUP BY
  genre, director
ORDER BY
  avg_rating DESC;
  
-- 15: Year wise released movies’ count:

SELECT COUNT(*) as movie_count,Year 
FROM imdb_movie_data
GROUP BY Year;

-- 16.Categorize movies based on their ratings:-- 
SELECT
  movie_name,
  rating,
  CASE
    WHEN rating >= 8.0 THEN 'Excellent'
    WHEN rating >= 6.0 AND rating < 8.0 THEN 'Good'
    ELSE 'Average or Below'
  END AS rating_category
FROM
  imdb_movie_data;
  
-- --17 Find the top 10 Genre which has the highest effectiveness ratio  
-- Effectiveness ratio=(Rating * Votes) + (AvgVotesPerMovie * GlobalAvgRating)) / (Votes + AvgVotesPerMovie)

create view Table1 as
select *, 
    ((Rating * Votes) + (AvgVotesPerMovie * GlobalAvgRating)) / (Votes + AvgVotesPerMovie) AS EffectiveRating
 from(
    select *,
        (select avg(Rating) from imdb_movie_data) AS GlobalAvgRating,
        (select avg(Votes) from imdb_movie_data) AS AvgVotesPerMovie
    from imdb_movie_data
) AS subquery
order by EffectiveRating desc;

select Genre,sum(EffectiveRating) as EffectiveRating
from table1
group by Genre
order by EffectiveRating desc
limit 10;


















 




























