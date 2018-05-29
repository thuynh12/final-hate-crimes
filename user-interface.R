library(shiny)
library(leaflet) # it's tracy's plz don't mind
library(geojson) # tracy's
library(geojsonio) # tracy's

source("analysis.R")

### TRY TO KEEP THE CODE NEAT. MAKE SURE YOUR PROGRAM RUNS BEFORE COMMITTING.
### AVOID MAKING OTHER'S CODE BREAK.
ui <- fluidPage(
  titlePanel("Hate Crimes Across the United States"),
  
  tabsetPanel(
    tabPanel(
      "Welcome",
      
      
      sidebarLayout(
        sidebarPanel(
          selectInput('slider_year', label = "Select Year",
                      choices = unique(hate.crimes$year))
        ),
        mainPanel(
          h3("Overall Look Of Hate Crimes in America", align = 'center'),
          leafletOutput('overall_map')
        )
      )      
      
    ),
    tabPanel(
      "Tracy's Mapping Hate Crimes",
      sidebarLayout(
        sidebarPanel(
          h3("Sections"),
          selectInput(
            'select_bias',
            label = "Select Bias",
            choices = unique(hate.crimes$bias_motivation)
          ),
          selectInput(
            'select_year',
            label = "Select Year",
            choices = unique(hate.crimes$year)
          )
          
        ),
        mainPanel(
          h3("Hate Crimes By Bias and Year"),
          leafletOutput('hate_map')
          
        )
      )
    ),
    tabPanel(
      "History and Hate Crime",
      h3("Rahma's")
    ),
    tabPanel(
      "Religious Hate Crime",
      h3("Ghina's")
    ),
    tabPanel(
      "Specific Event and Hate Crime",
      h3("Meesha's")
    )
  )
)
