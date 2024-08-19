CREATE TABLE cleaned_data.languages (
    language_id INT NOT NULL AUTO_INCREMENT,
    language TEXT,
    country_code_2 VARCHAR(2),
    PRIMARY KEY (language_id)
);

CREATE TEMPORARY TABLE cleaned_data.temp_cleaned_languages AS
SELECT
    null as language_id,
    TRIM(LOWER(REGEXP_REPLACE(language, '[^\\w\\s^.]', '.'))) AS language,
    TRIM(LOWER(REGEXP_REPLACE(country_code_2, '[^\\w\\s^.]', '.'))) AS country_code_2
FROM country_info.languages;

INSERT INTO cleaned_data.languages (
    language_id,
    language,
    country_code_2
)
SELECT
    language_id,
    language,
    country_code_2
FROM
    cleaned_data.temp_cleaned_languages;

DROP TEMPORARY TABLE IF EXISTS cleaned_data.temp_cleaned_languages;

SELECT 
    language_id,
    language,
    country_code_2
FROM 
    cleaned_data.languages;
