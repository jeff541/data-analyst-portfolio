# Data Cleaning - Layoffs Dataset (Kaggle)

## Source de données
[Kaggle: Layoffs 2022](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

## Objectif
L'objectif de ce projet est de nettoyer les données du dataset des licenciements pour garantir une meilleure qualité et fiabilité dans les analyses.

---

## Étapes de Nettoyage des Données

### 1. Suppression des Doublons

1. Création d'une table temporaire `layoffs_staging` pour éviter de modifier la table d'origine :
    ```sql
    CREATE TABLE layoffs_staging LIKE layoffs;
    INSERT layoffs_staging SELECT * FROM layoffs;
    ```

2. Identification des doublons en utilisant `row_number()` :
    ```sql
    WITH duplicate_cte AS (
        SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
        FROM layoffs_staging
    )
    SELECT * FROM duplicate_cte WHERE row_num > 1;
    ```

3. Création d'une table `layoffs_staging2` avec une colonne `row_num` pour faciliter la suppression des doublons :
    ```sql
    CREATE TABLE layoffs_staging2 (
        company TEXT,
        location TEXT,
        industry TEXT,
        total_laid_off INT DEFAULT NULL,
        percentage_laid_off TEXT,
        `date` TEXT,
        stage TEXT,
        country TEXT,
        funds_raised_millions INT DEFAULT NULL,
        row_num INT
    );
    ```

4. Insertion des données en attribuant un numéro de ligne pour les doublons :
    ```sql
    INSERT INTO layoffs_staging2
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM layoffs_staging;
    ```

5. Suppression des doublons :
    ```sql
    SET SQL_SAFE_UPDATES = 0;
    DELETE FROM layoffs_staging2 WHERE row_num > 1;
    SET SQL_SAFE_UPDATES = 1;
    ```

6. Vérification de la suppression des doublons :
    ```sql
    SELECT * FROM layoffs_staging2 WHERE row_num > 1;
    ```

---

### 2. Standardisation des Données

1. Identification des valeurs nulles ou vides dans la colonne `industry` :
    ```sql
    SELECT DISTINCT industry FROM layoffs_staging2 ORDER BY industry;
    ```
    ```sql
    SELECT * FROM layoffs_staging2 WHERE industry IS NULL OR industry = '' ORDER BY industry;
    ```

2. Remplacement des valeurs vides par `NULL` :
    ```sql
    UPDATE layoffs_staging2 SET industry = NULL WHERE industry = '';
    ```

3. Remplissage des valeurs `NULL` avec des valeurs existantes du même `company` :
    ```sql
    UPDATE layoffs_staging2 t1
    JOIN layoffs_staging2 t2
    ON t1.company = t2.company
    SET t1.industry = t2.industry
    WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
    ```

4. Uniformisation des noms d'industrie (`Crypto`, `Crypto Currency`, `CryptoCurrency`) :
    ```sql
    UPDATE layoffs_staging2
    SET industry = 'Crypto'
    WHERE industry IN ('Crypto Currency', 'CryptoCurrency');
    ```

5. Correction des valeurs de `country` (ex: `United States.` → `United States`) :
    ```sql
    UPDATE layoffs_staging2 SET country = TRIM(TRAILING '.' FROM country);
    ```

6. Conversion du format de la colonne `date` en type `DATE` :
    ```sql
    UPDATE layoffs_staging2 SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
    ALTER TABLE layoffs_staging2 MODIFY COLUMN `date` DATE;
    ```

---

### 3. Gestion des Valeurs Nulles

- Les colonnes `total_laid_off`, `percentage_laid_off`, et `funds_raised_millions` contiennent des valeurs nulles. Ces valeurs sont conservées car elles facilitent les calculs ultérieurs lors de l'analyse des données.

---

### 4. Suppression des Colonnes et Lignes Inutiles

1. Suppression des lignes où `total_laid_off` et `percentage_laid_off` sont `NULL` :
    ```sql
    DELETE FROM layoffs_staging2 WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
    ```

2. Suppression de la colonne `row_num` :
    ```sql
    ALTER TABLE layoffs_staging2 DROP COLUMN row_num;
    ```

---

## Résumé

✔ Suppression des doublons.
✔ Standardisation des données (`industry`, `country`, `date`).
✔ Remplacement des valeurs vides par `NULL` et remplissage intelligent.
✔ Conservation des valeurs `NULL` pertinentes.
✔ Suppression des données inutilisables.

Les données sont maintenant propres et prêtes pour une analyse approfondie ! 🚀

## Data Cleaning
[Télécharger le fichier](data_cleaning.sql)

