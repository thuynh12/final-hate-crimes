library(shiny)

source("analysis.R")

### TRY TO KEEP THE CODE NEAT. MAKE SURE YOUR PROGRAM RUNS BEFORE COMMITTING.
### AVOID MAKING OTHER'S CODE BREAK.
ui <- fluidPage(
  titlePanel("Hate Crimes Across the United States"),
  
  tabsetPanel(
    tabPanel(
      "Welcome",
      h3("Everyone")
    ),
    tabPanel(
      "Mapping Hate Crimes",
      h3("Tracy's")
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