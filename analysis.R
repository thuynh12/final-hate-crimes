library(dplyr)
library(ggplot2)
library(httr)
library(jsonlite)
library(leaflet)
library(geojson) # tracy's
library(geojsonio) # tracy's

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

# Interactive aspects
# - Sort by Bias
#   - Drop Down Menu (defaulted)
# - Sort by Year
#   - Slider (defaulted)

test <- hate.crimes %>% 
  filter(bias_motivation == "Anti-Black or African American" & year == 2010)

# - Sort by Range
#   - Radio buttons?

# Map work

