# Using the library usmap to make maps of what states have which 
# court transparency policies
# Tutorial: https://cran.r-project.org/web/packages/usmap/vignettes/mapping.html
# Documentation for usmap: https://cran.r-project.org/web/packages/usmap/usmap.pdf

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Loading libraries
library(usmap)
library(ggplot2)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This is an example from the tutorial

plot_usmap(regions = "states") +
  labs(title = "US States", subtitle = "This is a blank map of US States") +
  theme(panel.background = element_rect(color = "black", fill = "lightblue"))

plot_usmap(data = statepop, values = "pop_2015", color = "red") + 
  scale_fill_continuous(name = "Population (2015)", label = scales::comma) + 
  theme(legend.position = "right")

print(usmap::fips())

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Matches the Chicago Appleseed Map
# Aplleseed map: https://www.chicagoappleseed.org/wp-content/uploads/2022/05/Illinois-Judicial-Branch-Freedom-of-Information-Act-One-Pager.pdf

df <- data.frame(
  fips = c("02", "01", "05", "04", "06", "08", "09", "11", "10", "12", "13", "15", "19", "16", "17", "18", "20", "21", "22", "25", "24", "23", "26", "27", "29", "28", "30", "31", "37", "33", "38", "34", "35", "32", "36", "39", "40", "41", "42", "44", "45", "46", "47", "48", "49", "51", "50", "53", "55", "54", "56"),
  values = c(1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1)
)

plot_usmap(data = df, show.legend = FALSE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df <- data.frame(
  fips = c("02", "01", "05", "04", "06", "08", "09", "11", "10", "12", "13", "15", "19", "16", "17", "18", "20", "21", "22", "25", "24", "23", "26", "27", "29", "28", "30", "31", "37", "33", "38", "34", "35", "32", "36", "39", "40", "41", "42", "44", "45", "46", "47", "48", "49", "51", "50", "53", "55", "54", "56"),
  values = c(1,1,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1)
)

plot_usmap(data = df)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df <- data.frame(
  fips = c("01", "02", "04", "05", "06", "08", "09", "10", "12", "13", "15", "16", "17", "18","19", "20", "21", "22","23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "44", "45", "46", "47", "48", "49", "51", "50", "53", "54", "55", "56"),
  appleseed = c(1,1,1,1,1,0,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,1,1),
  courtFOIA = c(1,1,0,1,0,0,0,1,0,0,0,1,0,1,1,1,1,1,1,0,1,1,0,0,1,1, ,0,1,1,0)
)
plot_usmap(data = df)