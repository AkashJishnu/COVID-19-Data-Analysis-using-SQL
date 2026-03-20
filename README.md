# COVID-19 Data Analysis using SQL

## Overview
This project analyzes global COVID-19 data using SQL Server to derive insights on infection rates, death rates, and vaccination progress. It demonstrates how raw data can be transformed into meaningful metrics using SQL.

## Dataset
- CovidDeaths  
- CovidVaccinations  

These datasets contain country-level daily data on cases, deaths, population, and vaccinations.

## Key Analysis
- Infection rate as a percentage of population  
- Death rate relative to total cases  
- Countries with highest infection and death percentages  
- Global daily and overall fatality rates  
- Vaccination progress using rolling totals  
- Cross-country vaccination comparisons  

## Key Concepts Used
- Joins (combining datasets)
- Aggregations (SUM, MAX)
- Window functions (rolling totals)
- Common Table Expressions (CTEs)
- Views for reusable analysis
- Handling NULLs and division-by-zero errors

## Important Insight
Total vaccinations can exceed 100% of population because they represent doses administered, not individuals vaccinated. A more accurate metric is people fully vaccinated as a percentage of population.

## Tools
- SQL Server  
- SQL Server Management Studio (SSMS)

## Outcome
This project showcases end-to-end data analysis using SQL, including data cleaning, transformation, and insight generation.

