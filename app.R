library(ggplot2)
library(dplyr)
library(scales)
library(shiny)

source("user-interface.R")
source("analysis.R")

### TRY TO KEEP THE CODE NEAT. MAKE SURE YOUR PROGRAM RUNS BEFORE COMMITTING.
### AVOID MAKING OTHER'S CODE BREAK.
my_server <- function(input, output) {
  # Tracy's Server Code
  
  # narrow down map data frame
  hate_dataframe <- reactive({
    select <- new.map %>% 
      filter(bias_motivation == input$select_bias & year == input$select_year)
    select  
  })
  
  output$hate_map <- renderLeaflet({
    states <- states(cb = T)
    
    hate.map <- hate_dataframe() %>% 
      group_by(polyname) %>% 
      select(state_postal_abbr, count)
    
    merger <- geo_join(states, hate.map, "STUSPS", "state_postal_abbr")
    
    merger <- subset(merger, !is.na(count))
    
    pal <- colorNumeric("Reds", domain = merger$count)
    
    pop.up <- paste0("Total:", as.character(merger$count))
    
    map <- leaflet() %>%
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
    return(map)
  })
  
  
  
  
  # Rahma's Code
  
  
  # Meesha's Code
  
  
  # Ghina's Code
  
}

shinyApp(ui, my_server)