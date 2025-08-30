**Covid-19 Data Exploration in SQL Server**
This project explores global COVID-19  data using SQL Server, focuusing on cleaning, analysing, and extracting insights from real-world datasets.
It started with Selecting the data sources and converting critical columns such as total_cases and total_deaths from nvarchar to float for accurate numerical analysis. 
The analysis covers mulitple perspectives, including **total cases vs. tatal deaths** to show the likelihood of dying if you contracted COVID-19 in different countries, as well as **total cases vs. population to highlight countries with the highest infection rates relative to their population.
Also identified the countries with the highest death count per population, then broke the data down further by **continents** to reveal which regions were most impacted in terms of death per population.
In addition to regional breakdowns, **global numbers** were aggregated to provide a broader picture of the pandemic's impact. 
To make future analysis easier, an **SQL view** that stores vaccination progress data and allows for quick access to calculate metrics such as vaccination percentages was created.

**SQL Features Used**
*Data Cleaning:* Converted nvarchar fields (e.g, total_cases, total_deaths) to numeric(float) for proper aggregation.
*Joins:* Combined COVID cases and vaccination datasets for richer insights.
*Aggregate Functions:* Used SUM(), MAX(), and other aggregations to calculate tatals and rates.
*Window Functions:* Applied OVER(PARTITION BY...ORDER BY ...) to compute rolling vaccination counts.
*CTEs(Common Table Exoressions):* Simplified complex queries and made intermediate reesults more readable 
*Views:* Created resuable views for vaccination progress and population analysis.
*Ordering & Filtering:* Analyzed results at global, continental, and country levels with ORDER BY and WHERE conditions.
