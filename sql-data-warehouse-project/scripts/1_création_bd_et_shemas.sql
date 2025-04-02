/**Créer la base de données et les schémas
========================================================= 
Objectif du script : Ce script crée une nouvelle base de données nommée "DataWarehouse" après avoir vérifié si elle existe déjà.
Si la base de données existe, elle est supprimée et recréée. De plus, le script configure trois schémas dans la base de données : "bronze", "silver" et "gold".

⚠ AVERTISSEMENT : L'exécution de ce script entraînera la suppression complète de la base de données "DataWarehouse" si elle existe.
Toutes les données présentes seront définitivement effacées. Soyez prudent et assurez-vous d'avoir des sauvegardes appropriées avant de l'exécuter.
**/
USE master;
GO

--supprime la base de données si elle existe déjà

IF EXISTS (SELECT 1 FROM sys.databases WHERE name ='DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;

GO
-- Création de la BD "DataWarehouse"

CREATE DATABASE DataWarehouse;

GO

Use DataWarehouse;
GO

-- Création des schemas
CREATE SCHEMA bronze;

GO

CREATE SCHEMA silver;

GO

CREATE SCHEMA gold;
