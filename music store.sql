--tables:

SELECT * FROM album;
SELECT * FROM artist;
SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM genre;
SELECT * FROM invoice;
SELECT * FROM invoice_line;
SELECT * FROM media_type;
SELECT * FROM playlist;
SELECT * FROM playlist_track;
SELECT * FROM track;
/*
-Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals?*/
SELECT billing_city , sum(total) AS money
FROM invoice
GROUP BY billing_city
ORDER BY money desc
limit 1
;

/*
-Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money?
*/
SELECT c.first_name,c.last_name,sum(i.total) AS best
FROM customer c
join
invoice i
ON c.customer_id = i.customer_id
GROUP BY c.first_name,c.last_name
ORDER BY best desc LIMIT 1
;



/*
-Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A?
*/
SELECT DISTINCT c.email, c.first_name,c.last_name
FROM customer c
join invoice i
on c.customer_id = i.customer_id
join invoice_line il
on i.invoice_id=il.invoice_id
join track t 
on t.track_id=il.track_id
join genre g
on g.genre_id=t.genre_id
where g.name like'Rock'
ORDER BY c.email


/*
-Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands?
*/
SELECT a.name ,count(t.track_id) as top
FROM artist a
join album al
on a.artist_id=al.artist_id
join track t
on al.album_id=t.album_id
join genre g
on g.genre_id=t.genre_id
where g.name like'Rock'
group by a.name
order by top desc limit 10;


/*
Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first?
*/
SELECT name ,milliseconds
FROM track
where milliseconds>
(SELECT AVG(milliseconds) from track)
ORDER BY milliseconds desc; 

/*
Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent?
*/


SELECT c.first_name, c.last_name,a.name,sum(il.quantity*il.unit_price) as totalspent
FROM customer c
join invoice i
on i.customer_id=c.customer_id
join invoice_line il
on i.invoice_id = il.invoice_id
join track t
on il.track_id=t.track_id
join album al
on t.album_id=al.album_id
join artist a
on al.artist_id=a.artist_id
group by 1, 2, 3 
order by totalspent desc
/*
We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres?
*/
with max_purchase as 
(SELECT i.billing_country , g.name,g.genre_id ,count(il.quantity) as highest,
row_number() over (partition by i.billing_country order by count(il.quantity) desc) as rowno 
FROM invoice i
join invoice_line il
on i.invoice_id=il.invoice_id
join track t 
on t.track_id=il.track_id
join genre g
on g.genre_id=t.genre_id
group by i.billing_country , g.name,g.genre_id
)
SELECT * FROM max_purchase 
where rowno=1;
/*
 Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount?
customer for every country
top customer and how much


*/
WITH highspender as
(SELECT c.country, c.first_name,c.last_name,sum(i.total) as totalsale,
ROW_NUMBER() OVER (PARTITION BY c.country order by sum(i.total )desc) as rowno
FROM customer c
join
invoice i 
ON c.customer_id = i.customer_id
GROUP BY c.first_name,c.last_name ,c.country)
SELECT * FROM highspender 
where rowno<=1;

