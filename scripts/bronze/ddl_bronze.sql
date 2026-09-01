/*
=====================================================================================
DDL Script: Create Bronze Tables
=====================================================================================
Script Purpose:
  This script creates tables in thr bronze schema, dropping existing tables 
  if they already exists.
  Run this script to re-define the DDL structure of 'bronze' tables
====================================================================================
*/
create table datawarehouse_bronze.crm_cust_info(cst_id int, cst_key varchar(50),
	cst_firstname varchar(50),
	cst_lastname varchar(50),
	cst_material_status varchar(50),
	cst_gndr varchar(10),
	cst_create_date DATE);

	SELECT * 
	FROM crm_cust_info
	LIMIT 10;

	create table datawarehouse_bronze.crm_prd_info(
	prd_id int,
	prd_key varchar(50),
	prd_nm varchar(50),
	prd_cost int,
	prd_line varchar(20),
	prd_start_dt date,
	prd_end_dt date);

	SELECT * 
	FROM crm_prd_info
	LIMIT 10;

	create table datawarehouse_bronze.crm_sales_details(
	sls_ord_num varchar(50),
	sls_prd_key varchar(50),
	sls_cust_id varchar(50),sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,sls_quantity int,
	sls_price int);

	SELECT * 
	FROM crm_sales_details
	LIMIT 10;
	
    select '-------------------------------------' as message;
    select 'loading ERP tables' as message;
    select '-------------------------------------' as message;
	create table datawarehouse_bronze.erp_cust_az12(
	CID varchar(50),
	BDATE DATE,
	GEN VARCHAR(10));

	SELECT * 
	FROM erp_cust_az12
	LIMIT 10;

	create table datawarehouse_bronze.erp_loc_a101(
	CID VARCHAR(50),
	CNTRY varchar(50));

	SELECT * 
	FROM erp_loc_a101
	LIMIT 10;

	create table datawarehouse_bronze.erp_px_cat_g1v2(
	ID VARCHAR(50),
	CAT varchar(50),
	SUBCAT varchar(50),
	MAINTENANCE VARCHAR(50));

	SELECT * 
	FROM erp_px_cat_g1v2
	LIMIT 10;
