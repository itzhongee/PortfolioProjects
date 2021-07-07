SELECT * FROM PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
ORDER BY 3,4

--SELECT * FROM PORTFOLIOPROJECT..CovidVaccinations
--ORDER BY 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract COVID-19 in your country
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
AND Location like '%states%'
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows percentage of population contracted COVID-19
Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
AND Location like '%states%'
Order by 1,2

-- Looking at countries with highest infection rates compared to population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)*100) as PercentPopulationInfected
From PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
Group by Location, Population
Order by PercentPopulationInfected desc

-- Looking at countries with highest death rates compared to population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc


-- GLOBAL NUMBERS
-- Looking at total cumulative cases, deaths and death percentage
Select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

-- Looking at total cases, deaths and death percentage currently
Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PORTFOLIOPROJECT..CovidDeaths
Where continent is not null
--Group by date
Order by 1,2


-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinatedPercentage
From PopvsVac

-- Temp Table

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as RollingPeopleVaccinatedPercentage
From #PercentPopulationVaccinated


-- Creating View to store data for later visualisations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(Convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated