# Bee-Colony-Analysis-in-the-United-States

### Project Overview
The database in this project is about managed honeybee colonies in the United States. Populations of pollinators, including wild and managed honeybees, have recently been in decline, and this jeopardizes our food supply. We will explore some data about changes in numbers of managed honeybee colonies.

### Data Source and Data Dictionary
For the honeybee project, the following information is provided: human populations of counties and states for different years, and managed colony counts for counties and states for different years.

The information is provided in the following csv files:
  bee_colonies_county_src.csv
  bee_colonies_state_src.csv
  population_src.csv
  
In addition, documentation about the bee colony data is provided in a file called bee_glossary.pdf.

Some minimal changes have been made to the original spreadsheets obtained from the US Government to make it easier to load the data. For example, unneeded columns were deleted from bee colony csv files and blanks were eliminated from attribute names. Extraneous information was deleted from the population estimates, and the file was converted from an excel file to a csv file.

### Data Provenance
The source files for the bee data were obtained from the US Department of Agriculture at https://quickstats.nass.usda.gov/%230F62D3C3-7780-3B2B-B1AC-9CC58BA20227.

The bee_glossary.pdf file was obtained from: https://quickstats.nass.usda.gov/src/glossary.pdf. The source file for the population data was obtained from the US Department of Agriculture at https://www.ers.usda.gov/data-products/county-level-data-sets/download-data/. The population data is estimated based on the results of the US Census conducted every 10 years.

### Target Tables
From the source files, a normalized database was created that has the following relations:
  Bee_Colonies(State_ANSI, County_ANSI, Ag_District_Code, Colonies_2002, Colonies_2007, Colonies_2012, Colonies_2017, Colonies_2022)
  Population(State_ANSI, County_ANSI, Rural_Urban_Code_2013, Population_1990, Population_2000, Population_2010, Population_2020)
  Geo_Codes(Geo_Level, State_ANSI, County_ANSI, State, Area_Name)
  Ag_Codes(State_ANSI, Ag_District_Code, Ag_District)

### Data Cleaning
- Gave all the attributes proper types. Sized every numeric type to the smallest size that will accommodate the data and used VARCHAR for strings that vary in length.
- Specified the appropriate primary and foreign keys.
- Used the Bee_Glossary.pdf to interpret any letters in the cells that might mean that the data is secret or unknown and changed them to NULLS as necessary (e.g., D).
- Used the FIPStxt column in population_src.csv to extract the State_ANSI and the County_ANSI using the following SQL formulas: State_ANSI = FLOOR(FIPStxt/1000), County_ANSI = FIPStxt % 1000
- Pivoted the bee colonies csv files to provide columns of colony counts for each year.

### SQL Analysis
1. What is the number of bee colonies for 2002, 2007, 2013, 2017 and 2022 for all the counties in NJ and for the state of NJ as a whole?
2. What is the number of counties in the state of New York?
3. List each county in the state of New York. List the county name in a column called County_Name, the population of the county in 2020, and the number of bee colonies in the county in 2022.
4. What area with the Geo_Level of COUNTY in the state of Alaska had the most bee colonies in 2022?
5. How many ag districts are there in each state?
6. Which ag district had the most bee hives in 2022?
7. Generate a report for the states that have experienced (1) the largest percentage increase in the number of bee colonies from 2002 to 2022, and (2) the largest percentage decline in the number of colonies from 2002 to 2022.
8. Generate a report for the states returned by the previous query. List the population for each of the available years and the change in the population from 2002 to 2022.

### SQL Features Used
- Common Table Expressions (CTEs)
- Aggregate functions (SUM, AVG, COUNT)
- Joins (INNER, LEFT)
- Subqueries
- CASE statements
- Views

### Tableau Visualization
Created a table called Colony_Growth that listed the State Name in a column called State_Name, the year, and the colony count for that year and that state in a column called Colonies. Populated the table with the state colony counts for each year from bee_colonies for the states in the Northeast. The states in the Northeast are: Connecticut, Delaware, Maine, Maryland, Massachusetts, New Hampshire, New Jersey, New York, Pennsylvania, Rhode Island, Vermont, Virginia, and West Virginia.

Created two worksheets:
1. A line graph with a line for each state representing the colony counts for each year
2. An area graph with stacked solid areas for each state representing the colony counts for each year that state

### Tools Used
- MySQL
- MySQL Workbench
- Tableau
