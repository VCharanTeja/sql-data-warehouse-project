/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.crm_cust_info'
-- ====================================================================


--Check for nulls or duplicates in primary key
--Expectation:No Result

select
	cst_id,
	count(*)
from silver.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is null

--Check for unwanted spaces
--Expectation:No Result

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info

select * from silver.crm_cust_info


  -- ====================================================================
-- Checking 'silver.crm_prd_info'
-- ====================================================================
--Check for nulls or duplicates in primary key
--Expectation:No Result

select
	prd_id,
	count(*)
from silver.crm_prd_info
group by prd_id
having count(*) >1 or prd_id is null

--Check for unwanted spaces
--Expectation:No Result

SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--Check for NULLS or negative values
--Expectation:No Result

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for invalid date orders(start date > end date)
-- Expectation: No Results

SELECT
 *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT *
FROM silver.crm_prd_info


  -- ====================================================================
-- Checking 'silver.crm_sales_details'
-- ====================================================================

-- Check for Invalid dates
--Expectation: No invalid dates

SELECT
NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
OR LENGTH(CAST(sls_ship_dt AS VARCHAR)) !=8
OR sls_ship_dt > 20500101 -- due date,order date
OR sls_ship_dt < 19000101


-- Check for invalid date orders

SELECT
*
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
OR sls_order_dt > sls_due_dt

-- Check Data Consistency: Between Sales,Quantity and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero or negative

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales,sls_quantity,sls_price 

SELECT * FROM silver.crm_sales_details

  -- ====================================================================
-- Checking 'silver.erp_cust_az12'
-- ====================================================================

-- Identify Out-of-Range Dates

SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate > NOW()

-- Data Standardization & Consistency

SELECT DISTINCT 
	gen
FROM silver.erp_cust_az12

SELECT * FROM silver.erp_cust_az12


  -- ====================================================================
-- Checking 'silver.erp_loc_a101'
-- ====================================================================
-- Data Standardization & Consistency
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry

SELECT * FROM silver.erp_loc_a101

  -- ====================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ====================================================================
-- Check for unwanted spaces
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat!= TRIM(cat)
OR subcat!= TRIM(subcat)
OR maintenance != TRIM(maintenance)

-- 	Data Standardization & Consistency
SELECT DISTINCT
	maintenance -- Checked cat & subcat
FROM silver.erp_px_cat_g1v2

SELECT * FROM silver.erp_px_cat_g1v2
