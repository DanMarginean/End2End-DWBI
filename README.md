# End2End-DWBI
In this project, I developed a complete data pipeline and dashboarding solution for simulating and analyzing retail sales data. The project covered the full data lifecycle—from synthetic data generation in Python, through data ingestion and transformation in Snowflake, to interactive visualization in Power BI.

End2End DWBI Project
Overview
The End2End DWBI (Data Warehouse and Business Intelligence) project involves various components aimed at building a robust data pipeline, visualizing the data in Power BI, and working with SQL queries to interact with Snowflake.

This repository contains the codebase for the project, along with supporting files for data storage, transformation, and visualization.

Project Structure
StoreProject.pbix:
This is the Power BI project file, which contains the Power BI reports and visualizations. It connects to data sources and provides dashboards and insights based on the underlying data.

snowflake_project_all.sql:
This file contains a set of SQL queries for querying and managing data within the Snowflake data warehouse. The queries cover various data transformation, extraction, and loading operations to support the project’s data pipeline.

DataPipeline/:
This folder contains the core codebase for managing and processing data. It includes the necessary Python code, configuration files, and other resources for executing the data pipeline operations.

Setup Instructions
Clone the Repository:

git clone <repository-url>
cd End2End-DWBI
Set Up Dependencies: If you're working with Python, install the required dependencies:

Power BI Project: Open the StoreProject.pbix file in Power BI Desktop to view or modify the Power BI reports and dashboards. You may need to configure the data source connections as per your environment.

SQL Queries for Snowflake: Open snowflake_project_all.sql in a SQL editor (such as Snowflake Web UI, DBeaver, or any preferred SQL tool). Run the queries as needed to manage or transform data within the Snowflake data warehouse.


Here is a screenshot of the Power BI report from the `StoreProject.pbix` file:

![Power BI Report Screenshot](images/Screenshot 2025-05-01 181413.png)

