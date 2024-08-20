-- 1 Select the names of all the products in the store.
select name from computer_store.products;

-- 2 Select the names and the prices of all the products in the store.
select name,price from computer_store.products;

-- 3 Select the name of the products with a price less than or equal to $200.
select name, price from computer_store.products where Price <= 200;

-- 4 Select all the products with a price between $60 and $120.
select * from computer_store.products where price  between 60 and 120;

-- 5 Select the name and price in cents (i.e., the price must be multiplied by 100).
select name,price*100 from computer_store.products;

-- 6 Compute the average price of all the products.
select avg(price) from computer_store.products;

-- 7 Compute the average price of all products with manufacturer code equal to 2.
select avg(price) from computer_store.products where Manufacturer = 2;

-- 1.8 Compute the number of products with a price larger than or equal to $180.
select name,price  from computer_store.products where price >=180;

-- 9 Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order),
-- and then by name (in ascending order).
select name, price from computer_store.products where price>=180 order by price Desc; 
select name, price from computer_store.products where price>=180 order by name asc;
 
-- 10 Select all the data from the products, including all the data for each product's manufacturer.
select products.*, Manufacturers.Name from computer_store.products
join computer_store.manufacturers on products.Manufacturer = manufacturers.code;

-- 11 Select the product name, price, and manufacturer name of all the products.
select products.name,price, manufacturer from computer_store.products
join computer_store.manufacturers on products.Manufacturer = manufacturers.code;

-- 12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
select avg(price),manufacturer from computer_store.products 
group by Manufacturer;

-- 13 Select the average price of each manufacturer's products, showing manufacturerthe manufacturer's name.
select round(avg(price),2),manufacturers.name from computer_store.products
join computer_store.manufacturers on products.Manufacturer = manufacturers.code
group by manufacturers.name;

-- 14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
select avg(price),manufacturer from computer_store.products
group by Manufacturer 
having avg(price) >=150;

-- 15 Select the name and price of the cheapest product.
select min(price),name from computer_store.products
limit 1;

-- 16 Select the name of each manufacturer along with the name and price of its most expensive product.
select manufacturers.name,products.name, products.price
from computer_store.products 
join computer_store.manufacturers  on products.manufacturer = manufacturers.code
join
    (select manufacturer, MAX(price) as max_price
     from computer_store.products
     group by manufacturer) max_price_mapping 
     on products .manufacturer = max_price_mapping.manufacturer 
     and products.price = max_price_mapping.max_price
order by manufacturers.name;


-- 17 Add a new product: Loudspeakers, $70, manufacturer 2.
insert into computer_store.products values (11, 'Loudspeakers', 70, 2);
select * from computer_store.products;

-- 18 Update the name of product 8 to "Laser Printer".
update computer_store.products set  name = "Laser Printer" where code= 8;

-- 19 Apply a 10% discount to all products.
update computer_store.products set price=price*0.9;

-- 20 Apply a 10% discount to all products with a price larger than or equal to $120.
update computer_store.products set price=price*0.9
where price >=120;
 
 
