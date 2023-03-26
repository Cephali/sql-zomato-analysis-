--questions
-- 1. What is the total amount each customer spent?

select a.userid, sum(b.price) total_amt_spent
from sales a 
inner join product b on a.product_id=b.product_id
group by a.userid

--2. How many days has each customer visited?
select userid, count(distinct created_date)
from sales
group by  userid

--3. What was the first product purchased by each customer?
select * 
from (select *, rank() over(partition by userid
            order by created_date) rnk
             from sales) a 
where rnk = 1

--4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select userid, count(product_id) cnt
from sales
where product_id= (select top 1 product_id
                                   from sales
 			        group by product_id
                                   order by count (product_id) desc)
group by userid

--5. Which item was the most popular for each customer?
select * 
from (select *, rank() over(partition by userid
           order by cnt desc) rnk
            from (select userid, product_id,              	    	      count(product_id) cnt
                         from sales
		        group by userid, product_id)a)b
where rnk = 1

--6. Which item was purchased first by the customer after they became a member?
select * 
from (select c.*, rank () over (partition by userid
          order by created_date) rnk
          from (select a.userid, 		a.created_date,a.product_id,
		  b.gold_signup_date
		from sales a
		  inner join goldusers_signup b 
		   on a.userid=b.userid
                     and created_date >=  			gold_signup_date)c)d
where rnk = 1

--7. Which item was purchased just before the customer became a member?

select * 
from (select c.*, rank () over (partition by userid
          order by created_date desc) rnk
          from (select a.userid, 		a.created_date,a.product_id,
		  b.gold_signup_date
		from sales a
		  inner join goldusers_signup b 
		   on a.userid=b.userid
                     and created_date <=  			gold_signup_date)c)d
where rnk = 1

--8. What is the total orders and amount spent by each member before they became a member?
select userid, count(created_date) order_purchased, sum(price) total_amt_spent
from (select c.*, d.price
          from(select a.userid, a.created_date,  		a.product_id, b.gold_signup_date
		   from sales a 
                   inner join goldusers_signup b
                  on a.userid=b.userid and created_date
		 <= gold_signup_date) c
inner join product d on c.product_id = d.product_id)e

--9. If buying each product generates points, for example, $5 = 2 Zomato points and each product has different purchasing points for example $5 = 1 Zomato point, for p2 $10= 5 zomato points and p1 $5 = 1 Zomato point
cacuate point collected by each customer and for which product most points have been given till now.

select userid, sum(total_points)*2.5 total_money_earned
from (select e.*, amt/points total_points
          from (select d.* , case when product_id=1 		then 5
		when product_id=2 then 2
		when product_id=3 then 5
		else 0
		end as points
		from(select c.userid, c.product_id, 			sum(price) amt
			 from (select a.*, b.price
				     from sales a 
                                        inner join product b on 					a.product_id = 					b.product_id)c
		group by userid, prduct_id)d
		)e)
f
group by userid;

---product that has highest point
select * 
from(select *, rank()over(order by 	total_point_earned desc) rnk
	  from (select e.*, amt/points total_points
          from (select d.* , case when product_id=1 		then 5
		when product_id=2 then 2
		when product_id=3 then 5
		else 0
		end as points
		from(select c.userid, c.product_id, 			sum(price) amt
			 from (select a.*, b.price
				     from sales a 
                                        inner join product b on 					a.product_id = 					b.product_id)c
		group by userid, prduct_id)d
		)e)
		group by product_id) f) g
		  where rnk = 1)
---10.In the first one year after a customer joins the gold program (including the join date) irrespective of what the customer has purchased they earn 5 zomato points for every $10 spent , who earned more 1 or 3 and what was their points earnings in their first year?

select c.*, d.price* 0.5 total_points_earned
from(select a.userid, a.created_date, 	a.product_id, b.gold_signup_date
	from sales a
	inner join goldusers_signup b on 	a.userid=b.userid and 	created_date>=gold_signup_date and 	created_date <= dateadd(year, 1, 	gold_signup_date) c 
	inner join product d on c.product_id = 	d.product_id

--11. Rank all the transaction of the customers
select *, rank()over(partition by userid
order by created_date) rnk
from sales

--12. Rank all the transactions for each member whenever they are a Zomato gold member for every non-member transaction mark as na

select c.*, cast(
	(case when gold_signup_date is null then na
	else rank()over (partition by userid
	order by created_date desc)
	end) 
	as varchar) as rnk
from(select a.userid, a.created_date, 	a.product_id, b.gold_signup_date
	from sales a 
	left join goldusers_signup b on a.userid= 	b.userid and created_date >= 	gold_signup_date)c
