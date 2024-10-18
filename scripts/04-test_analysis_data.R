#### Preamble ####
# Purpose: Testing cleaned pollster data for the 2024 US presidential election
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
pollster_data <- read_csv("data/02-analysis_data/analysis_data.csv")

########################### Tests for Pollster Data########################### 

test_that("Pollster data has correct structure", {
  expected_cols <- c("poll_id", "pollster_id", "pollster", "numeric_grade", "pollscore",
                     "methodology", "transparency_score", "sample_size", "population",
                     "population_full", "party", "answer", "pct", "state",
                     "end_date", "num_supporters", "candidate_binary")
  expect_equal(colnames(pollster_data), expected_cols)
})

test_that("Data types are correct", {
  expect_true(is.numeric(pollster_data$poll_id))
  expect_true(is.numeric(pollster_data$pollster_id))
  expect_true(is.character(pollster_data$pollster))
  expect_true(is.numeric(pollster_data$numeric_grade))
  expect_true(is.numeric(pollster_data$pollscore))
  expect_true(is.character(pollster_data$methodology))
  expect_true(is.numeric(pollster_data$transparency_score))
  expect_true(is.numeric(pollster_data$sample_size))
  expect_true(is.character(pollster_data$population))
  expect_true(is.character(pollster_data$population_full))
  expect_true(is.character(pollster_data$party))
  expect_true(is.character(pollster_data$answer))
  expect_true(is.numeric(pollster_data$pct))
  expect_true(is.character(pollster_data$state))
  expect_true(inherits(pollster_data$end_date, "Date"))
  expect_true(is.numeric(pollster_data$num_supporters))
  expect_true(is.numeric(pollster_data$candidate_binary))
})

test_that("Numeric values are within expected ranges", {
  expect_true(all(pollster_data$numeric_grade >= 0 & pollster_data$numeric_grade <= 5))
  expect_true(all(pollster_data$pollscore >= -5 & pollster_data$pollscore <= 5))
  expect_true(all(pollster_data$transparency_score >= 0 & pollster_data$transparency_score <= 10))
  expect_true(all(pollster_data$sample_size > 0))
  expect_true(all(pollster_data$pct >= 0 & pollster_data$pct <= 100))
  expect_true(all(pollster_data$candidate_binary %in% c(0, 1)))
})

test_that("Character values are valid", {
  expect_true(all(pollster_data$population %in% c("rv", "lv", "a")))
  expect_true(all(pollster_data$party %in% c("DEM", "REP")))
  expect_true(all(pollster_data$answer %in% c("Harris", "Trump")))
})

test_that("Dates are within expected range", {
  expect_true(all(pollster_data$end_date >= as.Date("2024-01-01") & 
                    pollster_data$end_date <= as.Date("2024-10-18")))
})

test_that("No missing values in critical columns", {
  critical_cols <- c("poll_id", "pollster", "pct", "answer", "end_date")
  expect_true(all(!is.na(pollster_data[critical_cols])))
})

test_that("Percentages sum to 100 (or close to it) for each poll", {
  poll_totals <- pollster_data %>%
    group_by(poll_id) %>%
    summarize(total_pct = sum(pct))
  expect_true(all(poll_totals$total_pct >= 99 & poll_totals$total_pct <= 101))
})

test_that("Candidate binary values match answer names", {
  expect_true(all((pollster_data$answer == "Harris" & pollster_data$candidate_binary == 1) |
                    (pollster_data$answer == "Trump" & pollster_data$candidate_binary == 0)))
})

test_that("Number of supporters is consistent with percentage and sample size", {
  pollster_data <- pollster_data %>%
    mutate(calculated_supporters = round(pct * sample_size / 100))
  expect_true(all(abs(pollster_data$num_supporters - pollster_data$calculated_supporters) <= 1))
})
