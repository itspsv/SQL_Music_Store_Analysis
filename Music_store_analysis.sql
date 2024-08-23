SELECT * FROM album 
select * from employee
select * from invoice
select * from invoice_line
select * from customer
select * from genre
select * from track
select * from artist
--Who is the senior most employee based on job title?
select *
from employee
order by levels desc
limit 1;

--Which countries have the most Invoices?
select count(*) as c,billing_country
from invoice
group by billing_country
order by c desc

--What are top 3 values of total invoice?
select total 
from invoice
order by total desc
limit 3;

-- Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals

select billing_city as city,sum(total) as iv_total
from invoice
group by city
order by iv_total desc
limit 1;

-- Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money

select cust.customer_id,first_name, last_name, sum(iv.total) as total
from customer as cust
join invoice as iv
on cust.customer_id = iv.customer_id
group by cust.customer_id
order by total desc
limit 1;

--Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A

select distinct email,first_name,last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id IN (
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name like 'ROCK'
)
order by email;

-- Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first


select name,milliseconds
from track
where milliseconds > (
select avg(milliseconds)
from track
)
order by milliseconds;

--Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent

with best_selling_artist as (

select artist.artist_id as artist_id, artist.name as name,
sum(invoice_line.unit_price * invoice_line.quantity) as total_sum
from invoice_line 
join track on invoice_line.track_id = track.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by 1
order by 3 desc
limit 1
)



select customer.customer_id,customer.first_name, customer.last_name, best_selling_artist.name,
sum(invoice_line.unit_price * invoice_line.quantity) as amount_spent
from invoice
join customer on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track on invoice_line.track_id = track.track_id
join album on album.album_id = track.album_id
join best_selling_artist on best_selling_artist.artist_id = album.artist_id
group by 1,2,3,4
order by 5 desc;

--We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres

with popular_genre as (

select count(invoice_line.quantity) as purchases, customer.country, genre.name,genre.genre_id,
row_number() over(partition by customer.country order by count(invoice_line.quantity) desc) as rowno
from invoice_line
join invoice on invoice_line.invoice_id = invoice.invoice_id
join customer on invoice.customer_id = customer.customer_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
group by 2,3,4
order by 2 asc, 1 desc
)

select * from popular_genre where rowno<=1;













