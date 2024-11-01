#### Preamble ####
# Purpose: Testing simulated pollster data for the 2024 US presidential election
# Authors: Tim Chen, Steven Li, Tommy Fu
# Date: 31 October 2024
# Contacts: 
# - Tim Chen: timwt.chen@mail.utoronto.ca
# - Steven Li: stevency.li@mail.utoronto.ca
# - Tommy Fu: tommy.fu@mail.utoronto.ca
# Pre-requisites: 
# - 00-simulate_data.R must have been run
# - The `tidyverse`, `lubridate`, and `testthat` packages must be installed

#### Workspace setup ####
library(tidyverse)
library(testthat)
library(lubridate)

# Read in the simulated data
pollster_data <- read_csv(
  here::here("data/00-simulated_data/simulated_pollster_data.csv"))

######################## Test basic data structure ############################
test_that("Data has correct structure", {
  # Test presence of required columns
  expected_columns <- c("poll_id", "date", "pollster", "state", "method", 
                        "voter_type", "sample_size", "margin_of_error", 
                        "harris_pct", "trump_pct", "undecided")
  expect_true(all(expected_columns %in% colnames(pollster_data)))
  
  # Test number of rows
  expect_equal(nrow(pollster_data), 1000)
  
  # Test for unique poll IDs
  expect_equal(length(unique(pollster_data$poll_id)), 1000)
  expect_false(any(duplicated(pollster_data$poll_id)))
})

########################## Test data types and ranges #######################
test_that("Variables have correct types and ranges", {
  # Test date range
  expect_true(all(pollster_data$date >= as.Date("2024-01-01")))
  expect_true(all(pollster_data$date <= as.Date("2024-10-18")))
  
  # Test sample sizes
  expect_true(all(pollster_data$sample_size >= 600))
  expect_true(all(pollster_data$sample_size <= 1500))
  expect_true(all(pollster_data$sample_size %% 1 == 0))  # integers only
  
  # Test percentage values
  expect_true(all(pollster_data$harris_pct >= 0))
  expect_true(all(pollster_data$harris_pct <= 100))
  expect_true(all(pollster_data$trump_pct >= 0))
  expect_true(all(pollster_data$trump_pct <= 100))
  expect_true(all(pollster_data$undecided >= 0))
  expect_true(all(pollster_data$undecided <= 100))
  
  # Test margin of error
  expect_true(all(pollster_data$margin_of_error > 0))
  expect_true(all(pollster_data$margin_of_error < 10))  # realistic MoE range
})

############################ Test categorical variables ####################
test_that("Categorical variables have correct values", {
  # Test pollster names
  expected_pollsters <- c("YouGov", "RMG Research", "Siena College", 
                          "Morning Consult", "Emerson")
  expect_true(all(pollster_data$pollster %in% expected_pollsters))
  
  # Test methods
  expected_methods <- c("Online", "Mixed", "Phone")
  expect_true(all(pollster_data$method %in% expected_methods))
  
  # Test voter types
  expected_voter_types <- c("LV", "RV")
  expect_true(all(pollster_data$voter_type %in% expected_voter_types))
  
  # Test states
  expected_states <- c("AZ", "GA", "MI", "NV", "PA", "WI", "NAT")
  expect_true(all(pollster_data$state %in% expected_states))
})

######################### Test statistical properties ########################
test_that("Data exhibits expected statistical properties", {
  # Test reasonable distribution of support
  harris_mean <- mean(pollster_data$harris_pct)
  expect_true(harris_mean > 45 && harris_mean < 55)
  
  # Test reasonable standard deviation
  harris_sd <- sd(pollster_data$harris_pct)
  expect_true(harris_sd > 1 && harris_sd < 5)
  
  # Test distribution of sample sizes
  size_mean <- mean(pollster_data$sample_size)
  expect_true(size_mean > 900 && size_mean < 1100)
  
  # Test undecided voter percentages
  undecided_mean <- mean(pollster_data$undecided)
  expect_true(undecided_mean > 2 && undecided_mean < 8)
})

############################ Test data quality ################################
test_that("Data quality meets requirements", {
  # Test for missing values
  expect_false(any(is.na(pollster_data)))
  
  # Test for reasonable sample size distribution
  quantiles <- quantile(pollster_data$sample_size, c(0.25, 0.75))
  iqr <- quantiles[2] - quantiles[1]
  expect_true(iqr > 100 && iqr < 500)  # reasonable spread
})