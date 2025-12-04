USE [International_football] 
GO 

-- Which cities have hosted the largest number of international matches?
SELECT city ,
       COUNT(city) AS MOSTCITY 
FROM results 
GROUP BY city
ORDER BY MOSTCITY DESC ;


---Do home teams generally have a higher chance of winning?

SELECT 
   (
   SELECT 
   (
	  (COUNT(home_team)*100.00) /
   
      (SELECT COUNT(home_team) FROM results )
   
   ) 
    FROM results
    WHERE home_score > away_score )AS HOMETEAMCOUNT 
   


--Which tournaments have the highest percentage of matches that end in a draw?   
SELECT( 
   SELECT (
        (COUNT(*) * 100.00 ) /
        (SELECT COUNT(*) FROM results) 
	      )
   FROM results
   WHERE home_score = away_score );

---Which teams score the most goals on average, and which teams concede the most goals on average?
SELECT  home_team , AVG (home_score ) AS  AVG_HOMESCORE_BER_TEAM
FROM results
GROUP BY home_team
HAVING AVG (home_score) > (SELECT AVG (home_score) FROM results )
ORDER BY AVG_HOMESCORE_BER_TEAM DESC 



-- which teams concede the most goals on average?
SELECT  home_team , AVG (away_score ) AS  Strongest_defensive_team
FROM results
GROUP BY home_team
HAVING AVG (away_score) > (SELECT AVG (away_score) FROM results )
ORDER BY Strongest_defensive_team DESC     


-- What are the matches with the highest total number of goals,
-- and what patterns can be observed from them?
SELECT home_team ,
      away_team ,
	  tournament ,
	  city , 
	  country,
	  (away_score + home_score)AS Match_score 
FROM results
ORDER BY Match_score DESC ;