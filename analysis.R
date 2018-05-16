library(dplyr)
library(ggplot2)
library(httr)
library(jsonlite)


# Note : You will need to get your own API key 
# https://api.data.gov/signup/ 
source("api-key.R")

# This is the documentation of the Crime Explorer
# https://crime-data-explorer.fr.cloud.gov/api 
# This API is useful because you don't have to continuously change uri manually.

base_uri <- "https://api.usa.gov/crime/fbi/ucr/"
endpoint_bias <- "hc/count/national/bias_name"
endpoint_offense <- "hc/count/national/bias_name/offenses"

# Change state for variation
state <- "WA"
endpoint_state_bias <- paste0("hc/count/states/", state, "/bias_name")
endpoint_state_offense <- paste0("hc/count/states/", state, "/bias_name/offenses")

# Change endpoint to different variable
endpoint <- endpoint_bias

query <- paste0("?page=1&per_page=10&output=json&api_key=", api_key)


resource_uri <- paste0(base_uri, endpoint, query)

response <- GET(resource_uri)
