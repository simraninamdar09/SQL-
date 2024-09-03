-- 1 Who receieved a 1.5kg package?
select client.name
from client join plant.package on client.AccountNumber = package.Recipient
where package.Weight=1.5;

-- 2 What is the total weight of all the packages that he sent?
select sum(package.Weight) 
from plant.client join plant.package on package.sender = client.AccountNumber
where client.name ="Al Gore's Head";

