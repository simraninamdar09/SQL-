CREATE TABLE cleaned_data.cities (
    city_id INT NOT NULL AUTO_INCREMENT,
    city_name TEXT,
    latitude FLOAT,
    longitude FLOAT,
    country_code_2 VARCHAR(2) NOT NULL,
    capital BOOLEAN,
    population INT,
    insert_date DATE,
    PRIMARY KEY (city_id)
);

CREATE TEMPORARY TABLE cleaned_data.temp_clean_cities AS
SELECT
    TRIM(LOWER(REGEXP_REPLACE(city_name, '[^\\w\\s^.]', ''))) AS city_name,
    CAST(longitude AS DECIMAL(10,6)) AS longitude,  -- Adjust decimal precision as needed
    CAST(latitude AS DECIMAL(10,6)) AS latitude,    -- Adjust decimal precision as needed
    TRIM(LOWER(REGEXP_REPLACE(country_code_2, '[^\\w\\s^.]', ''))) AS country_code_2,
    CAST(capital AS CHAR) = 'true' AS capital,      -- Ensure conversion to BOOLEAN
    CAST(population AS UNSIGNED) AS population,     -- Ensure conversion to INT
    CAST(insert_date AS DATE) AS insert_date
FROM country_info.cities;


INSERT INTO cleaned_data.cities (
    city_name,
    latitude,
    longitude,
    country_code_2,
    capital,
    population,
    insert_date
)
SELECT
    city_name,
    latitude,
    longitude,
    country_code_2,
    capital,
    population,
    insert_date
FROM cleaned_data.temp_clean_cities;

DROP TEMPORARY TABLE IF EXISTS cleaned_data.temp_clean_cities;

SELECT * FROM cleaned_data.cities;

SELECT * FROM country_info.cities;



