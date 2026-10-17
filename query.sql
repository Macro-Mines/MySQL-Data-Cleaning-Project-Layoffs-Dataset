USE layoff_db;
--
SELECT 
    COUNT(*)
FROM
    layoffs;
    
--
SELECT * FROM layoffs LIMIT 20;

-- Created a raw dataset
CREATE TABLE raw_layoffs LIKE layoffs;
INSERT raw_layoffs SELECT * FROM layoffs;
SELECT * FROM raw_layoffs LIMIT 10;

-- check for duplicate rows

SELECT *,
       COUNT(*) AS duplicate_count
FROM raw_layoffs
GROUP BY
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions
HAVING COUNT(*) > 1;

--
SELECT 
    *
FROM
    raw_layoffs;
    
--


--
select * from layoff_db.raw_layoffs
where company = 'Yahoo';

--
ALTER TABLE raw_layoffs
ADD COLUMN row_id INT AUTO_INCREMENT PRIMARY KEY;

-- Identify duplicate rows
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY
                   company,
                   location,
                   industry,
                   total_laid_off,
                   percentage_laid_off,
                   `date`,
                   stage,
                   country,
                   funds_raised_millions
               ORDER BY row_id
           ) AS row_num
    FROM raw_layoffs
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- Delete the duplicate rows
WITH duplicate_cte AS (
    SELECT row_id,
           ROW_NUMBER() OVER (
               PARTITION BY
                   company,
                   location,
                   industry,
                   total_laid_off,
                   percentage_laid_off,
                   `date`,
                   stage,
                   country,
                   funds_raised_millions
               ORDER BY row_id
           ) AS row_num
    FROM raw_layoffs
)
DELETE FROM raw_layoffs
WHERE row_id IN (
    SELECT row_id
    FROM duplicate_cte
    WHERE row_num > 1
);


-- 
SELECT COUNT(*)
FROM raw_layoffs;

SELECT 
    *
FROM
    raw_layoffs
LIMIT 100;

-- find space before name
SELECT 
    company
FROM
    raw_layoffs
WHERE
    company LIKE ' %';

--
UPDATE raw_layoffs
SET company = trim(company);

--
SELECT DISTINCT
    industry
FROM
    raw_layoffs
ORDER BY 1;

--
SELECT 
    *
FROM
    raw_layoffs
WHERE
    industry LIKE 'Crypto%';

--
UPDATE raw_layoffs 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE 'Crypto%';

--
SELECT DISTINCT
    country
FROM
    raw_layoffs
ORDER BY 1;

--
SELECT 
    country
FROM
    raw_layoffs
WHERE
    country LIKE '% ';
    
--
UPDATE raw_layoffs 
SET 
    country = TRIM(TRAILING '.' FROM country)
WHERE
    country LIKE 'United Nations%';
    
-- 
SELECT DISTINCT
    country
FROM
    raw_layoffs;
    
-- change DATE column
SELECT 
    `date`, STR_TO_DATE(`date`, '%m/%d/%Y') AS `changed_date`
FROM
    raw_layoffs
LIMIT 10;
    
UPDATE raw_layoffs 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
    
--
DESCRIBE raw_layoffs;

ALTER TABLE raw_layoffs
MODIFY COLUMN `date` DATE;

SELECT 
    *
FROM
    raw_layoffs
LIMIT 5;

-- NULL

SELECT 
    *
FROM
    raw_layoffs
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;
    

SELECT 
    company, industry
FROM
    raw_layoffs
WHERE
    industry IS NULL OR industry = '';


-- finding industry
SELECT 
    company, industry
FROM
    raw_layoffs
WHERE
    company IN ('Airbnb' , 'Bally\'s Interactive',
        'Juul',
        'Carvana');
    

-- Airbnb
UPDATE raw_layoffs 
SET 
    industry = 'Travel'
WHERE
    company = 'Airbnb'
        AND (industry IS NULL OR industry = '');

-- Juul
UPDATE raw_layoffs 
SET 
    industry = 'Consumer'
WHERE
    company = 'Juul'
        AND (industry IS NULL OR industry = '');

-- Carvana
UPDATE raw_layoffs 
SET 
    industry = 'Transportation'
WHERE
    company = 'Carvana'
        AND (industry IS NULL OR industry = '');

--

SELECT 
    *
FROM
    raw_layoffs
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;
        
--

ALTER TABLE raw_layoffs
drop column row_id;

-- clean table
CREATE TABLE clean_layoffs LIKE raw_layoffs;


INSERT INTO clean_layoffs
select *
from raw_layoffs
where total_laid_off IS NOT NULL 
and percentage_laid_off is not null;

SELECT count(*) FROM clean_layoffs;
