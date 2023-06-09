--Creating the product table
drop table if exists product;

CREATE TABLE product(product_id integer, product_name text, price integer) ;

INSERT INTO product(product_id, product_name, price)
VALUES (1, 'P1', 980),
     	  (2,  'P2', 870),
	      (3, 'P3', 330);

--creating the sales table
drop table if exists sales;
create table sales(userid integer, created_date date, product_id integer);
INSERT INTO sales(userid, created_date, product)
VALUES 
(1, '19-04-2017', 2)
(3, '18-12-2019', 1)
(2, '20-07-2020', 3)
(1, '23-10-2019', 2)
(1, '19-03-2018', 3)
(3, '20-12-2016', 2)
(1, '09-11-2016' 1)
(1, '20-05-2016', 3)
(2, '24-09-2017', 1)
(1, '11-03-2017', 2)
(1, '11-03-2016', 1)
(3, '10-11-2016', 1)
(3, '07-12-2017', 2)
(3, '15-12-2016', 2)
(2, '08-11-2017', 2)
(2, '10-09-2018', 3)

--creating goldusers_signup
drop table if exists goldusers_signup;
create table goldusers_singup(userid integer, gold_signup_date date);
insert into goldusers_signup(userid, gold_signup_date)
values (1, '22-07-2017')
             (3, '21-04-2017')

--creating the users table
drop table if exists users;
create table users (userid integer, signup_date date); 
insert into users(userid, signup_date)
values (1, '02-09-2014')
             (2, '15-01-2015')
             (3, '11-04-2014')
--viewing the tables
select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;
