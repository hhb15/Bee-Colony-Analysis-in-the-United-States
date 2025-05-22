-- Question 2
SELECT 
	gc.Geo_Level, 
    gc.State_ANSI, 
    gc.State AS State_Abbreviation, 
    gc.County_ANSI, gc.Area_Name, 
    bc.Colonies_2002, 
    bc.Colonies_2007, 
    bc.Colonies_2012, 
    bc.Colonies_2017, 
    bc.Colonies_2022
FROM Geo_Codes gc
LEFT JOIN Bee_Colonies bc 
	ON gc.State_ANSI = bc.State_ANSI AND gc.County_ANSI = bc.County_ANSI
WHERE gc.State = 'NJ' AND (gc.Geo_Level = 'COUNTY' OR gc.Geo_Level = 'STATE')
ORDER BY bc.Colonies_2022 DESC;
    
-- Question 3
SELECT COUNT(*) AS Number_of_Counties
FROM Geo_Codes
WHERE State_ANSI = (SELECT State_ANSI 
					FROM Geo_Codes 
                    WHERE Area_Name = 'New York' AND County_ANSI = 0 AND Geo_Level = 'STATE')
AND Geo_Level = 'COUNTY';

-- Question 4
SELECT 
	gc.Area_Name AS County_Name, 
    FORMAT(p.Population_2020, 0) AS Population_2020, 
    CASE WHEN bc.Colonies_2022 IS NULL THEN NULL ELSE bc.Colonies_2022 END AS Colonies_2022
FROM Geo_Codes gc
JOIN Population p 
	ON gc.State_ANSI = p.State_ANSI AND gc.County_ANSI = p.County_ANSI
LEFT JOIN Bee_Colonies bc 
	ON gc.State_ANSI = bc.State_ANSI AND gc.County_ANSI = bc.County_ANSI
WHERE gc.Geo_Level = 'COUNTY' AND gc.State = 'NY'
ORDER BY p.Population_2020 DESC;

-- Question 5
SELECT 
	gc.Geo_Level, 
    gc.State_ANSI, 
    (SELECT g.Area_Name FROM Geo_Codes g WHERE g.State_ANSI = gc.State_ANSI AND g.County_ANSI = 0) AS State_Name,
    gc.County_ANSI, 
    gc.Area_Name, 
    bc.Colonies_2002, 
    bc.Colonies_2007, 
    bc.Colonies_2012, 
    bc.Colonies_2017, 
    bc.Colonies_2022
FROM Geo_Codes gc
JOIN Bee_Colonies bc
	ON gc.State_ANSI = bc.State_ANSI AND gc.County_ANSI = bc.County_ANSI
WHERE gc.Geo_Level = 'COUNTY' AND gc.State_ANSI = (SELECT State_ANSI 
												   FROM Geo_Codes 
                                                   WHERE Area_Name = 'Alaska' AND County_ANSI = 0 AND Geo_Level = 'STATE')
AND bc.Colonies_2022 = (SELECT MAX(b2.Colonies_2022)
					    FROM Bee_Colonies b2
                        JOIN Geo_Codes g2 
						  ON b2.State_ANSI = g2.State_ANSI AND b2.County_ANSI = g2.County_ANSI
					    WHERE g2.State_ANSI = (SELECT State_ANSI 
											   FROM Geo_Codes 
                                               WHERE Area_Name = 'Alaska' AND County_ANSI = 0 AND Geo_Level = 'STATE')
					    AND g2.Geo_Level = 'COUNTY');

-- Question 6
SELECT 
	a.State_ANSI, 
	gc.Area_Name AS State,
    COUNT(DISTINCT a.Ag_District_Code) AS num_ag_districts
FROM Ag_Codes a
JOIN Geo_Codes gc 
	ON a.State_ANSI = gc.State_ANSI
WHERE gc.County_ANSI = 0 AND gc.Geo_Level = 'STATE'
GROUP BY a.State_ANSI, gc.Area_Name
ORDER BY gc.Area_Name ASC;

