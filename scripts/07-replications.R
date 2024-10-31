#### Preamble ####
# Purpose: Replicated graphs from... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

# Final models for Harris and Trump
mlr_harris_model_final <- readRDS(here::here(("models/mlr_harris_model_final.rds")))
mlr_trump_model_final <- readRDS(here::here(("models/mlr_trump_model_final.rds")))

# Predict poll percentages for Kamala Harris
harris_data$predicted_pct_harris <- predict(mlr_harris_model_final, newdata = harris_data)

# Predict poll percentages for Donald Trump
trump_data$predicted_pct_trump <- predict(mlr_trump_model_final, newdata = trump_data)
# Define electoral votes for each state (and Washington, D.C.)
electoral_votes <- data.frame(
  state = c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", 
            "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", 
            "Maine CD-1", "Maine CD-2", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", 
            "Missouri", "Montana", "Nebraska", "Nebraska CD-1", "Nebraska CD-2", "Nebraska CD-3", "Nevada", 
            "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", 
            "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", 
            "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming", 
            "District of Columbia"),
  electoral_votes = c(9, 3, 11, 6, 55, 9, 7, 3, 29, 16, 4, 4, 20, 11, 6, 6, 8, 8, 2, 1, 1, 10, 11, 15, 10, 6, 10, 
                      3, 5, 1, 1, 2, 6, 4, 14, 5, 29, 16, 3, 18, 7, 6, 20, 4, 9, 3, 11, 38, 6, 3, 13, 12, 5, 10, 3, 3)
)

# Aggregate predictions by state for Harris and Trump
harris_state_avg <- aggregate(predicted_pct_harris ~ state, data = harris_data, FUN = mean)
trump_state_avg <- aggregate(predicted_pct_trump ~ state, data = trump_data, FUN = mean)

# Merge predictions for both candidates
prediction_comparison <- merge(harris_state_avg, trump_state_avg, by = "state", all.x = TRUE)

# Merge the electoral votes with the predictions
prediction_comparison <- merge(prediction_comparison, electoral_votes, by = "state", all.x = TRUE)

# Determine the winner for each state
prediction_comparison$winner <- ifelse(prediction_comparison$predicted_pct_harris > prediction_comparison$predicted_pct_trump, "Harris", "Trump")

# Calculate total electoral votes for Kamala Harris
harris_electoral_votes <- sum(prediction_comparison$electoral_votes[prediction_comparison$winner == "Harris"], na.rm = TRUE)

# Calculate total electoral votes for Donald Trump
trump_electoral_votes <- sum(prediction_comparison$electoral_votes[prediction_comparison$winner == "Trump"], na.rm = TRUE)

# Print the results
print(paste("Harris Electoral Votes:", harris_electoral_votes))
print(paste("Trump Electoral Votes:", trump_electoral_votes))

# Determine the predicted winner
if (harris_electoral_votes >= 270) {
  print("Kamala Harris is predicted to win the 2024 election.")
} else if (trump_electoral_votes >= 270) {
  print("Donald Trump is predicted to win the 2024 election.")
} else {
  print("No candidate reached 270 electoral votes.")
}

# Load necessary libraries
library(reshape2)
library(ggplot2)

# Melt data for easier plotting
prediction_melted <- melt(prediction_comparison, id.vars = c("state", "electoral_votes", "winner"),
                          measure.vars = c("predicted_pct_harris", "predicted_pct_trump"))

# Rename melted variables for readability
colnames(prediction_melted)[colnames(prediction_melted) == "variable"] <- "candidate"
prediction_melted$candidate <- ifelse(prediction_melted$candidate == "predicted_pct_harris", "Harris", "Trump")

# Create the bar plot with improved aesthetics
vote_percentage_plot <- ggplot(prediction_melted, aes(x = reorder(state, electoral_votes), y = value, fill = candidate)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7) +
  coord_flip() +
  labs(
       x = "State",
       y = "Predicted Vote Percentage (%)") +
  scale_fill_manual(values = c("Harris" = "#87CEFA", "Trump" = "#F08080"), # Softer colors
                    labels = c("Kamala Harris", "Donald Trump")) +
  theme_classic() +
  theme(
    text = element_text(size = 12, family = "Arial"),   # General text size
    plot.title = element_text(size = 14, face = "bold"),  # Title size
    axis.text.y = element_text(size = 10),               # Y-axis (state names) text size
    axis.text.x = element_text(size = 10),               # X-axis (percentages) text size
    legend.title = element_blank(),                      # Remove legend title
    legend.position = "top",                             # Position legend at top
    legend.text = element_text(size = 12)                # Legend text size
  ) +
  geom_text(aes(label = round(value, 1)),                # Add labels with rounded percentages
            position = position_dodge(width = 0.7), hjust = -0.2, size = 3)

# Display the plot
print(vote_percentage_plot)

# Save the plot as a PNG file
ggsave("improved_vote_percentages_by_state.png", plot = vote_percentage_plot, width = 10, height = 8, dpi = 300)


