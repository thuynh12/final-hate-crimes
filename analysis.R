library(dplyr)
library(ggplot2)
library(httr)
library(jsonlite)

### Additional Source For Report : https://ucr.fbi.gov/hate-crime/2015/home 


# Note : You will need to get your own API key 
# https://api.data.gov/signup/ 
source("api-key.R")

# Another helpful csv 
# Documentation : https://crime-data-explorer.fr.cloud.gov/downloads-and-docs
# Only up to 2014
hate.csv <- read.csv(file = "data/hate_crime.csv", stringsAsFactors = FALSE)


# This is the documentation of the Crime Explorer
# https://crime-data-explorer.fr.cloud.gov/api 
# This API is useful because you don't have to continuously change uri manually.

base_uri <- "https://api.usa.gov/crime/fbi/ucr/"
endpoint_bias <- "hc/count/national/bias_name"

# Not useful, same data divided up
# endpoint_offense <- "hc/count/national/bias_name/offenses"
# endpoint_state_offense <- paste0("hc/count/states/", state, "/bias_name/offenses")



query <- paste0("?page=1&per_page=10&output=json&api_key=", api_key)


bias_resource_uri <- paste0(base_uri, endpoint_bias, query)

bias_response <- GET(bias_resource_uri)
bias_body <- content(bias_response, "text")
bias_body.data <- fromJSON(bias_body)
bias_body.df <- flatten(bias_body.data$results)

# Change state for variation
state <- "MS"
endpoint_state_bias <- paste0("hc/count/states/", state, "/bias_name")

state_resource_uri <- paste0(base_uri, endpoint_state_bias, query)

state_response <- GET(state_resource_uri)
state_body <- content(state_response, "text")
state_body.data <- fromJSON(state_body)
state_body.df <- flatten(state_body.data$results)



## Questions
## What are the possible discrepancies between major historical event and hate crimes in the past two decades?

## Does the frequency of hate crimes and the type vary depending on geological location?

## Compare and contrast the frequency of anti-Muslim hate crimes to those of anti-Christian and anti-Catholic
## hate crimes throughout the country from 1995 to 2005. 

## Compare the frequency of anti-LGBTQ hate crimes after the Defense of Marriage Act in 1996.



### Hate Crimes Overall

hate_crimes <- bias_body.df %>% 
  na.omit()

year <- unique(hate_crimes$year)


# Counting all hate crimes by year
year_combination <- data.frame(year, hate_crimes = 0)

count.all <- function(df, result) {
  for (n in year) {
    narrow <- filter(df, year == n)
    sum <- select(narrow, count) %>% sum()
    result[year == n, ]$hate_crimes = sum
  }
  return(result)
}

year_combination <- count.all(hate_crimes, year_combination)

# plot of hate crime over 25 years
ggplot(data = year_combination) +
  geom_bar(mapping = aes(x = year, y = hate_crimes, fill = hate_crimes), stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) # this is to make years verticle


# State 
state_crimes <- state_body.df %>% 
  na.omit()


state_combination <- data.frame(year, hate_crimes = 0)

state_combination <- count.all(state_crimes, state_combination)

## She broken :(
