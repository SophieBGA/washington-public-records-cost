library(tidyverse)
library(readxl)
library(gtsummary)
options(scipen = 10)

# what directory is the file in
path <- "/Users/svanpelt/Documents/projects/court_transparency/unprocessed_data"

# set the path to the directory the file is in
setwd(path)

df <- read_csv("jlarc_merged_cleaned.csv", col_names = TRUE)

head(df)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
df$above100k <- df$reporting_status == "Above the $100k threshold. Report submittal required."

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
colnames(df)
df$complete_case3 <- df %>%
  select(
    agency_name,
    year,
    agency_category,
    reporting_status,
    total_requests,
    est_staff_hours_spent,
    est_total_cost_responding_to_reqs,
    man_total_cost
  ) %>%
  complete.cases()

df3 <- df %>%
  filter(
    complete_case3 == TRUE
  )
df3 <- df3 %>%
  select(
   agency_name,
   year,
   agency_category,
   agency_type,
   above100k,
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
wa_pop <- read_csv("wa_county_pop", col_names = TRUE)

#substituting the values
wa_pop$name <- sub('\\.','',wa_pop$name)

wa_pop <- wa_pop %>%
  separate(name, into = c("county", "other"), sep = ",")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
table(df3$agency_category)

df3$category <- NA
df3$category[df3$agency_category %in% c("agency, commission or board", "state agency, commission or board", "state agency, commission, or board")] <- "state agency, commission, or board"
df3$category[df3$agency_category %in% c("post-secondary education", "higher education institutions")] <- "higher education institution"
df3$category[df3$agency_category == "county"] <- "county"
df3$category[df3$agency_category == "legislature"] <- "legislature"
df3$category[df3$agency_category == "school district/esd"] <- "school district/esd"
df3$category[df3$agency_category == "city/town"] <- "city/town"
df3$category[df3$agency_category == "special district"] <- "special district"

table(df3$category)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ggplot(data = df3) + 
  stat_summary(
    mapping = aes(x = category, y = total_requests),
    fun.min = min,
    fun.max = max,
    fun = median
  )

ggplot(data = df3) + 
  stat_summary(
    mapping = aes(x = category, y = est_staff_hours_spent),
    fun.min = min,
    fun.max = max,
    fun = median
  )

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ggplot(data = df3, mapping = aes(x = category, y = total_requests)) + 
  geom_boxplot()
ggplot(data = df3, mapping = aes(x = category, y = total_requests)) + 
  geom_boxplot() +
  coord_flip()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
df3Counties <- df3 %>%
  filter(
    df3$category == "county"
  )
df3Counties <- df3Counties %>%
  separate(agency_name, into = c("county", "subtype"), sep = "-")

df3Counties$subtype <- trimws(df3Counties$subtype, which = c("left"))
df3Counties$county <- trimws(df3Counties$county, which = c("right"))

df3CountiesCentralized <- df3Counties %>%
  filter(
    df3Counties$subtype == "Centralized"
  )
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
df3CountiesCentralizedPop <- left_join(df3CountiesCentralized, wa_pop, by = c("county", "year"))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ggplot(data = df3CountiesCentralizedPop) +
  geom_histogram(mapping = aes(x = population))

ggplot(data = df3CountiesCentralizedPop, mapping = aes(x = above100k, y = total_requests)) + 
  geom_boxplot()

ggplot(data = df3CountiesCentralizedPop, mapping = aes(x = population, y = est_total_cost_responding_to_reqs)) + 
  geom_point(mapping = aes(color = above100k)) +
  geom_smooth(se = FALSE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lm1 <- lm(df3CountiesCentralizedPop$est_total_cost_responding_to_reqs ~ df3CountiesCentralizedPop$population + df3CountiesCentralizedPop$total_requests + df3CountiesCentralizedPop$above100k)
summary(lm1)

lm2 <- lm(total_requests ~ population, data = df3CountiesCentralizedPop)
summary(lm2)
head(lm2)

lm3 <- lm(df3CountiesCentralizedPop$est_total_cost_responding_to_reqs ~ lm2$fitted.values)
summary(lm3)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df3CountiesCentralized <- df3Counties %>%
  filter(
    df3Counties$subtype == "Centralized"
  )

df3CountiesCentralizedPop$req_per_person <- df3CountiesCentralizedPop$total_requests/df3CountiesCentralizedPop$population

df3CountiesCentralizedPop$total_cost_per_req_per_person <- df3CountiesCentralizedPop$est_total_cost_responding_to_reqs/df3CountiesCentralizedPop$population

df3CountiesCentralizedPop <- df3CountiesCentralizedPop %>%
  rename(
    total_cost_per_person = total_cost_per_req_per_person
  )

ggplot(data = df3CountiesCentralizedPop) +
  geom_histogram(mapping = aes(x = req_per_person))

ggplot(data = df3CountiesCentralizedPop) +
  geom_histogram(mapping = aes(x = total_cost_per_person), bins = 8)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df3CountiesCentralizedPop %>%
  filter(
    above100k == FALSE
  ) %>%
  select(
    est_total_cost_responding_to_reqs
  ) %>%
  tbl_summary(
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean}", "{median} ({p25}, {p75})", "{sd}", "{min}, {max}")
  )

df3CountiesCentralizedPop %>%
  select(
    total_requests,
    est_staff_hours_spent,
    avg_est_staff_hours_spent,
    est_total_cost_responding_to_reqs,
    avg_est_cost_responding_per_req,
    total_litigation_cost,
    man_staff_cost,
    man_service_cost,
    man_third_party_cost,
    man_total_cost,
    expenses_recovered,
    population,
    req_per_person,
    total_cost_per_person
  ) %>%
  tbl_summary(
    type = all_continuous() ~ "continuous2",
    statistic = all_continuous() ~ c("{mean}", "{median} ({p25}, {p75})", "{sd}", "{min}, {max}")
  )

df3CountiesCentralizedPop %>%
  group_by(county) %>%
  summarise(mean = mean(total_requests))

df3CountiesCentralizedPop %>%
  group_by(county) %>%
  summarise(median = median(total_requests))


df3CountiesCentralizedPop %>%
  group_by(year, above100k) %>%
  summarise(min = min(population))

df3CountiesCentralizedPop %>%
  group_by(year, above100k) %>%
  summarise(median = median(population))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
df3 %>%
  group_by(category) %>%
  summarise(mean = mean(est_total_cost_responding_to_reqs))

df3 %>%
  group_by(category) %>%
  summarise(median = median(est_total_cost_responding_to_reqs))
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
View(df3Counties %>%
  group_by() %>%
  summarise(median = median(total_requests)))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
write_csv(df3CountiesCentralizedPop, file = "jlarc_centralized_counties.csv", col_names = TRUE, append = FALSE)

write_csv(df3, file = "jlarc_complete_cases3.csv", col_names = TRUE, append = FALSE)


