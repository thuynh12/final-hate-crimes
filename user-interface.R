library(shiny)
library(leaflet) # it's tracy's plz don't mind
library(geojson) # tracy's
library(geojsonio) # tracy's

source("analysis.R")

### TRY TO KEEP THE CODE NEAT. MAKE SURE YOUR PROGRAM RUNS BEFORE COMMITTING.
### AVOID MAKING OTHER'S CODE BREAK.
ui <- tagList(
  navbarPage(
    theme = shinythemes::shinytheme("darkly"),
    title = "Hate Crimes Across the United States",
    tabPanel(
      "Home",
      sidebarLayout(
        sidebarPanel(
          selectInput('slider_year', label = "Select A Year",
                       choices = unique(hate.crimes$year)), width = 2
        ), 
        mainPanel(
          h1("Overview"),
          p("The United States Federal Bureau of Investigation holds hate crimes to the highest 
            priority of the Civil Rights program. The FBI defines hate crimes as criminal offense
            against a person or property motivated in whole or in part by an offender's bias
            against a race, religion, disability, sexual orientation, ethnicity, gender, or 
            gender identity. Hate crimes have distructive impact on communities and families, and
            the preaching of hatred and intolerance can plant terrorism within the country. The FBI
            also mentions that hate itself is not a crime, and the FBI must be careful to protect
            freedom of speech and other civil liberties."),
          p("The data we have worked with covers information on the amount of hate crimes that happen within the years of
            1991 to 2014. We see that there is a major difference in the amount of hate crimes that happened to Muslims
            and the amount that happened to Catholics. We also looked at major events and how those affected the rates of 
            crime towards minority populations. Hate crimes continue to rise in the current political climate as
            continues research is being done and updated."),
          
          h3(textOutput('year_status'), align = 'center'),
          leafletOutput('overall_map'),
          h3("Resources:"),
          p(a("FBI's Hate Crime"), href = "https://www.fbi.gov/investigate/civil-rights/hate-crimes")
          
        )
      )
    ),
    tabPanel(
      "Mapping Hate Crimes",
      sidebarLayout(
        sidebarPanel(
          h3("Sect Bias and Year"),
          selectInput(
            'select_bias',
            label = "Select Bias",
            choices = unique(hate.crimes$bias_motivation)
          ),
          selectInput(
            'select_year',
            label = "Select Year",
            choices = unique(hate.crimes$year)
          ),
          width = 2
        ),
        mainPanel(
          h3("Hate Crimes By Bias and Year", align = 'center'),
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
<<<<<<< HEAD
      "General Data Table of Selected Crimes",
      h3("Meesha's")
=======
      "Specific Event and Hate Crime",
      h3("Meesha's") 
>>>>>>> a5a528b4637ac4521f47bc6726c32137004c47a3
    )
    
  )
  
)
  

