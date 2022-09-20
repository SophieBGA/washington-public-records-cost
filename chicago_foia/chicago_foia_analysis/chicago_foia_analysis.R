library(tidyverse)
library(lubridate)
setwd("/Users/svanpelt/Documents/projects/court_transparency/unprocessed_data/chicago_foia_data")
options(scipen = 10)

# Updated in 2022:
# (There is probably some bias in using only those that are up to date, but
# There is also issues with using bad/outdated data, so ¯\_(ツ)_/¯ )
  # City Clerk
  # Transportation
  # Business Affairs & Consumer Protection 
  # Ethics
  # Finance
  # Public Building Commission
  # Water
  # Cultural Affairs & Special Events
  # Health

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

busAffairs <- read_csv("FOIA_Request_Log_-_Business_Affairs___Consumer_Protection.csv", col_names = TRUE)

cityClerk <- read_csv("FOIA_Request_Log_-_City_Clerk.csv")

culturalAffairs <- read_csv("FOIA_Request_Log_-_Cultural_Affairs___Special_Events.csv")

ethics <- read_csv("FOIA_Request_Log_-_Ethics.csv")

finance <- read_csv("FOIA_Request_Log_-_Finance.csv")

health <- read_csv("FOIA_Request_Log_-_Health.csv")

humanResources <- read_csv("FOIA_Request_Log_-_Human_Resources.csv")

law <- read_csv("FOIA_Request_Log_-_Law.csv")

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
df_list <- list(busAffairs, cityClerk, culturalAffairs, ethics, finance,
            health, humanResources, law)

for (i in df_list) {
  print(colnames(i))
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

AppendMe <- function(dfNames) {
  do.call(rbind, lapply(dfNames, function(x) {
    cbind(get(x), source = x)
  }))
}
colnames(busAffairs)

colnames(ethics)
ethics <- ethics %>% 
  select(`REQUESTOR NAME`, ORGANIZATION, `DATE RECEIVED`, `DUE DATE`, `DESCRIPTION OF REQUEST - STATEMENTS OF FINANCIAL INTERESTS`) %>%
  rename(`DESCRIPTION OF REQUEST` = `DESCRIPTION OF REQUEST - STATEMENTS OF FINANCIAL INTERESTS`)

colnames(finance)
finance <- finance %>% 
  select(`REQUESTOR NAME`, ORGANIZATION, `DATE RECEIVED`, `DUE DATE`, `DESCRIPTION OF REQUEST`)

colnames(humanResources)
humanResources <- humanResources %>% 
  select(`REQUESTOR NAME`, ORGANIZATION, `DATE RECEIVED`, `DUE DATE`, `DESCRIPTION OF REQUEST`)

colnames(law)

df <- AppendMe(c("busAffairs", "cityClerk", "culturalAffairs", "ethics", "finance", "health", "humanResources", "law"))
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df$`DATE RECEIVED`<- mdy(df$`DATE RECEIVED`)
df$`DATE RECEIVED` %>% max()

df <- df %>%
  filter(year(`DATE RECEIVED`) < 2023)

df <- df %>%
  filter(year(`DATE RECEIVED`) > 2009)

ggplot(data = df) +
  geom_bar(mapping = aes(x = year(`DATE RECEIVED`), fill = source))
