#### Preamble ####
# Purpose: Perform Exploratory Data Analysis (EDA) on polling data for Kamala Harris and Donald Trump, and save the plots as images.
# Author: [Your Name]
# Date: [Today's Date]
# Contact: [Your Email]
# License: MIT
# Pre-requisites: Requires cleaned 'analysis_data.csv' with filtered data for Harris and Trump

#### Workspace setup ####
# Load necessary libraries
library(dplyr)
library(ggplot2)
library(naniar)
library(tidyverse)

#### Load the cleaned dataset ####
# Read the cleaned CSV file
filtered_data <- read_csv("data/02-analysis_data/analysis_data.csv")

#### 1. Overview of the Dataset ####
# Overview of the data structure
print("Overview of dataset:")
glimpse(filtered_data)

# Summary statistics for numeric variables
print("Summary statistics:")
summary(filtered_data)

# Checking for missing values
print("Visualizing missing data:")
vis_miss(filtered_data)

#### 2. Univariate Analysis ####

# 2.1 Distribution of polling percentages for Harris and Trump
png("distribution_polling_percentages.png")
ggplot(filtered_data, aes(x = pct, fill = candidate_name)) +
  geom_histogram(binwidth = 2, position = "dodge") +
  labs(title = "Distribution of Polling Percentages: Harris vs Trump",
       x = "Polling Percentage (%)", y = "Count") +
  theme_minimal()
dev.off()  # Close the PNG device

# 2.2 Distribution of sample sizes
png("distribution_sample_sizes.png")
ggplot(filtered_data, aes(x = sample_size)) +
  geom_histogram(binwidth = 100) +
  labs(title = "Distribution of Sample Sizes", x = "Sample Size", y = "Count") +
  theme_minimal()
dev.off()  # Close the PNG device

#### 3. Bivariate Analysis ####

# 3.1 Polling percentages over time for Harris and Trump
png("polling_percentages_over_time.png")
ggplot(filtered_data, aes(x = end_date, y = pct, color = candidate_name)) +
  geom_line() +
  geom_point() +
  labs(title = "Polling Percentages Over Time: Harris vs Trump",
       x = "Poll End Date", y = "Polling Percentage (%)") +
  theme_minimal()
dev.off()  # Close the PNG device

# 3.2 Polling percentage vs. sample size
png("polling_vs_sample_size.png")
ggplot(filtered_data, aes(x = sample_size, y = pct, color = candidate_name)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Polling Percentage vs. Sample Size",
       x = "Sample Size", y = "Polling Percentage (%)") +
  theme_minimal()
dev.off()  # Close the PNG device

#### 4. Handling Missing Data ####

# Missing data visualization
png("missing_data_visualization.png")
vis_miss(filtered_data)
dev.off()  # Close the PNG device

#### 5. Outliers and Anomalies ####

# 5.1 Boxplot of polling percentages by candidate
png("boxplot_polling_percentages.png")
ggplot(filtered_data, aes(x = candidate_name, y = pct, fill = candidate_name)) +
  geom_boxplot() +
  labs(title = "Boxplot of Polling Percentages: Harris vs Trump",
       y = "Polling Percentage (%)") +
  theme_minimal()
dev.off()  # Close the PNG device

# 5.2 Boxplot of sample sizes by candidate
png("boxplot_sample_sizes.png")
ggplot(filtered_data, aes(x = candidate_name, y = sample_size, fill = candidate_name)) +
  geom_boxplot() +
  labs(title = "Boxplot of Sample Sizes: Harris vs Trump",
       y = "Sample Size") +
  theme_minimal()
dev.off()  # Close the PNG device

#### Completion Message ####
print("EDA completed successfully, and plots saved as PNG images!")
