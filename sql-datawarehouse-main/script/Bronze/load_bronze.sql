create or alter procedure bronze.load_bronze as 
begin 
declare @start_time Datetime, @end_time  datetime; 
set @start_time=getdate()
begin try
print '======================================'
print 'loading Bronze layer'
print '======================================'
print '--------------------------------------'
print 'loading crm table'
print'loading cust-info table'
Truncate table bronze.crm_cust_info;
bulk insert bronze.crm_cust_info 
from 'C:\Users\chara\Downloads\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
with (
            FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
);

	print'---------------------------------------------------------------------------------------------'
print'loading prd-info table '

Truncate table bronze.prd_info;
bulk insert bronze.prd_info
from 'C:\Users\chara\Downloads\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
with (
            FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
);
Truncate table bronze.sales_details;
bulk insert bronze.sales_details
from 'C:\Users\chara\Downloads\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
with (
            FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
);
print'---------------------------------'
print'loading erp tables'
print'---------------------------------'
Truncate table bronze.erp_cust;
bulk insert bronze.erp_cust
from 'C:\Users\chara\Downloads\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
with (
            FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
);
Truncate table bronze.erp_loc;
bulk insert bronze.erp_loc
from 'C:\Users\chara\Downloads\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
with (
            FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
);
Truncate table bronze.erp_px_cat;
bulk insert bronze.erp_px_cat
from 'C:\Users\chara\Downloads\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
with (
            FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
);
end try 
begin CATch
print'ERROR occured during bronze layer'
end catch;

print 'loading bronze layer is completed '

set @end_time=getdate()
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
end
exec bronze.load_bronze;