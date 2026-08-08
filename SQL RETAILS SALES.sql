create database retail_sales;
-- database created

-- creating database table 
create table retails(
transactions_id	int PRIMARY KEY,
sale_date date,	
sale_time time,
	customer_id	int,
    gender	varchar(50),
    age int,	
    category varchar(50),
    quantiy	int , 
    intprice_per_unit	float,
    cogs	decimal(10,2),
    total_sale float
    ); 
  -- add primary key transactions_id (IF YOU FORGGET)
  
  alter table retails
   add primary key (transactions_id);
   
   
-- SELECT 0 FROM TABLE RETAILS IF ANY
select count(*) from retails;
select *from retails
where transactions_id =0
or price_per_unit  =0
or cogs =0 
or quantity =0 
or age=0;

-- UPDATING 0 TO NULL values
update retails
set 
age = nullif(age,0),
price_per_unit = nullif(price_per_unit,0),
cogs = nullif(cogs,0),
quantity= nullif(quantity,0)
where transactions_id is not null;

-- data cleaning  process

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


-- data exploration
 
 select *from retails;
  -- how many unique customers we have in retail_sales table 
 select count( customer_id) as ids from retails; -- this code show all customer_id (with duplicate values ) 
 
 -- to remove duplicate value  we use distinct function in count(distinct (distinct give unique id,number) customer_id)....
 select count(distinct customer_id) from retails;
 
 -- see categories 
 select distinct category from retails;
 
 
 -- Q1--> write a sql queery to retrieve all columns from sales  made on ' 2022-11-05
select * from retails
where sale_date ='2022-11-05';

-- Q2--> write a sql query to retrieve all  transaction where the  category  is 'cloathing'  and the quqntity sold  is more than 3 in the month of nov-2022...
SELECT * -- count(*) as total_rows
FROM retails
WHERE category = 'Clothing'
  AND quantity >= 4
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
-- DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';  ##2nd option for date 

-- Q3--> write a sql query to calculate the total sales  from each category...
select category, -- replace * to category 
sum(total_sale) as net_sale,
count(*) as total_oders  
from retails 
group by category 
;


-- Q4--> find the avg age of customers who purchase only beauty products

select 
avg(age)
age from retails
where category='Beauty'
;

-- Q5--> find the transaction values where the total_sale is greater than 1000
select  * from retails
where total_sale> 1000;



-- Q6--> find the total number of transaction  made by each gender in each category 
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
    
   -- Q7--> calculate the avg sale of each month . find the best selling month of each years
   -- answer: first select data from original table  by using select function select like year month, use avg() funtion in sell than make group and order,
   --  2nd atep is give rank by using rank()function and use over ( partition by(to devide data multiple groupes ))and than order by(jisko order ne lana hai us colum ka name) in last give new rank name by using (as rank)
   -- 3rd step make above two steps sub query under new select funtion than give name what u want,, 
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

-- > Q8--> find out the top 5 customers based on the total highest sale...
select customer_id,
sum(total_sale) as highest_sale 
from retails
group by 1 
order by 2 desc 
limit 1 offset 1;

-- --> Q9--> find the number of unique customers who purchase item from each category
select count(distinct customer_id), -- count (count-> how many coustomers  get the same product ). distinct-> use for unique (not duplicate)
category 
 from retails
 group by 2;
 
-- Q10 --> wirte a sql query   to create each shift and number of the orders ( example morning <12, afternoon between 12 to 17 , evening >17)

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


