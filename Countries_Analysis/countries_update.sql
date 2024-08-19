-- cleaned countries table

CREATE TABLE cleaned_data.countries (
	-- The country_id was automatically incremented and can be entered as an integer.
	country_id INT NOT NULL,
	-- Different from other database systems, in PostgreSQL, there is no performance difference among the three character types (char, varchar and text).  
	-- Use text to ensure that there are no errors due to string length.
	country_name TEXT NOT NULL,
	-- The data appears to have duplicate entries so we will remove them once the data has been cleaned of
	-- any unwanted characters.
	country_code_2 varchar(2) NOT NULL,
	country_code_3 varchar(3) NOT NULL,
	region TEXT,
	sub_region TEXT,
	intermediate_region TEXT,
	created_on date,
	PRIMARY KEY (country_id)
);

SET @rownum := (SELECT COALESCE(MAX(country_id), 0) FROM cleaned_data.countries);

CREATE TEMPORARY TABLE cleaned_data.temp_cleaned_data AS
SELECT
    TRIM(LOWER(REGEXP_REPLACE(country_name, '[^\\w\\s.]', ''))) AS country_name,
    TRIM(LOWER(REGEXP_REPLACE(country_code_2, '[^\\w\\s.]', ''))) AS country_code_2,
    TRIM(LOWER(REGEXP_REPLACE(country_code_3, '[^\\w\\s.]', ''))) AS country_code_3,
    TRIM(LOWER(REGEXP_REPLACE(region, '[^\\w\\s.]', ''))) AS region,
    TRIM(LOWER(REGEXP_REPLACE(sub_region, '[^\\w\\s.]', ''))) AS sub_region,
    TRIM(LOWER(REGEXP_REPLACE(intermediate_region, '[^\\w\\s.]', ''))) AS intermediate_region
FROM country_info.countries;


INSERT INTO cleaned_data.countries (
    country_id,
    country_name,
    country_code_2,
    country_code_3,
    region,
    sub_region,
    intermediate_region,
    created_on
)
SELECT
    @rownum := @rownum + 1 AS country_id,
    country_name,
    country_code_2,
    country_code_3,
    region,
    sub_region,
    intermediate_region,
    CURRENT_DATE AS created_on
FROM
    cleaned_data.temp_cleaned_data;
    
    DROP TEMPORARY TABLE IF EXISTS cleaned_data.temp_cleaned_data;

SELECT 
    *
FROM 
    cleaned_data.countries;

    
