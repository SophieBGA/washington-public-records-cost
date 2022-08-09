library(tidyverse)
library(readxl)


# what directory is the file in
path <- "/Users/svanpelt/Documents/projects/court_transparency/unprocessed_data"

# set the path to the directory the file is in
setwd(path)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# getting the files
df_2018 <- "2018 JLARC Public Records Full Dataset.xlsx"
df_2019 <- "2019 JLARC Public Records Full Dataset.xlsx"
df_2020 <- "2020 JLARC Public Records Full Dataset.xlsx"

# get list of excel file's sheets
excel_sheets(df_2020)[-c(1, 2, 3)]
sheets_2018 <- print(excel_sheets(df_2018)[-c(1, 2, 3, 10, 11, 16)])
sheets_2019 <- print(excel_sheets(df_2019)[-c(1, 2, 3, 11, 16)])
sheets_2020 <- print(excel_sheets(df_2020)[c(4, 5, 6, 7, 8, 9, 10, 14, 15, 16, 17, 18, 19, 20, 21)])

# load all the sheets into a list that contains each sheet as a tibble
list_2018 <- lapply(sheets_2018, function(x) read_excel(df_2018, sheet = x, skip = 1))
list_2019 <- lapply(sheets_2019, function(x) read_excel(df_2019, sheet = x, skip = 1))
list_2020 <- lapply(sheets_2020, function(x) read_excel(df_2020, sheet = x, skip = 1))

# change the name of each tibble in list_all to the name of the sheet
names(list_2018) <- sheets_2018
names(list_2019) <- sheets_2019
names(list_2020) <- sheets_2020

# can see the head of the first sheet, looks good
head(list_2020$Baseline)

# using purrr::reduce to use inner_join repeatedly
df_2018 <- list_2018 %>%
  reduce(left_join, by = "Agency name")

df_2019 <- list_2019 %>%
  reduce(left_join, by = "Agency name")

df_2020 <- list_2020 %>%
  reduce(left_join, by = "Agency name")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# removing spaces from column names

df_2018_new <- df_2018
colnames(df_2018_new) <- make.names(colnames(df_2018_new), unique = TRUE)
colnames(df_2018_new)

df_2019_new <- df_2019
colnames(df_2019_new) <- make.names(colnames(df_2019_new), unique = TRUE)
colnames(df_2019_new)

df_2020_new <- df_2020
colnames(df_2020_new) <- make.names(colnames(df_2020_new), unique = TRUE)
colnames(df_2020_new)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# selecting the variables I care about

df_2018_tiny <- df_2018_new %>%
  select(Agency.name,
         Agency.category.x, 
         Agency.Type.x, 
         Reporting.Status.x,
         Total.open.requests,
         Requests.open.at.beginning.of.reporting.and.closed.during.reporting.period,
         Total.requests.received,
         Total.requests.closed,
         Total.requests.closed..open.at.beginning.of.reporting.and.closed.during.plus.closed.,
         Requests.closed.within.5.days,
         Number.of.requests.with.final.disposition,
         Number.of.days.to.final.disposition,
         Median.number.of.days.to.final.disposition,
         Average.number.of.days.to.final.disposition,
         Denied.in.Full,
         Denied.Partial,
         Requests.fulfilled.electronically,
         Requests.fulfilled.physically,
         Requests.fulfilled.combination,
         Requests.closed.no.responsive.records,
         Percent.requests.fulfilled.electronically,
         Percent.requests.fulfilled.physically,
         Percent.requests.fulfilled.combination,
         Percent.requests.closed.no.responsive.records,
         Requests.Scanned,
         Estimated.Staff.Hours.Spent,
         Total.Requests,
         Average.estimated.staff.hours.spent...No.rounding.,
         Average.cost.per.request,
         Total.estimated.cost,
         Agency.applied.an.overhead.rate,
         Total.litigation.cost,
         Staff.costs,
         System.costs,
         Service.costs,
         Third.party.costs,
         Total.estimated.costs,
         Agency.applied.overhead.rate,
         Expenses.recovered,
         Customized.service.charges
  )

