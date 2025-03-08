# Analyse exploratoire des licenciements (EDA - Layoffs)

Ce projet vise à explorer un ensemble de données sur les licenciements afin d'identifier des tendances, des modèles et des informations pertinentes.

## Description du projet

L'analyse repose sur un ensemble de requêtes SQL appliquées à la table `layoffs_staging2`, qui contient les données sur les licenciements d'entreprises de divers secteurs et pays.

## Requêtes SQL et leurs objectifs

### 1. Exploration initiale des données
```sql
SELECT * FROM layoffs_staging2;
```
Affiche l'ensemble des données pour comprendre la structure et le contenu de la table.

### 2. Valeurs maximales de licenciements
```sql
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_staging2;
```
Identifie le plus grand nombre total de licenciements ainsi que le pourcentage le plus élevé de licenciements pour une entreprise.

### 3. Entreprises ayant licencié 100% de leurs employés
```sql
SELECT * FROM layoffs_staging2 WHERE percentage_laid_off = 1 ORDER BY funds_raised_millions DESC;
```
Liste les entreprises qui ont licencié l'ensemble de leurs employés, classées par fonds levés.

### 4. Total des licenciements par entreprise
```sql
SELECT company, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 GROUP BY company ORDER BY total_layoffs DESC;
```
Résume le total des licenciements pour chaque entreprise.

### 5. Période des licenciements
```sql
SELECT MIN(`date`), MAX(`date`) FROM layoffs_staging2;
```
Détermine la plage temporelle des licenciements enregistrés dans la base de données.

### 6. Total des licenciements par secteur d'activité
```sql
SELECT industry, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 GROUP BY industry ORDER BY total_layoffs DESC;
```
Identifie les secteurs les plus touchés par les licenciements.

### 7. Total des licenciements par pays
```sql
SELECT country, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 GROUP BY country ORDER BY total_layoffs DESC;
```
Analyse la répartition des licenciements par pays.

### 8. Total des licenciements par année
```sql
SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 GROUP BY year ORDER BY year DESC;
```
Montre l'évolution des licenciements par année.

### 9. Total des licenciements par localisation
```sql
SELECT location, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 GROUP BY location ORDER BY total_layoffs DESC;
```
Affiche la répartition des licenciements selon la localisation des entreprises.

### 10. Total des licenciements par stade de développement de l'entreprise
```sql
SELECT stage, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 GROUP BY stage ORDER BY total_layoffs DESC;
```
Analyse les licenciements selon le stade de développement des entreprises (startup, entreprise établie, etc.).

### 11. Total des licenciements par mois
```sql
SELECT DATE_FORMAT(`date`, '%Y-%m') AS `month`, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 WHERE `date` IS NOT NULL GROUP BY `month` ORDER BY `month`;
```
Analyse mensuelle des licenciements pour détecter des tendances saisonnières.

### 12. Total cumulé des licenciements par mois (rolling total)
```sql
WITH DATE_CTE AS (
    SELECT DATE_FORMAT(`date`, '%Y-%m') AS dates, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 GROUP BY dates ORDER BY dates ASC
)
SELECT dates, SUM(total_layoffs) OVER (ORDER BY dates ASC) AS rolling_total_layoffs FROM DATE_CTE;
```
Calcule le total cumulé des licenciements mois par mois.

### 13. Top 3 des entreprises avec le plus de licenciements par année
```sql
WITH Company_Year AS (
    SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_layoffs FROM layoffs_staging2 GROUP BY company, years
),
Company_Year_Rank AS (
    SELECT company, years, total_layoffs, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_layoffs DESC) AS ranking FROM Company_Year
)
SELECT company, years, total_layoffs, ranking FROM Company_Year_Rank WHERE ranking <= 3 AND years IS NOT NULL ORDER BY years ASC, total_layoffs DESC;
```
Détermine les trois entreprises ayant licencié le plus d'employés chaque année.

## Technologies utilisées
 SQL (MySQL, PostgreSQL ou autre SGBD compatible)


