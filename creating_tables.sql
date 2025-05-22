DROP TABLE IF EXISTS Population;
DROP TABLE IF EXISTS Bee_Colonies;
DROP TABLE IF EXISTS Ag_Codes;
DROP TABLE IF EXISTS Geo_Codes;

-- checking max length of geo_level 
SELECT MAX(LENGTH(Geo_Level))
FROM bee_colonies_county_src; -- 6

SELECT MAX(LENGTH(Geo_Level))
FROM bee_colonies_state_src; -- 5

-- checking max length of area_name
SELECT MAX(LENGTH(Area_name))
FROM population_src; -- 43

-- checking max length of ag_district
SELECT MAX(LENGTH(Ag_District))
FROM bee_colonies_county_src; -- 28

-- checking max length of Ag_District_Code
SELECT MAX(LENGTH(Ag_District_Code))
FROM bee_colonies_county_src; -- 2

-- checking max lenth of rural_urban_code_2013
SELECT MAX(LENGTH(Rural_urban_code_2013))
FROM population_src; -- 1

CREATE TABLE Geo_Codes(
	Geo_Level 	VARCHAR(7),
    State_ANSI 	TINYINT UNSIGNED,
    County_ANSI SMALLINT UNSIGNED,
    State		VARCHAR(2),
    Area_Name	VARCHAR(43),
    PRIMARY KEY (State_ANSI, County_ANSI)
);

CREATE TABLE Ag_Codes(
	State_ANSI 			TINYINT UNSIGNED,
    Ag_District_Code	TINYINT UNSIGNED,
    Ag_District			VARCHAR(28),
    PRIMARY KEY (State_ANSI, Ag_District_Code),
    FOREIGN KEY (State_ANSI) REFERENCES Geo_Codes(State_ANSI)
);

CREATE TABLE Bee_Colonies(
	State_ANSI			TINYINT UNSIGNED,
    County_ANSI			SMALLINT UNSIGNED,
    Ag_District_Code	TINYINT UNSIGNED,
    Colonies_2002		INT,
    Colonies_2007		INT,
    Colonies_2012		INT,
    Colonies_2017		INT,
    Colonies_2022		INT,
    PRIMARY KEY (State_ANSI, County_ANSI),
    FOREIGN KEY (State_ANSI, County_ANSI) REFERENCES Geo_Codes(State_ANSI, County_ANSI),
    FOREIGN KEY (State_ANSI, Ag_District_Code) REFERENCES Ag_Codes(State_ANSI, Ag_District_Code)
);

CREATE TABLE Population(
	State_ANSI 				TINYINT UNSIGNED,
    County_ANSI				SMALLINT UNSIGNED,
    Rural_Urban_Code_2013	TINYINT UNSIGNED,
    Population_1990			INT,
    Population_2000			INT,
    Population_2010			INT,
    Population_2020			INT,
	PRIMARY KEY (State_ANSI, County_ANSI),
    FOREIGN KEY (State_ANSI, County_ANSI) REFERENCES Geo_Codes(State_ANSI, County_ANSI)
);