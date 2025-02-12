create database if not exists salesdatawalmart;

use salesdatawalmart;

create table if not exists sales1(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar(30)not null,
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float(6,4) not null,
total decimal(12,4) not null,
date DATETIME not null,
time TIME not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float(11,9) ,
gross_income decimal(12,4) not null,
rating float(2,1)
);

-- -----------------------------------------------------------------------------------
-- ---------------------------------Feature Engineering-------------------------------

-- ------time_of_day
SELECT 
    time,
    (CASE 
        when time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        when time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM sales1;


alter table sales1 add column time_of_day varchar(20);

update sales1
set time_of_day =(
CASE 
        when time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        when time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
    
-- day_name

select date, dayname(date) as day_name  from sales1;
alter table sales1 add column day_name varchar(10);
update sales1 
set day_name = dayname(date);

-- month_name

select date,monthname(date) as month_name from sales1;
alter table sales1 add column month_name varchar(10);
update sales1 
set month_name = monthname(date);


-- --------------------------------------------------------------

-- ------------------------------------------------------------------
-- ------------------------------Generic-------------------------------------

-- How many unique cities does the data have?
select distinct city from sales1;

-- In which city is each branch?
select distinct branch from sales1;
select distinct city ,branch from sales1;

-- ------------------------------------------------------------------


-- -------------------------------------------------------------------
-- -------------------------------Product-----------------------------

-- How many unique product lines does the data have?
select count(distinct product_line) from sales1;

-- What is the most common payment method?
select  payment_method,count( payment_method) as count from sales1 
group by payment_method order by count desc;

-- What is the most selling product line?
select product_line,count(product_line) as cnt from sales1 
group by product_line order by cnt desc;

-- What is the total revenue by month?
select month_name ,sum(total)as total from sales1 
group by month_name order by total desc;

-- What month had the largest COGS?
select month_name,sum(cogs) as cogss from sales1 
group by month_name order by  cogss desc;

-- What product line had the largest revenue?
select product_line ,sum(total) as total_revenue from sales1 
group by product_line order by total_revenue desc;

-- What is the city with the largest revenue?
select city ,sum(total) as total_renv from sales1 group by city order by total_renv desc;

-- What product line had the largest VAT?
select product_line,avg(VAT) as large from sales1 
group by product_line order  by large desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales?
 SELECT 
    product_line, 
    total,
    CASE 
        WHEN total > (SELECT AVG(total) FROM sales1) THEN 'Good'
        ELSE 'Bad'
    END AS performance
FROM sales1;

 
 -- Which branch sold more products than average product sold?
 select branch ,sum(quantity) as qty from sales1 
 group by branch having sum(quantity) > (select avg(quantity) from sales1);
 
-- What is the most common product line by gender?
select gender , product_line,count(gender) as count from sales1 
group by gender ,product_line order by count desc; 

-- What is the average rating of each product line?
select round(avg(rating),2)as avg_rat ,product_line   from sales1 
group by product_line order by avg_rat desc;

-- -------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- --------------------------Sales----------------------------------------------


-- Number of sales made in each time of the day per weekday?
select time_of_day,count(*) as total_sales from sales1 where day_name= "monday" group by time_of_day order by total_sales desc;

-- Which of the customer types brings the most revenue?
select customer_type,sum(total) as total from sales1 group by customer_type order by total desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,avg(VAT) as vat from sales1 group by city order by vat desc;

-- Which customer type pays the most in VAT?
select customer_type,avg(VAT) as vat from sales1 
group by customer_type order by vat desc;

-- --------------------------------------------------------------


-- ---------------------------------------------------------------
-- ----------------------------Customers---------------------------

-- How many unique customer types does the data have?
select distinct customer_type ,count(customer_type)from sales1 
group by customer_type;

-- How many unique payment methods does the data have?
select distinct payment_method ,count(payment_method)from sales1 
group by payment_method;

-- What is the most common customer type?
select max(customer_type) from sales1;

-- Which customer type buys the most?
select distinct customer_type ,count(customer_type)from sales1 
group by customer_type;

-- What is the gender of most of the customers?
select  distinct gender,count(gender) from sales1 group by gender;

-- What is the gender distribution per branch?
select gender, count(*)from sales1  where branch ="a" group by gender;

-- Which time of the day do customers give most ratings?
select time_of_day,avg(rating) as avgr from sales1 
group by time_of_day order by avgr desc;

-- Which time of the day do customers give most ratings per branch?
select time_of_day,avg(rating) as avgr from sales1  
where branch="a" group by time_of_day order by avgr desc;

-- Which day fo the week has the best avg ratings?
select day_name,avg(rating) as avgr from sales1 
 group by day_name order by avgr desc;
 
 -- Which day of the week has the best average ratings per branch?
 select day_name,avg(rating) as avgr from sales1 
 where branch="a" group by day_name order by avgr desc;
 
 






