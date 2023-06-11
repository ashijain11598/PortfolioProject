--data that we'll use
select Location,date,total_cases,new_cases,total_deaths,population
from [Portfolio Project].[dbo].[CovidDeaths]
order by 1,2

--(shows likelihood of dying in India) total cases vs total deaths in a country
select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as percentageofdeathcase
from [Portfolio Project].[dbo].[CovidDeaths]
where Location='India'

--shows what percentage of people got covid in India
select Location, date, total_cases,population, (total_cases/population)*100 as percentageofaffectedpeople
from [Portfolio Project].[dbo].[CovidDeaths]
where Location='India'

--looking at country with highest affection rate
select Location, population, MAX(total_cases) as highestinfectioncount,MAX(total_cases/population)*100 as Highestaffectedrate
from [Portfolio Project].[dbo].[CovidDeaths]
group by Location, population
order by 4 desc

--looking at country with highest death count
select Location, population, MAX(total_deaths) as highestinfectioncount,MAX(total_deaths/population)*100 as Highestdeathrate
from [Portfolio Project].[dbo].[CovidDeaths]
group by Location, population
order by 4 desc

--breaking by continent
select Location, population, MAX(total_deaths) as highestinfectioncount
from [Portfolio Project].[dbo].[CovidDeaths]
where continent is null
group by Location, population
order by highestinfectioncount desc

--global numbers each day
select date, sum(total_cases) as total_cases_each_day
from [Portfolio Project].[dbo].[CovidDeaths]
group by date
order by 2 desc

--total population vs vaccination

with popvsvac (continent,Location,date,population,new_vaccinations,Rollingpeoplevaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated
from [Portfolio Project].[dbo].[CovidDeaths] as dea
join
[Portfolio Project].[dbo].[CovidVaccinations] as vac
on
dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--group by dea.location,dea.continent,dea.date
--order by 2,3 desc
)
select * ,(Rollingpeoplevaccinated/population)*100 as percentpopulationvccinated from popvsvac



