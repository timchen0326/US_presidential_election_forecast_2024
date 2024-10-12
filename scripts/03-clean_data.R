#### Preamble ####
# Purpose: Cleans the raw polling data, focusing on Kamala Harris and Donald Trump
# Author: [Your Name]
# Date: [Today's Date]
# Contact: [Your Email]
# License: MIT
# Pre-requisites: Requires 'president_polls.csv' file in 'data/01-raw_data/'
# Any other information needed? This script filters polling data for Harris and Trump only.

#### Workspace setup ####
# Load necessary library
library(dplyr)

# Read the dataset
polls <- read.csv("data/01-raw_data/president_polls.csv")

# Filter for only Kamala Harris and Donald Trump
polls_clean <- polls %>%
  filter(answer %in% c("Harris", "Trump")) %>%
  mutate(
    # Clean up population descriptions
    population = case_when(
      population == "a" ~ "Adults",
      population == "v" ~ "Voters",
      population == "lv" ~ "Likely Voters",
      population == "rv" ~ "Registered Voters",
      TRUE ~ population  # Keep original value if no match
    )
  )

# Select only the desired columns and drop rows with NA values
polls_clean <- polls_clean %>%
  select(answer, state, population, sample_size) %>%
  drop_na()

# Save the cleaned dataset as a new CSV file
write.csv(polls_clean, "data/02-analysis_data/analysis_data.csv", row.names = FALSE)
