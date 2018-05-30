library(ggplot2)
library(dplyr)
library(scales)
library(shiny)

<<<<<<< HEAD

=======
## Things to install!
# install.packages("tigris")
# install.packages("leaflet")
# install.packages("shinythemes")
>>>>>>> 47a36eb5e94458eb3278b6111e21797aa0744668

source("user-interface.R")
source("analysis.R")

### TRY TO KEEP THE CODE NEAT. MAKE SURE YOUR PROGRAM RUNS BEFORE COMMITTING.
### AVOID MAKING OTHER'S CODE BREAK.
my_server <- function(input, output) {
  # Tracy's Server Code
  
  #Welcome map
  overall_df <- reactive({
    select <- poly.comb %>% 
      filter(year == input$slider_year) %>% 
      group_by(polyname) %>% 
      summarize(count = sum(count))
    select
  })
  
  output$overall_map <- renderLeaflet({
    year_distribution <- full_join(list.state, overall_df(), by = c("polyname" = "polyname"))
    
    year_distribution[is.na(year_distribution)] <- 0
    
    combined.year <- geo_join(states, year_distribution, "STUSPS", "abb")
    
    combined.year <- subset(combined.year, !is.na(count))
    
    pal <- colorNumeric("Reds", domain = combined.year$count)
    pop.up <- paste0("Total:", as.character(combined.year$count))
    
    overall <- leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(-98.483330, 38.712046, zoom = 4) %>%
      addPolygons(data = combined.year, 
                  fillColor = ~pal(combined.year$count),
                  fillOpacity = 0.7,
                  weight = 0.2,
                  smoothFactor = 0.2,
                  popup = ~pop.up) %>% 
      addLegend(pal = pal, 
                values = combined.year$count,
                position = "bottomright",
                title = "Hate Crimes")
    
    return(overall)
  })
  
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
  
  output$year_status <- renderText({
    result <- paste("Hate Crimes in America in", input$slider_year)
    result  
  })
  
  
  # Rahma's Code
  
  
  # Meesha's Code
  
  
  # Ghina's Code
  
}

shinyApp(ui, my_server)