#### Preamble ####
# Purpose: Simulates a dataset of Australian electoral divisions, including the 
  #state and party that won each division.
# Author: Rohan Alexander
# Date: 26 September 2024
# Contact: rohan.alexander@utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)

#### Simulate data ####

# Create a dataset by randomly assigning states and parties to divisions
# Load necessary libraries
library(tidyverse)

# Set seed for reproducibility
set.seed(853)

# Number of observations for the simulation
num_obs <- 1000

# Simulating data based on variables in the provided president polls CSV
president_poll_simulation <- tibble(
  pollster = sample(c("InsiderAdvantage", "YouGov", "ActiVote"), size = num_obs, replace = TRUE),
  state = sample(c("Pennsylvania", "Arizona", "Texas", "Florida", "Ohio"), size = num_obs, replace = TRUE),
  sample_size = sample(400:1500, size = num_obs, replace = TRUE),
  methodology = sample(c("Text", "App Panel", "Online Panel"), size = num_obs, replace = TRUE),
  population = sample(c("lv", "rv"), size = num_obs, replace = TRUE), # Likely Voters (lv), Registered Voters (rv)
  candidate_name = sample(c("Kamala Harris", "Donald Trump", "Jill Stein"), size = num_obs, replace = TRUE),
  party = case_when(
    candidate_name == "Kamala Harris" ~ "DEM",
    candidate_name == "Donald Trump" ~ "REP",
    candidate_name == "Jill Stein" ~ "GRE"
  ),
  pct = rnorm(num_obs, mean = 50, sd = 5), # Simulating percentage of support
  pollster_rating_name = sample(c("A+", "A", "B", "C"), size = num_obs, replace = TRUE),
  election_date = as.Date("2024-11-05"), # Fixed election date
  poll_start_date = sample(seq(as.Date("2024-09-01"), as.Date("2024-10-07"), by = "day"), size = num_obs, replace = TRUE),
  poll_end_date = sample(seq(as.Date("2024-10-08"), as.Date("2024-10-10"), by = "day"), size = num_obs, replace = TRUE)
) %>%
  mutate(
    supports_candidate = if_else(pct > 50, "yes", "no")
  )

# Show the first few rows of the simulated data
head(president_poll_simulation)





#### Save data ####
write_csv(president_poll_simulation, "data/00-simulated_data/simulated_data.csv")
