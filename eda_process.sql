-- Overall Layoff Landscape
SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT company) AS unique_companies,
    COUNT(DISTINCT industry) AS unique_industries,
    COUNT(DISTINCT country) AS unique_countries,
    MIN(`date`) AS earliest_layoff_date,
    MAX(`date`) AS latest_layoff_date,
    SUM(total_laid_off) AS total_employees_laid_off,
    ROUND(AVG(total_laid_off), 2) AS average_layoffs_per_record,
    MAX(total_laid_off) AS largest_reported_layoff
FROM
    clean_layoffs;
    
-- Identify the Year with the Highest Total Layoffs
SELECT 
    YEAR(`date`) AS layoff_year,
    SUM(total_laid_off) AS total_employee_laid_off
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY total_employee_laid_off DESC;

-- Which 10 Companies Had the Highest Cumulative Layoffs?
SELECT 
    company, SUM(total_laid_off) AS total_employee_laid_off
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
GROUP BY company
ORDER BY total_employee_laid_off DESC
LIMIT 10;

-- Which Industries Recorded the Highest Total Layoffs
SELECT 
    industry, SUM(total_laid_off) AS total_employee_laid_off
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY total_employee_laid_off DESC
LIMIT 10;

-- Which countries recorded the highest total number of layoffs
SELECT 
    country, SUM(total_laid_off) AS total_layoffs
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total_layoffs DESC
LIMIT 10;

-- Which company stages recorded the highest total number of layoffs
SELECT 
    stage, SUM(total_laid_off) AS total_layoffs
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
GROUP BY stage
ORDER BY total_layoffs DESC
LIMIT 10;

--
SELECT
    company,
    industry,
    country,
    total_laid_off,
    percentage_laid_off
FROM clean_layoffs
WHERE percentage_laid_off IS NOT NULL
ORDER BY percentage_laid_off DESC
LIMIT 5;

--
SELECT
    industry,
    ROUND(AVG(percentage_laid_off) * 100, 2) AS avg_layoff_percentage,
    COUNT(*) AS total_records
FROM clean_layoffs
WHERE percentage_laid_off IS NOT NULL
  AND industry IS NOT NULL
GROUP BY industry
ORDER BY avg_layoff_percentage DESC LIMIT 5;

-- Which companies raised the most funding but also reported large layoffs
SELECT 
    company,
    SUM(total_laid_off) AS total_employee_laid,
    SUM(funds_raised_millions) AS total_fund_raised
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
        OR funds_raised_millions IS NOT NULL
GROUP BY company
ORDER BY total_fund_raised DESC LIMIT 5;


--
SELECT 
    company,
    COUNT(DISTINCT `date`) AS layoff_dates,
    SUM(total_laid_off) AS total_employees_laid_off,
    MIN(`date`) AS first_layoff_date,
    MAX(`date`) AS latest_layoff_date
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
        AND `date` IS NOT NULL
GROUP BY company
HAVING COUNT(DISTINCT `date`) > 1
ORDER BY layoff_dates DESC , total_employees_laid_off DESC
LIMIT 10;

--
SELECT
    MONTHNAME(`date`) AS layoff_month,
    MONTH(`date`) AS month_number,
    SUM(total_laid_off) AS total_employees_laid_off,
    COUNT(*) AS layoff_records
FROM clean_layoffs
WHERE total_laid_off IS NOT NULL
  AND `date` IS NOT NULL
GROUP BY
    MONTH(`date`),
    MONTHNAME(`date`)
ORDER BY total_employees_laid_off DESC
LIMIT 5;


--
SELECT 
    company,
    industry,
    country,
    `date` AS layoff_date,
    total_laid_off,
    percentage_laid_off,
    stage
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
ORDER BY total_laid_off DESC
LIMIT 10;

-- Which industries experienced the highest number of layoffs?
SELECT 
    industry, SUM(total_laid_off) AS total_employee_laid_off
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY total_employee_laid_off DESC
LIMIT 5;

-- Which companies laid off the most employees in each country?
SELECT 
    company,
    country,
    SUM(total_laid_off) AS total_employee_laid_off
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
GROUP BY company , country
ORDER BY total_employee_laid_off DESC limit 20;

-- Which Years Experienced the Highest Layoffs?
SELECT 
    YEAR(`date`) AS `year`,
    SUM(total_laid_off) AS total_employee_laid_off,
    COUNT(*) AS total_records
FROM
    clean_layoffs
WHERE
    total_laid_off IS NOT NULL
        AND `date` IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY total_employee_laid_off DESC;




