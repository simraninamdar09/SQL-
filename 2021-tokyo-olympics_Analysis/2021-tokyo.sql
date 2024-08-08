-- 2021_tokyo_olympics --

-- Query 1: - Avg count of participants across all disciplines --
Select discipline,total
from 2021tokyo.entriesgender
group by discipline
order by total desc;

--  Query 2: - Most Medals won by each country, top 3 ranks--
select * from 2021tokyo.medals 
order by total desc
limit 3;

--  Query 3: - Most Bronze,silver and gold -- 
ALTER TABLE 2021tokyo.medals
RENAME  column `team` TO `NOC`;

select 'Gold :- ' as Medal_Type, Most_Gold_win_country, Medals 
from (select NOC as Most_Gold_win_country, MAX(gold) as Medals 
    from 2021tokyo.medals 
    group by NOC 
    order by Medals DESC 
    limit 1
) as Gold_Medal
union all

select 'Silver :- ' as Medal_Type, Most_Silver_win_country, Medals 
from (select NOC as Most_Silver_win_country, MAX(silver) as Medals 
    from 2021tokyo.medals 
    group by NOC 
    order by Medals desc
    limit 1
) as Silver_Medal
union all
select 'Bronze :- ' as Medal_Type, Most_Bronze_win_country, Medals 
from (select NOC as Most_Bronze_win_country,MAX(bronze) as Medals 
    from 2021tokyo.medals 
    group by NOC 
    order by Medals desc 
    limit 1
) as Bronze_Medal;


 
--  Query 4: - Particpants at across countries --
select NOC,count(Name) as c from 2021tokyo.athletes 
group by NOC
order by c desc ;

--  Query 5: - Numbers Table, count of various events --
select 'Count of Events :- ' as Label, COUNT(distinct discipline) as Number 
from 2021tokyo.athletes
union all
select 'Count of Countries :- ' as Label, COUNT(distinct noc) as Number 
from 2021tokyo.athletes
union all
select 'Total Female Athletes :- ' as Label, SUM(female) as Number 
from 2021tokyo.entriesGender
union all
select 'Total Male Athletes :- ' as Label, SUM(male) as Number 
from 2021tokyo.entriesGender
union all
select 'Total Athletes :- ' as Label, SUM(total) as Number 
from 2021tokyo.entriesGender
union all
select 'Total Gold :- ' as Label, SUM(gold) as Number 
from 2021tokyo.medals
union all
select 'Total Silver :- ' as Label, SUM(silver) as Number 
from 2021tokyo.medals
union all
select 'Total Bronze :- ' as Label, SUM(bronze) as Number 
from 2021tokyo.medals
union all
select 'Total Medals :- ' as Label, SUM(total) as Number 
from 2021tokyo.medals;


-- Query 6: - Coaches produced by the countries --
select NOC, count(name) as C
from 2021tokyo.coaches
group by NOC
order by c desc;

-- Query 7: - Coaches vs Player Ratio--
SELECT athletes.NOC,COUNT(DISTINCT athletes.name) AS Count_of_players,COUNT(DISTINCT coaches.name) AS Count_of_coaches,
round(count( DISTINCT athletes.name)/count(DISTINCT coaches.name),1) as player_coach_Ratio
FROM 2021tokyo.athletes 
JOIN 2021tokyo.coaches ON athletes.NOC = coaches.NOC
GROUP BY athletes.NOC
order by Count_of_players desc;

-- Query 8: - Country wise Performance Table --
SELECT a.Count_of_players,a.Count_of_coaches,a.NOC,m.total AS Total_medals
FROM 
(SELECT COUNT(DISTINCT athletes.name) AS Count_of_players,COUNT(DISTINCT coaches.name) AS Count_of_coaches,athletes.NOC
FROM 2021tokyo.athletes 
JOIN 2021tokyo.coaches ON athletes.NOC = coaches.NOC
GROUP BY athletes.NOC
ORDER BY Count_of_players DESC) AS a
JOIN 2021tokyo.medals m ON a.NOC = m.NOC;


-- Query 9: - Sports with Highes female participation --
select entriesgender.Discipline as d,sum(Female) as count_female, sum(total) as Total,
100*(round(round(female,4)/round(total,4),2))as female_Participation
from 2021tokyo.entriesgender 
group by d
order by female_Participation desc;

-- Query 10: - Sports with Highes male participation --
select entriesgender.Discipline as d,sum(male) as count_female, sum(total) as Total,
100*(round(round(male,4)/round(total,4),2))as male_Participation
from 2021tokyo.entriesgender 
group by d
order by male_Participation desc;

-- Query 11: -  Player vs coach List --
select athletes.name as Player_name,coaches.name as Coaches_name ,athletes.NOC, athletes.Discipline
from 2021tokyo.athletes
join 2021tokyo.coaches on athletes.NOC = coaches.NOC
group by NOC
order by Discipline asc;


-- Query 12: -  Teams vs Disciplines --
select teams.name as country_name, count(distinct Discipline) as count_of_discipline
from 2021tokyo.teams
group by country_name
order by count_of_discipline desc;

--  Query 13: -  Continent wise breakdown --
select distinct(name),continent_list.continent
from 2021tokyo.teams
join 2021tokyo.continent_list on teams.name = continent_list.country ;


-- Query 14: -  Continent vs count of countries partcipated in the olympics --
select continent_list.continent, count(country)as number_of_country
from 2021tokyo.continent_list
group by Continent
order by number_of_country desc;

--  Query 15: - Continents Performance Table --
select co.continent,count(c.name) as Total_Coaches,count_of_players as Total_Players,m.total as Total_Medals_Won
from 2021tokyo.coaches c
join (select NOC as country,gold,silver,bronze,total
from 2021tokyo.medals) m
on c.noc=m.country
join (select * from (select count(name) as Count_of_Players,NOC
from 2021tokyo.athletes
group by noc) a
order by a.count_of_players desc) p on c.noc=p.noc
join 2021tokyo.continent_list co on c.noc=co.country
group by co.continent
order by m.total desc;
