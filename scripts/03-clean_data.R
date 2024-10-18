#### Preamble ####
# Purpose: Prepare polling data for the multi-linear regression model
# Authors: Tim Chen, Steven Li, Tommy Fu
# Date: 18 October 2024
# Contacts: 
# - Tim Chen: timwt.chen@mail.utoronto.ca
# - Steven Li: stevency.li@mail.utoronto.ca
# - Tommy Fu: tommy.fu@mail.utoronto.ca
# Pre-requisites:
# - Requires downloading presidential polls data as 'president_polls.csv' file in 'data/01-raw_data/'
# - Packages `tidyverse`, `dplyr`, `janitor`, and `lubridate` must be installed and loaded

#### Workspace setup ####
# Load necessary libraries
library(dplyr)
library(tidyverse)
library(janitor)
library(lubridate)

########################### Data Import and Cleaning########################### 
# Read the dataset and clean column names
data <- read_csv("data/01-raw_data/president_polls.csv") |>
  clean_names()

###################### Filter Data for Both Candidates ########################
# Filter data for Kamala Harris and Donald Trump based on high-quality polls
filtered_data <- data |>
  # Select only the specified columns
  select(poll_id, pollster_id, pollster, numeric_grade, pollscore, methodology, 
         transparency_score, sample_size, population, population_full, party, 
         answer, pct, state, end_date
  ) |>
  filter(
    answer %in% c("Harris", "Trump"), # Keep only Harris and Trump
    numeric_grade >= 2.7 # Filter high-quality polls
  ) |>
  filter( # Filter polls after each candidate declared
    (answer == "Harris" & end_date >= as.Date("2024-07-21")) | 
      (answer == "Trump" & end_date >= as.Date("2024-07-21"))
  ) |>
  mutate(
    state = if_else(is.na(state), "National", state), # Fix for national polls
    end_date = mdy(end_date), # Convert end date to date format
    num_supporters = round((pct / 100) * sample_size, 0), # Convert percentage to number of supporters
    candidate_binary = ifelse(answer == "Harris", 1, 0) # Binary encoding for Harris (1) and Trump (0)
  ) |>
  drop_na()

# Save the cleaned dataset as a new CSV file
write.csv(filtered_data, "data/02-analysis_data/analysis_data.csv", row.names = FALSE)