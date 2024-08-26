-- 1 Select the title of all movies.
select title from movie_analysis.movies;

-- 2 Show all the distinct ratings in the database.
select distinct(rating) from movie_analysis.movies;

-- 3  Show all unrated movies.
select * from movie_analysis.movies where rating is null;

-- 4 Select all movie theaters that are not currently showing a movie.
select * from movie_analysis.movietheaters where movie is null;

-- 5 Select all data from all movie theaters and, additionally, the data from the movie that is being 
-- shown in the theater (if one is being shown).
select * from movie_analysis.movietheaters
left join movie_analysis.movies on movietheaters.Movie = movies.code;

-- 6 Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater.
select * from movie_analysis.movietheaters
right join movie_analysis.movies on movietheaters.Movie = movies.code;

-- 7 Show the titles of movies not currently being shown in any theaters.
select title from movie_analysis.movietheaters 
right join movie_analysis.movies on movietheaters.movie = movies.code
where movietheaters.Movie is null;


-- 8 Add the unrated movie "One, Two, Three".
insert into movie_analysis.movies(code,Title,Rating) values(9,'One, Two, Three',NULL); 

-- 9 Set the rating of all unrated movies to "G".
update movie_analysis.movies set rating = "G" where  rating is null;

-- 10 Remove movie theaters projecting movies rated "NC-17".
delete from movie_analysis.movietheaters where movie
in (select code from Movies where rating = 'NC-17');
