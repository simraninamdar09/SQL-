/* Question Set 1 - Easy*/
/*1. Who is the senior most employee based on job title?*/
SELECT * FROM music_system.employee
order by levels desc
limit 1; 

/*2. Which countries have the most Invoices? */
SELECT count(*) AS c, billing_country
from  music_system.invoice
group by billing_country
order by c desc;


/*3. What are top 3 values of total invoice?*/
SELECT total
FROM music_system.invoice
ORDER BY  total DESC
LIMIT 3;


/*4. Which city has the best customers? We would like to throw a promotional Music 
Festival in the city we made the most money. Write a query that returns one city that 
has the highest sum of invoice totals. Return both the city name & sum of all invoice totals*/
SELECT billing_city,SUM(total) AS invoicetotal
FROM music_system.invoice
group by billing_city
order by invoicetotal desc
limit 1;


/*5. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the most money*/
SELECT customer.customer_id,first_name,last_name,SUM(total) AS total_spending
FROM music_system.customer
JOIN music_system.invoice ON customer.customer_id=invoice.customer_id
GROUP BY customer_id
ORDER BY total_spending desc
limit 1;



/* Question Set 2 – Moderate*/
/*1. Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A*/
select email, first_name, last_name 
from music_system.customer
join music_system.invoice on customer.customer_id = invoice.customer_id
join music_system.invoice_line on invoice.invoice_id = invoice_line.invoice_id
join music_system.track on invoice_line.track_id = track.track_id
join music_system.genre on track.genre_id = genre.genre_id
where genre.name LIKE 'Rock'
order by email;




/*2. Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands*/
select artist.artist_id, artist.name, count(artist.artist_id)  as total_no_count
from music_system.track
join music_system.album2 on track.album_id = album2.album_id
join music_system.artist on album2.artist_id = artist.artist_id
join music_system.genre on track.genre_id = genre.genre_id
where genre.name LIKE 'Rock'
group by artist.artist_id
order by total_no_count desc
limit 10;





/*3. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first*/
select name,milliseconds 
from music_system.track
where milliseconds > 
(select avg(milliseconds) as track_avg from music_system.track)
order by milliseconds desc;


/*Question Set 3 – Advance*/
/*1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent*/
WITH best_selling_artist AS
(select artist.artist_id as artist_id, artist.name as artist_name ,
sum(invoice_line.quantity * invoice_line.unit_price) as total_spent
from music_system.invoice_line
join music_system.track on invoice_line.track_id = track.track_id
join music_system.album2 on track.album_id = album2.album_id
join music_system.artist on album2.artist_id = artist.artist_id
group by artist_id
order by total_spent desc
limit 1)

select customer.customer_id, customer.first_name,customer.last_name,bsa.artist_name,
sum(invoice_line.quantity * invoice_line.unit_price) as amount_spent
from music_system.invoice
JOIN music_system.customer  ON customer.customer_id = invoice.customer_id
JOIN music_system.invoice_line  ON invoice_line.invoice_id = invoice.invoice_id
JOIN music_system.track  ON track.track_id = invoice_line.track_id
JOIN music_system.album2  ON album2.album_id = track.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = album2.artist_id
group by 1,2,3,4
order by 5 desc
limit 1;


/*2. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres*/
WITH popular_genre AS 
(select COUNT(invoice_line.quantity) AS purchases, customer.country, genre.genre_id,genre.name,
row_number() over (partition by customer.country order by  COUNT(invoice_line.quantity) desc) as row_no
from music_system.invoice_line
join music_system.invoice on invoice_line.invoice_id = invoice.invoice_id
join music_system.customer on invoice.customer_id = customer.customer_id
join music_system.track on invoice_line.track_id = track.track_id
join music_system.genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2 asc)
select * from popular_genre where row_no<=1;




/*3. Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount*/
with customer_country as(
select customer.first_name,last_name,country, invoice.billing_country,sum(invoice.total)as total_spending,
row_number() over (partition by billing_country order by sum(total)desc) as row_no
from music_system.invoice
join music_system.customer on invoice.customer_id = customer.customer_id
group by 1,2,3,4
order by 5 desc
)
select * from customer_country where row_no <=1;