df_2019_tiny <- df_2019_new %>%
  select(Agency.name,
         Agency.category.x,
         Agency.type.x,
         Reporting.status.x,
         Total.open.requests,
         Requests.open.at.beginning.of.reporting.and.closed.during.reporting.period,
         Total.requests.received,
         Total.requests.closed,
         Total.requests.closed..open.at.beginning.of.reporting.and.closed.during.plus.closed.,
         Requests.closed.within.5.days,
         Number.of.requests.where.an.estimated.response.time.beyond.5.days.was.provided,
         Number.of.requests.with.final.disposition,
         Number.of.days.to.final.disposition,
         Median.number.of.days.to.final.disposition,
         Average.number.of.days.to.final.disposition,
         Requests.requiring.clarification,
         Denied.in.full,
         Partially.denied,
         Requests.abandoned.by.requesters,
         Requests.fulfilled.electronically,
         Requests.fulfilled.physically,
         Requests.fulfilled.combination,
         Requests.closed...no.responsive.records,
         Percent.of.requests.fulfilled.electronically,
         Percent.requests.fulfilled.physically,
         Percent.requests.fulfilled.combination,
         Percent.requests.closed...no.responsive.records,
         Requests.scanned,
         Estimated.staff.hours.spent,
         Total.requests,
         Average.estimated.staff.hours.spent..No.rounding.,
         Average.cost.per.request,
         Total.estimated.cost,
         Agency.applied.an.overhead.rate.x,
         Total.litigation.cost,
         Staff.costs,
         System.costs,
         Service.costs,
         Third.party.costs,
         Total.estimated.costs,
         Agency.applied.an.overhead.rate.y,
         Expenses.recovered,
         Customized.service.charges
  )

df_2020_tiny <- df_2020_new %>%
  select(
    Agency.name,
    Agency.category.x,
    Agency.type.x,
    Reporting.status.x,
    Total.open.requests,
    Requests.open.at.beginning.of.reporting.and.closed.during.reporting.period,
    Total.requests.received,
    Requests.closed,
    Total.requests.closed..open.at.beginning.of.reporting.and.closed.during.plus.closed.,
    Requests.closed.within.5.days,
    Number.of.requests.where.an.estimated.response.time.beyond.5.days.was.provided,
    Number.of.requests.with.final.disposition,
    Number.of.days.to.final.disposition,
    Median.number.of.days.to.final.disposition,
    Average.number.of.days.to.final.disposition,
    Requests.requiring.clarification,
    Denied.in.full,
    Partially.denied,
    Requests.abandoned.by.requesters,
    Requests.fulfilled.electronically,
    Requests.fulfilled.physically, 
    Requests.fulfilled.combination,
    Requests.closed...no.responsive.records,
    Percent.of.requests.fulfilled.electronically,
    Percent.of.requests.fulfilled.physically,
    Percent.of.requests.fulfilled.combination,
    Percent.requests.closed...no.responsive.records,
    Requests.scanned,
    Estimated.staff.hours.spent,
    Total.requests..open...received.,
    Average.estimated.staff.hours.spent..No.rounding.,
    Average.estimated.cost.per.request,
    Total.cost.estimated,
    Agency.applied.an.overhead.rate.x,
    Total.claims.filed,
    Total.litigation.cost,
    Staff.costs,
    System.costs,
    Service.costs,
    Third.party.costs,
    Total.estimated.costs,
    Agency.applied.an.overhead.rate.y,
    Expenses.recovered,
    Customized.service.charges,
  )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Lets have all the colnames be the same so we can append them all together!
# Also need to add the year 

names(df_2018_tiny) <- tolower(names(df_2018_tiny))
names(df_2019_tiny) <- tolower(names(df_2019_tiny))
names(df_2020_tiny) <- tolower(names(df_2020_tiny))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

