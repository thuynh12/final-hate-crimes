#Loads libraries

library(shiny)
library(ggplot2)  
library(dplyr)
library(tidyr)

# Importing raw data set
crimes_data <- read.csv("file:///C:/Users/meesh/final-hate-crimes/hate_crime.csv", stringsAsFactors = TRUE)

#Filtering data set for crimes specific to our chosen groups.
select_groups <- filter(crimes_data, bias_motivation == c("Anti-Lesbian, Gay, Bisexual, or Transgender, Mixed Group (LGBT)", "Anti-Catholic",
                                                          "Anti-Male Homosexual (Gay)","Anti-Female Homosexual (Lesbian)","Anti-Islamic (Muslem)",
                                                          "Anti-Black or African American"))

# Calculates the mean, meadian, min, and max for the total count in the data set. 
bias_motivation_stats <- summarize(select_groups , mean = mean(count, na.rm = TRUE),
                                   median = median(count, na.rm = TRUE), min = min(count, na.rm = TRUE), 
                                   max = max(count, na.rm = TRUE))


server <- function(input, output) {
  
  # Choose columns to display
  crime_data_2 = select_groups[sample(nrow(select_groups), 500), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(crime_data_2[, input$show_vars, drop = FALSE])

  })
  
  # Plotting/Graph
  output$plot1 <- renderPlot({
    
      ggplot(data = select_groups, mapping = aes(x = year, y = count, fill = bias_motivation), stat = "identity") +
        geom_histogram(aes(color = (count %in% select_groups$bias_motivation)), size = 5) +
        guides(color = FALSE)
      
      ggplot(select_groups) +
        geom_histogram(mapping = aes(x = year, y = count, fill = bias_motivation), stat = "identity", width = .5, height = 50 ) +
        
      ggtitle("Number of Hate Crimes from 1991-2014 based on Minority Groups") +
     labs(y = "Count(Number of Single Crimes Committed",
      x = "Year (1991-2014)",
      fill = "Motivation for Hate Crimes"
      )
    })
}

