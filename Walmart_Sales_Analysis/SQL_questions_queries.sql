/*Generic 
1) How many unique cities does the data have?*/
select distinct city from walmartsales.sales;

/*2) In which city is each branch?*/
select distinct city,branch from walmartsales.sales;


/*Product 
1) How many unique product lines does the data have?*/
select distinct Product_line from walmartsales.sales;

/*2) What is the most selling product line*/
select sum(quantity) as total_quantity ,Product_line from walmartsales.sales
group by Product_line
order by total_quantity desc; 

/*3) What is the total revenue by month*/
select sales.month_name , round(sum(total),2) as revenue
from walmartsales.sales
group by month_name
order by revenue;

/*4) What month had the largest COGS?*/
select sales.month_name , round(sum(cogs),2) as cogs
from walmartsales.sales
group by month_name
order by cogs;

/*5) What product line had the largest revenue?*/
select sales.Product_line , round(sum(total),2) as revenue
from walmartsales.sales
group by Product_line
order by revenue desc;

/*6) What is the city with the largest revenue?*/
select sales.City , round(sum(total),2) as revenue
from walmartsales.sales
group by City
order by revenue desc;

/*7) What product line had the largest VAT?*/
select sales.Product_line , round(avg(Tax),2) as VAT
from walmartsales.sales
group by Product_line
order by VAT desc;

/*8) Fetch each product line and add a column to those product line 
showing "Good", "Bad". Good if its greater than average sales*/
select avg(quantity) as avg_qua from walmartsales.sales;
select sales.product_line,
  case
when avg(Quantity) > 6 then 'Good' 
else 'Bad'
END AS Product_review
from walmartsales.sales
group by Product_line;

/*9) Which branch sold more products than average product sold?*/
select  sales.branch,sum(quantity)
from walmartsales.sales
group by branch
order by quantity desc;

/*10) What is the most common product line by gender*/
select gender,count(Product_line)
from walmartsales.sales
group by gender
order by product_line;

/*11) What is the average rating of each product line*/
select Product_line,round(avg(rating),2) as rating_avg
from walmartsales.sales
group by product_line
order by rating_avg;



/*Customers 
1) How many unique customer types does the data have?*/
select distinct customer_type from walmartsales.sales;

/*2) How many unique payment methods does the data have?*/
select distinct payment from walmartsales.sales;

/*3) What is the most common customer type?*/
select sales.customer_type,count(Customer_type)as count_customer
from walmartsales.sales
group by Customer_type;

/*4) Which customer type buys the most?*/
select sales.customer_type,count(Customer_type)as count_customer
from walmartsales.sales
group by Customer_type
order by count_customer desc
limit 1;

/*5) What is the gender of most of the customers?*/
select sales.gender,count(*) as G_count
from walmartsales.sales
group by gender
order by G_count desc;

/*6) What is the gender distribution per branch?*/
select sales.gender,sales.Branch,count(branch)
from walmartsales.sales
group by gender,branch
order by branch;

/*7) Which time of the day do customers give most ratings?*/
select sales.time_of_day, round(avg(rating),2) as time_rating
from walmartsales.sales
group by time_of_day
order by time_rating desc;

/*8) Which time of the day do customers give most ratings per branch?*/
select sales.time_of_day,sales.Branch ,round(avg(rating),2) as time_rating
from walmartsales.sales
group by time_of_day,branch
order by time_rating desc;

/*9) Which day fo the week has the best avg ratings?*/
select sales.day_name ,round(avg(rating),2) as time_rating
from walmartsales.sales
group by day_name
order by time_rating desc;

/*10) Which day of the week has the best average ratings per branch?*/
select sales.day_name,sales.Branch ,round(avg(rating),2) as time_rating
from walmartsales.sales
group by day_name,branch
order by time_rating desc;



/*Sales
1) Number of sales made in each time of the day per weekday*/
 SELECT time_of_day,COUNT(*) AS total_sales
FROM walmartsales.sales
WHERE day_name = "wednesday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
 
/*2) Which of the customer types brings the most revenue?*/
select sales.Customer_type,round(sum(total),2) as most_revenue
from walmartsales.sales
group by customer_type
order by most_revenue desc;

/*3) Which city has the largest tax/VAT percent?*/
select sales.city, round(sum(tax),2) as city_tax
from walmartsales.sales
group by city
order by city_tax desc;

/*4) Which customer type pays the most in VAT?*/
select sales.customer_type, round(avg(tax),2) as cust_tax
from walmartsales.sales
group by Customer_type
order by cust_tax desc;

