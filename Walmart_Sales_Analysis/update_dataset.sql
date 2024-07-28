-- Data cleaning
SELECT
	*
FROM walmartsales.sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM walmartsales.sales;


ALTER TABLE walmartsales.sales ADD COLUMN time_of_day VARCHAR(20);

-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Edito > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server
UPDATE walmartsales.sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM walmartsales.sales;

ALTER TABLE walmartsales.sales ADD COLUMN day_name VARCHAR(10);

UPDATE walmartsales.sales
SET day_name = DAYNAME(Date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM walmartsales.sales;

ALTER TABLE walmartsales.sales ADD COLUMN month_name VARCHAR(10);

UPDATE walmartsales.sales
SET month_name = MONTHNAME(date);


select * from walmartsales.sales;


ALTER TABLE walmartsales.sales
RENAME  column `Invoice ID` TO `Invoice_ID`;

ALTER TABLE walmartsales.sales
RENAME  column `Customer type` TO `Customer_type`;

ALTER TABLE walmartsales.sales
RENAME  column `Unit price` TO `Unit_price`;

ALTER TABLE walmartsales.sales
RENAME  column `Product line` TO `Product_line`;

ALTER TABLE walmartsales.sales
RENAME  column `Tax_5%` TO `Tax`;

ALTER TABLE walmartsales.sales
RENAME  column `gross margin percentage` TO `gross_margin_percentage`;

ALTER TABLE walmartsales.sales
RENAME  column `gross_income` TO `gross_income`;

