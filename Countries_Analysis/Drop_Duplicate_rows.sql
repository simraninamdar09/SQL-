SELECT country_code_2,count(*)
FROM cleaned_data.countries
GROUP BY country_code_2
HAVING count(*) > 1;

-- Delete duplicate entries
USE cleaned_data;
DELETE c1
FROM cleaned_data.countries c1
JOIN cleaned_data.countries c2
ON c1.country_code_2 = c2.country_code_2
AND c1.country_id > c2.country_id;

SELECT country_code_2,count(*)
FROM cleaned_data.countries
GROUP BY country_code_2
HAVING count(*) > 1;

----------------------------------------------------------------------------
SELECT 
	country_name,
	country_code_2
FROM 
	cleaned_data.countries 
LIMIT 5;

