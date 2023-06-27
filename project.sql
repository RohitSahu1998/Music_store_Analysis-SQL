create database  if not exists music;
use music;
drop database music;
# employee table creation
create table employee(employee_id int primary key,last_name varchar(50),first_name varchar(50),
title varchar(50),reports_to int not null,levels varchar(50),birthdate date,hire_date date,
address varchar(100),city varchar(50),state varchar(50),country varchar(50),postal_code varchar(50),
phone varchar(50),fax varchar(50),email varchar(50) );
select * from employee;

#customer table creation
create table customer(customer_id  int primary key,first_name varchar(50),last_name varchar(50),
company varchar(100),address varchar(100),city varchar(50),state varchar(50),country varchar(50),
postal_code varchar(50),phone text,fax text,email text,support_rep_id int not null,
foreign key (support_rep_id)  references employee(employee_id)
on delete cascade on update cascade);
select * from customer;



#invoice table creation
create table invoice(invoice_id int primary key,customer_id int not null  ,invoice_date date,
biiling_address varchar(50),billing_city varchar(50),billing_state varchar(50),
biiling_country varchar(50),billing_postal_code varchar(50),total int,foreign key (customer_id)
references customer(customer_id) on delete cascade on update cascade); 

select * from invoice;
desc invoice;

#playlist table creation
create table playlist(playlist_id int primary key,name_ varchar(50));
select * from playlist;

#artist table creation
create table artist(artist_id int primary key,name_ varchar(50));
select * from artist;

#media_type table creation
create table media_type(media_type_id int primary key,name_ varchar(50));
select * from media_type;


#genre table creation
create table genre(genre_id int primary key,name_ varchar(50));
select * from genre;

#album table creation
create table album(album_id int primary key,title varchar(50),artist_id int not null,
foreign key(artist_id) references artist(artist_id) on delete cascade on update cascade );
select * from album;


#track table creation
create table track(track_id int primary key,name_ varchar(100),album_id int not null,
media_type_id int not null,genre_id int not null,composer varchar(100),milliseconds bigint,bytes bigint,
unit_price float,foreign key(media_type_id) references media_type(media_type_id),
foreign key(genre_id) references genre(genre_id),foreign key(album_id) references album(album_id)
on update cascade on delete cascade);
select * from track;



-- playlist_track table creation
create table playlist_track(playlist_id int not null,track_id int not null,
foreign key(playlist_id) references playlist(playlist_id),
foreign key(track_id) references track(track_id) on delete cascade on update cascade);
desc playlist_track;


#invoice_line table creation

create table invoice_line(invoice_line_id int primary key,invoice_id int,track_id int,unit_price float,
quantity int,foreign key(invoice_id) references invoice(invoice_id),
foreign key(track_id) references track(track_id) on delete cascade on update cascade );
desc invoice_line;
select * from invoice_line;
select count(*) from invoice_line;


--                              Major Task
--                           Question Set 1 - Easy


-- 1) Who is the senior most employee based on job title?
select * from employee where title='Senior General Manager';
select * from employee;
SELECT title, last_name, first_name FROM employee ORDER BY levels DESC LIMIT 1;
SELECT title, last_name, first_name,hire_date FROM employee ORDER BY hire_date limit 1;

-- 2) Which countries have the most Invoices?
select count(*),biiling_country from invoice group by biiling_country ;

--  3) What are top 3 values of total invoice?
select total from invoice order by total desc limit 3;

/* 4) Which city has the best customers? We would like to throw a promotional Music Festival in the 
city we made the most money. Write a query that returns one city that has the highest sum of 
invoice totals. Return both the city name & sum of all invoice totals. */
select c.city,sum(i.total) from customer c inner join 
invoice i on c.customer_id = i.customer_id group by c.city;

/* 5) Who is the best customer? The customer who has spent the most money will be declared the best 
customer. Write a query that returns the person who has spent the most money */
select c.customer_id,concat(c.first_name,c.last_name) as full_name,sum(i.total) as best_customer
from customer c inner join invoice i on c.customer_id=i.customer_id group by customer_id
order by best_customer desc limit 1;

--                                      Question Set 2 – Moderate

/* 1)Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A */
select distinct c.email as Email,c.first_name as Firstname,c.last_name as Lastname,g.name_ as Genre_Name
from customer c join invoice i 
on c.customer_id=i.customer_id join invoice_line il on i.invoice_id=il.invoice_id join track t 
on il.track_id=t.track_id join genre g on t.genre_id=g.genre_id 
where g.name_='Rock' and email like 'a%'  order by c.email ; 



/*2) Let's invite the artists who have written the most rock music in our dataset. Write a query that
 returns the Artist name and total track count of the top 10 rock bands */
 select * from artist;
select * from track;
select a.name_,count(t.track_id) as total from artist a join album ab on a.artist_id=ab.artist_id 
join track t on ab.album_id=t.album_id join genre g on t.genre_id=g.genre_id 
where g.name_='rock' group by t.track_id order by total desc limit 10;

 /* 3)Return all the track names that have a song length longer than the average song length.
 Return the Name and Milliseconds for each track. Order by the song length with the longest 
 songs listed first */
 
select name_,milliseconds from track where milliseconds >
(select avg(milliseconds) from track)
order by milliseconds desc;

--                                    Question Set 3 – Advance

/*1) Find how much amount spent by each customer on artists? Write a query to return customer name, 
artist name and total spent */

select a.name_ as name_of_artist,c.first_name,c.last_name as full_name,sum(inv.unit_price*inv.quantity)
as amount_spent from customer as c join invoice as i
on i.customer_id=c.customer_id
join invoice_line as inv on inv.invoice_id=i.invoice_id
join track as t on t.track_id=inv.track_id
join album as al on al.album_id=t.album_id
join artist as a on a.artist_id=al.artist_id
group by a.name_,c.first_name,c.last_name
order by amount_spent desc;


/*2) We want to find out the most popular music Genre for each country. We determine the most popular genre 
as the genre with the highest amount of purchases. Write a query that returns each country along with 
the top Genre. For countries where the maximum number of purchases is shared return all Genres*/


SELECT * FROM popular_genre WHERE RowNo <= 1;
select g.name_,c.country,count(g.genre_id) as Purchase_per_genre 
from customer as c join invoice as i on c.customer_id=i.customer_id
join invoice_line as inv on inv.invoice_id=i.invoice_id
join track as t on t.track_id=inv.track_id
join genre as g on g.genre_id=t.genre_id
group by c.country,g.name_
order by purchase_per_genre desc
;


/* 3)Write a query that determines the customer that has spent the most on music for each country.
 Write a query that returns the country along with the top customer and how much they spent.
 For countries where the top amount spent is shared, provide all customers who spent this amount*/
 
select i.biiling_country,c.country,c.first_name,c.last_name,sum(i.total) as amount_spent from customer
 as c join invoice as i on 
c.customer_id=i.customer_id
group by i.biiling_country,c.country,c.first_name,c.last_name 
order by amount_spent desc
;


