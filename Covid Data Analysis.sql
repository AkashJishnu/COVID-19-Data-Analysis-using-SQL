-- Data Exploration

SELECT * 
FROM dbo.CovidDeaths
ORDER BY location, date;

SELECT * 
FROM dbo.CovidVaccinations
ORDER BY location, date;


-- Selected Columns for Analysis

SELECT 
    location, 
    date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
FROM dbo.CovidDeaths
ORDER BY location, date;


-- Total Cases vs Total Deaths (India)

SELECT 
    location,
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths * 100.0 / NULLIF(total_cases,0)) AS DeathPercentage
FROM dbo.CovidDeaths
WHERE location = 'India'
ORDER BY location, date;


-- Total Cases vs Population (India)

SELECT 
    location,
    date, 
    population,
    total_cases, 
    (total_cases * 100.0 / population) AS InfectionPercentage
FROM dbo.CovidDeaths
WHERE location = 'India'
ORDER BY location, date;


-- Countries with Highest Infection Rate

SELECT 
    location, 
    population,
    MAX(total_cases) AS TotalCases,
    MAX(total_cases * 100.0 / population) AS InfectionPercentage
FROM dbo.CovidDeaths
GROUP BY location, population
ORDER BY InfectionPercentage DESC;


-- Countries with Highest Death Percentage

SELECT 
    location, 
    population,
    MAX(total_deaths) AS TotalDeaths,
    MAX(total_deaths * 100.0 / population) AS DeathPercentage
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY DeathPercentage DESC;


-- Continents with Highest Death Count

SELECT 
    location AS continent,
    MAX(total_deaths) AS TotalDeaths
FROM dbo.CovidDeaths
WHERE continent IS NULL
AND location IN ('Asia','Europe','Africa','North America','South America','Oceania')
GROUP BY location
ORDER BY TotalDeaths DESC;


-- Global Daily Numbers

SELECT 
    date,
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths,
    ROUND(SUM(new_deaths) * 100.0 / NULLIF(SUM(new_cases), 0), 4) AS FatalityRate
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


-- Global Overall Numbers

SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths,
    ROUND(SUM(new_deaths) * 100.0 / NULLIF(SUM(new_cases), 0), 4) AS FatalityRate
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL;


-- Join Deaths and Vaccinations

SELECT 
    *
FROM dbo.CovidDeaths d
JOIN dbo.CovidVaccinations v
    ON d.location = v.location
    AND d.date = v.date;


-- Rolling Vaccination Count

SELECT 
    d.continent,
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (
        PARTITION BY d.location 
        ORDER BY d.date
    ) AS RollingSumVaccinations
FROM dbo.CovidDeaths d
JOIN dbo.CovidVaccinations v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.continent IS NOT NULL
ORDER BY d.location, d.date;


-- Vaccination Progress using CTE

WITH VaccinationCTE AS (
    SELECT 
        d.continent,
        d.location,
        d.date,
        d.population,
        v.new_vaccinations,
        SUM(v.new_vaccinations) OVER (
            PARTITION BY d.location 
            ORDER BY d.date
        ) AS RollingSumVaccinations
    FROM dbo.CovidDeaths d
    JOIN dbo.CovidVaccinations v
        ON d.location = v.location
        AND d.date = v.date
    WHERE d.continent IS NOT NULL
)
SELECT 
    *,
    (RollingSumVaccinations * 100.0 / population) AS DosePerPopulation
FROM VaccinationCTE;


-- Create View for Reusable Vaccination Analysis

CREATE VIEW DosePerPopulation AS
SELECT 
    d.continent,
    d.location,
    d.date,
    d.population,
    v.new_vaccinations,
    SUM(v.new_vaccinations) OVER (
        PARTITION BY d.location 
        ORDER BY d.date
    ) AS RollingSumVaccinations,
    (SUM(v.new_vaccinations) OVER (
        PARTITION BY d.location 
        ORDER BY d.date
    ) * 100.0 / d.population) AS DosePerPopulation
FROM dbo.CovidDeaths d
JOIN dbo.CovidVaccinations v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.continent IS NOT NULL;


-- Countries by Actual Vaccination Percentage (People Fully Vaccinated)

SELECT 
    d.location,
    MAX(v.people_fully_vaccinated * 100.0 / d.population) AS VaccinatedPercentage
FROM dbo.CovidDeaths d
JOIN dbo.CovidVaccinations v
    ON d.location = v.location
    AND d.date = v.date
WHERE d.continent IS NOT NULL
GROUP BY d.location
ORDER BY VaccinatedPercentage DESC;