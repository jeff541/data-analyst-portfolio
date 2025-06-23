# Ultimate - SQL SERVER POWER BI

## Source de données
- [China Sales](raw_data/sales_China.csv)
- [Canada Sales](raw_data/sales_Canada.csv)
- [India Sales](raw_data/sales_India.csv)
- [Nigeria Sales](raw_data/sales_Nigeria.csv)
- [UK Sales](raw_data/sales_UK.csv)
- [US Sales](raw_data/sales_UK.csv)

## Problématique métier
Une multinationale souhaite analyser ces performances de ventes dans le monde entier 

## Objectif
- Créer une base de données et injecter les données depuis les fichiers csv et les fusionner avec SQL SERVER
- nétoyer , transformer et enrichir les données avec SQL SERVER
- Analyser les données avec des requêtes appropriées 
- créer un dashboard intuitif avec POWER BI



### 1. Création des tables

```sql
    Use Ultimate;
    Go

    Create table SalesCanada(
    TransactionID Nvarchar(50) PRIMARY KEY,
    [Date] Nvarchar(10),
    Country Nvarchar(50),
    ProductID Nvarchar(50),
    ProductName Nvarchar(50),
    Category Nvarchar(50),
    PricePerUnit NUMERIC,
    QuantityPurchased INT,
    CostPrice NUMERIC,
    DiscountApplied NUMERIC,
    PaymentMethod Nvarchar(50),
    CustomerAgeGroup Nvarchar(50),
    CustomerGender Nvarchar(50),
    StoreLocation Nvarchar(50),
    SalesRepresentative Nvarchar(50));
```

Le même processus sera utiliser pour la création des autres tables  liées aux autres pays

 [Télécharger le  fichier de création de toutes les tables](script/create_database_and_tables.sql)


Afficher le total des ventes par région pourl’année 2014   

### 2. Insertion des données

```sql
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
```
Le même processus sera utiliser pour l'insertion dans les autres tables 

 [Télécharger le  fichier d'insertion de toutes les tables](script/insert_data.sql)

### 2. Fusion des tables

```sql
Use Ultimate;
Go

SELECT *
INTO dbo.SalesData
FROM (
    SELECT * FROM dbo.SalesCanada
    UNION ALL
    SELECT * FROM dbo.SalesChina
    UNION ALL
    SELECT * FROM dbo.SalesIndia
    UNION ALL
    SELECT * FROM dbo.SalesNigeria
    UNION ALL
    SELECT * FROM dbo.SalesUK
    UNION ALL
    SELECT * FROM dbo.SalesUS
) AS CombinedTables;
ALTER TABLE SalesData ALTER COLUMN [date] date;

```

### 4. Transformation des données

- Rechecherchons les valeurs nulles
```sql
USE Ultimate;
SELECT * 
FROM dbo.SalesData
WHERE
    Country is null
	or PricePerUnit is null
	or QuantityPurchased is null
	or CostPrice is null
	or DiscountApplied is null;
```
Nous avons 2 valeurs nulles une dans la colonne QuantityPurchased et l'autre dans PricePerUnit

- Remplissons le vide de QuantityPurchased
```sql
UPDATE dbo.SalesData
SET QuantityPurchased = 3
WHERE TransactionID = '00a30472-89a0-4688-9d33-67ea8ccf7aea';
```
Nous nous somme basés sur les valeurs du unit price costprice et DiscountApplied pour trouver cette valeur

- Remplissons le vide de PricePerUnit par la moyenne des prix
```sql
update dbo.SalesData
set PricePerUnit = (
    SELECT AVG(PricePerUnit)
	FROM dbo.SalesData
	WHERE PricePerUnit is not null
)
where TransactionID = '001898f7-b696-4356-91dc-8f2b73d09c63';
```
Nous avons comblé la valeur vide avec la moyenne des valeurs existantes

- Rechecherchons les doublons
```sql
SELECT TransactionID, Count(*)
FROM SalesData
group by TransactionID
having count(*)>1;
```



-  Ajoutons la colonne TotalAmount
```sql
ALTER TABLE dbo.SalesData
ADD TotalAmount Numeric(10,2);
```
- Remplissons la colonne TotalAmount
```sql
UPDATE dbo.SalesData
SET TotalAmount =(PricePerUnit * QuantityPurchased) - DiscountApplied;
```
- Ajoutons la colonne Profit

```sql
ALTER TABLE dbo.SalesData
ADD Profit Numeric(10,2);
```
- Remplissons la colonne Profit
```sql
UPDATE dbo.SalesData
SET Profit = TotalAmount - (CostPrice * QuantityPurchased);
```

### 5. Analyse

 [Télécharger le  fichier](script/Analysis.sql)

### 6. Visualisation

![dashboard](images/analysis.png)