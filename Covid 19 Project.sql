--Ran the command to check that the data is fully loaded and correct--
SELECT *
FROM [Covid Project]..[CovidDeaths(1)]
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT *
--FROM [Covid Project]..[Covidvaccinations(1)]
WHERE continent IS NOT NULL
--ORDER BY 3,4


--Select the data I started with--
SELECT location, date,total_cases, new_cases, total_deaths, population
FROM [Covid Project]..[CovidDeaths(1)]
order by 1,2


-- Total Cases vs Total Deaths--
-- Shows likelihood of dying if a person contract covid in their country--

SELECT total_cases
FROM [Covid Project]..[CovidDeaths(1)]
WHERE TRY_CAST (total_cases AS float) IS NULL AND total_cases IS NOT NULL;

SELECT total_deaths
FROM [Covid Project]..[CovidDeaths(1)]
WHERE TRY_CAST (total_deaths AS float) IS NULL AND total_deaths IS NOT NULL;

ALTER TABLE [Covid Project]..[CovidDeaths(1)]
ALTER COLUMN total_cases float;

ALTER TABLE [Covid Project]..[CovidDeaths(1)]
ALTER COLUMN total_deaths float;

-- Total Cases vs Population--
-- Shows what percentage of population infected with Covid--

SELECT location, date, total_cases, population, (total_cases/population) *100 as  PercentagePopulationInfected
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
ORDER BY 1,2

-- Countries with Highest Infection Rate compared to Population--

SELECT location,  population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population) *100 as PercentagePopulationInfected
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
GROUP BY location, population
ORDER BY  PercentagePopulationInfected DESC

-- Countries with Highest Death Count per Population--

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY  TotalDeathCount DESC

-- BROKE THINGS DOWN BY CONTINENT--
-- Displayed contintents with the highest death count per population--

SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY continent


SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NULL
GROUP BY location
ORDER BY  TotalDeathCount DESC






SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY  TotalDeathCount DESC




--THIS SHOWED GLOBAL NUMBERS--
--Changed new_cases column to float--

ALTER TABLE [Covid Project]..[CovidDeaths(1)]
ALTER COLUMN new_cases float;

SELECT  date,SUM( new_cases)--, total_deaths, (total_deaths/total_cases) *100 as  DeathPercentage
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT  date,SUM( new_cases), SUM(CAST( new_deaths AS INT))--, (total_deaths/total_cases) *100 as  DeathPercentage
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


SELECT  date,SUM( new_cases) AS total_cases, SUM(CAST( new_deaths AS INT)) AS total_deaths, SUM(CAST (new_deaths AS int))/ SUM(new_cases) *100 as  DeathPercentage
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--Total Cases World Wide--

SELECT SUM( new_cases) AS total_cases, SUM(CAST( new_deaths AS INT)) AS total_deaths, SUM(CAST (new_deaths AS int))/ SUM(new_cases) *100 as  DeathPercentage
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2

--LOOKED AT TOTAL POPULATION vs VACCINATIONS--
-- Displayed Percentage of Population that has recieved at least one Covid Vaccine--

SELECT *
FROM [Covid Project]..[CovidDeaths(1)] dea
JOIN [Covid Project]..[CovidVaccinations(1)] vac
     ON dea.location = vac.location
	 AND dea.date = vac.date


 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
FROM [Covid Project]..[CovidDeaths(1)] dea
JOIN [Covid Project]..[CovidVaccinations(1)] vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
	 WHERE dea.continent IS NOT NULL
	 ORDER BY 2,3

--Using CTE to perform Calculation on Partition By in previous query--

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Covid Project]..[CovidDeaths(1)] dea
JOIN [Covid Project]..[CovidVaccinations(1)] vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT*, (RollingPeopleVaccinated/population)*100
FROM PopvsVac



--TEMP TABLE
-- Using Temp Table to perform Calculation on Partition By in previous query--

CREATE TABLE #PercentagePopulationVaccinated
(
continent nvarchar(MAX),
location nvarchar(MAX),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Covid Project]..[CovidDeaths(1)] dea
JOIN [Covid Project]..[CovidVaccinations(1)] vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT*, (RollingPeopleVaccinated/population)*100
FROM #PercentagePopulationVaccinated



--Used Drop Table if exists to ALTER data in the table

DROP TABLE IF EXISTS  #PercentagePopulationVaccinated
CREATE TABLE #PercentagePopulationVaccinated
(
continent nvarchar(MAX),
location nvarchar(MAX),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentagePopulationVaccinated
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Covid Project]..[CovidDeaths(1)] dea
JOIN [Covid Project]..[CovidVaccinations(1)] vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT*, (RollingPeopleVaccinated/population)*100
FROM #PercentagePopulationVaccinated



--Created a view to store data for later visualisations--

CREATE VIEW PercentagePopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Covid Project]..[CovidDeaths(1)] dea
JOIN [Covid Project]..[CovidVaccinations(1)] vac
     ON dea.location = vac.location
	 AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3;

SELECT *, (RollingPeopleVaccinated * 1.0/population) * 100 AS PercentVaccinated
FROM PercentagePopulationVaccinated
ORDER BY location, date;


SELECT *
FROM PercentagePopulationVaccinated


SELECT SUM( new_cases) AS total_cases, SUM(CAST( new_deaths AS INT)) AS total_deaths, SUM(CAST (new_deaths AS int))/ SUM(new_cases) *100 as  DeathPercentage
FROM [Covid Project]..[CovidDeaths(1)]
--WHERE location LIKE '%Africa%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2