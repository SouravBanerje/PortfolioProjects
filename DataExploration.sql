--select *
--from PortfolioProject..CovidDeaths
--where continent is not null
--order by 3,4


----select *
----from PortfolioProject..CovidVaccinations
----order by 3,4

----select Data that we are going to be using

--select location, date, total_cases, new_cases,total_deaths,population
--from PortfolioProject..CovidDeaths
--order by 1,2

----Looking at Total Cases vs Total Deaths
----shows likelihood of dying if you cantract covid in your country
--select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
--from PortfolioProject..CovidDeaths
--where location like '%india%'
--order by 1,2

----Looking at Total cases vs Population
--select location, date, total_cases,population,(total_cases/population)*100 as CasePercentage
--from PortfolioProject..CovidDeaths
--where location like '%india%'
--order by 1,2

----Looking at countries with Highest Infection Rate compared to population
--select location, population, MAX(total_cases) as HighestInfectionCount, 
--MAX((total_cases/population))*100 as CasePercentage
--from PortfolioProject..CovidDeaths
--group by location,population
--order by CasePercentage desc

--showing countries with Highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


--Total population vs Vaccination
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 1,2,3


select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

--use cte
with PopvsVac(continent,location,date,population,New_Vaccination,RollingPeopleVaccinated)

as(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 1,2,3
)
select *from PopvsVac