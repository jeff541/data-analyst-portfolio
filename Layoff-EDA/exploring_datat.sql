-- Exploratory Data Analysis

-- Here we are going to explore the data and find trends or patterns or anything interesting.

select * 
FROM layoffs_staging2;

-- We are looking for the maximum total of layoffs and the maximum percentage of layoffs reached.
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Companies that have laid off all their employees.
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- All layoffs carried out by each company.
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Layoff date range.
SELECT MIN(`date`), MIN(`date`)
FROM layoffs_staging2;

-- All layoffs carried out by each industry.
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
;

-- All layoffs carried out by each country.
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;

-- All layoffs carried out each year.
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- By location.
SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC ;

-- By stage.
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

--  Total of Layoffs for each Month.
SELECT SUBSTRING(`date` ,1,7) as `MONTH`, SUM(total_laid_off)
FROM  layoffs_staging2
WHERE SUBSTRING(`date` ,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ;

-- Now use it in a CTE so we can query off of it.
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
-- Rolling Total of Layoffs Per Month.
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE;

-- For each year, we want to select the 3 companies that have the most layoffs.

-- This CTE selects the companies and their total layoffs per year.
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
-- This CTE classifies the result of the previous CTE by year and gives the rank of each.
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)

-- Here, we select the top three companies with the most layoffs each year. The results are ranked by year in ascending order and by the total number of layoffs in descending order.
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;