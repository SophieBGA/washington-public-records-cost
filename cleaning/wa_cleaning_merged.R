library(tidyverse)
library(readxl)

# what directory is the file in
path <- "/Users/svanpelt/Documents/projects/court_transparency/unprocessed_data"

# set the path to the directory the file is in
setwd(path)

df <- read_csv("jlarc_merged.csv", col_names = TRUE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# fixing the 2017 data

df_2017 <- "JLARC Public Records Full Dataset.xlsx"

excel_sheets(df_2017)

df_2017 <- read_excel(df_2017, sheet = "Baseline Data", skip = 1, col_names = TRUE)
colnames(df_2017)
df_2017 %>%
  select(
    `Total Open Requests`,
    `Total Requests Received`
  ) %>%
  complete.cases()

df_2017 <- df_2017 %>%
  mutate(
    total_requests = `Total Open Requests` + `Total Requests Received`,
    year = 2017
    )

df_2017 <- df_2017 %>%
  select(
    `Agency Name`,
    year,
    total_requests
  )
df_2017 <- df_2017 %>%
  rename(
    agency_name = `Agency Name`
  )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df_2018_2019_2020 <- df %>%
  filter(
    year != "2017"
  ) %>%
  select(
    agency_name,
    year,
    total_requests
  )

total_requests <- rbind(df_2017, df_2018_2019_2020)

df <- df %>%
  select(
    -total_requests
  )

df <- df %>%
  full_join(total_requests, by = c("agency_name", "year"))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df <- df %>%
  distinct()

colnames(df)

df <- df %>%
  select(
    -complete_case
  )

df$complete_case <- df%>%
  select(
    agency_name,
    year,
    agency_category,
    reporting_status,
    total_requests,
  ) %>%
  complete.cases()


df %>%
  filter(complete_case == TRUE)

complete_case_FALSE <- df %>%
  filter(complete_case == FALSE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# making sure the man_total_cost is correct

man_cost <- df %>%
  mutate(
    true_man_total_cost = man_staff_cost + man_system_cost + man_service_cost + 
      man_third_party_cost
  )


man_cost$man_staff_cost[is.na(man_cost$man_staff_cost)] <- 0
man_cost$man_service_cost[is.na(man_cost$man_service_cost)] <- 0
man_cost$man_system_cost[is.na(man_cost$man_system_cost)] <- 0
man_cost$man_third_party_cost[is.na(man_cost$man_third_party_cost)] <- 0

man_cost <- man_cost %>%
  mutate(
    difference = true_man_total_cost - man_total_cost
  )

df_difference <- man_cost %>%
  filter(
    difference != 0
  )

df$man_staff_cost[is.na(df$man_staff_cost)] <- 0
df$man_service_cost[is.na(df$man_service_cost)] <- 0
df$man_system_cost[is.na(df$man_system_cost)] <- 0
df$man_third_party_cost[is.na(df$man_third_party_cost)] <- 0

df <- df %>%
  mutate(
    true_man_total_cost = man_staff_cost + man_system_cost + man_service_cost + 
      man_third_party_cost
  )

df %>%
  filter(
    true_man_total_cost != man_total_cost
  )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


df <- df %>%
  select(
    -complete_case1
  )

df$complete_case1 <- df%>%
  select(
    agency_name,
    year,
    agency_category,
    reporting_status,
    total_requests,
    est_staff_hours_spent,
    est_total_cost_responding_to_reqs
  ) %>%
  complete.cases()

df %>%
  filter(complete_case1 == TRUE)

complete_case1_FALSE <- df %>%
  filter(complete_case1 == FALSE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df$complete_case2 <- df%>%
  select(
    agency_name,
    year,
    agency_category,
    reporting_status,
    total_requests,
    est_staff_hours_spent,
    est_total_cost_responding_to_reqs,
    true_man_total_cost,
    total_litigation_cost
  ) %>%
  complete.cases()

df %>%
  filter(complete_case2 == TRUE)

complete_case2_FALSE <- df %>%
  filter(complete_case2 == FALSE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
df$agency_category <- tolower(df$agency_category)
table(df$agency_category)

write_csv(df, file = "jlarc_merged_cleaned.csv", col_names = TRUE, append = FALSE)

