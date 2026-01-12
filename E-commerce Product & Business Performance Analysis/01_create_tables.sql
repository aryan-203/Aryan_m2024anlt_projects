create schema ba_project;
use ba_project;
create table customers (customer_id int primary key, age int,gender varchar(10),city varchar(20),segment varchar(20));
create table products(product_id int primary key,category varchar(20),cost decimal(10,2), price decimal(10,2));
create table orders(order_id int primary key,order_date date,customer_id int,product_id int,quantity int,sales decimal(20,2),discount decimal(10,4),foreign key (customer_id) references customers(customer_id),foreign key (product_id) references products(product_id));
create table user_events (event_id int primary key,customer_id int,product_id int,event_type varchar(30),event_date date);
create table sessions (session_id int primary key,cutomer_id int,session_date date,device varchar(20),traffic_source varchar(20));