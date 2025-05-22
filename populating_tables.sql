-- Geo_Codes Table
-- populating the Geo_Codes table with every column except Geo_Level
INSERT INTO Geo_Codes (State_ANSI, County_ANSI, State, Area_Name)
SELECT State_ANSI, County_ANSI, State, Area_Name
FROM population_src;

-- updating Geo_Level column in Geo_Codes
UPDATE Geo_Codes
SET Geo_Level = 'COUNTRY'
WHERE State_ANSI = 0 AND County_ANSI = 0;

UPDATE Geo_Codes
SET Geo_Level = 'STATE'
WHERE State_ANSI > 0 AND County_ANSI = 0;

UPDATE Geo_Codes
SET Geo_Level = 'COUNTY'
WHERE State_ANSI > 0 AND County_ANSI > 0;

-- Alaska's Area_Name column was populated properly from the start since I used population_src to insert values

-- Ag_Codes Table
-- populating the Ag_Codes table with rows from bee_colonies_county_src
INSERT INTO Ag_Codes (State_ANSI, Ag_District_Code, Ag_District)
SELECT DISTINCT State_ANSI, Ag_District_Code, Ag_District
FROM bee_colonies_county_src
WHERE Ag_District_Code IS NOT NULL AND Ag_District IS NOT NULL;

-- Population Table
INSERT INTO Population (State_ANSI, County_ANSI, Rural_Urban_Code_2013, Population_1990, Population_2000, Population_2010, Population_2020)
SELECT 
    State_ANSI,
    County_ANSI,
    CASE WHEN Rural_urban_code_2013 = '' THEN NULL 
         ELSE CAST(Rural_urban_code_2013 AS SIGNED) END,
    CASE WHEN Population_1990 = '' THEN NULL 
         ELSE CAST(REPLACE(Population_1990, ',', '') AS SIGNED) END,
    CASE WHEN Population_2000 = '' THEN NULL 
         ELSE CAST(REPLACE(Population_2000, ',', '') AS SIGNED) END,
    CASE WHEN Population_2010 = '' THEN NULL 
         ELSE CAST(REPLACE(Population_2010, ',', '') AS SIGNED) END,
    CASE WHEN Population_2020 = '' THEN NULL 
         ELSE CAST(REPLACE(Population_2020, ',', '') AS SIGNED) END
FROM population_src;

-- Bee_Colonies Table
-- creating a temporary table
DROP TEMPORARY TABLE IF EXISTS temp_bee_colonies;

CREATE TEMPORARY TABLE temp_bee_colonies (
    State_ANSI INT,
    County_ANSI INT,
    Ag_District_Code INT,
    PRIMARY KEY (State_ANSI, County_ANSI)
);

-- populating the temporary table
INSERT INTO temp_bee_colonies (State_ANSI, County_ANSI, Ag_District_Code)
SELECT DISTINCT State_ANSI, County_ANSI, Ag_District_Code
FROM bee_colonies_county_src;

-- populating the Bee_Colonies table with nulls temporarily for colony counts
INSERT INTO Bee_Colonies (State_ANSI, County_ANSI, Ag_District_Code, Colonies_2002, Colonies_2007, Colonies_2012, Colonies_2017, Colonies_2022)
SELECT 
    State_ANSI, 
    County_ANSI, 
    Ag_District_Code,
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    NULL
FROM temp_bee_colonies;

-- populating the Bee_Colonies table with state records
INSERT INTO Bee_Colonies 
SELECT
    State_ANSI AS State_ANSI,
    0 AS County_ANSI,
    NULL AS Ag_District_Code,
    SUM(IF(Year = '2002', CAST(REPLACE(Value, ',', '') AS UNSIGNED), NULL)) AS Colonies_2002,
    SUM(IF(Year = '2007', CAST(REPLACE(Value, ',', '') AS UNSIGNED), NULL)) AS Colonies_2007,
    SUM(IF(Year = '2012', CAST(REPLACE(Value, ',', '') AS UNSIGNED), NULL)) AS Colonies_2012,
    SUM(IF(Year = '2017', CAST(REPLACE(Value, ',', '') AS UNSIGNED), NULL)) AS Colonies_2017,
    SUM(IF(Year = '2022', CAST(REPLACE(Value, ',', '') AS UNSIGNED), NULL)) AS Colonies_2022
