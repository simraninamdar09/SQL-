--  Cricket anlysis

-- 1 Query to display all the matches and their outcomes in the data base
Select Match_ID, Start_Date, Country , Opposition, toss, bat, Result, margin, Ground 
from cricket.odi_match_results 
where Country < Opposition 
order by Country, Opposition;

-- 2 Query to display total matches, avg won, avr tied, avg no result, runs per match, wkts per match in Indian Stadiums
select sum(Mat),avg(won),avg(tied),avg(NR),avg(runs/mat),avg(wkts/mat) 
from cricket.ground_averages
where Ground like"%India%";

-- 3 Query to display a particular bowler, his country, his total_maiden spells, total wickets taken by him , his average economy, 
-- total overs bowled by him 
select wc_players.Player, wc_players.Country, SUM(bowler_data.Mdns) as Total_Maidens , 
sum(bowler_data.Wkts) as Total_Wickets, avg(bowler_data.Econ) as Average_Economy, 
sum(bowler_data.Overs) as Total_Overs 
from cricket.bowler_data 
right join cricket.wc_players 
on bowler_data.Player_ID = wc_players.ID 
where wc_players.ID = (SELECT DISTINCT id from wc_players where Player LIKE"%Jasprit%");

-- 4 Query to display top 10 bowlers with best economy with minimum 6 overs bowled in a match 
select bowler_data.Bowler, bowler_data.Econ 
from cricket.bowler_data 
where Econ IN (SELECT Econ from cricket.bowler_data where Overs > 6 and Econ NOT IN(SELECT 
Econ FROM cricket.bowler_data where Econ = '-'))ORDER by Econ LIMIT 10;

-- 5  Query to display top 10 batsman who have faced more than 30 balls in a match and have the highest SR 
select batsman_data.Batsman, batsman_data.SR 
from  cricket.batsman_data 
where SR IN (SELECT SR from batsman_data where BF > 30 and sr NOT IN(SELECT SR FROM 
batsman_data where BF = '-')) and SR > 100 ORDER by SR DESC LIMIT 10;

-- 6  Display the bowler name who had taken the most no of wickets in a single match against a opposition during world cup of 2019? 
select bowler_data.Bowler,max(bowler_data.wkts) AS 
Highest_Wickets,bowler_data.Opposition 
 from cricket.bowler_data,cricket.wc_players 
 where bowler_data.Player_ID=wc_players.ID 
 and bowler_data.Start_Date LIKE '%2019%';
 
-- 7 Write a query to list all the ODI matches won by Indian against Pakistan 
select * from cricket.odi_match_totals where Country="India" and (Result="won" and Opposition="v Pakistan");

-- 8 Write a query to count all the duplicate values from the column “Player_id” from the table batsman data 
select Player_ID, COUNT(Player_ID) from cricket.batsman_data group by Player_ID having COUNT(Player_ID) > 1;

