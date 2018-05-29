library(dplyr)
library(ggplot2)
library(leaflet)
library(tigris)

### Additional Source For Report : https://ucr.fbi.gov/hate-crime/2015/home 

### DO YOUR ANALYSIS AND WRANGLING HERE FOR NEATNESS
hate.crimes <- read.csv(file = "hate_crime.csv", stringsAsFactors = FALSE)

year <- unique(hate.crimes$year)


# Counting all hate crimes by year

count.by.year <- function(df, result) {
  for (n in year) {
    narrow <- filter(df, year == n)
    sum <- select(narrow, count) %>% sum()
    result[year == n, ]$hate_crimes = sum
  }
  return(result)
}

by.year <- count.by.year(hate.crimes, data.frame(year, hate_crimes = 0))



# Rahma's Section











# Meesha's Section











# Ghina's Section












# Tracy's Section

# Map work


library(maps)

data("state.fips")
list.state <- state.fips %>% 
  select(abb, polyname) %>% 
  filter(!polyname %in% c("massachusetts:martha's vineyard", "massachusetts:nantucket",
                          "michigan:north", "new york:manhattan", "new york:staten island",
                          "new york:long island", "north carolina:knotts", "north carolina:spit",
                          "virginia:chesapeake", "virginia:chincoteague", "washington:san juan island",
                          "washington:lopez island", "washington:orcas island", "washington:whidbey island"))

# Changing items manually
list.state[20,]$polyname = "massachusetts"
list.state[21,]$polyname = "michigan"
list.state[31,]$polyname = "new york"
list.state[32,]$polyname = "north carolina"
list.state[45,]$polyname = "virginia"
list.state[46,]$polyname = "washington"
list.state[50,] = c("AL", "alaska")
list.state[51,] = c("HI", "hawaii")

# alphabetically
list.state <- arrange(list.state, abb)

list.state$polyname <- stringr::str_to_title(list.state$polyname)

new.map <- left_join(hate.crimes, list.state, by = c("state_postal_abbr" = "abb"))

narrow.map <- new.map  %>% 
  filter(bias_motivation == "Anti-Black or African American" & year == 2010)
  
states <- states(cb = T)

hate.map <- narrow.map %>% 
  group_by(polyname) %>% 
  select(state_postal_abbr, count)

merger <- geo_join(states, hate.map, "STUSPS", "state_postal_abbr")

merger <- subset(merger, !is.na(count))
pal <- colorNumeric("Reds", domain = merger$count)
pop.up <- paste0("Total:", as.character(merger$count))

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(-98.483330, 38.712046, zoom = 4) %>%
  addPolygons(data = merger, 
              fillColor = ~pal(merger$count),
              fillOpacity = 0.7,
              weight = 0.2,
              smoothFactor = 0.2,
              popup = ~pop.up) %>% 
    addLegend(pal = pal, 
              values = merger$count,
              position = "bottomright",
              title = "Hate Crimes")
  