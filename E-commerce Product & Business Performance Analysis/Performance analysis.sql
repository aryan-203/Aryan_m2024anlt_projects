create schema ba_project;
use ba_project;
create table customers (customer_id int primary key, age int,gender varchar(10),city varchar(20),segment varchar(20));
create table products(product_id int primary key,category varchar(20),cost decimal(10,2), price decimal(10,2));
create table orders(order_id int primary key,order_date date,customer_id int,product_id int,quantity int,price decimal(20,2),sales decimal(20,2),discount decimal(10,2),foreign key (customer_id) references customers(customer_id),foreign key (product_id) references products(product_id));
create table user_events (event_id int primary key,customer_id int,product_id int,event_type varchar(30),event_date date);
create table sessions (session_id int primary key,customer_id int,session_date date,device varchar(20),traffic_source varchar(20));

-- Row count check
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'user_events', COUNT(*) FROM user_events
UNION ALL
SELECT 'sessions', COUNT(*) FROM sessions;
-- Orders without matching customers
SELECT *
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Total Revenue & Orders
SELECT 
    COUNT(order_id) AS total_orders,
    SUM(sales) AS total_revenue
FROM orders;
-- Revenue by Category
SELECT 
    p.category,
    SUM(o.sales) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;
-- Profit Calculation
SELECT 
    SUM(o.sales - (p.cost * o.quantity)) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id;

SELECT 
    event_type,
    COUNT(DISTINCT customer_id) AS users
FROM user_events
GROUP BY event_type;

-- Who are our most valuable customers?
SELECT 
    o.customer_id,
    COUNT(o.order_id) AS total_orders,
    SUM(o.sales) AS total_revenue
FROM orders o
GROUP BY o.customer_id
ORDER BY total_revenue DESC;
-- Can we bucket customers based on their contribution?
SELECT 
    customer_id,
    total_revenue,
    CASE 
        WHEN total_revenue >= 15000 THEN 'High Value'
        WHEN total_revenue BETWEEN 5000 AND 14999 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM (
    SELECT 
        customer_id,
        SUM(sales) AS total_revenue
    FROM orders
    GROUP BY customer_id
) t;
-- Which segment drives the business?
SELECT 
    customer_segment,
    SUM(total_revenue) AS segment_revenue
FROM (
    SELECT 
        customer_id,
        SUM(sales) AS total_revenue,
        CASE 
            WHEN SUM(sales) >= 15000 THEN 'High Value'
            WHEN SUM(sales) BETWEEN 5000 AND 14999 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM orders
    GROUP BY customer_id
) t
GROUP BY customer_segment;

-- Which categories matter most?
SELECT 
    p.category,
    COUNT(o.order_id) AS total_orders,
    SUM(o.sales) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;
-- Profit by Category
SELECT 
    p.category,
    SUM(o.sales - (p.cost * o.quantity)) AS profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY profit DESC;
-- 	Are discounts helping or hurting?
SELECT 
    discount,
    SUM(o.sales) AS revenue,
    SUM(o.sales - (p.cost * o.quantity)) AS profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY discount
ORDER BY discount;
use ba_project;

-- Funnel Conversion by Step
SELECT 
    event_type,
    COUNT(DISTINCT customer_id) AS users
FROM user_events
GROUP BY event_type;
-- Funnel Drop-off Identification
SELECT 
    customer_id,
    COUNT(DISTINCT event_type) AS steps_completed
FROM user_events
GROUP BY customer_id;

-- Daily Active Users (DAU)
SELECT 
    event_date,
    COUNT(DISTINCT customer_id) AS dau
FROM user_events
GROUP BY event_date
ORDER BY event_date;
-- Conversion Rate: View → Purchase
SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN customer_id END) AS viewers,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) AS purchasers,
    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_type = 'view' THEN customer_id END),
        2
    ) AS view_to_purchase_pct
FROM user_events;
-- Step-wise Funnel Conversion
WITH funnel AS (
    SELECT
        customer_id,
        MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS viewed,
        MAX(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS added,
        MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM user_events
    GROUP BY customer_id
)
SELECT
    SUM(viewed) AS viewed_users,
    SUM(added) AS cart_users,
    SUM(purchased) AS purchase_users,
    ROUND(SUM(added) * 100.0 / SUM(viewed), 2) AS view_to_cart_pct,
    ROUND(SUM(purchased) * 100.0 / SUM(added), 2) AS cart_to_purchase_pct
FROM funnel;

-- Do users come back after their first purchase?
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
),
cohorts AS (
    SELECT
        o.customer_id,
        DATE_FORMAT(f.first_order_date, '%Y-%m-01') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS activity_month
    FROM orders o
    JOIN first_purchase f
        ON o.customer_id = f.customer_id
)
SELECT
    cohort_month,
    activity_month,
    COUNT(DISTINCT customer_id) AS active_users
FROM cohorts
GROUP BY cohort_month, activity_month
ORDER BY cohort_month, activity_month;
-- Retention Rate Calculation
WITH first_purchase AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
),
cohort_size AS (
    SELECT
        DATE_FORMAT(first_order_date, '%Y-%m-01') AS cohort_month,
        COUNT(DISTINCT customer_id) AS users
    FROM first_purchase
    GROUP BY DATE_FORMAT(first_order_date, '%Y-%m-01')
),
retention AS (
    SELECT
        DATE_FORMAT(f.first_order_date, '%Y-%m-01') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m-01') AS activity_month,
        COUNT(DISTINCT o.customer_id) AS active_users
    FROM orders o
    JOIN first_purchase f
        ON o.customer_id = f.customer_id
    GROUP BY
        DATE_FORMAT(f.first_order_date, '%Y-%m-01'),
        DATE_FORMAT(o.order_date, '%Y-%m-01')
)
SELECT
    r.cohort_month,
    r.activity_month,
    ROUND(r.active_users * 100.0 / c.users, 2) AS retention_pct
FROM retention r
JOIN cohort_size c
    ON r.cohort_month = c.cohort_month
ORDER BY r.cohort_month, r.activity_month;

-- Did version B improve conversion?
SELECT
    experiment_group,
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN customer_id END) AS viewers,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) AS purchasers,
    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_type = 'view' THEN customer_id END),
        2
    ) AS conversion_rate
FROM user_events
GROUP BY experiment_group;
