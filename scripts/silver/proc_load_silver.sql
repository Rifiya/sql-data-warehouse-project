/*
==============================================================================================
Stored Procedure: Load Silver Layer (Bronze-> Silver)
==============================================================================================

Script Purpose:
  This stored procedure performs the ETL process to populate the silver schema tables from the bronze schema.
  Actions Performed:
    - Truncates silver tables
    - Inserts transformed and cleansed data from bronze into silver tables.
Parameters:
  None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
  EXEC Silver.load_silver;

==================================================================================================
*/

truncate datawarehouse_silver.crm_prd_info;
insert into datawarehouse_silver.crm_prd_info(prd_id, cat_id, prd_key, prd_nm, 
prd_cost, prd_line, prd_start_dt, prd_end_dt)

select prd_id,
replace(substring(prd_key, 1,5), '-','_') as cat_id,
substring(prd_key,7,length(prd_key)) as prd_key, 
prd_nm, 
coalesce(prd_cost,0) as prd_cost,
case 
	when upper(trim(prd_line)) = 'M' then 'Mountain'
	when upper(trim(prd_line)) = 'R' then 'Road'
	when upper(trim(prd_line)) = 'S' then 'Other sales'
	when upper(trim(prd_line)) = 'T' then 'Touring'
	else 'n/a'
end as prd_line,
cast(prd_start_dt as date) as prd_start_dt, 
DATE_SUB(
        LEAD(prd_start_dt) OVER (
            PARTITION BY prd_key
            ORDER BY prd_start_dt
        ),
        INTERVAL 1 DAY
    ) AS prd_end_dt

from datawarehouse_bronze.crm_prd_info;

TRUNCATE TABLE datawarehouse_silver.crm_sales_details;
insert into datawarehouse_silver.crm_sales_details(
sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price)
select sls_ord_num, sls_prd_key, sls_cust_id, 
case 
	when sls_order_dt = 0 or length(sls_order_dt) !=8 then NULL
	else STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d') 
	end as sls_ordr_dt,
case 
	when sls_ship_dt = 0 or length(sls_ship_dt) !=8 then NULL
	else STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d') 
	end as sls_ship_dt, 
case 
	when sls_due_dt = 0 or length(sls_due_dt) !=8 then NULL
	else STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d') 
	end as sls_due_dt, 

case 	
	when sls_sales <= 0 or sls_sales is null or sls_sales != sls_quantity * ABS(sls_price)
    then sls_quantity * ABS(sls_price)
    else sls_sales
end as sls_sales,

case 
	when sls_price is null or sls_price <=0
	then sls_sales/ nullif(sls_quantity,0)
	else sls_price
	end as sls_price

,sls_quantity
from datawarehouse_bronze.crm_sales_details;

TRUNCATE TABLE datawarehouse_silver.erp_cust_az12;
insert into datawarehouse_silver.erp_cust_az12(cid, bdate, gen)
select 
case when cid like 'NAS%' THEN substring(cid, 4, length(cid))
	else cid
end cid,
case 
	when bdate> current_date() then null
	else bdate 
end as bdate,
case 
	WHEN UPPER(TRIM(REPLACE(gen, '\r', ''))) IN ('FEMALE', 'F') THEN 'Female'
    WHEN UPPER(TRIM(REPLACE(gen, '\r', ''))) IN ('MALE', 'M') THEN 'Male'
    ELSE 'N/A'
    
end as gen
from datawarehouse_bronze.erp_cust_az12;

TRUNCATE TABLE datawarehouse_silver.erp_loc_a101;
insert into datawarehouse_silver.erp_loc_a101(cid, cntry)
select replace(cid,'-','') as cid,
case 
	when TRIM(REPLACE(cntry, '\r', '')) = 'DE' THEN 'Germany'
    when TRIM(REPLACE(cntry, '\r', '')) IN ('US', 'USA') THEN 'United States'
    when TRIM(REPLACE(cntry, '\r', '')) = '' or cntry is null then 'n/a'
    else TRIM(REPLACE(cntry, '\r', ''))
end as cntry
from datawarehouse_bronze.erp_loc_a101;

#cleaning the px_cat table
truncate datawarehouse_silver.erp_px_cat_g1v2;
insert into datawarehouse_silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
select id, cat, subcat, maintenance from 
datawarehouse_bronze.erp_px_cat_g1v2;










