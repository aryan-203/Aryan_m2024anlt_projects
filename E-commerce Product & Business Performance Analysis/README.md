# Business & Product Analytics Project (MySQL)

## Business Context
This project simulates an e-commerce platform where customers browse products, add items to cart,
and complete purchases. The objective is to analyze business performance and user behavior using
SQL to support data-driven business and product decisions.

The project is designed to reflect real-world Business Analyst and Associate Product Manager
use cases, combining transactional, behavioral, and engagement data.

---

## Problem Statement
The business lacks clarity on:
- What drives revenue growth
- Where users drop off in the purchase funnel
- Which customer segments and products contribute the most value
- How user engagement and retention affect long-term growth

The goal is to use data to identify opportunities to improve conversion, retention, and overall
product performance.

---

## Business Goals
1. Increase total revenue and average order value  
2. Improve user conversion across the purchase funnel  
3. Increase customer retention and repeat purchases  
4. Identify high-performing products and customer segments  
5. Enable product decisions using behavioral data  

---

## Key Performance Indicators (KPIs)

### Revenue Metrics
- Total Revenue
- Revenue Growth (Month-over-Month)
- Average Order Value (AOV)

### Customer Metrics
- Total Customers
- New vs Returning Customers
- Revenue by Customer Segment

### Product & Funnel Metrics
- View → Cart Conversion Rate
- Cart → Purchase Conversion Rate
- Overall Funnel Conversion Rate

### Engagement Metrics
- Daily Active Users (DAU)
- Sessions per User
- Traffic Source Performance

### Retention Metrics
- Monthly Retention Rate
- Churn Rate
- Cohort Retention

### North Star Metric
- **Purchases per Active User**

---

## Logical Data Model Overview
The data model is designed to clearly separate identity, behavior, and transactions:

- **Customers**: Stores customer demographic and segmentation information  
- **Products**: Stores product category, pricing, and cost details  
- **Orders**: Captures transactional purchase and revenue data  
- **User Events**: Tracks user behavior across the purchase funnel  
- **Sessions**: Captures session-level engagement and acquisition data  

This structure supports both business analytics and product analytics use cases.

---

## Data Requirements
To achieve the business goals and compute KPIs, the following data is required:
- Customer demographics and segments
- Product pricing and cost data
- Transaction-level order data
- User behavioral events (view, add to cart, purchase)
- Session-level engagement data (device and traffic source)

Each dataset directly maps to a specific business question to avoid redundancy.

---

## Database Schema
The project uses a relational schema implemented in MySQL with primary and foreign key constraints
to maintain data integrity and support scalable analytical queries.

---

## Tools & Technologies
- **Database:** MySQL  
- **Querying:** SQL  
- **Version Control:** GitHub  
- **Visualization:** Power BI  
- **Documentation:** Markdown

# 1. Data Validation
## 1.1 Row count check
```sql
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'user_events', COUNT(*) FROM user_events
UNION ALL
SELECT 'sessions', COUNT(*) FROM sessions;
```
## 1.2 Orders without matching customers
```sql
SELECT *
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
```

# 2. Core Business Metrics
## 2.1 Total Revenue & Orders
```sql
SELECT 
    COUNT(order_id) AS total_orders,
    SUM(sales) AS total_revenue
FROM orders;
```
## 2.2 Revenue by Category
```sql
SELECT 
    p.category,
    SUM(o.sales) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;
```
## 2.3 Profit Calculation
```sql
SELECT 
    SUM(o.sales - (p.cost * o.quantity)) AS total_profit
FROM orders o
JOIN products p ON o.product_id = p.product_id;
```

# 3. Funnel Basics
```sql
SELECT 
    event_type,
    COUNT(DISTINCT customer_id) AS users
FROM user_events
GROUP BY event_type;
```

# 4. Customer Segmentation
## 4.1 Who are our most valuable customers?
```sql
SELECT 
    o.customer_id,
    COUNT(o.order_id) AS total_orders,
    SUM(o.sales) AS total_revenue
FROM orders o
GROUP BY o.customer_id
ORDER BY total_revenue DESC;
```
## 4.2 Can we bucket customers based on their contribution?
```sql
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
```
## 4.3 Which segment drives the business?
```sql
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
```

# 5. Product Category Insights
## 5.1 Which categories matter most?
```sql
SELECT 
    p.category,
    COUNT(o.order_id) AS total_orders,
    SUM(o.sales) AS revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;
```
## 5.2 Profit by Category
```sql
SELECT 
    p.category,
    SUM(o.sales - (p.cost * o.quantity)) AS profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY profit DESC;
```
### 5.3 Are discounts helping or hurting?
```sql
SELECT 
    discount,
    SUM(o.sales) AS revenue,
    SUM(o.sales - (p.cost * o.quantity)) AS profit
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY discount
ORDER BY discount;
```

# 6. Product Funnel Deep Dive
## 6.1 Funnel Conversion by Step
```sql
SELECT 
    event_type,
    COUNT(DISTINCT customer_id) AS users
FROM user_events
GROUP BY event_type;
```
## 6.2 Funnel Drop-off Identification
```sql
SELECT 
    customer_id,
    COUNT(DISTINCT event_type) AS steps_completed
FROM user_events
GROUP BY customer_id;
```

# 7. Product Metrics
## 7.1 Daily Active Users (DAU)
```sql
SELECT 
    event_date,
    COUNT(DISTINCT customer_id) AS dau
FROM user_events
GROUP BY event_date
ORDER BY event_date;
```
## 7.2 Conversion Rate: View → Purchase
```sql
SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'view' THEN customer_id END) AS viewers,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) AS purchasers,
    ROUND(
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) * 100.0 /
        COUNT(DISTINCT CASE WHEN event_type = 'view' THEN customer_id END),
        2
    ) AS view_to_purchase_pct
FROM user_events;
```
## 7.3 Step-wise Funnel Conversion
```sql
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
```

# 8. Cohort Retention
## 8.1 Do users come back after their first purchase?
```sql
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
```
## 8.2 Retention Rate Calculation
```sql
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
```

# 9. Experiment Analysis
## 9.1 Did version B improve conversion?
```sql
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
```
