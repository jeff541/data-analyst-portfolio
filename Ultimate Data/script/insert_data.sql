Use Ultimate;
Go

	BULK INSERT dbo.SalesCanada

	FROM 'C:\Users\jeff\Documents\data-analyst-portfolio\Ultimate Data\raw_data\sales_Canada.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);
	UPDATE SalesCanada
	SET [date] = CONVERT(DATE, [date], 101);

	BULK INSERT dbo.SalesChina

	FROM 'C:\Users\jeff\Documents\data-analyst-portfolio\Ultimate Data\raw_data\sales_China.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);
	UPDATE SalesChina
	SET [date] = CONVERT(DATE, [date], 101);

	BULK INSERT dbo.SalesIndia

	FROM 'C:\Users\jeff\Documents\data-analyst-portfolio\Ultimate Data\raw_data\sales_India.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);
	UPDATE SalesIndia
	SET [date] = CONVERT(DATE, [date], 101);

	BULK INSERT dbo.SalesNigeria

	FROM 'C:\Users\jeff\Documents\data-analyst-portfolio\Ultimate Data\raw_data\sales_Nigeria.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);
	UPDATE SalesNigeria
	SET [date] = CONVERT(DATE, [date], 101);

	BULK INSERT dbo.SalesUK

	FROM 'C:\Users\jeff\Documents\data-analyst-portfolio\Ultimate Data\raw_data\sales_UK.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);
	UPDATE SalesUK
	SET [date] = CONVERT(DATE, [date], 101);

	BULK INSERT dbo.SalesUS

	FROM 'C:\Users\jeff\Documents\data-analyst-portfolio\Ultimate Data\raw_data\sales_US.csv' -- Chemin vers le fichier
	WITH (
		FIRSTROW = 2, 
		FIELDTERMINATOR =',',
		TABLOCK
		);
	UPDATE SalesUS
	SET [date] = CONVERT(DATE, [date], 101);