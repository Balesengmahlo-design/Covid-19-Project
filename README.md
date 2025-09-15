# Covid-19-Project
This is a project about Covid using SQL Server to transform data
This project explores global COVID-19 data using SQL Server, focusing on cleaning, analyzing, and extracting insights from real-world datasets. I began by selecting the data sources and converting critical columns such as total_cases and total_deaths from nvarchar to float for accurate numerical analysis.

The analysis covers multiple perspectives, including total cases vs. total deaths to show the likelihood of dying if you contracted COVID-19 in different countries, as well as total cases vs. population to highlight countries with the highest infection rates relative to their population.

I also identified the countries with the highest death count per population, then broke the data down further by continents to reveal which regions were most impacted in terms of death per population.

In addition to regional breakdowns, I aggregated global numbers to provide a broader picture of the pandemic’s impact.

To make future analysis easier, I created a SQL view that stores vaccination progress data and allows for quick access to calculate metrics such as vaccination percentages.

🔧 SQL Features Used:
Data Cleaning: Converted nvarchar fields (e.g., total_cases, total_deaths) to numeric (float) for proper aggregation.
Joins: Combined COVID cases and vaccination datasets for richer insights.
Aggregate Functions: Used SUM(), MAX(), and other aggregations to calculate totals and rates.
Window Functions: Applied OVER(PARTITION BY … ORDER BY …) to compute rolling vaccination counts.
CTEs (Common Table Expressions): Simplified complex queries and made intermediate results more readable.
Views: Created reusable views for vaccination progress and population analysis.
Ordering & Filtering: Analyzed results at global, continental, and country levels with ORDER BY and WHERE conditions.

