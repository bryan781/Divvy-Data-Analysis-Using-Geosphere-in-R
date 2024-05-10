# Divvy Data Analysis using R Studio

## Introduction
Divvy, Chicago's popular bike-sharing program, provides a convenient and sustainable transportation option for residents and visitors alike. To understand user behaviors and ridership patterns, we analyzed Divvy trip data for a twelve-month period, from July 2022 to June 2023. This comprehensive dataset offers valuable insights into how people are using Divvy's extensive network of bicycles and docking stations.
This analysis explores various aspects of Divvy ridership, including the breakdown between casual and annual members, their preferred bike types, average ride characteristics like time and distance, and how these patterns vary throughout the day, week, and year. By examining these trends, we can gain a deeper understanding of how Chicagoans utilize Divvy and potentially inform future program development and optimization efforts.

## Data Overview
I used Divvy Trip Data from July 2022 to June 2023. I used these data to analyze the percentage and differences between casual users and annual member users. I used R studio and R programming language to perform the analysis.

## Libraries
1. ggplot2: The Visual Storyteller
Imagine a library that transforms raw numbers into compelling visuals. That's the magic of ggplot2. This core R library is the go-to choice for creating a wide range of charts and graphs. It follows the "Grammar of Graphics" approach, allowing you to build visualizations layer by layer. With ggplot2, you can create bar charts to compare ridership between casual and annual members, line charts to track hourly ridership patterns, or even scatterplots to explore relationships between ride time and distance. In your Divvy data analysis, ggplot2 was likely instrumental in bringing the ridership patterns to life through informative and clear visualizations.

3. geosphere: A Glimpse into the Geographic Landscape (Optional)
While Divvy trip data might focus on Chicago and not global locations, the geosphere library offers a powerful set of tools for working with geographic data on a spherical Earth. It provides functionalities for calculating distances, bearings, and areas – all on a curved surface. Even though it might not have been directly used in your analysis, including geosphere keeps the door open for future exploration that might involve spatial considerations.

4. tidyverse: A Suite of Data Wrangling Wizards
The tidyverse is a collection of R packages that work together seamlessly for data science tasks. It's like having a team of data wranglers at your fingertips. This powerful suite includes:
- dplyr: This package allows you to manipulate your data using a verb-based syntax. You can filter rows, select columns, and even group data for further analysis. In your Divvy analysis, dplyr might have been used to filter data by user type (casual vs. annual member) or select specific variables like ride duration.
- tidyr: This package focuses on data transformation. It allows you to reshape your data from wide to long formats (and vice versa), making it easier to analyze and visualize. For instance, tidyr could have been used to transform data from separate columns for casual and annual member bike usage into a single format suitable for comparison.
- readr: This package simplifies the process of importing data from various file formats, such as CSV (comma-separated values), which is commonly used for Divvy trip data.
By including tidyverse, you had access to a comprehensive set of tools for cleaning, manipulating, and exploring your Divvy data before diving into the analysis.
5. skimr: Unveiling Data Distributions at a Glance
skimr provides a helping hand when it comes to summarizing and describing your data. This library offers concise summaries of data distributions, including measures of central tendency (like mean and median) and spread (like standard deviation). In your analysis, skimr might have been used to get a quick overview of how ride durations are distributed across casual and annual members, or to understand the range of distances traveled by different user categories.

6. janitor: Keeping Your Data Clean
Data cleaning is a crucial step in any analysis, and janitor offers a set of tools to make it easier. This library provides functions for handling missing values, converting data types (e.g., from text to numeric), and generally improving data quality for analysis. Janitor might have been used to clean your Divvy trip data by removing rows with missing values or converting timestamps into a usable format for further analysis.
