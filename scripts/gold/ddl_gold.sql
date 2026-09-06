
/*
===========================================================================================
DDL SCRIPT: Create Gold Views
==========================================================================================
Script Purpose: 
      This sript creates views for the gold layer in the data warehouse.
      The gold layer represents the final dimension and the fact tables (Star Schema)

      Each view performs transformations and combines data from the silver layer to produce
      a clean, enriched, and business-ready dataset.

Usage:
      These views can be queried directly for analytics and reporting.
==========================================================================================
*/

create view datawarehouse_gold.report_customers as
with base_query as(
select f.order_number,
f.product_key, f.order_date, f.sales_amount,
f.quantity, c.customer_key,c.customer_number,
concat(c.first_name, ' ', c.last_name) as customer_name,
timestampdiff(year, c.birthdate, current_date()) as age
from datawarehouse_gold.fact_sales f 
left join datawarehouse_gold.dim_customers c 
on c.customer_key = f.customer_key
where f.order_date is not null)

, customer_aggregation as (select customer_key, customer_number, customer_name, age,
count(distinct order_number) as total_orders,
sum(sales_amount) as total_sales,
sum(quantity) as total_quantity,
max(order_date) as last_order_date,
timestampdiff(month, min(order_date), max(order_date)) as lifespan,
count(distinct product_key) as total_products from base_query
group by customer_key, customer_number, customer_name, age)

select customer_key, 
customer_number, 
customer_name, 
age,
case
	when age < 20 then 'Under 20'
    when age between 20 and 29 then '20-29'
    when age between 30 and 29 then '30-39'
    when age between 40 and 49 then '40-49'
    else '50 and above'
end as age_group,
case
	when lifespan >= 12 and total_sales>5000 then 'VIP'
    when lifespan >= 12 and total_sales <= 5000 then 'Regular'
    else 'New'
end as customer_segment,
last_order_date,
timestampdiff(month, last_order_date, current_date()) as recency,
total_orders,
total_sales,
total_quantity,
lifespan,
#average order value = total sales/total no of orders
#total_sales/total_orders as avg_order_value,
case when total_sales = 0 then 0
	else total_sales/total_orders
end as avg_order_value,
#average monthly spend
case 
	when lifespan = 0 then total_sales 
    else total_sales/ lifespan
end as avg_monthly_spend
from customer_aggregation;





create view datawarehouse_gold.dim_customers as
select 
row_number() over(order by cst_id) as customer_key,
ci.cst_id as customer_id, 
ci.cst_key as customer_number, 
ci.cst_firstname as first_name, 
ci.cst_lastname as last_name, 
ci.cst_material_status as marital_status, 
case 
	when ci.cst_gndr !='n/a' then ci.cst_gndr
	else coalesce(ca.gen, 'n/a')
end as gender,
ci.cst_create_date as create_date,
ca.bdate as birthdate,
la.cntry as country
from datawarehouse_silver.crm_cust_info ci
left join datawarehouse_silver.erp_cust_az12 ca
on ci.cst_key = ca.cid
left join datawarehouse_silver.erp_loc_a101 la 
on ci.cst_key = la.cid where ci.cst_id !=0;



create view datawarehouse_gold.dim_products as
select 
row_number() over(order by pn.prd_start_dt, pn.prd_key) as product_key, 
prd_id as product_id, 
pn.cat_id as category_id, pn.prd_key as product_number, pn.prd_nm as product_name, 
pn.prd_cost as cost, pn.prd_line as product_line, 
pn.prd_start_dt as start_date, pc.cat as category, 
pc.subcat as subcategory, pc.MAINTENANCE
from datawarehouse_silver.crm_prd_info pn
left join datawarehouse_silver.erp_px_cat_g1v2 pc 
on pn.cat_id = pc.id
where prd_end_dt is null; 



create view gold.fact_sales as 
select sd.sls_ord_num as order_number, pr.product_key, cu.customer_key, 
sd.sls_order_dt as order_date, sd.sls_ship_dt as shipping_date, 
sd.sls_due_dt as due_date,
sd.sls_sales as sales_amount, 
sd.sls_quantity as quantity, 
sd.sls_price as price from datawarehouse_silver.crm_sales_details sd
left join datawarehouse_gold.dim_products pr on
sd.sls_prd_key = pr.product_number
left join datawarehouse_gold.dim_customers cu 
on sd.sls_cust_id = cu.customer_id;





