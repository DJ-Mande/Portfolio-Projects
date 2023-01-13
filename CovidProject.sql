SELECT *
FROM coviddeaths
WHERE 'continent' is not null
ORDER BY 3,4;

-- SELECT DATA THAT WE ARE GOING TO BE USING

SELECT Location, date, total_cases, new_cases,total_deaths, population
FROM coviddeaths
WHERE 'continent' is not null
ORDER BY 1,2;

-- looking for total cases vd total deaths
-- shoes likelyhood of dying if you contract contract

SELECT Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
WHERE location = 'United States'
ORDER BY 1,2;

-- looking at Total cases VS Population
-- shows what percentage of pop got covid
SELECT Location, date,Population, total_cases,(total_cases/population)*100 as PercentOfPopulationInfected
FROM coviddeaths
WHERE location = 'United States'
ORDER BY 1,2;

-- Looking at countries with highest infection rate compared to population

SELECT Location,Population, MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/population))*100 as PercentOfPopulationInfected
FROM coviddeaths
WHERE 'continent' is not null
GROUP BY Location, Population
ORDER BY PercentOfPopulationInfected DESC;

-- showing countries with highest death count per population

SELECT Location, MAX(CAST(total_deaths AS UNSIGNED)) as TotalDeathCount
FROM coviddeaths
WHERE 'continent' is not null
GROUP BY Location
ORDER BY TotalDeathCount desc;

-- IS NULL
SELECT Location, MAX(CAST(total_deaths AS UNSIGNED)) as TotalDeathCount
FROM coviddeaths
WHERE 'continent' is not null
GROUP BY Location
ORDER BY TotalDeathCount desc;


-- Break down by continent

SELECT continent, MAX(CAST(total_deaths AS UNSIGNED)) as TotalDeathCount
FROM coviddeaths
WHERE 'continent'is not null
GROUP BY continent
ORDER BY TotalDeathCount desc;

-- global numbers

SELECT date, SUM(new_cases)
FROM coviddeaths
WHERE 'continent' is not null
GROUP BY date
ORDER BY 1,2;

SELECT date, SUM(new_cases), SUM(CAST(new_deaths AS UNSIGNED)) as DeathPercentage
FROM coviddeaths
WHERE 'continent' is not null
GROUP BY date
ORDER BY 1,2;

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths AS UNSIGNED)), SUM(CAST(new_deaths AS UNSIGNED))/SUM(new_cases)*100  as DeathPercentage
FROM coviddeaths
WHERE 'continent' is not null
GROUP BY date
ORDER BY 1,2;

-- looking at total pop vs vacc
SELECT *
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date;


WITH PopvsVac (Continent,location, date, population, New_Vaccinatations, RollingPeopleVaccinated)
as(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(vac.new_vaccinations)
 OVER (partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
);





-- TEMP TABLE

CREATE TABLE #PercentPopulationVaccinated(
continent nvarchar(255) NOT NULL,
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,SUM(vac.new_vaccinations)
 OVER (partition by dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
FROM coviddeaths AS dea
JOIN covidvaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
);