FROM bee_colonies_state_src bcs
WHERE Year in ('2002', '2007', '2012', '2017', '2022')
GROUP BY bcs.State_ANSI;

-- using correlated subqueries to populate the colony counts
-- colonies_2002
UPDATE Bee_Colonies bc
SET Colonies_2002 = (
    SELECT 
        CASE 
            WHEN Value LIKE '%D%' 
			OR  Value LIKE '%H%'
            OR Value LIKE '%S%'
            OR Value LIKE '%NA%'
            OR Value LIKE '%X%'
            OR Value LIKE '%Z%' 
            THEN NULL
            ELSE CAST(REPLACE(Value, ',', '') AS SIGNED)
        END
    FROM bee_colonies_county_src bcs
    WHERE bcs.State_ANSI = bc.State_ANSI
    AND bcs.County_ANSI = bc.County_ANSI
    AND bcs.Year = 2002
    LIMIT 1
)
WHERE NOT (bc.State_ANSI > 0 AND bc.County_ANSI = 0);

-- colonies_2007
UPDATE Bee_Colonies bc
SET Colonies_2007 = (
    SELECT 
        CASE 
            WHEN Value LIKE '%D%' 
			OR  Value LIKE '%H%'
            OR Value LIKE '%S%'
            OR Value LIKE '%NA%'
            OR Value LIKE '%X%'
            OR Value LIKE '%Z%' 
            THEN NULL
            ELSE CAST(REPLACE(Value, ',', '') AS SIGNED)
        END
    FROM bee_colonies_county_src bcs
    WHERE bcs.State_ANSI = bc.State_ANSI
    AND bcs.County_ANSI = bc.County_ANSI
    AND bcs.Year = 2007
    LIMIT 1
)
WHERE NOT (bc.State_ANSI > 0 AND bc.County_ANSI = 0);

-- colonies_2012
UPDATE Bee_Colonies bc
SET Colonies_2012 = (
    SELECT 
        CASE 
            WHEN Value LIKE '%D%' 
			OR  Value LIKE '%H%'
            OR Value LIKE '%S%'
            OR Value LIKE '%NA%'
            OR Value LIKE '%X%'
            OR Value LIKE '%Z%' 
            THEN NULL
            ELSE CAST(REPLACE(Value, ',', '') AS SIGNED)
        END
    FROM bee_colonies_county_src bcs
    WHERE bcs.State_ANSI = bc.State_ANSI
    AND bcs.County_ANSI = bc.County_ANSI
    AND bcs.Year = 2012
    LIMIT 1
)
WHERE NOT (bc.State_ANSI > 0 AND bc.County_ANSI = 0);

-- colonies_2017
UPDATE Bee_Colonies bc
SET Colonies_2017 = (
    SELECT 
        CASE 
            WHEN Value LIKE '%D%' 
			OR  Value LIKE '%H%'
            OR Value LIKE '%S%'
            OR Value LIKE '%NA%'
            OR Value LIKE '%X%'
            OR Value LIKE '%Z%' 
            THEN NULL
            ELSE CAST(REPLACE(Value, ',', '') AS SIGNED)
        END
    FROM bee_colonies_county_src bcs
    WHERE bcs.State_ANSI = bc.State_ANSI
    AND bcs.County_ANSI = bc.County_ANSI
    AND bcs.Year = 2017
    LIMIT 1
)
WHERE NOT (bc.State_ANSI > 0 AND bc.County_ANSI = 0);

-- colonies_2022
UPDATE Bee_Colonies bc
SET Colonies_2022 = (
    SELECT 
        CASE 
            WHEN Value LIKE '%D%' 
			OR  Value LIKE '%H%'
            OR Value LIKE '%S%'
            OR Value LIKE '%NA%'
            OR Value LIKE '%X%'
            OR Value LIKE '%Z%' 
            THEN NULL
            ELSE CAST(REPLACE(Value, ',', '') AS SIGNED)
        END
    FROM bee_colonies_county_src bcs
    WHERE bcs.State_ANSI = bc.State_ANSI
    AND bcs.County_ANSI = bc.County_ANSI
    AND bcs.Year = 2022
    LIMIT 1
)
WHERE NOT (bc.State_ANSI > 0 AND bc.County_ANSI = 0);