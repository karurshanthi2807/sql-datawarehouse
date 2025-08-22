IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
	go 
create view gold.dim_customers as 
select 
Row_number() over (order by cst_id) as Customer_key,
cst_id as customer_id,
    cli.cst_key as customer_number,
    cli.cst_firstname as First_name,
    cli.cst_lastname as Last_name,
	la.cntry as country,
    cli.cst_marital_status as Marital_status,
    cli.cst_create_date as create_date,
	ca.bdate as birthdate,
	case when cli.cst_gndr != 'n/a' then cli.cst_gndr
	     else coalesce(ca.gen,'n/a')
	end as Gender
	

from silver.crm_cust_info cli
left join silver.erp_cust ca  on cli.cst_key=ca.cid
left join silver.erp_loc la  on cli.cst_key =la.cid;
go

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,
    pn.prd_key      AS product_number,
    pn.prd_nm       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM silver.prd_info pn
LEFT JOIN silver.erp_px_cat pc
    ON pn.cat_id = pc.id;
	go 
	IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

	CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key,
    cu.customer_key AS customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
	go