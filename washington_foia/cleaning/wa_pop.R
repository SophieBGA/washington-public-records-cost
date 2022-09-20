library(tidyverse)
library(readxl)

df <- read_excel("co-est2019-annres-53.xlsx", skip = 3, col_names = TRUE)

wa_county_populations_2010_2019 <- df %>%
  pivot_longer(c("2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019"), names_to = "year", values_to = "population")

df <- read_excel("co-est2021-pop-53.xlsx", skip = 3, col_names = TRUE)

wa_county_populations_2020_2021 <- df %>%
  pivot_longer(c("2020", "2021"), names_to = "year", values_to = "population")

wa_county_populations_2020_2021 <- wa_county_populations_2020_2021 %>%
  rename(
    Census = ...2
  )

colnames(wa_county_populations_2010_2019)
colnames(wa_county_populations_2020_2021)

wa_county_populations_2010_2019 <- wa_county_populations_2010_2019 %>%
  select(
    ...1,
    year,
    population
  )

wa_county_populations_2020_2021 <- wa_county_populations_2020_2021 %>%
  select(
    ...1,
    year,
    population
  )

wa_county_populations <- rbind(wa_county_populations_2010_2019, wa_county_populations_2020_2021)

wa_county_populations <- wa_county_populations %>%
  rename(
    name = ...1
  )

write_csv(wa_county_populations, file = "wa_county_pop", col_names = TRUE, append = FALSE)
