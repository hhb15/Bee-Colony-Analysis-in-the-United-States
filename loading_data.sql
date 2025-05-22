USE individual_project;

-- creating the population_src table using the LOAD DATA command
CREATE TABLE `population_src` (
  `FIPStxt` text,
  `State` text,
  `Area_name` text,
  `Rural_urban_code_2013` text,
  `Population_1990` text,
  `Population_2000` text,
  `Population_2010` text,
  `Population_2020` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE
'/Users/heerbhathawala/Downloads/individual_project/population_src.csv'
INTO TABLE population_src
CHARACTER SET 'latin1'
COLUMNS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- checking to see if the first couple of rows match the source file
SELECT * 
FROM population_src
LIMIT 5;

-- loaded the bee_colonies_county_src and bee_colonies_state_src files using the table data import wizard

-- checking to see if the first couple of rows match the source file
SELECT * 
FROM bee_colonies_county_src
LIMIT 5;

-- checking to see if the first couple of rows match the source file
SELECT * 
FROM bee_colonies_state_src
LIMIT 5;