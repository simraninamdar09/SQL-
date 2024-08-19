-- 1.  List Regions and Country Count
select countries.region,count(*) as country_count
from cleaned_data.countries
group by region
order by country_count desc;

-- 2. List Sub-Regions and City Count
select countries.sub_region, count(*) as city_count
from cleaned_data.countries
JOIN cleaned_data.cities ON countries.country_code_2 = cities.country_code_2
group by sub_region
order by sub_region;

-- 3. Specific Sub-Region and String Functions
/* List all of the countries and the total number of cities in the Northern Europe sub-region.  
 List the country names in uppercase and order the list by the length of the country name and alphabetically in ascending order.*/
select countries.country_name,count(*) as city_count
from cleaned_data.countries
join cleaned_data.cities on countries.country_code_2 = cities.country_code_2
where countries.sub_region = 'Northern Europe'
group by country_name
order by city_count asc;

-- 4. List Specific Countries by Year
/* List all of the countries and the total number of cities in the Southern Europe sub-region that were inserted in 2021. 
 Capitalize the country names and orderalphabetically by the **LAST** letter of the country name and the number of cities.*/
select countries.country_name,count(*) as city_count
from cleaned_data.countries
join cleaned_data.cities on countries.country_code_2 = cities.country_code_2
where countries.sub_region = 'Southern Europe'
AND YEAR(cities.insert_date) = 2021
group by country_name
order by city_count asc;

-- 5. List Anti-Join
/* List all of the countries in the region of Asia that did **NOT** have a city with an inserted 
 date from June 2021 through Sept 2021*/
select distinct countries.country_name
from cleaned_data.countries
left join cleaned_data.cities on cities.country_code_2 = countries.country_code_2
and cities.insert_date BETWEEN '2021-06-01' AND '2021-10-01'
WHERE countries.region = 'asia'
AND cities.country_code_2 IS NULL;

-- 6. Reversable Names
/* List the country, city name, population and city name length for the city names that are in the Western Asia sub-region.  
Format the population with a thousands separator (1,000) and format the length of the city name in roman numerals. 
Order by the length of the city name in descending order and alphabetically in ascending order.
to_roman_numeral(LENGTH(cleaned_data.cities.city_name)) AS roman_numeral_length*/

/* Create roman number first*/

DELIMITER //
CREATE FUNCTION to_roman_numeral(num INT) RETURNS VARCHAR(20)
    DETERMINISTIC
    READS SQL DATA
BEGIN
    DECLARE result VARCHAR(20) DEFAULT '';
    DECLARE remainder INT;

    SET remainder = num;

    WHILE remainder >= 1000 DO
        SET result = CONCAT(result, 'M');
        SET remainder = remainder - 1000;
    END WHILE;

    WHILE remainder >= 900 DO
        SET result = CONCAT(result, 'CM');
        SET remainder = remainder - 900;
    END WHILE;

    WHILE remainder >= 500 DO
        SET result = CONCAT(result, 'D');
        SET remainder = remainder - 500;
    END WHILE;

    WHILE remainder >= 400 DO
        SET result = CONCAT(result, 'CD');
        SET remainder = remainder - 400;
    END WHILE;

    WHILE remainder >= 100 DO
        SET result = CONCAT(result, 'C');
        SET remainder = remainder - 100;
    END WHILE;

    WHILE remainder >= 90 DO
        SET result = CONCAT(result, 'XC');
        SET remainder = remainder - 90;
    END WHILE;

    WHILE remainder >= 50 DO
        SET result = CONCAT(result, 'L');
        SET remainder = remainder - 50;
    END WHILE;

    WHILE remainder >= 40 DO
        SET result = CONCAT(result, 'XL');
        SET remainder = remainder - 40;
    END WHILE;

    WHILE remainder >= 10 DO
        SET result = CONCAT(result, 'X');
        SET remainder = remainder - 10;
    END WHILE;

    WHILE remainder >= 9 DO
        SET result = CONCAT(result, 'IX');
        SET remainder = remainder - 9;
    END WHILE;

    WHILE remainder >= 5 DO
        SET result = CONCAT(result, 'V');
        SET remainder = remainder - 5;
    END WHILE;

    WHILE remainder >= 4 DO
        SET result = CONCAT(result, 'IV');
        SET remainder = remainder - 4;
    END WHILE;

    WHILE remainder >= 1 DO
        SET result = CONCAT(result, 'I');
        SET remainder = remainder - 1;
    END WHILE;

    RETURN result;