-- Question 7
SELECT 
	a.State_ANSI, 
    gc.Area_Name AS State, 
    a.Ag_District_Code, 
    a.Ag_District, 
    bc.Colonies_2002, 
    bc.Colonies_2007, 
    bc.Colonies_2012, 
    bc.Colonies_2017, 
    bc.Colonies_2022
FROM Bee_Colonies bc
JOIN Ag_Codes a 
	ON bc.State_ANSI = a.State_ANSI AND bc.Ag_District_Code = a.Ag_District_Code
JOIN Geo_Codes gc 
	ON a.State_ANSI = gc.State_ANSI AND gc.County_ANSI = 0 AND gc.Geo_Level = 'STATE'
WHERE bc.Colonies_2022 = (SELECT MAX(district_totals.total_colonies)
						  FROM (SELECT Colonies_2022 AS total_colonies
							    FROM Bee_Colonies b2
							    JOIN Ag_Codes a2 
								  ON b2.State_ANSI = a2.state_ANSI AND b2.Ag_District_Code = a2.Ag_District_Code
							    JOIN Geo_Codes g2
								  ON a2.State_ANSI = g2.State_ANSI AND g2.County_ANSI = 0 AND g2.Geo_Level = 'STATE'
							    WHERE b2.Colonies_2022 IS NOT NULL) district_totals); 
                               
-- Question 8
CREATE VIEW StateColonies AS
SELECT 
    gc.State AS State_Abbreviation,
    gc.Area_Name AS State_Name,
    bc.Colonies_2002,
    bc.Colonies_2007,
    bc.Colonies_2012,
    bc.Colonies_2017,
    bc.Colonies_2022,
    CAST(((bc.Colonies_2022 - bc.Colonies_2002) / bc.Colonies_2002) * 100 AS DECIMAL(10,2)) AS Pct_Change
FROM Bee_Colonies bc
JOIN Geo_Codes gc 
	ON bc.State_ANSI = gc.State_ANSI AND bc.County_ANSI = gc.County_ANSI AND gc.Geo_Level = 'STATE'
WHERE bc.Colonies_2002 IS NOT NULL AND bc.Colonies_2022 IS NOT NULL;

CREATE VIEW MaxChanges AS
SELECT MAX(Pct_Change) AS Max_Increase, MIN(Pct_Change) AS Max_Decrease
FROM StateColonies;

SELECT 
    sc.State_Abbreviation,
    sc.State_Name,
    FORMAT(sc.Colonies_2002, 0) AS Colonies_2002,
    FORMAT(sc.Colonies_2007, 0) AS Colonies_2007,
    FORMAT(sc.Colonies_2012, 0) AS Colonies_2012,
    FORMAT(sc.Colonies_2017, 0) AS Colonies_2017,
    FORMAT(sc.Colonies_2022, 0) AS Colonies_2022,
    CONCAT(CAST(ROUND(sc.Pct_Change, 0) AS SIGNED), '%') AS Percent_Change
FROM StateColonies sc
JOIN MaxChanges mc
	ON (sc.Pct_Change = mc.Max_Increase OR sc.Pct_Change = mc.Max_Decrease)
ORDER BY sc.Pct_Change DESC;

-- Question 9
SELECT 
    sc.State_Abbreviation,
    sc.State_Name,
    FORMAT(p.Population_1990, 0) AS Population_1990,
    FORMAT(p.Population_2000, 0) AS Population_2000,
    FORMAT(p.Population_2010, 0) AS Population_2010,
    FORMAT(p.Population_2020, 0) AS Population_2020,
    FORMAT(p.Population_2020 - p.Population_1990, 0) AS Amount_of_Change
FROM StateColonies sc
JOIN MaxChanges mc 
	ON (sc.Pct_Change = mc.Max_Increase OR sc.Pct_Change = mc.Max_Decrease)
JOIN Geo_Codes gc 
	ON sc.State_Abbreviation = gc.State AND gc.County_ANSI = 0 AND gc.Geo_Level = 'STATE'
JOIN Population p 
	ON gc.State_ANSI = p.State_ANSI AND p.County_ANSI = 0
ORDER BY sc.Pct_Change DESC;