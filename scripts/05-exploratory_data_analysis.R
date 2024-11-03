#### Preamble ####
# Purpose: Perform Exploratory Data Analysis (EDA) on polling data for Kamala Harris and Donald Trump, and save the plots as images.
# Authors: Tim Chen, Steven Li, Tommy Fu
# Date: 3 November 2024
# Contacts: 
# - Tim Chen: timwt.chen@mail.utoronto.ca
# - Steven Li: stevency.li@mail.utoronto.ca
# - Tommy Fu: tommy.fu@mail.utoronto.ca
# Pre-requisites: 
# - Requires cleaned 'analysis_data.csv' with filtered data for Harris and Trump in the 'data/02-analysis_data/' directory
# - The following R packages must be installed: 'dplyr', 'knitr', 'caret', 'tidyverse', 'Metrics'
# - This script performs model training on national polling data for both candidates and calculates RMSE performance metrics

# Install and load the caret package if you haven't already
install.packages("caret")
library(dplyr)
library(knitr)
library(caret)
library(tidyverse)
analysis_data <- read_csv("data/02-analysis_data/analysis_data.csv")
harris_data <- subset(analysis_data, candidate_name == "Kamala Harris")
trump_data <- subset(analysis_data, candidate_name == "Donald Trump")

# Filter data for National level polls only
harris_national <- subset(harris_data, state == "National")
trump_national <- subset(trump_data, state == "National")

# Ensure reproducibility
set.seed(304)

# Split the national data into training and test sets
split_harris <- createDataPartition(harris_national$pct, p = 0.7, list = FALSE)
harris_train <- harris_national[split_harris, ]
harris_test <- harris_national[-split_harris, ]

split_trump <- createDataPartition(trump_national$pct, p = 0.7, list = FALSE)
trump_train <- trump_national[split_trump, ]
trump_test <- trump_national[-split_trump, ]

# Fit the model for Kamala Harris on the national training data
mlr_harris_model_national <- lm(pct ~ pollscore + log(sample_size), data = harris_train)

# Fit the model for Donald Trump on the national training data
mlr_trump_model_national <- lm(pct ~ pollscore + log(sample_size), data = trump_train)

# Predict on the national test data for Kamala Harris
harris_test$predicted_pct_harris <- predict(mlr_harris_model_national, newdata = harris_test)

# Predict on the national test data for Donald Trump
trump_test$predicted_pct_trump <- predict(mlr_trump_model_national, newdata = trump_test)

# Calculate performance metrics for national polls
library(Metrics)

# RMSE for Harris model (National)
rmse_harris_national <- rmse(harris_test$pct, harris_test$predicted_pct_harris)

# RMSE for Trump model (National)
rmse_trump_national <- rmse(trump_test$pct, trump_test$predicted_pct_trump)

print(paste("RMSE for Harris model (National):", rmse_harris_national))
print(paste("RMSE for Trump model (National):", rmse_trump_national))
