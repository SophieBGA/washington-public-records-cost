library(tidyverse)
library(readxl)

options(scipen=999)

setwd("~/Documents/projects/court_transparency/unprocessed_data")

df <- read_excel("Exp Report Data 1991-2021.xlsm", col_names = TRUE)
## Data from: https://www.nasbo.org/mainsite/reports-data/historical-data?attachments=&libraryentry=629bc842-583e-49ac-b206-16be92cdf1b4&pageindex=0&pagesize=12&search=&sort=most_recent&viewtype=row
## Citation: National Association of State Budget Officers, State Expenditure Report Historical Data Set, 1991-2021

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Total Spending is the variable TOTAL_CAPI
## KFF has a smaller dataset I used to double check this
## They list Alabama's spending to be 31638 (in millions) in 2020
## I got the same!

df %>% 
  filter(STATE == "Alabama" & YEAR == 2020) %>%
  select(TOTAL_CAPI)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ggplot(df, mapping = aes(x = YEAR, y = TOTAL_CAPI)) +
  geom_line(aes(linetype = as.factor(STATE)))

ggplot(df, mapping = aes(x = YEAR, y = TOTAL_CAPI, color = STATE)) +
  geom_line()

df %>%
  filter(STATE == "Pennsylvania") %>%
  ggplot(mapping = aes(x = YEAR, y = TOTAL_CAPI)) +
  geom_line()

df %>%
  group_by(YEAR) %>%
  summarize(TOTAL_CAPI = mean(TOTAL_CAPI)) %>%
  ggplot(mapping = aes(x = YEAR, y = TOTAL_CAPI)) +
  geom_line() +
  geom_line(data = df %>% filter(STATE == "Pennsylvania"), color = "blue") +
  geom_line(data = df %>% filter(STATE == "Illinois"), color = "red") +
  geom_line(data = df %>% filter(STATE == "Delaware"), color = "yellow") +
  geom_line(data = df %>% filter(STATE == "Maryland"), color = "purple") +
  geom_line(data = df %>% filter(STATE == "New Jersey"), color = "green") +
  geom_line(data = df %>% filter(STATE == "Florida"), color = "orange") +
  geom_line(data = df %>% filter(STATE == "Ohio"), color = "white")


recessions <- data.frame(YEAR = 1991:2021,
  RECESSION = c(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0)
  )

df <- left_join(df, recessions, by = "YEAR")


g = ggplot(unrate.df) + geom_line(aes(x=date, y=UNRATE)) + theme_bw()
g = g + geom_rect(data=recessions.trim, aes(xmin=Peak, xmax=Trough, ymin=-Inf, ymax=+Inf), fill='pink', alpha=0.2)

pa <- df %>%
  filter(STATE == "Pennsylvania")

ggplot(pa) +
  geom_line(aes(x = YEAR, y = TOTAL_CAPI)) +
  geom_bar(aes(fill = RECESSION))

