-- 1. Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id) AS Total_Orders
FROM
    orders;

    
-- 2. Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS Total_Revenue
FROM
    order_details od
        JOIN
    pizzas p ON p.pizza_id = od.pizza_id;


-- 3. Identify the highest-priced pizza.
SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;


-- 4. Identify the most common pizza size ordered.
SELECT 
    p.size, COUNT(od.order_details_id) AS Order_Count
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY Order_Count DESC
LIMIT 1;


-- 5. List the top 5 most ordered pizza types along with their quantities
SELECT 
    pt.name, SUM(od.quantity) AS Quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Quantity DESC
LIMIT 5;


-- 6. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pt.category, SUM(od.quantity) AS Quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY Quantity DESC;


-- 7. Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(order_time) AS Hour, COUNT(order_id) AS Orders
FROM
    Orders
GROUP BY Hour;


-- 8. Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- 9. Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(Quantity), 0) AS Avg_Pizzas_Per_Day
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS Quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS Order_Quantity;


-- 10. Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name, SUM(od.quantity * p.price) AS Revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.name
ORDER BY Revenue DESC
LIMIT 3;


-- 11. Calculate the percentage contribution of each pizza type to total revenue
SELECT 
    pt.category,
    ROUND(SUM(od.quantity * p.price) / (SELECT 
                    ROUND(SUM(od.quantity * p.price), 2) AS total_sales
                FROM
                    order_details od
                        JOIN
                    pizzas p ON p.pizza_id = od.pizza_id) * 100,
            2) AS Revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY Revenue DESC;   


-- 12. Analyze the cumulative revenue generated over time
select order_date, round(sum(Revenue) 
over( order by order_date),2) as cum_rev
from (SELECT 
    o.order_date, SUM(od.quantity * p.price) AS Revenue
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id
        JOIN
    orders o ON o.order_id = od.order_id
GROUP BY o.order_date) as Sales;


-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category
select name, Revenue from
(select category, name, Revenue,
rank() over(partition by category order by Revenue desc) as rn
from 
(SELECT 
    pt.category,
    pt.name,
    ROUND(SUM(od.quantity * p.price), 2) AS Revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY pt.category , pt.name) as a) as b
where rn <= 3;






















