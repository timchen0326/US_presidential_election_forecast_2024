#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")

### Model data ####
# Summary statistics for numeric variables
summary(analysis_data)

# Detailed summary of specific variables
analysis_data %>%
  summarize(
    avg_pct = mean(pct, na.rm = TRUE),
    median_pct = median(pct, na.rm = TRUE),
    sd_pct = sd(pct, na.rm = TRUE),
    avg_sample_size = mean(sample_size, na.rm = TRUE),
    min_sample_size = min(sample_size, na.rm = TRUE),
    max_sample_size = max(sample_size, na.rm = TRUE)
  )

analysis_data

