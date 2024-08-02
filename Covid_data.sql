
-- Covid 19 data SQL

SELECT * 
FROM PortfolioProject..CovidDeath
where continent is not null
order by 3,4

--Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeath
order by 1,2

SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'CovidDeath'

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeath 
WHERE Location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population get Covid
Select Location, date, Population, total_cases, (total_cases/Population)*100 as DeathPercentage
FROM PortfolioProject..CovidDeath 
WHERE Location like '%malaysia%'
order by 1,2

-- Looking at countries with highest Infection rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfection, MAX((total_cases/Population)*100) as PercentPopulationInfected
FROM PortfolioProject..CovidDeath 
WHERE Location like '%malaysia%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Showing the continent with highest Death Count per Population
Select continent, MAX(total_deaths) as TotalDeathCount
FROM PortfolioProject..CovidDeath 
--WHERE Location like '%malaysia%'
Where continent is not null 
--not null kena ada sebab ada row yang null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeath 
WHERE continent is not null
--Group by date
order by 1,2


-- Looking at Total Population vs Vaccination
-- dea and vac act as alias so do not need to type everything all over again
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeath dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeath dea
Join PortfolioProject..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


Select location, SUM(new_deaths) as TotalDeathCount
From PortfolioProject..CovidDeath
Where continent is null
and location not in ('High income','Upper middle income','Lower middle income','Low income','World', 'European Union', 'International')
group by location
order by TotalDeathCount desc

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeath
Group by Location, Population, date
Order by PercentPopulationInfected desc