colnames(df_2018_tiny)
df_2018_tiny <- df_2018_tiny %>%
  rename(
    agency_name = agency.name,
    agency_category = agency.category.x,
    agency_type = agency.type.x,
    reporting_status = reporting.status.x,
    total_requests = total.requests,
    reqs_fulfilled_electronically = requests.fulfilled.electronically,
    reqs_fulfilled_physically = requests.fulfilled.physically,
    reqs_fulfilled_combination = requests.fulfilled.combination,
    percent_reqs_fulfilled_electronically = percent.requests.fulfilled.electronically,
    percent_reqs_fulfilled_physically = percent.requests.fulfilled.physically,
    percent_reqs_fulfilled_combination = percent.requests.fulfilled.combination,
    reqs_scanned = requests.scanned,
    est_staff_hours_spent = estimated.staff.hours.spent,
    avg_est_staff_hours_spent = average.estimated.staff.hours.spent...no.rounding.,
    est_total_cost_responding_to_reqs = total.estimated.cost,
    avg_est_cost_responding_per_req = average.cost.per.request,
    total_litigation_cost = total.litigation.cost,
    man_staff_cost = staff.costs,
    man_system_cost = system.costs,
    man_service_cost = service.costs,
    man_third_party_cost = third.party.costs,
    man_total_cost = total.estimated.costs,
    total_reqs_received = total.requests.received,
    expenses_recovered = expenses.recovered
  )
df_2018_tiny$year <- 2018

df_2018_tiny %>%
  rename(
    total_reqs_closed = total.requests.closed,
    total_reqs_closed_open_at_beginning = total.requests.closed..open.at.beginning.of.reporting.and.closed.during.plus.closed.,
    reqs_closed_within_5_days = requests.closed.within.5.days,
    agency_applied_overhead_rate = agency.applied.an.overhead.rate,
    total_open_reqs = total.open.requests,
    denied_in_full = denied.in.full,
    denied_partial = denied.partial,
    reqs_closed_within_5_days = requests.closed.within.5.days
  )

df_2018_ready_to_merge <- df_2018_tiny %>%
  select(
    agency_name,
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

df_2018_ready_to_merge$year <- 2018

write_csv(df_2018_ready_to_merge, file = "jlarc_2018_ready_to_merge.csv", col_names = TRUE, append = FALSE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

colnames(df_2019_tiny)
df_2019_ready_to_merge <- df_2019_tiny %>%
  rename(
    agency_name = agency.name,
    agency_category = agency.category.x,
    agency_type = agency.type.x,
    reporting_status = reporting.status.x,
    total_requests = total.requests,
    reqs_fulfilled_electronically = requests.fulfilled.electronically,
    reqs_fulfilled_physically = requests.fulfilled.physically,
    reqs_fulfilled_combination = requests.fulfilled.combination,
    percent_reqs_fulfilled_electronically = percent.of.requests.fulfilled.electronically,
    percent_reqs_fulfilled_physically = percent.requests.fulfilled.physically,
    percent_reqs_fulfilled_combination = percent.requests.fulfilled.combination,
    reqs_scanned = requests.scanned,
    est_staff_hours_spent = estimated.staff.hours.spent,
    avg_est_staff_hours_spent = average.estimated.staff.hours.spent..no.rounding.,
    est_total_cost_responding_to_reqs = total.estimated.cost,
    avg_est_cost_responding_to_reqs = average.cost.per.request,
    total_litigation_cost = total.litigation.cost,
    man_staff_cost = staff.costs,
    man_system_cost = system.costs,
    man_service_cost = service.costs,
    man_third_party_cost = third.party.costs,
    man_total_cost = total.estimated.costs,
    expenses_recovered = expenses.recovered
  )

df_2019_ready_to_merge <- df_2019_ready_to_merge %>%
  rename(
    avg_est_cost_responding_per_req = avg_est_cost_responding_to_reqs
  )

df_2019_ready_to_merge <- df_2019_ready_to_merge %>%
  select(
    agency_name,
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

df_2019_ready_to_merge$year <- 2019
write_csv(df_2019_ready_to_merge, file = "jlarc_2019_ready_to_merge.csv", col_names = TRUE, append = FALSE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df_2018_2019_merged <- rbind(df_2018_ready_to_merge, df_2019_ready_to_merge)
write_csv(df_2018_2019_merged, file = "jlarc_2018_2019_merged.csv", col_names = TRUE, append = FALSE)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




















