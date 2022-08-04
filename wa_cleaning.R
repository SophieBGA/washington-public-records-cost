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
df <- read_csv(file)

head(df)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df <- df %>%
  distinct()

colnames(df)

df %>%
  complete()

typeof(df$reporting_status)

x <- df$reporting_status == "Above the $100k threshold. Report submittal required."

df <- df %>%
  mutate(above_100K = x)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

write_csv(df, "jlarc_full_dataset.csv")
