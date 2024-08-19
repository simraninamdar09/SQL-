CREATE TABLE cleaned_data.currencies (
    currency_id INT NOT NULL AUTO_INCREMENT,
    country_code_2 VARCHAR(2),
    currency_name TEXT,
    currency_code TEXT,
    PRIMARY KEY (currency_id)
);

CREATE TEMPORARY TABLE  cleaned_data.temp_clean_currencies AS
SELECT
    NULL AS currency_id,  -- Placeholder for AUTO_INCREMENT
    TRIM(LOWER(SUBSTRING(REPLACE(REPLACE(country_code_2, ',', ''), '.', ''), 1, 2))) AS country_code_2,
    TRIM(LOWER(REPLACE(REPLACE(currency_name, ',', ''), '.', ''))) AS currency_name,
    TRIM(LOWER(REPLACE(REPLACE(currency_code, ',', ''), '.', ''))) AS currency_code
FROM country_info.currencies;

INSERT INTO cleaned_data.currencies (
    country_code_2,
    currency_name,
    currency_code
)
SELECT
    country_code_2,
    currency_name,
    currency_code
FROM cleaned_data.temp_clean_currencies;


DROP TEMPORARY TABLE IF EXISTS cleaned_data.temp_clean_currencies ;



select * from cleaned_data.currencies;