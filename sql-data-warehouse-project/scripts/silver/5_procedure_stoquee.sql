/*
===============================================================================
Procédure Stockée : Chargement de la couche Silver (Bronze -> Silver)
===============================================================================
Objectif du script :
    Cette procédure stockée effectue le processus ETL (Extract, Transform, Load) pour
    alimenter les tables du schéma 'silver' à partir du schéma 'bronze'.
    Actions réalisées :
        - Tronque les tables Silver.
        - Insère les données transformées et nettoyées de Bronze dans Silver.

Paramètres :
    Aucun.
    Cette procédure stockée n'accepte aucun paramètre et ne retourne aucune valeur.

Exemple d'utilisation :
    EXEC Silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @start_process DATETIME, @end_process DATETIME; 
    BEGIN TRY
        SET @start_process = GETDATE();
        PRINT '================================================';
        PRINT 'Chargement De La Couche d Argent';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Chargement Des Tables CRM';
		PRINT '------------------------------------------------';

		-- Chargement de silver.crm_cust_info
        SET @start_time = GETDATE();
		PRINT '>> Suppression des enregistrements de la table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;
		PRINT '>> Insertion des enregistrements dans la table: silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
			cst_id, 
			cst_key, 
			cst_firstname, 
			cst_lastname, 
			cst_marital_status, 
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE 
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				ELSE 'n/a'
			END AS cst_marital_status,  -- Normalisation des valeurs d'état matrimonial
			CASE 
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'n/a'
			END AS cst_gndr,  -- Normalisation des valeurs de genre
			cst_create_date
		FROM (
			SELECT
				*,
				ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
			FROM bronze.crm_cust_info
			WHERE cst_id IS NOT NULL
		) t
		WHERE flag_last = 1; -- Sélection du dernier enregistrement par client
		SET @end_time = GETDATE();
        PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';
        PRINT '>> -------------';

		-- Chargement de silver.crm_prd_info
        SET @start_time = GETDATE();
		PRINT '>> Suppression des enregistrements de la table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
		PRINT '>> Insertion des enregistrements dans la table: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extraction de la catégorie. 
			                                                       -- Les 5 premières lettres de prd_key correspondent à la catégorie,
																   -- Nous remplaçons aussi '-' par '_' pour une correspondance avec la table bronze.erp_cust_az12
			
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,        -- Extraction de la clé du produit
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE 
				WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line, -- Associer les codes de gamme de produits à des valeurs descriptives
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(
				LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
				AS DATE
			) AS prd_end_dt -- Calculer la date de fin comme un jour avant la prochaine date de début
		FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';
        PRINT '>> -------------';

        -- Chargement de crm_sales_details
        SET @start_time = GETDATE();
		PRINT '>>  Suppression des enregistrements de la table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Insertion des enregistrements dans la table: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE 
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE 
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE 
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE 
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
					THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales, -- Recalculer les ventes si la valeur es null, incohérente ou inexacte
			sls_quantity,
			CASE 
				WHEN sls_price IS NULL OR sls_price <= 0 
					THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price  -- 
			END AS sls_price
		FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';
        PRINT '>> -------------';

        -- Chargement de erp_cust_az12
        SET @start_time = GETDATE();
		PRINT '>>  Suppression des enregistrements de la table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;
		PRINT '>> Insertion des enregistrements dans la table: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (
			cid,
			bdate,
			gen
		)
		SELECT
			CASE
				WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) -- Rétirer le préfixe NAS si il est présent
				ELSE cid
			END AS cid, 
			CASE
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS bdate, -- Supprimer les dates incohérentes 
			CASE
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gen -- Normaliser les genres
		FROM bronze.erp_cust_az12;
	    SET @end_time = GETDATE();
        PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Chargement des tables ERP ';
		PRINT '------------------------------------------------';

        -- Chargement de erp_loc_a101
        SET @start_time = GETDATE();
		PRINT '>>  Suppression des enregistrements de la table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;
		PRINT '>> Insertion des enregistrements dans la table: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		)
		SELECT
			REPLACE(cid, '-', '') AS cid, 
			CASE
				WHEN TRIM(cntry) = 'DE' THEN 'Germany'
				WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
				ELSE TRIM(cntry)
			END AS cntry -- Normaliser et gérer les codes de pays manquants ou vides
		FROM bronze.erp_loc_a101;
	    SET @end_time = GETDATE();
        PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';
        PRINT '>> -------------';
		
		-- Chargement de erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>>  Suppression des enregistrements de la table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE silver.erp_px_cat_g1v2;
		PRINT '>> Insertion des enregistrements dans la table: silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2;
		SET @end_time = GETDATE();
		PRINT '>> Durée du chargement:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_time, @end_time)) + ' secondes';
        PRINT '>> -------------';

		SET @end_process = GETDATE();
		PRINT '=========================================='
		PRINT 'CHARGEMENT DE LA COUCHE DE D ARGRNT TERMINé';
      PRINT '>> Durée du chargement de la couche de bronze:'  + CONVERT(NVARCHAR(50), DATEDIFF(second, @start_process, @end_process)) + ' secondes';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'UNE ERREUR EST SURVENUE LORS DU CHARGEMENT DE LA COUCHE D ARGENT'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
GO
USE DataWarehouse;
GO

EXEC silver.load_silver;