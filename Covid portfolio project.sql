Select * from PortfolioProject1..CovidDeaths order by 3,4

--Select * from PortfolioProject1..CovidVaccinations Order by 3,4

--Select data that we are going to use
Select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject1..CovidDeaths order by 1,2

--Total cases VS total deaths
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercent
from PortfolioProject1..CovidDeaths where location like '%India%' order by 1,2

--Total cases VS Population
Select location,date,total_cases,population,(total_cases/population)*100 as DeathPercentoverpopulation
from PortfolioProject1..CovidDeaths 
--where location like '%India%' 
order by 1,2

--Countries with Highest Infection rate compared to population
Select location,population,MAX(total_cases) as highestinfection,MAX((total_cases/population))*100 as InfectedPercentoverpopulation
from PortfolioProject1..CovidDeaths 
Group by location,population
--where location like '%India%' 
order by InfectedPercentoverpopulation desc


--Countries with highest  death count per population
Select continent,MAX(CAST(total_deaths as int)) as highestdeaths
from PortfolioProject1..CovidDeaths
where continent is not NULL
Group by continent
order by highestdeaths desc
--where location like '%India%' 

--Continents with highest death count
Select continent,MAX(CAST(total_deaths as int)) as highestdeaths
from PortfolioProject1..CovidDeaths
where continent is not NULL
Group by continent
order by highestdeaths desc


--GLOBAL NUMBERS

Select sum(new_cases)as total_cases,SUM(CAST(new_deaths as int))as total_deaths ,SUM(CAST(new_deaths as int))/sum(new_cases)*100 as DeathPercent
from PortfolioProject1..CovidDeaths 
where continent is not null and location like '%India%'
--group by date
order by 1,2


Select date,sum(new_cases)as total_cases,SUM(CAST(new_deaths as int))as total_deaths ,SUM(CAST(new_deaths as int))/sum(new_cases)*100 as DeathPercent
from PortfolioProject1..CovidDeaths 
where continent is not null 
group by date
order by 1,2


--Total population VS vaccinations

Select * from PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
ON dea.location=vac.location 
and dea.date=vac.date


Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingpplvacc
from PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
ON dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null 
Order by 2,3


--TEMP table


DROP TABLE if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
rollingpplvacc numeric 
)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingpplvacc
from PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
ON dea.location=vac.location 
and dea.date=vac.date
--where dea.continent is not null 
--Order by 2,3



--Creating view to store data fr later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingpplvacc
from PortfolioProject1..CovidDeaths dea
JOIN PortfolioProject1..CovidVaccinations vac
ON dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null 
--Order by 2,3

Select * from PercentPopulationVaccinated