/*
==================================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=================================================================================================

Script Purpose:
  This stored procedure loads data into the bronze schema from the external csv files.
  It performs the following actions:
  - Truncates the bronze table before laoding the data.
  - uses the 'BULK INSERT' command to load data from csv files to the bronze tables.
Parameters: 
  None
This stored procedure does not accept any parameters or returns any values.

Usage Example:
  EXEC bronze.load_bronze;
==================================================================================================
*/
