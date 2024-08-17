
## 1) Test the code by select the complete table
select * from car.car_dataset;

## 2) Count of cars
select count(Name) from car.car_dataset;

## 3) Cars available for each group
select make,count(*) from car.car_dataset
group by make;

## 4) Total number of cars across each variant
select make,Basic_V,Mid_V,Top_V,
sum(c.Basic_V + c.Mid_V + c.Top_V) as Total_Available
from 
(select
make,
sum(case when Varient='Basic' then 1 else 0 end) as Basic_V,
sum(case when Varient='Mid' then 1 else 0 end) as Mid_V,
sum(case when Varient='Top' then 1 else 0 end) as Top_V
from car.car_dataset  
group by make) c
group by make;

## 5) Makers vs the range of cars avaliable as per budget catgory Total number of cars across each variant
select *from car.car_dataset;
ALTER TABLE car.car_dataset
RENAME  column `Initial Price` TO `Initial_Price`;
select make,
sum(case when a.price_group='4-9' then 1 else 0 end) as four_to_nine,
sum(case when a.price_group='9-13' then 1 else 0 end) as nine_to_thirteen,
sum(case when a.price_group='13-18' then 1 else 0 end) as thirteen_to_eighteen,
sum(case when a.price_group='18-23' then 1 else 0 end) as eighteen_to_twentythree,
sum(case when a.price_group='23-28' then 1 else 0 end) as twentythree_to_twentyeight,
sum(case when a.price_group='28-33' then 1 else 0 end) as twentyeight_to_thirtythree,
sum(case when a.price_group='33-38' then 1 else 0 end) as thirtythree_to_thirtyeight,
sum(case when a.price_group='38-43' then 1 else 0 end) as thirtyeight_to_fourtythree
from
(select make,
case 
when initial_price >= 400000 and initial_price < 900000 then '4-9'
when initial_price >= 900000 and initial_price < 1300000 then '9-13'
when initial_price >= 1300000 and initial_price < 1800000 then '13-18'
when initial_price >= 1800000 and initial_price < 2300000 then '18-23'
when initial_price >= 2300000 and initial_price < 2800000 then '23-28'
when initial_price >= 2800000 and initial_price < 3300000 then '28-33'
when initial_price >= 3300000 and initial_price < 3800000 then '33-38'
when initial_price >= 3800000 and initial_price < 4300000 then '38-43'
else 'No Grp'
end as price_group
from car.car_dataset) as a
group by make;

## 6) Makers vs the range of cars avaliable as per budget catgory Total number of cars across each variant
select make,
sum(case when a.price_group='4-9' then 1 else 0 end) as four_to_nine,
sum(case when a.price_group='9-13' then 1 else 0 end) as nine_to_thirteen,
sum(case when a.price_group='13-18' then 1 else 0 end) as thirteen_to_eighteen,
sum(case when a.price_group='18-23' then 1 else 0 end) as eighteen_to_twentythree,
sum(case when a.price_group='23-28' then 1 else 0 end) as twentythree_to_twentyeight,
sum(case when a.price_group='28-33' then 1 else 0 end) as twentyeight_to_thirtythree,
sum(case when a.price_group='33-38' then 1 else 0 end) as thirtythree_to_thirtyeight,
sum(case when a.price_group='38-43' then 1 else 0 end) as thirtyeight_to_fourtythree
from
(select make,
case 
when initial_price >= 400000 and initial_price < 900000 then '4-9'
when initial_price >= 900000 and initial_price < 1300000 then '9-13'
when initial_price >= 1300000 and initial_price < 1800000 then '13-18'
when initial_price >= 1800000 and initial_price < 2300000 then '18-23'
when initial_price >= 2300000 and initial_price < 2800000 then '23-28'
when initial_price >= 2800000 and initial_price < 3300000 then '28-33'
when initial_price >= 3300000 and initial_price < 3800000 then '33-38'
when initial_price >= 3800000 and initial_price < 4300000 then '38-43'
else 'No Grp'
end as price_group
from car.car_dataset) as a
group by make;

## 7) mileage as per diseal and Petrol
ALTER TABLE car.car_dataset RENAME  column `engine type` TO `engine_type`;

with mileage as
(select make,avg(mileage),engine_type,Mileage
from car.car_dataset
group by make,engine_type)

select make,
max(a.Avg_petrol),
max(a.Avg_disel)
from 
(select make,
case when engine_type='Petrol' then Mileage else 0 end as Avg_petrol,
case when engine_type='Diesel' then Mileage else 0 end as Avg_disel
from mileage  ) as a
group by make;




