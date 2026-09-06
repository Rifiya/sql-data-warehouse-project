/*
===================================================================================================
Quality Checks
===================================================================================================

Script Purpose:
    This script performs quality checks to validate the integrity, consistency, and acccuracy of the gold layer.
    The checks ensure
    - uniqueness of surrogate keys in dimension tables.
    - Refrential integrity between facts and dimensions tables
    - Validation of relatiosnships in the data model for analytical purpose.


usage notes:
    - Run these checks after loading the silver layer.
    - Investigate and resolve any discrepancies found during the checks.
=============================================================================================================
*/


select * from information_schema.tables;

#explore all the countries our customers came from
select distinct country from datawarehouse_gold.dim_customers;

#explore all the categories 'the major divisons'
select distinct category, subcategory, product_name from datawarehouse_gold.dim_products
order by 1,2,3;

#find the date of the first and last order
select min(order_date) as first_order_date,
max(order_date) as last_order_date,
TIMESTAMPDIFF(year, min(order_date), max(order_date)) as order_range_years
from datawarehouse_gold.fact_sales;

#find the youngest and the oldest customer
select min(birthdate) as oldest_birthdate,
max(birthdate) as youngest_birthdate,
timestampdiff(year, min(birthdate), current_date())as oldest_age,
timestampdiff(year, max(birthdate), current_date())as oldest_age
from datawarehouse_gold.dim_customers;
