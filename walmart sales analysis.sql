-- create database
CREATE DATABASE IF NOT EXISTS WALMART;

-- create table
CREATE TABLE IF NOT EXISTS SALES(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);

-- add time of the day column 
ALTER TABLE sales ADD column TIME_OF_DAY VARCHAR(20);
UPDATE SALES 
SET TIME_OF_DAY= ( CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
		ELSE "EVENING"
        END);

-- add dayname column 
ALTER TABLE sales add column dayname varchar(10);
update sales
set dayname= DAYNAME(date);

-- add monthname column 
ALTER TABLE SALES ADD column monthname VARCHAR(10);
UPDATE SALES 
SET monthname= monthname(date);

-- ------------------------------------------------------------------------
-- ------------------------------------------------------------------------
-- questions to answer
-- How many unique cities does the data have?
select distinct city 
from sales; 

-- In which city is each branch?
select distinct city, branch 
from sales;

--  How many unique product lines does the data have?
select count(distinct product_line)
from sales;

-- What is the most common payment method?
select payment, count(*)
from sales
group by payment
order by count(*) desc
limit 1;

-- What is the most selling product line?
select product_line, count(*)
from sales
group by product_line
order by count(*) desc
limit 1;

-- What is the total revenue by month?
select sum(total) as total_revenue, monthname
from sales 
group by MONTHNAME
order by total_revenue desc;

-- What month had the largest COGS?
select sum(cogs) as COGS, monthname
from sales 
group by monthname
order by COGS DESC
LIMIT 1;

-- What product line had the largest revenue?
SELECT PRODUCT_LINE, SUM(TOTAL)
FROM SALES 
GROUP BY PRODUCT_LINE
ORDER BY SUM(TOTAL) DESC LIMIT 1;

-- What is the city with the largest revenue?
SELECT CITY, SUM(TOTAL)
FROM SALES 
GROUP BY CITY
ORDER BY SUM(TOTAL) DESC LIMIT 1;

-- What product line had the largest VAT?
SELECT PRODUCT_LINE, AVG(tax_pct)
FROM SALES 
GROUP BY PRODUCT_LINE
ORDER BY  AVG(tax_pct) DESC LIMIT 1;


-- Which branch sold more products than average product sold?
SELECT BRANCH, sum(quantity)
from sales
group by branch
having sum(quantity)> (select avg(quantity) from sales);

-- What is the most common product line by gender?
select  gender, product_line, count(gender)
from sales 
group by product_line, gender
order by count(gender) desc ;

-- What is the average rating of each product line?
select product_line, round(avg(rating), 2)
from sales 
group by product_line;


-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- sales questions 
-- Number of sales made in each time of the day per weekday
select time_of_day, count(*)
from sales
group by time_of_day;


-- Which of the customer types brings the most revenue?
select customer_type, sum(total)
from sales 
group by customer_type
order by sum(total) desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, AVG(tax_pct)
from sales
group by city
ORDER BY AVG(tax_pct) DESC;

-- Which customer type pays the most in VAT?
SElECT customer_type, avg(tax_pct)
from sales
group by customer_type
ORDER BY AVG(tax_pct) DESC;

-- -------------------------------------------------------------------
-- ---------------------------------------------------------------------

-- customer questions 

-- How many unique customer types does the data have?
select distinct customer_type 
from sales;

-- How many unique payment methods does the data have?
select distinct payment 
from sales;

-- Which customer type buys the most?
select  customer_type, count(*)
from sales
group by customer_type
order by count(*) desc;

-- What is the gender of most of the customers?
select  gender, count(*)
from sales
group by gender
order by count(*) desc;

-- What is the gender distribution per branch?
select branch, gender, count(gender)
from sales 
group by branch, gender;

-- Which time of the day do customers give most ratings?
select time_of_day, round(avg(rating), 2)
from sales 
group by time_of_day 
order by avg(rating);


