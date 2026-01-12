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
