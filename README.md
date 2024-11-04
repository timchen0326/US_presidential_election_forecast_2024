# US Presidential Election Forecast 2024

## Overview

This repository provides a forecast for the 2024 U.S. Presidential Election between Kamala Harris and Donald Trump, using state-level polling data to predict Electoral College outcomes. Utilizing over 800 polls from July to October 2024, we developed statistical models incorporating pollster reliability, sample size, and state-specific variables to simulate the Electoral College distribution, forecasting 306 votes for Harris and 232 for Trump. The analysis highlights the importance of state-level predictions over national averages, especially in battleground states, to enhance forecasting accuracy. Additionally, the repository evaluates polling methodologies and their influence on candidate support, underscoring the need for transparency and rigorous methodology in electoral forecasting. The repository includes data, code, and documentation supporting the analysis and findings.

## Repository Structure

- **data/**
  - `00-simulated_data/`: Contains simulated data used for testing and validation.
    - `simulated_pollster_data.csv`
  - `01-raw_data/`: Contains the raw polling data.
    - `president_polls.csv`
  - `02-analysis_data/`: Contains cleaned and processed data for analysis.
    - `analysis_data.parquet`

- **models/**: Contains saved model objects in RDS format for the analysis of Harris and Trump polling data.
  - `mlr_harris_model_final.rds`
  - `mlr_harris_model_refined.rds`
  - `mlr_harris_model.rds`
  - `mlr_trump_model_final.rds`
  - `mlr_trump_model.rds`

- **other/**
  - `llm_usage/`: Documentation of interactions with large language models.
    - `01-usage-steven.txt`
    - `02-usage-tim.txt`
    - `03-usage-tommy.txt`
  - `sketches/`: Visual materials related to exploratory data analysis.
    - `dataset.jpg`
    - `eda.jpg`
    - `output.jpg`

- **paper/**: Files related to the final research paper.
  - `paper.pdf`: The final report.
  - `paper.qmd`: Quarto document used for generating the report.
  - `references.bib`: Bibliography for the report.

- **scripts/**: R scripts used in data simulation, processing, analysis, and modeling.
  - `00-simulate_data.R`: Script for generating simulated data.
  - `01-test_simulated_data.R`: Tests the integrity of simulated data.
  - `02-clean_data.R`: Cleans the raw data for analysis.
  - `03-test_analysis_data.R`: Tests the cleaned data for analysis readiness.
  - `04-exploratory_data_analysis.R`: Performs exploratory data analysis (EDA).
  - `05-model_data.R`: Builds and refines models for analysis.

- `.gitignore`: Lists files and directories ignored by Git.
- `README.md`: This file, providing an overview of the project structure.
- `us_presidential_election_forecast_2024.Rproj`: R project file for the analysis.

## Statement on LLM Usage

Aspects of the code were written with the assistance of ChatGPT-4o. The abstract and introduction were crafted using ChatGPT-4o. The entire chat history is saved in other/llm_usage/usage.txt.
