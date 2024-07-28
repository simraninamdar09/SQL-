/* Basic:
Retrieve the total number of orders placed.*/
select count(order_id)as total_order from pizza_order.order_details;

/*Calculate the total revenue generated from pizza sales.*/
select round(sum(order_details.quantity * pizzas.price),2) as total_sales
from pizza_order.order_details 
join pizza_order.pizzas on pizzas.pizza_id = order_details.pizza_id;

/*Identify the highest-priced pizza.*/
select pizza_types.name, pizzas.price
from pizza_order.pizza_types
join pizza_order.pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1;


/*Identify the most common pizza size ordered.*/
select pizzas.size,count(order_details.order_details_id) as order_count
from pizza_order.pizzas
join pizza_order.order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count desc
limit 1;

/*List the top 5 most ordered pizza types along with their quantities.*/
select pizza_types.name,
sum(order_details.quantity) as Quantity
from pizza_order.pizza_types
join pizza_order.pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
join pizza_order.order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by Quantity desc
limit 5;

/*Intermediate:
/*Join the necessary tables to find the total quantity of each pizza category ordered.*/
select pizza_types.category, sum(order_details.quantity)as quantity
from pizza_order.pizza_types
 join pizza_order.pizzas on pizza_types.pizza_type_id =pizzas.pizza_type_id
 join pizza_order.order_details on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.category
 order by quantity desc;

/*Determine the distribution of orders by hour of the day.*/
select hour(order_time),count(order_id) from pizza_order.order
group by hour(order_time);

/*Join relevant tables to find the category-wise distribution of pizzas.*/
select category, count(name) from pizza_order.pizza_types
group by category;

/*Group the orders by date and calculate the average number of pizzas ordered per day.*/
select round(avg(quantity),0) from
(select order_date, sum(order_details.quantity)as quantity
from pizza_order.order
join pizza_order.order_details on order.order_id = order_details.order_id
group by order.order_date) as order_quantity;

/*Determine the top 3 most ordered pizza types based on revenue.*/
select pizza_types.name,
sum(order_details.quantity * pizzas.price ) as revenue
from pizza_order.pizza_types
join pizza_order.pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join pizza_order.order_details on order_details.pizza_id =  pizzas.pizza_id 
group by pizza_types.name
order by revenue desc
limit 3;

/*Advanced:
Calculate the percentage contribution of each pizza type to total revenue.*/
select pizza_types.category,
round(sum(order_details.quantity * pizzas.price) / (select
 round(sum(order_details.quantity*pizzas.price),2) as total_sales
from pizza_order.order_details
join pizza_order.pizzas on pizzas.pizza_id = order_details.pizza_id)*100,2) as revenue
from pizza_order.pizza_types
join pizza_order.pizzas on pizza_types.pizza_type_id =  pizzas.pizza_type_id 
join pizza_order.order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc;

/*Analyze the cumulative revenue generated over time.*/
select order_date,round(sum(revenue) over (order by order_date),2) as cum_revenue
from
(select order_date, sum(order_details.quantity * pizzas.price) as revenue
from pizza_order.order_details 
join pizza_order.pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_order.order  on order.order_id = order_details.order_id
group by order_date) as sales;


/*Determine the top 3 most ordered pizza types based on revenue for each pizza category.*/
select name, revenue ,category,rn
from
(select category, name,revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category ,pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_order.pizza_types 
join pizza_order.pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join pizza_order.order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category ,pizza_types.name)as a)as b
where rn <= 3;
