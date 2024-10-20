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

harris_data <- subset(analysis_data, candidate_name == "Kamala Harris")

#### Model data ####
# Convert categorical variables to factors for Kamala Harris
harris_data$state <- as.factor(harris_data$state)
harris_data$methodology <- as.factor(harris_data$methodology)

# Build MLR model for Kamala Harris
mlr_harris_model <- lm(pct ~ numeric_grade + pollscore + transparency_score + sample_size + state + methodology, 
                       data = harris_data)

#### Save model ####
# Save the model to an .rds file for future use
saveRDS(mlr_harris_model, file = "models/mlr_harris_model.rds")


# Filter for Donald Trump data only
trump_data <- subset(analysis_data, candidate_name == "Donald Trump")

#### Model data ####
# Convert categorical variables to factors for Donald Trump
trump_data$state <- as.factor(trump_data$state)
trump_data$methodology <- as.factor(trump_data$methodology)

# Build MLR model for Donald Trump
mlr_trump_model <- lm(pct ~ numeric_grade + pollscore + transparency_score + sample_size + state + methodology, 
                      data = trump_data)

#### Save model ####
# Save the model to an .rds file for future use
saveRDS(mlr_trump_model, file = "models/mlr_trump_model.rds")


mlr_harris_model_refined <- lm(pct ~ numeric_grade + pollscore + sample_size + state, data = harris_data)

saveRDS(mlr_harris_model_refined, file = "models/mlr_harris_model_refined.rds")


mlr_harris_model_final <- lm(pct ~ pollscore + log(sample_size) + state, data = harris_data)
mlr_trump_model_final <- lm(pct ~ pollscore + log(sample_size) + state, data = trump_data)

saveRDS(mlr_harris_model_final, file = "models/mlr_harris_model_final.rds")
saveRDS(mlr_trump_model_final, file = "models/mlr_trump_model_final.rds")




