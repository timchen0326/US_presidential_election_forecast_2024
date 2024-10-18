#### Preamble ####
# Purpose: Cleans the raw polling data, focusing on Kamala Harris and Donald Trump
# Author: [Your Name]
# Date: [Today's Date]
# Contact: [Your Email]
# License: MIT
# Pre-requisites: Requires 'president_polls.csv' file in 'data/01-raw_data/'
# Any other information needed? This script filters polling data for Harris and Trump only.
install.packages("janitor")
#### Workspace setup ####
# Load necessary library
library(dplyr)
library(tidyverse)
library(janitor)

# Read the dataset
data <- read_csv("data/01-raw_data/president_polls.csv") |>
  clean_names()

# Filter data to Harris estimates based on high-quality polls after she declared
just_harris_high_quality <- data |>
  filter(
    candidate_name == "Kamala Harris",
    numeric_grade >= 2.7 # Need to investigate this choice - come back and fix. 
    # Also need to look at whether the pollster has multiple polls or just one or two - filter out later
  ) |>
  mutate(
    state = if_else(is.na(state), "National", state), # Hacky fix for national polls - come back and check
    end_date = mdy(end_date)
  ) |>
  filter(end_date >= as.Date("2024-07-21")) |> # When Harris declared
  mutate(
    num_harris = round((pct / 100) * sample_size, 0) # Need number not percent for some models
  )

# Save the cleaned dataset as a new CSV file
write.csv(just_harris_high_quality, "data/02-analysis_data/analysis_data.csv", row.names = FALSE)



