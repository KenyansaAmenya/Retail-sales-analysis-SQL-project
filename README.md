# Retail-sales-analysis-SQL-project
## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `sql_projects`
**Schema**: `sales`

This project demonstrates SQL skills and techniques in data analysis to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with available sales data.
2. **Data Cleaning**: To identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: To perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Then I will use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_projects`.
- **Schema Creation**: Then I will create the database schema named `sales`
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_projects;

create schema sales;

CREATE TABLE sales.retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```
### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
-- to view the entire table
select * from sales.retail_sales;

select count(*)
from sales.retail_sales;

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

-- Data cleaning
select * from sales.retail_sales 
where 
transactions_id is null
or
sale_date is null
or
sale_time is null 
or
gender is null
or
customer_id is null 
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;
```

```sql
-- deleting nulls from rows in sql
delete from sales.retail_sales
where
transactions_id is null
or
sale_date is null
or
sale_time is null 
or
gender is null
or
customer_id is null 
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;
```
### 3. Data Analysis & Findings

The following SQL queries are the ones I used to answer specific business questions:

1. **Write an SQL query to retrieve all columns for sales made on '2022-11-05**:

```sql
select * from
sales.retail_sales
where sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transaction where the category is 'clothing' and the quantity sold is more than 4  in the month of nov 2022**:

```sql
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
```

3. **Write an SQL query to calculate the total sales (total_sale) for each category and total orders**:

```sql
select 
       category,
       sum(total_sale) as net_sale,
       count(*) as total_orders
from sales.retail_sales
group by 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beuaty' category.**:

```sql
select 
ROUND(AVG(age), 1) as avg_age
from sales.retail_sales
where category = 'Beauty';
```


5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:

```sql
 select * from sales.retail_sales
 where total_sale > 1000;
```

6. **Write a SQL query to find the total number of tansactions (transaction_id) made by each gender in each category.**:

```sql
select 
      category,
      gender,
      count(*) total_trans
from sales.retail_sales
group by 
        category,
        gender 
order by 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.**:

```sql
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
```

8. **write an SQL query to find the top 5 customers based on the highest total sales.**:

```sql
select 
customer_id,
sum(total_sale) as total_sales
from sales.retail_sales
group by 1
order by 2 desc
limit 5;
```

9. **Write an SQL query to find the number of unique customers who purchased items from each category.**:

```sql
select 
category,
count(distinct customer_id) as cnt_unique_cs
from sales.retail_sales
group by category ;
```

10. **write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening > 17)**:

```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project helped me in covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Felix Amenya

This project is part of my portfolio, showcasing my SQL skills essential for a data analyst. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

