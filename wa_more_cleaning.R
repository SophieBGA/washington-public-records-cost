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
df_full <- read_csv(file)

# get complete cases
df_full$complete_case <- df_full %>% 
  select(total_requests, est_staff_hours_spent, avg_est_staff_hours, requests_cost, avg_est_total_cost, total_litigation_cost) %>%
  complete.cases()

colnames(df_full)

df_full <- df_full %>%
  select(agency_name, year, agency_category, agency_type, above_100K, total_requests, est_staff_hours_spent, avg_est_staff_hours, requests_cost, avg_est_total_cost, total_litigation_cost, complete_case)

write_csv(df_full, "jlarc_full_dataset_with_complete_cases.csv")
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# creating sub-datasets

df_dropped_nas <- df_full %>%
  filter(complete_case == TRUE)
write_csv(df_dropped_nas, "jlarc_only_complete_cases_dataset.csv")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

counties <- df_dropped_nas %>%
  filter(agency_category == "County")

counties <- counties %>%
  separate(agency_name,into = c("county", "subtype"), sep = "-")

counties$subtype <- trimws(counties$subtype, which = "left")

write_csv(counties, "jlarc_counties_dataset.csv")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
citites_towns <- df_dropped_nas %>%
  filter(agency_category %in% c("City/Town", "City/town"))
write_csv(citites_towns, "jlarc_citites_towns_dataset.csv")
