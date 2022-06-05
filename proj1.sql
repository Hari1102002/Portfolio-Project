select*
from PortfolioProj1..['covid death$']
order by 3,4

select*
from PortfolioProj1..vaccine$
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProj1..['covid death$']
order by 1,2

-- Total Case vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPer
from PortfolioProj1..['covid death$']
where location like '%india%'
order by 1,2

-- Total case vs Population

select location, date, total_cases, population, (total_cases/population)*100 as CasePer
from PortfolioProj1..['covid death$']
where location like '%india%'
order by 1,2

-- Countries with highest infection rate

select location, population, MAX(total_cases) as HighestCases, MAX(total_cases/population)*100 as MaxPopulationInfected
from PortfolioProj1..['covid death$']
Group by location, population
order by MaxPopulationInfected desc

-- Countries with highest deaths

select location, MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioProj1..['covid death$']
Where continent is not null
Group by location, population
order by TotalDeaths desc

-- Continent with highest deaths

select continent, MAX(cast(total_deaths as int)) as TotalDeaths
from PortfolioProj1..['covid death$']
Where continent is not null
Group by continent
order by TotalDeaths desc

-- World Data by Date

select date, SUM(new_cases) as TotalCAse, SUM(CAST(total_deaths as int)) as TotalDeath, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPer
from PortfolioProj1..['covid death$']
where continent is not null
Group by Date
order by 1,2

-- Total Cases
select SUM(new_cases) as TotalCAse, SUM(CAST(new_deaths as int)) as TotalDeath, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPer
from PortfolioProj1..['covid death$']
where continent is not null
order by 1,2

-- Total Vaccination 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as PercentageVaccinated
from PortfolioProj1..['covid death$'] dea
join PortfolioProj1..vaccine$ vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Percentage people vaccinated

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, totalvaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as TotalVaccinated
from PortfolioProj1..['covid death$'] dea
join PortfolioProj1..vaccine$ vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
)
Select*, (totalvaccinated/Population)*100
From PopvsVac



-- View to store data

Create view PercentVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM (CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as TotalVaccinated
from PortfolioProj1..['covid death$'] dea
join PortfolioProj1..vaccine$ vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null