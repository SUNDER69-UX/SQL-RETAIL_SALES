# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales`.
- **Table Creation**: A table named `retailS` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product, category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
create database retail_sales;

create table retails(
transactions_id	int PRIMARY KEY,
sale_date date,	
sale_time time,
	customer_id	int,
    gender	varchar(50),
    age int,	
    category varchar(50),
    quantiy	int , 
    price_per_unit	float,
    cogs	decimal(10,2),
    total_sale float
    ); 
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

select *from retails
where transactions_id is null
or price_per_unit  is null
or cogs is null
or quantity is null
;

delete from retails
where transactions_id is null
or price_per_unit  is null
or cogs is null
or quantity is null;


select count( customer_id) as ids from retails; -- this code show all customer_id (with duplicate values ) 
 
 -- to remove duplicate value  we use distinct function in count(distinct (distinct give unique id,number) customer_id)....
 select count(distinct customer_id) from retails;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from retails
where sale_date ='2022-11-05';
```

2. **write a sql query to retrieve all  transaction where the  category  is 'cloathing'  and the quantity sold  is more than 3 in the month of nov-2022...**:
```sql
SELECT * -- count(*) as total_rows
FROM retails
WHERE category = 'Clothing'
  AND quantity >= 4
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
```

3. **write a sql query to calculate the total sales  from each category...**:
```sql
select category,  
sum(total_sale) as net_sale,
count(*) as total_oders  
from retails 
group by category 
;
```

4. **Write a SQL query to find the avg age of customers who purchase only beauty products **:
```sql
select 
avg(age)
age from retails
where category='Beauty'
;
```

5. **find the transaction values where the total_sale is greater than 1000.**:
```sql
select  * from retails
where total_sale> 1000;
```

6. **Write a SQL query to  find the total number of transaction  made by each gender in each category **:
```sql
select category,
 gender ,
 count(*)as  trans
 from retails
group by category, gender
ORDER BY 
    CASE 
        WHEN gender = 'Male' THEN 1
        WHEN gender = 'Female' THEN 2
    END;
```

7. **Write a SQL query to calculate the avg sale of each month . find the best selling month of each years**:
```sql
select year, month, net_sale from 
   (
   select 
   year(sale_date) as year,
  month(sale_date) as month,
   avg(total_sale)as net_sale,
   
   rank() over           				-- rank() over-->  (use hota hai kisis bhi value ko position ya rank dene ke liye...)
   (
   partition by  year(sale_date) 		-- partition by --> ( use hota hai for values/data ko seprate karne ko.or perform calculation seprately for each group
   order by avg(total_sale) desc) as rankl	-- order by --> ( yeh rank provide krata hai {jiska sbse bda rank hoga usko top rank milega })...
   
   from retails
   group by year (sale_date) ,month (sale_date)
   order by year (sale_date), month (sale_date)
   ) as t1
   where rankl= 1;
```

8. **Write a SQL query to find out the top 5 customers based on the total highest sale... **:
```sql
select customer_id,
sum(total_sale) as highest_sale 
from retails
group by 1 
order by 2 desc 
limit 1 offset 1;
```

9. **Write a SQL query to find the number of unique customers who purchase item from each category**:
```sql
select count(distinct customer_id), -- count (count-> how many coustomers  get the same product ). distinct-> use for unique (not duplicate)
category 
 from retails
 group by 2;
```

10. **wirte a sql query to create each shift and number of the orders ( example morning <12, afternoon between 12 to 17 , evening >17)**:
```sql
with hourlysales
as (
 select *, case
when hour(sale_time)<12 then 'morning'
when hour(sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shifts
from retails)
select shifts,
 count(transactions_id) as total_orders
from hourlysales
group by shifts;
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

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - sunder

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **LinkedIn**: [Connect with me professionally](www.linkedin.com/in/sunder-kumar-079856297)

Thank you for your support, and I look forward to connecting with you!
