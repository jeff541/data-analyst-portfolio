CREATE OR ALTER PROCEDURE bronze.load_bronze AS 

BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @start_process DATETIME, @end_process DATETIME ; 
BEGIN TRY
	PRINT '==========================================';
	PRINT 'Chargement de la base de données de bronze ';
	PRINT '==========================================';

	PRINT '-------------------------------------------';
	PRINT 'Chargement des tables CRM ';
	PRINT '-------------------------------------------';

	PRINT '>> Suppression des enregistrements de la table: bronze.crm_cust_info '; 

	PRINT '-------------------------------------------';
	SET @start_process = GETDATE();
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_cust_info;

	PRINT '>> Insertion des enregistrements dans la table: bronze.crm_cust_info ';
	BULK INSERT bronze.crm_cust_info

	FROM 'C:\Users\jeff\Documents\sql\datasets\source_crm\cust_info.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);
	SET @end_time = GETDATE();
	PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';

	PRINT '>> Suppression des enregistrements de la table: bronze.crm_prd_info ';

	PRINT '-------------------------------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_prd_info;

	PRINT '>> Insertion des enregistrements dans la table: bronze.crm_prd_info ';

	BULK INSERT bronze.crm_prd_info

	FROM 'C:\Users\jeff\Documents\sql\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);

	SET @end_time = GETDATE();
	PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';



	
	PRINT '>> Suppression des enregistrements de la table: bronze.crm_sales_details ';

	PRINT '-------------------------------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_sales_details;

	PRINT '>> Insertion des enregistrements dans la table: bronze.crm_sales_details ';

	BULK INSERT bronze.crm_sales_details

	FROM 'C:\Users\jeff\Documents\sql\datasets\source_crm\sales_details.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);

	SET @end_time = GETDATE();
	PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';

	PRINT '>> Suppression des enregistrements de la table: bronze.erp_cust_az12 ';

	PRINT '-------------------------------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_cust_az12;

	PRINT '>> Insertion des enregistrements dans la table: bronze.erp_cust_az12 ';

	BULK INSERT bronze.erp_cust_az12

	FROM 'C:\Users\jeff\Documents\sql\datasets\source_erp\cust_az12.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);

	SET @end_time = GETDATE();
	PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';

	PRINT '>> Suppression des enregistrements de la table: bronze.erp_loc_a101 ';

	PRINT '-------------------------------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_loc_a101;

	PRINT '>> Insertion des enregistrements dans la table: bronze.erp_loc_a101 ';

	BULK INSERT bronze.erp_loc_a101

	FROM 'C:\Users\jeff\Documents\sql\datasets\source_erp\loc_a101.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);

	SET @end_time = GETDATE();
	PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';

	PRINT '>> Suppression des enregistrements de la table: bronze.erp_px_cat_g1v2 ';

	PRINT '-------------------------------------------';

	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	PRINT '>> Insertion des enregistrements dans la table: bronze.erp_px_cat_g1v2 ';

	BULK INSERT bronze.erp_px_cat_g1v2

	FROM 'C:\Users\jeff\Documents\sql\datasets\source_erp\px_cat_g1v2.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);

	SET @end_time = GETDATE();
	SET @end_process = GETDATE();
	PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';
	PRINT '=================================================================================='
	PRINT 'CHARGEMENT DE LA COUCHE DE BRONZE TERMINé'
	PRINT '>> Durée du chargement de la couche de bronze:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_process, @end_process)) + ' secondes';
	PRINT '=================================================================================='
	END TRY
	BEGIN CATCH
		PRINT '========================================================================='
		PRINT 'UNE ERREUR EST SURVENUE LORS DU CHARGEMENT DE LA COUCHE DE BRONZE'
		PRINT 'MESSAGE D ERREUR ' + ERROR_MESSAGE();
		PRINT 'MESSAGE D ERREUR ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'MESSAGE D ERREUR ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '========================================================================='
	END CATCH
END
GO

USE DataWarehouse;

EXEC bronze.load_bronze;