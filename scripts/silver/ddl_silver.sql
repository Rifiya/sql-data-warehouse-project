/*
============================================================================
SQL Script: Create Silver Tables
============================================================================
Script Purpose:
  This script creates tables in the silver schema 
  Run this script to redefine the DDL structure of the bronze tables
===========================================================================
*/

create table datawarehouse_silver.crm_cust_info(cst_id int, cst_key varchar(50),
	cst_firstname varchar(50),
	cst_lastname varchar(50),
	cst_material_status varchar(50),
	cst_gndr varchar(10),
	cst_create_date DATE,
	dwh_create_date DATETIME DEFAULT current_timestamp);
    
	SELECT * 
	FROM crm_cust_info
	LIMIT 10;

	create table datawarehouse_silver.crm_prd_info(
	prd_id int,
    cat_id varchar(50),
	prd_key varchar(50),
	prd_nm varchar(50),
	prd_cost int,
	prd_line varchar(20),
	prd_start_dt date,
	prd_end_dt date,
    dwh_create_date DATETIME DEFAULT current_timestamp);

	SELECT * 
	FROM crm_prd_info
	LIMIT 10;

	create table datawarehouse_silver.crm_sales_details(
	sls_ord_num varchar(50),
	sls_prd_key varchar(50),
	sls_cust_id varchar(50),
    sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,sls_quantity int,
	sls_price int,
    dwh_create_date DATETIME DEFAULT current_timestamp);

	SELECT * 
	FROM crm_sales_details
	LIMIT 10;
	
    select '-------------------------------------' as message;
    select 'loading ERP tables' as message;
    select '-------------------------------------' as message;
	create table datawarehouse_silver.erp_cust_az12(
	CID varchar(50),
	BDATE DATE,
	GEN VARCHAR(10),
    dwh_create_date DATETIME DEFAULT current_timestamp);

	SELECT * 
	FROM erp_cust_az12
	LIMIT 10;

	create table datawarehouse_silver.erp_loc_a101(
	CID VARCHAR(50),
	CNTRY varchar(50),
    dwh_create_date DATETIME DEFAULT current_timestamp);

	SELECT * 
	FROM erp_loc_a101
	LIMIT 10;

	create table datawarehouse_silver.erp_px_cat_g1v2(
	ID VARCHAR(50),
	CAT varchar(50),
	SUBCAT varchar(50),
	MAINTENANCE VARCHAR(50),
    dwh_create_date DATETIME DEFAULT current_timestamp);
