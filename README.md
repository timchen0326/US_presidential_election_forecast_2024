# US Presidential Election Forecast 2024

## Overview

This repository presents a statistical model designed to forecast the outcome of the 2024 U.S. Presidential Election. By leveraging polling data from multiple sources, we develop multiple linear regression models to predict the support percentages for the main candidates, Kamala Harris and Donald Trump, across various states. These predictions are then aggregated to simulate the Electoral College vote and estimate the likelihood of either candidate winning. Preliminary results indicate that neither candidate currently secures the necessary 270 electoral votes to claim victory.

## File Structure

The repository is structured as follows:

- **data/**
  - `00-simulated_data/`: Contains the simulated data generated for model testing.
    - `simulated_data.csv`
    - `simulated_pollster_data.csv`
  - `01-raw_data/`: Contains the raw polling data used for analysis.
    - `president_polls.csv`
  - `02-analysis_data/`: Contains cleaned and analyzed data that was constructed from the raw data.
    - `analysis_data.csv`
    - `harris_analysis_data.csv`

- **models/**: Contains fitted models for both Harris and Trump, saved in RDS format.
  - `mlr_harris_model_final.rds`
  - `mlr_harris_model_refined.rds`
  - `mlr_harris_model.rds`
  - `mlr_trump_model_final.rds`
  - `mlr_trump_model.rds`

- **other/**:
  - `datasheet/`: Contains the datasheet template for the project.
    - `datasheet_template.pdf`
    - `datasheet_template.qmd`
  - `llm_usage/`: Includes documentation about interactions with large language models (LLMs).
    - `usage.txt`
  - `sketches/`: Contains images related to exploratory data analysis and dataset exploration.
    - `dataset.jpg`
    - `eda.jpg`
    - `output.jpg`

- **paper/**: Contains files used to generate the final paper.
  - `paper.pdf`: The final report in PDF format.
  - `paper.qmd`: The Quarto document used to generate the report.
  - `political_preferences.rds`: RDS file with political preference data.
  - `references.bib`: Bibliography file with references for the paper.

- **scripts/**: Contains R scripts for simulating, downloading, cleaning, and analyzing the data.
  - `00-simulate_data.R`
  - `01-test_simulated_data.R`
  - `02-download_data.R`
  - `03-clean_data.R`
  - `04-test_analysis_data.R`
  - `05-exploratory_data_analysis.R`
  - `06-model_data.R`
  - `07-replications.R`

- `.gitignore`: Specifies files to ignore in version control.
- `us_presidential_election_forecast_2024.Rproj`: The R project file.
- `README.md`: This file.

## Statement on LLM Usage

Aspects of the code were written with the assistance of ChatGPT-4o. The abstract and introduction were crafted using ChatGPT-4o. The entire chat history is saved in other/llm_usage/usage.txt.
