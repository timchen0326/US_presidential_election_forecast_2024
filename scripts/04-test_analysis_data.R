#### Preamble ####
# Purpose: Testing cleaned pollster data for the 2024 US presidential election,
#          ensuring data quality and consistency with expected formats
# Authors: Tim Chen, Steven Li, Tommy Fu
# Date: 18 October 2024
# Contacts: 
# - Tim Chen: timwt.chen@mail.utoronto.ca
# - Steven Li: stevency.li@mail.utoronto.ca
# - Tommy Fu: tommy.fu@mail.utoronto.ca
# Pre-requisites: 
# - 03-clean_data.R must have been run
# - The `tidyverse`, `lubridate`, and `testthat` package must be installed and loaded


#### Workspace setup ####
library(tidyverse)
library(testthat)
library(lubridate)

# Read in the data
pollster_data <- read_parquet(here("data/02-analysis_data/analysis_data.parquet"))

############################ Test Data Structure ############################
test_that("Data has correct structure and identifiers", {
  # Test for required columns
  expected_cols <- c("poll_id", "pollster_id", "pollster", "numeric_grade",
                     "pollscore", "methodology", "transparency_score", 
                     "sample_size", "population", "population_full", "party", 
                     "answer", "pct", "state", "candidate_name", "end_date", 
                     "candidate_binary", "num_supporters")
  expect_equal(colnames(pollster_data), expected_cols)
  
  # Test relationship between poll_id and pollster_id
  expect_true(all(!is.na(pollster_data$poll_id)))
  expect_true(all(!is.na(pollster_data$pollster_id)))
})

######################## Test Data Types and Formats ########################
test_that("Variables have correct data types", {
  # Test numeric variables
  numeric_vars <- c("poll_id", "pollster_id", "numeric_grade", "pollscore",
                    "transparency_score", "sample_size", "pct", 
                    "candidate_binary", "num_supporters")
  for(var in numeric_vars) {
    expect_true(is.numeric(pollster_data[[var]]), 
                info = paste(var, "should be numeric"))
  }
  
  # Test character variables
  char_vars <- c("pollster", "methodology", "population", "population_full",
                 "party", "answer", "state", "candidate_name")
  for(var in char_vars) {
    expect_true(is.character(pollster_data[[var]]), 
                info = paste(var, "should be character"))
  }
  
  # Test date variables
  expect_true(inherits(pollster_data$end_date, "Date"))
})

######################## Test Value Ranges and Categories ####################
test_that("Variables have valid values and categories", {
  # Test numeric ranges
  expect_true(all(pollster_data$numeric_grade >= 1 & 
                    pollster_data$numeric_grade <= 5))
  expect_true(all(pollster_data$transparency_score >= 0 & 
                    pollster_data$transparency_score <= 10))
  expect_true(all(pollster_data$pct >= 0 & pollster_data$pct <= 100))
  expect_true(all(pollster_data$sample_size >= 100))  # reasonable minimum
  
  # Test categorical values
  expect_true(all(pollster_data$population %in% c("rv", "lv", "a")))
  expect_true(all(pollster_data$party %in% c("DEM", "REP")))
  expect_true(all(pollster_data$answer %in% c("Harris", "Trump")))
})

############################ Test Data Consistency ############################
test_that("Data shows internal consistency", {
  # Test population consistency
  expect_true(all(pollster_data$population_full %in% 
                    c("lv", "rv", "a")))
  expect_true(all((pollster_data$population == "lv" & 
                     pollster_data$population_full == "lv") |
                    (pollster_data$population == "rv" & 
                       pollster_data$population_full == "rv") |
                    (pollster_data$population == "a" & 
                       pollster_data$population_full == "a")))
  
  # Test party-candidate consistency
  expect_true(all((pollster_data$party == "DEM" & 
                     pollster_data$answer == "Harris") |
                    (pollster_data$party == "REP" & 
                       pollster_data$answer == "Trump")))
  
  # Test binary encoding
  expect_true(all((pollster_data$answer == "Harris" & 
                     pollster_data$candidate_binary == 1) |
                    (pollster_data$answer == "Trump" & 
                       pollster_data$candidate_binary == 0)))
})

############################ Test Temporal Aspects ############################
test_that("Dates are logical and within expected range", {
  # Test date range
  expect_true(all(pollster_data$end_date >= as.Date("2024-01-01")))
  expect_true(all(pollster_data$end_date <= as.Date("2024-10-18")))
  
  # Test date is before election
  expect_true(all(pollster_data$end_date < as.Date("2024-11-05")))
})

#### Test Data Quality ####
test_that("Data quality meets requirements", {
  # Test for missing values in critical columns
  critical_cols <- c("poll_id", "pollster", "pct", "answer", 
                     "end_date", "state", "sample_size")
  for(col in critical_cols) {
    expect_false(any(is.na(pollster_data[[col]])),
                 info = paste("Missing values in", col))
  }
  
  # Test pollscore consistency
  expect_true(all(is.na(pollster_data$pollscore) | 
                    (pollster_data$pollscore >= -5 & 
                       pollster_data$pollscore <= 5)))
  
  # Test number of supporters calculation
  pollster_data <- pollster_data %>%
    mutate(calculated_supporters = round(pct * sample_size / 100))
  expect_true(all(abs(pollster_data$num_supporters - 
                        pollster_data$calculated_supporters) <= 1))
})

############################ Test Methodological Aspects ####################
test_that("Methodology information is consistent", {
  # Test valid methodology types
  valid_methods <- c("Online Panel", "Probability Panel", "Live Phone", 
                     "IVR/Online Panel/Text-to-Web", 
                     "Live Phone/Online Panel/Text-to-Web", 
                     "Live Phone/Text-to-Web", "Online Panel/Text-to-Web",
                     "Live Phone/Text-to-Web/Email/Mail-to-Web/Mail-to-Phone",
                     "Online Ad", "Live Phone/Online Panel/Text", 
                     "Live Phone/Email")
  expect_true(all(pollster_data$methodology %in% valid_methods))
  
  # Test transparency score relationship with methodology
  # Higher transparency scores should have methodology information
  high_transparency <- pollster_data$transparency_score >= 8
  expect_true(all(!is.na(pollster_data$methodology[high_transparency])))
})

############################ Test Statistical Properties ####################
test_that("Statistical properties are reasonable", {
  # Test percentage distribution
  state_means <- pollster_data %>%
    group_by(state) %>%
    summarise(mean_pct = mean(pct[answer == "Harris"]))
  expect_true(all(state_means$mean_pct >= 30 & state_means$mean_pct <= 70))
  
  # Test sample size distribution
  expect_true(median(pollster_data$sample_size) >= 500)
  expect_true(quantile(pollster_data$sample_size, 0.95) <= 5000)
})