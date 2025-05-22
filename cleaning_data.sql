-- checking population_src for empty cells
SELECT * 
FROM population_src
WHERE Rural_urban_code_2013 = ''; -- returns 58 rows

SELECT * 
FROM population_src
WHERE Population_1990 = ''; -- returns 8 rows

SELECT * 
FROM population_src
WHERE Population_2000 = ''; -- returns 6 rows

SELECT * 
FROM population_src
WHERE Population_2010 = ''; -- returns 6 rows

SELECT * 
FROM population_src
WHERE Population_2020 = ''; -- returns 6 rows

-- checking bee_colonies_state_src for empty cells
SELECT * 
FROM bee_colonies_state_src
WHERE Ag_District = ''; -- returns 300 rows

SELECT * 
FROM bee_colonies_state_src
WHERE Ag_District_Code = ''; -- returns 300 rows

SELECT * 
FROM bee_colonies_state_src
WHERE County = ''; -- returns 300 rows

SELECT * 
FROM bee_colonies_state_src
WHERE County_ANSI = ''; -- returns 300 rows

-- checking bee_colonies_county_src for empty cells
SELECT * 
FROM bee_colonies_county_src
WHERE County_ANSI = ''; -- returns 16 rows

-- updating any empty cells in source tables to NULL
UPDATE population_src
SET Rural_urban_code_2013 = NULL
WHERE Rural_urban_code_2013 = '';

UPDATE population_src
SET Population_1990 = NULL
WHERE Population_1990 = '';

UPDATE population_src
SET Population_2000 = NULL
WHERE Population_2000 = '';

UPDATE population_src
SET Population_2010 = NULL
WHERE Population_2010 = '';

UPDATE population_src
SET Population_2020 = NULL
WHERE Population_2020 = '';

UPDATE bee_colonies_state_src
SET Ag_District = NULL
WHERE Ag_District = '';

UPDATE bee_colonies_state_src
SET Ag_District_Code = NULL
WHERE Ag_District_Code = '';

UPDATE bee_colonies_state_src
SET County = NULL
WHERE County = '';

UPDATE bee_colonies_state_src
SET County_ANSI = NULL
WHERE County_ANSI = '';

UPDATE bee_colonies_county_src
SET County_ANSI = NULL
WHERE County_ANSI = '';

-- extracting State_ANSI and County_ANSI from FIPStxt and creating new columns in population_src
ALTER TABLE population_src ADD COLUMN State_ANSI TINYINT UNSIGNED;
ALTER TABLE population_src ADD COLUMN County_ANSI SMALLINT UNSIGNED;

UPDATE population_src 
SET 
    State_ANSI = FLOOR(FIPStxt/1000),
    County_ANSI = FIPStxt % 1000;
    
-- used this query to find out that County_ANSI is null for the state of Alaska
SELECT State_ANSI, County_ANSI, Ag_District_Code
FROM Bee_Colonies
WHERE County_ANSI IS NULL;

-- used this query to find which county names to change 
SELECT * 
FROM bee_colonies_county_src
WHERE State_ANSI = 2;

-- used this query to figure out what to change the county names to using Area_name
SELECT * 
FROM population_src
WHERE State_ANSI = 2;
    
-- updating the county names for Alaska in bee_colonies_county_src table where they aren't the same
UPDATE bee_colonies_county_src
SET County = 'Anchorage Municipality'
WHERE County = 'ANCHORAGE';

UPDATE bee_colonies_county_src
SET County = 'Fairbanks North Star Borough'
WHERE County = 'FAIRBANKS NORTH STAR';

UPDATE bee_colonies_county_src
SET County = 'Kenai Peninsula Borough'
WHERE County = 'KENAI PENINSULA';

UPDATE bee_colonies_county_src
SET County = 'Aleutians West Census Area' -- used this because Ag_District in the bee_colonies_county_src said 'Southwest and West'
WHERE County = 'ALEUTIAN ISLANDS';

-- updating the County_ANSI values in the bee_colonies_county_src table
UPDATE bee_colonies_county_src 
SET County_ANSI = (SELECT population_src.County_ANSI 
				   FROM population_src 
                   WHERE population_src.Area_name = bee_colonies_county_src.County
                   AND population_src.State = 'AK')
WHERE State = 'ALASKA'
AND County_ANSI IS NULL;