-- CREATE Database PortfolioProject
CREATE Database PortfolioProject;

SELECT *
FROM portfolioproject.coviddeaths
WHERE continent is not NULL
ORDER BY 3, 4;

SELECT *
FROM portfolioproject.covidvaccinations
ORDER BY 3, 4;

SELECT *
FROM portfolioproject.covidvaccinations;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM portfolioproject.coviddeaths
WHERE continent is not NULL
ORDER BY 1, 2;

-- Looking at Total cases vs Total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS Deathpercentage
FROM portfolioproject.coviddeaths
ORDER BY 1, 2;

-- Looking at the total cases vs population
-- shows what percentage of population got Covid
SELECT location, date, total_cases, population, (total_cases/population) * 100 AS Deathpercentage
FROM portfolioproject.coviddeaths
WHERE location like 'N%%RIA' AND continent is not NULL
ORDER BY 1, 2;

-- Looking at countries with the highest infection rate
SELECT location, population, max(total_cases) AS HighestInfectionCount, Max((total_cases/population)) * 100 AS PercentagePopulationInfected
FROM portfolioproject.coviddeaths
Group By location, population
Order by PercentagePopulationInfected DESC;

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION 
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM portfolioproject.coviddeaths
WHERE continent is NOT NULL
Group by location
Order by TotalDeathCount DESC;

-- SHOWING PERCENTAGE OF COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION 
SELECT location, max(total_deaths) AS TotalDeathCount, max((total_deaths/population)) * 100 AS DeathPercentage
FROM portfolioproject.coviddeaths
Group by location
Order by DeathPercentage DESC;

-- SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION
SELECT continent, MAX(Total_deaths) AS TotalDeathCount
FROM portfolioproject.coviddeaths
WHERE continent is NOT NULL
Group By continent
Order by TotalDeathCount;

-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS TotalNewCases, SUM(new_deaths) AS TotalNewDeaths, SUM(new_deaths)/ SUM(new_cases) * 100 AS DeathPercentage
FROM portfolioproject.coviddeaths
-- WHERE location like 'N%%RIA' 
WHERE continent is not NULL
-- Group By Date
Order By 1, 2;

-- LOOKING AT POPULATION VS VACCINATION
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition By DEA.location Order by DEA.location, DEA.date) AS RollingPeopleVaccinated
FROM portfolioproject.coviddeaths DEA
Join portfolioproject.covidvaccinations VAC
ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
Order By 2, 3;

-- USE CTE
WITH PopVsVac 
(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS
(SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition By DEA.location Order by DEA.location, DEA.date) AS RollingPeopleVaccinated
FROM portfolioproject.coviddeaths DEA
Join portfolioproject.covidvaccinations VAC
ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
Order By 2, 3)
SELECT *, (RollingPeopleVaccinated/Population) * 100
FROM PopVsVac


-- TEMP TABLE
DROP TABLE IF EXISTS PercentPopulationVaccinated
CREATE temporary TABLE PercentPopulationVaccinated
(Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric);

INSERT INTO PercentPopulationVaccinated
(SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition By DEA.location Order by DEA.location, DEA.date) AS RollingPeopleVaccinated
FROM portfolioproject.coviddeaths DEA
Join portfolioproject.covidvaccinations VAC
ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
Order By 2, 3)

SELECT *, (RollingPeopleVaccinated/Population) * 100
FROM PercentPopulationVaccinated

--- CREATING VIEW TO STORE DATA FOR VISUALIZATIONS
CREATE VIEW PercentPopulationVaccinated AS
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VAC.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (Partition By DEA.location Order by DEA.location, DEA.date) AS RollingPeopleVaccinated
FROM portfolioproject.coviddeaths DEA
Join portfolioproject.covidvaccinations VAC
ON DEA.location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent IS NOT NULL
-- Order By 2, 3

CREATE VIEW 


