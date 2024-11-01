#### Preamble ####
# Purpose: Simulates polling data for the 2024 US presidential election between
# Kamala Harris and Donald Trump, incorporating realistic polling features
# Authors: Tim Chen, Steven Li, Tommy Fu
# Date: 31 October 2024
# Contacts: 
# - Tim Chen: timwt.chen@mail.utoronto.ca
# - Steven Li: stevency.li@mail.utoronto.ca
# - Tommy Fu: tommy.fu@mail.utoronto.ca
# Pre-requisites:
# - Packages `tidyverse`, and `lubridate` must be installed and loaded


#### Workspace setup ####
library(tidyverse)
library(lubridate)
set.seed(2024) # For reproducibility

######################## Define simulation parameters ########################
# Key polling parameters based on historical patterns
BASE_HARRIS_SUPPORT <- 51.0  # Starting point for Harris support
POLL_ERROR <- 2.5           # Standard deviation for polling errors
DEM_BIAS <- -1.0           # Historical pro-Democrat bias in polls

# Define a few pollsters and their ratings and method
pollsters <- tribble(
  ~name,           ~rating,  ~method,
  "YouGov",        4.5,     "Online",
  "RMG Research",  4.2,     "Mixed",
  "Siena College", 4.8,     "Phone",
  "Morning Consult",4.3,    "Online",
  "Emerson",       4.0,     "Mixed"
)

# Define swing states with their baseline characteristics
swing_states <- tribble(
  ~state,  ~harris_margin,
  "AZ",     0.5,
  "GA",    -0.3,
  "MI",     2.1,
  "NV",    -0.8,
  "PA",     1.4,
  "WI",     0.9
)

############################ Generate simulated data ########################
# Generate 1000 polls with more frequent polling closer to election
num_polls <- 1000
dates <- as.Date('2024-01-01') + sort(rbeta(num_polls, 2, 1) * 
                                        as.numeric(as.Date('2024-10-18') - as.Date('2024-01-01')))

# Create base dataset
simulated_polls <- tibble(
  poll_id = seq_len(num_polls),
  date = dates,
  # Sample pollsters (more polls from higher-rated pollsters)
  pollster = sample(pollsters$name, num_polls, 
                    prob = pollsters$rating, replace = TRUE),
  # Include both state and national polls
  state = sample(c(swing_states$state, "NAT"), num_polls, 
                 prob = c(rep(2, nrow(swing_states)), 3), replace = TRUE),
  # Generate sample sizes
  sample_size = round(rnorm(num_polls, mean = 1000, sd = 100)),
  # Generate more 'likely voters' closer to election
  voter_type = if_else(
    date > as.Date("2024-08-01"),
    sample(c("LV", "RV"), num_polls, prob = c(0.7, 0.3), replace = TRUE),
    sample(c("LV", "RV"), num_polls, prob = c(0.3, 0.7), replace = TRUE)
  )
)

# Add pollster characteristics
simulated_polls <- simulated_polls %>%
  left_join(pollsters, by = c("pollster" = "name"))

# Add polling results
simulated_polls <- simulated_polls %>%
  left_join(swing_states, by = "state") %>%
  mutate(
    # Calculate base support level
    base_support = case_when(
      state == "NAT" ~ BASE_HARRIS_SUPPORT,
      !is.na(harris_margin) ~ 50 + harris_margin,
      TRUE ~ BASE_HARRIS_SUPPORT
    ),
    
    # Add time trends (slight tightening as election approaches)
    days_to_election = as.numeric(as.Date('2024-11-05') - date),
    time_effect = days_to_election / 300,
    
    # Calculate final percentages with various effects
    harris_pct = base_support + 
      time_effect +
      rnorm(num_polls, 0, POLL_ERROR) +
      DEM_BIAS,
    
    # Ensure percentages are within realistic bounds
    harris_pct = pmax(pmin(harris_pct, 62), 38),
    trump_pct = 100 - harris_pct,
    
    # Add undecided voters
    undecided = pmax(0, rnorm(num_polls, 5, 2)),
    harris_pct = round(harris_pct * (100 - undecided) / 100, 1),
    trump_pct = round(trump_pct * (100 - undecided) / 100, 1),
    undecided = round(undecided, 1),
    
    # Calculate margin of error (95% confidence level)
    margin_of_error = round(1.96 * sqrt(0.5 * 0.5 / sample_size) * 100, 1)
  )

# Create final dataset
final_polls <- simulated_polls %>%
  select(poll_id, date, pollster, state, method, voter_type,
         sample_size, margin_of_error, harris_pct, trump_pct, undecided)

# Save the simulated data
write_csv(final_polls, "data/00-simulated_data/simulated_pollster_data.csv")

############################ Create validation plots ########################
# Polling trends
ggplot(final_polls, aes(x = date, y = harris_pct)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "loess") +
  facet_wrap(~state) +
  labs(title = "Harris Support by State Over Time",
       x = "Date",
       y = "Support (%)") +
  theme_minimal()

# Method distribution
ggplot(final_polls, aes(x = method, fill = voter_type)) +
  geom_bar(position = "dodge") +
  labs(title = "Poll Distribution by Method and Voter Type",
       x = "Method",
       y = "Count") +
  theme_minimal()
