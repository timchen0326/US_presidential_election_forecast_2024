#### Preamble ####
# Purpose: Testing simulated pollster data for the 2024 US presidential election
# Authors: Tim Chen, Steven Li, Tommy Fu
# Date: 18 October 2024
# Contacts: 
# - Tim Chen: timwt.chen@mail.utoronto.ca
# - Steven Li: stevency.li@mail.utoronto.ca
# - Tommy Fu: tommy.fu@mail.utoronto.ca
# Pre-requisites: 
  # - 00-simulate_data.R must have been run
  # - The `tidyverse`, `lubridate`, and `testthat` package must be installed and loaded

#### Workspace setup ####
library(tidyverse)
library(testthat)
library(lubridate)

# Read in the data
pollster_data <- read_csv("data/00-simulated_data/simulated_pollster_data.csv")

########################### Tests for Pollster Data########################### 

test_that("Pollster data has correct structure", {
  expected_cols <- c("poll_id", "date", "pollster", "pollster_rating", "method", 
                     "state", "voter_type", "party", "winner", "percentage")
  expect_equal(colnames(pollster_data), expected_cols)
  expect_true(is.numeric(pollster_data$poll_id))
  expect_true(inherits(pollster_data$date, "Date"))
  expect_true(is.character(pollster_data$pollster))
  expect_true(is.numeric(pollster_data$pollster_rating))
  expect_true(is.character(pollster_data$method))
  expect_true(is.character(pollster_data$state))
  expect_true(is.character(pollster_data$voter_type))
  expect_true(is.character(pollster_data$party))
  expect_true(is.character(pollster_data$winner))
  expect_true(is.numeric(pollster_data$percentage))
})

test_that("Pollster data has valid values", {
  expect_true(all(!is.na(pollster_data)))
  expect_true(all(pollster_data$date >= as.Date("2024-01-01") & 
                    pollster_data$date <= as.Date("2024-10-18")))
  expect_true(all(pollster_data$pollster_rating >= 1 & pollster_data$pollster_rating <= 5))
  expect_true(all(pollster_data$percentage >= 0 & pollster_data$percentage <= 100))
})

test_that("Poll IDs are unique", {
  expect_equal(length(unique(pollster_data$poll_id)), nrow(pollster_data))
})

test_that("Method values are valid", {
  valid_methods <- c("Online", "Phone", "Mixed")
  expect_true(all(pollster_data$method %in% valid_methods))
})

test_that("State values are valid", {
  expect_true(all(pollster_data$state %in% state.abb))
})

test_that("Voter type values are valid", {
  valid_voter_types <- c("Likely Voters", "Registered Voters", "All Adults")
  expect_true(all(pollster_data$voter_type %in% valid_voter_types))
})

test_that("Party values are valid", {
  valid_parties <- c("Republican", "Democrat")
  expect_true(all(pollster_data$party %in% valid_parties))
})

test_that("Winner values are valid", {
  valid_winners <- c("Trump", "Harris")
  expect_true(all(pollster_data$winner %in% valid_winners))
})

test_that("Dataset has expected number of rows", {
  expect_equal(nrow(pollster_data), 1000)
})

test_that("Dataset has expected number of columns", {
  expect_equal(ncol(pollster_data), 10)
})

test_that("There are no empty strings in character columns", {
  char_cols <- c("pollster", "method", "state", "voter_type", "party", "winner")
  expect_true(all(pollster_data[char_cols] != ""))
})

test_that("Pollster column has at least two unique values", {
  expect_true(n_distinct(pollster_data$pollster) >= 2)
})
