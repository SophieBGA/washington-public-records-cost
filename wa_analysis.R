library(tidyverse)
library(hexbin)

options(scipen = 10)

# what directory is the file in
path <- "/Users/svanpelt/Documents/projects/court_transparency/unprocessed_data/"

# set the path to the directory the file is in
setwd(path)

# I don't like copying and pasting the file name all the time
file <- "jlarc_full_dataset.csv"

# load data 
df <- read_csv(file)

head(df)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# County Level Analysis

unique(df$agency_category)

counties <- df %>% 
  filter(agency_category == "County")

counties <- counties %>%
  separate(agency_name, into = c("county", "subtype"), sep = "-")

write_csv(counties, "jlarc_counties_dataset.csv")

counties <- read_csv("jlarc_counties_dataset.csv")

counties$subtype <- trimws(counties$subtype, which = c("left"))

unique(counties$subtype)

counties_centralized <- counties %>%
  filter(subtype == "Centralized")
  
counties_centralized_drop_nas <- counties_centralized %>%
  filter(!is.na(total_requests))
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

counties_centralized_drop_nas %>%
  sapply(mean, na.rm = TRUE)

counties_centralized_drop_nas %>%
  sapply(median, na.rm = TRUE)

counties_centralized_drop_nas %>%
  sapply(min, na.rm = TRUE)

counties_centralized_drop_nas %>%
  sapply(max, na.rm = TRUE)

counties_centralized_drop_nas %>%
  sapply(sd, na.rm = TRUE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ggplot(data = counties_centralized_drop_nas) +
  geom_histogram(mapping = aes(x = requests_cost))


ggplot(data = counties_centralized_drop_nas) +
  geom_histogram(mapping = aes(x = avg_est_staff_hours)) +
  labs(x = "Average Est. Hours Spent Per Request", y = "Count", title = "Hours Spent Responding Per Request")


ggplot(data = counties_centralized_drop_nas, mapping = aes(x = requests_cost, y = reporting_status)) +
  geom_boxplot() +
  labs(x = "Total Cost of Requests", y = "Reporting Status", title = "Cost of Request by Reporting Status")

ggplot(data = counties_centralized_drop_nas) + 
  geom_hex(mapping = aes(x = total_requests, y = requests_cost)) +
  labs(x = "Total Number of Requests", y = "Total Cost of Requests", title = "Total Requests by Total Cost")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cor(x = counties_centralized_drop_nas$total_requests,y = counties_centralized_drop_nas$requests_cost, use = "na.or.complete")
