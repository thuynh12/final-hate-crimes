library(ggplot2)
library(dplyr)
library(scales)
library(shiny)
 
## Things to install!
# install.packages("tigris")
# install.packages("leaflet")
# install.packages("shinythemes")


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
  
 output$plot_9_11 <- renderPlot({
     ggplot(data_9_11) +
     geom_histogram(mapping = aes(x = year, y = count, fill = year == 2001),
                    stat = "identity") +
     theme(legend.position = "none") +
     labs(
       title = "Pre and Post 9/11 Hate Crimes Against Muslims in America",
       y = "Count (Number of Single Crimes Committed)",
       x = "Year (1991 - 2014)"
     )  
 }) 
 
 
 output$LGBT <- renderPlot({
   ggplot(data_LGBTQ) +
     geom_histogram(mapping = aes(x = year, y = count, fill = year == 2000), stat = "identity") +
     theme(legend.position = "none") +
     labs(
       title = "Hate Crimes Against the LGBTQ+ Community",
       y = "Count (Number of Single Crimes Committed)",
       x = "Year (1991 - 2014)"
     )
 })
 
 output$black_white <- renderPlot({
   ggplot(data_black_white) +
    geom_histogram(mapping = aes(x = year, y = count, fill = bias_motivation), 
                    stat = "identity", position = "dodge") +
     labs(
       title = "Comparing Hate Crimes Against Whites and Blacks",
       y = "Count (Number of Single Crimes Committed)",
       x = "Year (1991 - 2014)", 
       fill = "Motivation of Hate Crimes"
     )
   
 })
  
  
  # Meesha's Code
  overview_table <- reactive({
    minority <- select_groups %>% 
      filter(year == input$m.year) %>% 
      group_by(Bias) 
    minority
  })
  
  output$minority_table <- renderTable({
    sum.table <- overview_table() %>% 
      summarize(Mean = mean(count, na.rm = TRUE),
                Median = median(count, na.rm = TRUE),
                Min = min(count, na.rm = TRUE), 
                Max = max(count, na.rm = TRUE))
    sum.table
   })
  
  output$sum_plot <- renderPlot({
    ggplot(select_groups) +
      geom_histogram(mapping = aes(x = year, y = count, fill = Bias), stat = "identity") +
      ggtitle("Number of Hate Crimes from 1991-2014 based on Minority Groups") +
      labs(y = "Count(Number of Single Crimes Committed",
           x = "Year (1991-2014)",
           fill = "Motivation for Hate Crimes"
      )
  })
  # Ghina's Code
  output$plot_catholic <- renderPlot({
    catholic.plot
  })
  
  output$plot_muslim <- renderPlot({
    muslim.plot
  })
  

}

shinyApp(ui, my_server)