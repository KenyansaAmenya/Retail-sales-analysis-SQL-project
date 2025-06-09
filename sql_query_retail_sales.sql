select * from sales.retail_sales rs;

select count(*)
from sales.retail_sales rs;


--  use
-- Data cleaning

select * from sales.retail_sales rs 
where 
rs.transactions_id is null
or
rs.sale_date is null
or
rs.sale_time is null 
or
rs.gender is null
or
rs.customer_id is null 
or
rs.age is null
or
rs.category is null
or
rs.quantity is null
or
rs.price_per_unit is null
or
rs.cogs is null
or
rs.total_sale is null;

-- deleting rows in sql
delete from sales.retail_sales rs
where
rs.transactions_id is null
or
rs.sale_date is null
or
rs.sale_time is null 
or
rs.gender is null
or
rs.customer_id is null 
or
rs.age is null
or
rs.category is null
or
rs.quantity is null
or
rs.price_per_unit is null
or
rs.cogs is null
or
rs.total_sale is null;

-- Data exploration

-- How many sales we have?
select count(*)
as total_sale
from sales.retail_sales;

-- How many customers we have?
select count(distinct customer_id)
as total_sale
from sales.retail_sales;

-- How many categories we have?
select count(distinct category)
as total_sale
from sales.retail_sales;

select distinct category from sales.retail_sales;

-- Data analysis & Business key problems & answers
-- Q.1 Write an SQL query to retrieve all columns for sales made on 2022-11-05

select * from
sales.retail_sales
where sale_date = '2022-11-05';

-- Q2 Write a SQL query to retrieve all transaction where the category is 'clothing' and the quantity sold is more than 4  in the month of nov 2022

select
     category,
     SUM(quantity)
from sales.retail_sales
where category = 'Clothing'
group by 1;

select *
from sales.retail_sales
where category = 'Clothing'
and 
      TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
group by 1;

select *
from sales.retail_sales
where category = 'Clothing'
and 
      TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
      and 
      quantity >= 4;

-- Q3 Write an SQL query to calculate the total sales (total_sale) for each category and total orders.

select 
       category,
       sum(total_sale) as net_sale,
       count(*) as total_orders
from sales.retail_sales
group by 1;
       
-- q4. Write a SQL query to find the average age of customers who purchased items from the 'Beuaty' category.

select 
ROUND(AVG(age), 1) as avg_age
from sales.retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
 select * from sales.retail_sales
 where total_sale > 1000;

-- Q6 Write a SQL query to find the total number of tansactions (transaction_id) made by each gender in each category
select 
      category,
      gender,
      count(*) total_trans
from sales.retail_sales
group by 
        category,
        gender 
order by 1;

-- Q. 7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

select 
extract(year from sale_date) as year,
extract(month from sale_date) as month,
avg(total_sale) as avg_sale
from sales.retail_sales
group by 1, 2
order by 1, 3 desc;

-- part 2
select * from 
(
select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from sales.retail_sales
group by 1, 2
) as t1
where rank = 1;

-- q. 8 write an SQL query to find the top 5 customers based on the highest total sales

select 
customer_id,
sum(total_sale) as total_sales
from sales.retail_sales
group by 1
order by 2 desc
limit 5;

-- Q. 9 Write an SQL query to find the number of unique customers who purchased items from each category.

select 
category,
count(distinct customer_id) as cnt_unique_cs
from sales.retail_sales
group by category ;

-- Q. 10 write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening > 17)

select *,
case
	when extract(hour from sale_time) < 12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon' 
	else 'Evening'	
end as shift
from sales.retail_sales;

-- part 2
with hourly_sale
as 
(
select *,
case
	when extract(hour from sale_time) < 12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon' 
	else 'Evening'	
end as shift
from sales.retail_sales
)
select 
shift,
count(*) as total_orders
from hourly_sale
group by shift;

-- end of the project