END //

DELIMITER ;
/* Here's the question solution Query*/
USE cleaned_data;
SELECT countries.country_name,cities.city_name,cities.population,
    to_roman_numeral(LENGTH(cities.city_name)) AS roman_numeral_length
FROM cleaned_data.countries
JOIN cleaned_data.cities ON countries.country_code_2 = cities.country_code_2
WHERE cities.city_name = REVERSE(cities.city_name)
    AND countries.sub_region = 'Western Asia'
ORDER BY cities.city_name;

-- 7. Search with Wildcard and Case
/* List all of the countries that end in 'stan'.  Make your query case-insensitive and list whether the total population of the
 cities listed is an odd or even number for cities inserted in 2022.
 Order by whether the population value is odd or even in ascending order and country name in alphabetical order.*/
use cleaned_data;
select countries.country_name,sum(cities.population)as Total_population,
case
		WHEN (sum(cities.population) % 2) = 0
			THEN 'Even'
		ELSE 
			'Odd'
	END AS odd_or_even
from cleaned_data.countries
join cleaned_data.cities on countries.country_code_2  = cities.country_code_2
where country_name like '%stan'
AND YEAR(cities.insert_date) = 2022
group by country_name
order by odd_or_even,country_name asc;

-- 8. Ranking Regions
/* List the third most populated city ranked by region WITHOUT using limit or offset. 
 List the region name, city name, population and order the results by region.*/
WITH city_rank_cte AS (
    SELECT cities.city_name,countries.region,cities.population AS third_largest_pop,
        DENSE_RANK() OVER (PARTITION BY countries.region ORDER BY cities.population DESC) AS rnk
    FROM cleaned_data.countries
    JOIN cleaned_data.cities ON countries.country_code_2 = cities.country_code_2
    WHERE cities.population IS NOT NULL
)
SELECT region,city_name, third_largest_pop
FROM city_rank_cte
WHERE rnk = 3;


-- 9. Using Buckets
/* list the bottom third of all countries in the Western Asia sub-region that speak Arabic. 
Include the row number and country name.  Order by row number.*/
/*method 1*/
    SELECT ROW_NUMBER() OVER (ORDER BY countries.country_name) AS row_no,countries.country_name
    from cleaned_data.countries
    join cleaned_data.languages on countries.country_code_2 = languages.country_code_2
    where countries.sub_region = 'Western Asia'
    and	languages.language = 'arabic'
    group by country_name
    order by row_no desc
    limit 3;
/*method 2*/
WITH get_ntile_cte AS (
	SELECT ROW_NUMBER() OVER (ORDER BY countries.country_name) AS rn,countries.country_name,
		-- ntile() window functions returns groups of data section into 'buckets'.
	NTILE(3) OVER (ORDER BY countries.country_name) AS nt
	FROM cleaned_data.countries 
	JOIN cleaned_data.languages ON countries.country_code_2 = languages.country_code_2
	WHERE countries.sub_region = 'western asia'
	AND languages.language = 'arabic'
)
SELECT rn AS row_id,country_name
FROM get_ntile_cte
WHERE nt = 3;

-- 10. Using Arrays
/*Create a query that lists country name, capital name, population, languages spoken and currency name 
 for countries in the Northen Africa sub-region.  There can be multiple currency names and languages spoken per country. 
Add multiple values for the same field into an array.*/
SELECT c1.country_name,c2.population,c2.capital,c3.currency_name,
    CONCAT('{', GROUP_CONCAT(DISTINCT l.language ORDER BY l.language SEPARATOR ', '), '}') AS languages
FROM cleaned_data.countries AS c1
JOIN cleaned_data.cities AS c2 ON c1.country_code_2 = c2.country_code_2
JOIN cleaned_data.languages AS l ON c2.country_code_2 = l.country_code_2
JOIN cleaned_data.currencies AS c3 ON l.country_code_2 = c3.country_code_2
WHERE c1.sub_region = 'Northern Africa'
AND c2.capital = TRUE
GROUP BY c1.country_name, c2.population, c2.capital, c3.currency_name;

