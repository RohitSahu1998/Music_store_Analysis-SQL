# Music_store_Analysis-SQL
Analysis on Music Store Data using SQL
## Overview
Non Vizualized data analysis on music Store, This music Store Database Contains 7 tables in it, which are interconnected through foreign keys.
<br>
## Aim
Aim is to analyse the data in a sequential mannerand extract some insights and answer some specific question on regarding music store.
<br>
Following question has been answered in this EDA.
* [Who is the senior most employee based on job title?](#a)
* [Which countries have the most Invoices??](#b)
* [What are top 3 values of total invoice??](#c)
* [Which city has the best customers? We would like to throw a promotional Music Festival in the 
city we made the most money. Write a query that returns one city that has the highest sum of 
invoice totals. Return both the city name & sum of all invoice totals.](#d)
* [ Who is the best customer? The customer who has spent the most money will be declared the best 
customer. Write a query that returns the person who has spent the most money?](#e)
* [Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A.](#f)
* [Let's invite the artists who have written the most rock music in our dataset. Write a query that
 returns the Artist name and total track count of the top 10 rock bands?](#g)
* [Return all the track names that have a song length longer than the average song length.
 Return the Name and Milliseconds for each track. Order by the song length with the longest 
 songs listed first?](#h)
* [Find how much amount spent by each customer on artists? Write a query to return customer name, 
artist name and total spent](#i)
* [We want to find out the most popular music Genre for each country. We determine the most popular genre 
as the genre with the highest amount of purchases. Write a query that returns each country along with 
the top Genre. For countries where the maximum number of purchases is shared return all Genres?](#j)
* [Write a query that determines the customer that has spent the most on music for each country.
 Write a query that returns the country along with the top customer and how much they spent.
 For countries where the top amount spent is shared, provide all customers who spent this amount?](#k)

---

### Who is the senior most employee based on job title?.<a class="anchor" id="a"></a>
SELECT title, last_name, first_name,hire_date FROM employee ORDER BY hire_date limit 1;

### Which countries have the most Invoices?.<a class="anchor" id="b"></a>
select count(*),biiling_country from invoice group by biiling_country ;

### What are top 3 values of total invoice?<a class="anchor" id="c"></a>
select total from invoice order by total desc limit 3;

### Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals?<a class="anchor" id="d"></a>
select c.city,sum(i.total) from customer c inner join 
invoice i on c.customer_id = i.customer_id group by c.city;

### Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money?<a class="anchor" id="e"></a>
select c.customer_id,concat(c.first_name,c.last_name) as full_name,sum(i.total) as best_customer
from customer c inner join invoice i on c.customer_id=i.customer_id group by customer_id
order by best_customer desc limit 1;

### Write query to return the email, first name, last name, & Genre of all Rock Music listeners.Return your list ordered alphabetically by email starting with A?<a class="anchor" id="f"></a>
select distinct c.email as Email,c.first_name as Firstname,c.last_name as Lastname,g.name_ as Genre_Name
from customer c join invoice i 
on c.customer_id=i.customer_id join invoice_line il on i.invoice_id=il.invoice_id join track t 
on il.track_id=t.track_id join genre g on t.genre_id=g.genre_id 
where g.name_='Rock' and email like 'a%'  order by c.email ; 

### Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands<a class="anchor" id="g"></a>
select a.name_,count(t.track_id) as total from artist a join album ab on a.artist_id=ab.artist_id 
join track t on ab.album_id=t.album_id join genre g on t.genre_id=g.genre_id 
where g.name_='rock' group by t.track_id order by total desc limit 10;

### Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest  songs listed first <a class="anchor" id="h"></a>
select name_,milliseconds from track where milliseconds >
(select avg(milliseconds) from track)
order by milliseconds desc;

###  Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent <a class="anchor" id="i"></a>
select a.name_ as name_of_artist,c.first_name,c.last_name as full_name,sum(inv.unit_price*inv.quantity)
as amount_spent from customer as c join invoice as i
on i.customer_id=c.customer_id
join invoice_line as inv on inv.invoice_id=i.invoice_id
join track as t on t.track_id=inv.track_id
join album as al on al.album_id=t.album_id
join artist as a on a.artist_id=al.artist_id
group by a.name_,c.first_name,c.last_name
order by amount_spent desc;

###  We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres<a class="anchor" id="j"></a>
select g.name_,c.country,count(g.genre_id) as Purchase_per_genre 
from customer as c join invoice as i on c.customer_id=i.customer_id
join invoice_line as inv on inv.invoice_id=i.invoice_id
join track as t on t.track_id=inv.track_id
join genre as g on g.genre_id=t.genre_id
group by c.country,g.name_
order by purchase_per_genre desc;

### Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount<a class="anchor" id="k"></a>
select i.biiling_country,c.country,c.first_name,c.last_name,sum(i.total) as amount_spent from customer
 as c join invoice as i on 
c.customer_id=i.customer_id
group by i.biiling_country,c.country,c.first_name,c.last_name 
order by amount_spent desc;

## Entity Relationship(ERR) Diagram 



