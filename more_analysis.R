library(tidyverse)
library(hexbin)
library(gtsummary)

options(scipen = 10)

# what directory is the file in
path <- "/Users/svanpelt/Documents/projects/court_transparency/processed_data/"

# set the path to the directory the file is in
setwd(path)

# files
complete <- "jlarc_only_complete_cases_dataset.csv"
counties <- "jlarc_counties_dataset.csv"

# load data 
df_complete <- read_csv(complete)
df_counties <- read_csv(counties, skip = 1)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# clerks
df_county_clerk <- df_counties %>%
  filter(subtype == "Clerk")

df_county_clerk %>%
  select(
    `Total Number Of Requests` = total_requests,
    `Total Staff Hours Spent` = est_staff_hours_spent,
    `Average Staff Hours Per Request` = avg_est_staff_hours
  ) %>%
  tbl_summary(
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean}", "{median} ({p25}, {p75})", "{sd}", "{min}, {max}")
  )


`Total Cost Of Requests` = requests_cost,
`Average Cost Per Request` = avg_est_total_cost,
`Total Litigation Cost` = total_litigation_cost,