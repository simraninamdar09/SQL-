-- 1 Select all warehouses,boxes.
select * from warehouse.warehouses;
select * from warehouse.boxes;

-- 2 Select all boxes with a value larger than $150.
select * from warehouse.boxes where value > 150;

-- 3 Select all distinct contents in all the boxes.
select distinct contents from warehouse.boxes;

-- 4 Select the average value of all the boxes.
select round(avg(value),2) as value from warehouse.boxes;

-- 5 Select the warehouse code and the average value of the boxes in each warehouse.
select W_H,round(avg(value),2)as value from warehouse.boxes
group by W_H;

-- 6 Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150.
select W_H,round(avg(value),2) as value from warehouse.boxes
group by W_H
having value > 150;

-- 7 Select the code of each box, along with the name of the city the box is located in.
select boxes.code,warehouses.Location from warehouse.warehouses
join warehouse.boxes on warehouses.code = boxes.W_H;

-- 8 Select the warehouse codes, along with the number of boxes in each warehouse. 
    -- Optionally, take into account that some warehouses are empty (i.e., the box count should show up as zero, 
    -- instead of omitting the warehouse from the result).
    select W_H ,count(*) from warehouse.boxes
    group by W_H;
    
-- 9 Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in 
-- it is larger than the warehouse's capacity).
select code from warehouse.warehouses
where capacity <
(select COUNT(*)FROM warehouse.Boxes WHERE W_H = Warehouses.Code);

-- 10 Select the codes of all the boxes located in Chicago.
select boxes.code from  warehouse.warehouses
join warehouse.boxes on warehouses.code = boxes.W_H
where warehouses.location = 'Chicago';


-- 11 Create a new warehouse in New York with a capacity for 3 boxes.
INSERT INTO warehouse.warehouses(Code,Location,Capacity) VALUES(6,'New York',3);

-- 12 Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2.
INSERT INTO warehouse.boxes(Code,Contents,Value,W_H) VALUES('H5RT','Papers',200,2);

-- 13 Reduce the value of all boxes by 15%.
update warehouse.boxes set value = value * 0.85;

-- 14 Remove all boxes with a value lower than $100.
delete from warehouse.boxes where value < 100;

-- 15 Remove all boxes from saturated warehouses.
with SaturatedWarehouses as (
select W_H from warehouse.boxes 
group by W_H 
having count(*) >=
 (select capacity from warehouse.warehouses where code = W_H))
delete from warehouse.boxes 
where W_H in (select W_H from SaturatedWarehouses);

-- 16 Add Index for column "Warehouse" in table "boxes"
create index index_warehouse on warehouse.boxes(W_H);

-- 17 Print all the existing indexes
show index from warehouse.boxes;




