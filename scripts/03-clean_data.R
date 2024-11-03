#### Preamble ####
# Purpose: Prepare and filter polling data to build a multiple linear regression model predicting popular vote percentages for Kamala Harris and Donald Trump.
# Author: Tim Chen, Steven Li, Tommy Fu
# Date: 3 November 2024
# Contact: 
# - Tim Chen: timwt.chen@mail.utoronto.ca
# - Steven Li: stevency.li@mail.utoronto.ca
# - Tommy Fu: tommy.fu@mail.utoronto.ca
# Pre-requisites: 
# - Ensure the 'president_polls.csv' file is located in 'data/01-raw_data/'
# - The following R packages must be installed: 'dplyr', 'tidyverse', 'janitor', 'lubridate', 'arrow', 'here'
# - Polling data will be filtered for high-quality entries and limited to Harris and Trump, with necessary data transformations for modeling.

#### Workspace setup ####
# Load necessary libraries

library(dplyr)
library(tidyverse)
library(janitor)
library(lubridate)
library(arrow)
library(here)


########################### Data Import and Cleaning########################### 
# Read the dataset and clean column names
data <- read_csv("data/01-raw_data/president_polls.csv") |>
  clean_names()

####################### Filter Data for Both Candidates #######################
# Filter data for Kamala Harris and Donald Trump based on high-quality polls
filtered_data <- data |>
  filter(
    candidate_name %in% c("Kamala Harris", "Donald Trump"), # Keep only Harris and Trump
    numeric_grade >= 2.7 # Filter high-quality polls
  ) |>
  mutate(
    state = if_else(is.na(state), "National", state), # Fix for national polls
    end_date = mdy(end_date) # Convert end date to date format
  ) |>
  filter( # Filter polls after each candidate declared
    (candidate_name == "Kamala Harris" & end_date >= as.Date("2024-07-21")) | 
    (candidate_name == "Donald Trump" & end_date >= as.Date("2024-07-21"))
  ) |>
  mutate(
    num_supporters = round((pct / 100) * sample_size, 0), # Convert percentage to number of supporters
    candidate_binary = ifelse(candidate_name == "Kamala Harris", 1, 0) # Binary encoding for Harris (1) and Trump (0)
  ) |>
  # Select only the specified columns
  select(poll_id, pollster_id, pollster, numeric_grade, pollscore, methodology, 
         transparency_score, sample_size, population, population_full, party, 
         answer, pct, state, candidate_name, end_date, candidate_binary, num_supporters
  ) |>
  drop_na()

write_parquet(filtered_data,
  here("data", "02-analysis_data", "analysis_data.parquet"))

