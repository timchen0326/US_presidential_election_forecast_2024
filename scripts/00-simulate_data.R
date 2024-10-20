#### Preamble ####
# Purpose: Simulates a dataset of US pollster polling outcomes
# Authors: Tim Chen, Steven Li, Tommy Fu
# Date: 18 October 2024
# Contacts: 
# - Tim Chen: timwt.chen@mail.utoronto.ca
# - Steven Li: stevency.li@mail.utoronto.ca
# - Tommy Fu: tommy.fu@mail.utoronto.ca
# Pre-requisites:
# - Packages `tidyverse`, and `lubridate` must be installed and loaded


#### Workspace setup ####
library(tidyverse)
library(lubridate)

#### Data expectations ####
# Pollster Data:
# - Columns: poll_id, pollster, pollster_rating, method, state, voter_type, party, winner, percentage
# - poll_id should be unique
# - Date should be between 2024-01-01 and 2024-10-18
# - pollster_rating should be between 1 and 5
# - method should be one of: "Online", "Phone", "Mixed"
# - state should be valid US state abbreviations
# - voter_type should be one of: "Likely Voters", "Registered Voters", "All Adults"
# - party should be one of: "Republican", "Democrat"
# - winner should be one of: "Trump", "Harris"
# - percentage should be between 0 and 100

set.seed(2024)

########################### Simulate Pollster Data ############################ 
num_polls <- 1000

pollster_data <- tibble(
  poll_id = seq(1, num_polls),
  date = sample(seq(as.Date('2024-01-01'), as.Date('2024-10-18'), by="day"), 
                num_polls, replace=TRUE),
  pollster = sample(c("PollsterA", "PollsterB", "PollsterC", 
                      "PollsterD", "PollsterE"), num_polls, replace=TRUE),
  pollster_rating = round(runif(num_polls, 1, 5), 1),
  method = sample(c("Online", "Phone", "Mixed"), num_polls, replace=TRUE),
  state = sample(state.abb, num_polls, replace=TRUE),
  voter_type = sample(c("Likely Voters", "Registered Voters"), 
                      num_polls, replace=TRUE),
  party = sample(c("Republican", "Democrat"), num_polls, replace=TRUE),
  winner = sample(c("Trump", "Harris"), num_polls, replace=TRUE),
  percentage = round(runif(num_polls, 40, 60), 1)
)

# Adjust percentages based on winner
pollster_data <- pollster_data %>%
  mutate(percentage = case_when(
    winner == "Trump" ~ percentage,
    winner == "Harris" ~ 100 - percentage
  ))

############################## Visualizations  ##############################
# Poll results over time
pollster_data %>%
  ggplot(aes(x = date, y = percentage, color = winner)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(title = "Poll Results Over Time",
       x = "Date",
       y = "Percentage",
       color = "Candidate") +
  theme_minimal()

# Distribution of poll methods
pollster_data %>%
  count(method) %>%
  ggplot(aes(x = method, y = n, fill = method)) +
  geom_col() +
  labs(title = "Distribution of Poll Methods",
       x = "Method",
       y = "Count") +
  theme_minimal()

# Average poll results by state
pollster_data %>%
  group_by(state, winner) %>%
  summarise(avg_percentage = mean(percentage)) %>%
  ggplot(aes(x = reorder(state, avg_percentage), y = avg_percentage, 
             fill = winner)) +
  geom_col() +
  coord_flip() +
  labs(title = "Average Poll Results by State",
       x = "State",
       y = "Average Percentage",
       fill = "Candidate") +
  theme_minimal()

# Save the simulated data
write_csv(pollster_data, "data/00-simulated_data/simulated_pollster_data.csv")