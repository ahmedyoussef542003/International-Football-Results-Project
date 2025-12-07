USE [International_football] 
GO 











--- ===========Basic Exploration and Data Cleaning=================
--Display count of data 
SELECT count(*) AS NUMOFROWS
FROM results


---Display name of columns 
SELECT TOP 0 *
FROM results;

-- checking for missing value
SELECT * 
FROM results
WHERE date IS NULL
           OR home_team IS NULL
           OR away_team IS NULL 
		   OR home_score IS NULL 
		   OR away_score IS NULL
		   OR tournament IS NULL
		   OR city IS NULL
		   OR country IS NULL
		   OR neutral IS NULL;

--- checking for duplicates 
SELECT date, home_team, away_team, home_score, away_score, tournament, city, country, neutral,
       COUNT(*) AS duplicates_count
FROM results
GROUP BY date, home_team, away_team, home_score, away_score, tournament, city, country, neutral
HAVING COUNT(*) > 1;
 
-----===============================  Goals  =========================
--1- Which cities have hosted the largest number of international matches?
SELECT TOP 5 city ,
       COUNT(city) AS MOSTCITY 
FROM results 
GROUP BY city
ORDER BY MOSTCITY DESC ;


--2-Do home teams generally have a higher chance of winning?
SELECT 
    (SUM(CASE WHEN home_score > away_score THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*)) AS HomeTeamWinPercentage,
        
    (SUM(CASE WHEN home_score = away_score THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)) AS DrawPercentage,
	(SUM (CASE WHEN  home_score< away_score THEN 1 ELSE 0 END ) * 100.0
	    /COUNT(*)) AS AwayTeamWinPercentage
FROM results;



--3- Which tournaments have the highest 
--percentage of matches that end in a draw?   

SELECT TOP 1 tournament , COUNT (*) AS CountdrawperTournament ,
     CONCAT(
   
        (COUNT(*) * 100 / 
          (SELECT COUNT(*) FROM results WHERE home_score = away_score)
        ), 
          '%'
      ) AS Percentage
FROM results
WHERE home_score = away_score
GROUP BY tournament
ORDER BY CountdrawperTournament DESC; 



--4-Which teams score the most goals on average?
SELECT TOP 5 team,
       AVG(goals_scored) AS avg_goals_scored
FROM (
        SELECT home_team AS team, home_score AS goals_scored
        FROM results
        UNION ALL
        SELECT away_team AS team, away_score AS goals_scored
        FROM results
     ) AS all_goals
GROUP BY team
HAVING AVG(goals_scored) > (SELECT AVG(away_score + home_score  )  FROM results)
ORDER BY avg_goals_scored DESC;



-- which teams concede the most goals on average?
SELECT TOP 5 team,
       AVG(goals_conceded) AS avg_conceded
FROM (
        SELECT home_team AS team, away_score AS goals_conceded
        FROM results
        
        UNION ALL
        
        SELECT away_team AS team, home_score AS goals_conceded
        FROM results
     ) AS all_conceded
GROUP BY team
HAVING AVG(goals_conceded) > (SELECT AVG(away_score+home_score) FROM results)
ORDER BY avg_conceded DESC;
    


-- What are the matches with the highest total number of goals,
-- and what patterns can be observed from them?
SELECT TOP 5 home_team ,
      away_team ,
	  tournament ,
	  city , 
	  country,
	  (away_score + home_score)AS Match_score 
FROM results
ORDER BY Match_score DESC ;