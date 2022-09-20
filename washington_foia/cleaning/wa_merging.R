library(tidyverse)
library(readxl)

# what directory is the file in
path <- "/Users/svanpelt/Documents/projects/court_transparency/unprocessed_data"

# set the path to the directory the file is in
setwd(path)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# getting the files

df_2017 <- "jlarc_2017_ready_to_merge.xlsx"
df_2018_2019 <- "jlarc_2018_2019_merged.csv"
df_2020 <- "jlarc_2020_ready_to_merge.csv"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# loading the files in

df_2017 <- read_excel(df_2017, col_names = TRUE)
df_2018_2019 <- read_csv(df_2018_2019, col_names = TRUE)
df_2020 <- read_csv(df_2020, col_names = TRUE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# df_2017 has some extra variables atm, so lets get them to all match

df_2017 <- df_2017 %>%
  select(
    agency_name,
    year,
    agency_category,
    agency_type,
    reporting_status,
    total_requests,
    reqs_fulfilled_electronically,
    reqs_fulfilled_physically,
    reqs_fulfilled_combination,
    percent_reqs_fulfilled_electronically,
    percent_reqs_fulfilled_physically,
    percent_reqs_fulfilled_combination,
    reqs_scanned,
    est_staff_hours_spent,
    avg_est_staff_hours_spent,
    est_total_cost_responding_to_reqs,
    avg_est_cost_responding_per_req,
    total_litigation_cost,
    man_staff_cost,
    man_system_cost,
    man_service_cost,
    man_third_party_cost,
    man_total_cost,
    expenses_recovered
  )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# now using rbind to bind these dfs together

df_2017_2018_2019 <- rbind(df_2017, df_2018_2019)
df <- rbind(df_2017_2018_2019, df_2020)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# making it into a csv

write_csv(df, file = "jlarc_merged.csv", col_names = TRUE, append = FALSE)

