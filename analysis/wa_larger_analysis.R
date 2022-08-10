library(tidyverse)
library(readxl)
library(gtsummary)

# what directory is the file in
path <- "/Users/svanpelt/Documents/projects/court_transparency/unprocessed_data"

# set the path to the directory the file is in
setwd(path)

df <- read_csv("jlarc_merged_cleaned.csv", col_names = TRUE)

head(df)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# agency_name,
# year,
# agency_category,
# reporting_status,
# total_requests,
# est_staff_hours_spent,
# est_total_cost_responding_to_reqs,
# true_man_total_cost,
# total_litigation_cost

df_complete_cases2 <- df %>%
  filter(
    complete_case2 == TRUE
  )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df_complete_cases2 %>%
  select(
    total_requests,
    est_staff_hours_spent,
    avg_est_staff_hours_spent,
    est_total_cost_responding_to_reqs,
    avg_est_cost_responding_per_req,
    total_litigation_cost,
    man_staff_cost,
    man_service_cost,
    man_system_cost,
    man_service_cost,
    man_third_party_cost,
    man_total_cost,
    expenses_recovered
  ) %>%
  tbl_summary(
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean}", "{median} ({p25}, {p75})", "{sd}", "{min}, {max}")
  )






