library(leaflet)
library(maps)
library(stringr)

mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Leaflet communicates well with the map function's "state" category
# To not mess anything up and try and reinvent the wheel I just added a new 
# column for the data that I am interested in to the dataframe above
# mapStates, that way I know Leaflet is reading all the state shapes correctly
mapStates$values <- c(0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,
                      1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0)

mapStates$foia <- c("Subject to state FOIA", "Supreme Court Rule", 
                    "Subject to state FOIA", "Supreme Court Rule", 
                    "No Rule & Not Subject to FOIA", "Only Administrative Records are Subject to FOIA",
                    "Subject to state FOIA", "NA", "Supreme Court Rule", 
                    "Supreme Court Rule", "Subject to state FOIA",
                    "No Rule & Not Subject to FOIA", "Subject to state FOIA",
                    "Subject to state FOIA", "Subject to state FOIA", 
                    "Subject to state FOIA", "Subject to state FOIA",
                    "No Rule & Not Subject to FOIA", "Subject to state FOIA",
                    "Subject to state FOIA", "Subject to state FOIA",
                    "Subject to state FOIA", "No Rule & Not Subject to FOIA",
                    "No Rule & Not Subject to FOIA", "Supreme Court Rule", 
                    "Subject to state FOIA", "Subject to state FOIA",
                    "Only Administrative Records are Subject to FOIA", "Subject to state FOIA", 
                    "Subject to state FOIA", "No Rule & Not Subject to FOIA",
                    "Supreme Court Rule", "Subject to state FOIA",
                    "Supreme Court Rule", "Supreme Court Rule", 
                    "Supreme Court Rule", "Supreme Court Rule", 
                    "Subject to state FOIA", "Subject to state FOIA",
                    "Subject to state FOIA", "Supreme Court Rule", 
                    "Subject to state FOIA", "Only Administrative Records are Subject to FOIA",
                    "Subject to state FOIA", "Supreme Court Rule", 
                    "Supreme Court Rule", "No Rule & Not Subject to FOIA",
                    "Subject to state FOIA", "No Rule & Not Subject to FOIA",
                    "Subject to state FOIA", "No Rule & Not Subject to FOIA",
                    "Subject to state FOIA", "Supreme Court Rule", 
                    "Supreme Court Rule", "Supreme Court Rule", 
                    "Supreme Court Rule", "Supreme Court Rule", 
                    "Supreme Court Rule", "Supreme Court Rule", 
                    "Supreme Court Rule", "Supreme Court Rule", 
                    "Subject to state FOIA", "Supreme Court Rule")
# This section controls the colors of the maps
factpal <- colorFactor(topo.colors(3), mapStates$foia)

factpal <- colorFactor(palette = "Blues", mapStates$values)

factpal <- colorFactor(palette = c("white", "blue 
                                   "), mapStates$values)

factpal <- colorFactor(palette = c("#FFFFFF", "#000000"), mapStates$values)

factpal <- colorFactor(palette = c("#00008B", "#0000FF"), mapStates$values)

factpal <- colorFactor(palette = c("#0D3B66", 
                                   "#FAF0CA",
                                   "#F4D35E",
                                   "#EE964B",
                                   "#F95738"), 
                       mapStates$foia)

factpal <- colorFactor(palette = c("#A5C4D4", 
                                   "#8499B1",
                                   "#7B6D8D",
                                   "#593F62"), 
                       mapStates$foia)

factpal <- colorFactor(palette = c("#C81D25", 
                                   "#FF5A5F",
                                   "#BFD7EA",
                                   "#0B3954"), 
                       mapStates$foia)

factpal <- colorFactor(palette = c("#696969",
                                   "#E4572E", 
                                   "#FFC914",
                                   "#6DAEDB",
                                   "#173753"), 
                       mapStates$foia)

# This section controls the labels that pop up over each state when you hover
# it, the <strong>%s</strong>... is HTML, and tells leaflet this should just 
# be plain text
labels <- sprintf(
  "<strong>%s</strong><br/>%s",
  gsub(":.*","",str_to_title(mapStates$names)), mapStates$foia
) %>% 
  lapply(htmltools::HTML)

# This is the section that actually draws the map, using the things I defined 
# above
leaflet(mapStates) %>%
  addPolygons(color = ~factpal(foia),
              weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.75,
              highlightOptions = highlightOptions(color = "white", weight = 1,
                                                  bringToFront = TRUE),
              label = labels,
              labelOptions = labelOptions(style = list("font-weight" = "normal",
                                           padding = "3px 8px"),
                              textsize = "15px",
                              direction = "auto")) %>%
  addLegend("bottomrigh", pal = factpal, values = ~foia,
            title = "State Court Transparency Access",
            opacity = 1)

