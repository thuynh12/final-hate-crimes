#install.packages("shiny")
#install.packages("ggplot2")

library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)

# Comparing and contrasting the frequency of anti-Muslim hate crimes to those 
#of anti-Catholic hate crimes.

hate_crime <- read.csv("hate_crime.csv", stringsAsFactors = FALSE)
View(hate_crime)

#Compare the trend of anti-Muslim hate crimes crimes over time. 

  #Filtering the data for Muslim only motivated hate crimes
muslim_motivation <- filter(hate_crime, bias_motivation == c('Anti-Islamic (Muslem)')) %>% 
  select(c(year, bias_motivation, count)) %>% 
  group_by(year)
View(muslim_motivation)

#Creating the data visualization for Muslim hate crimes over time

ggplot(muslim_motivation) + 
  geom_histogram(mapping = aes(x = year, y = count, fill= bias_motivation), stat ="identity") + scale_fill_brewer(
    palette = "Greens") + theme(legend.position = "none")

#Compare the trend of anti-Catholic hate crimes over time.

  #Filtering the data for Catholic only motivated hate crimes
catholic_motivation <- filter(hate_crime, bias_motivation == c('Anti-Catholic')) %>% 
  select(c(year, bias_motivation, count)) %>% 
  group_by(year)
View(catholic_motivation)
  
#Creating the data visualization for Catholic hate crimes over time

ggplot(catholic_motivation) + 
  geom_histogram(mapping = aes(x = year, y = count, fill= bias_motivation), stat ="identity") + scale_fill_brewer(
    palette = "Blues") + theme(legend.position = "none")

##Overview
# The data we have worked with covers information on the amount of hate crimes that happen within the years of
# 1991 to 2014. We see that there is a major difference in the amount of hate crimes that happened to Muslims
# and the amount that happened to Catholics. Hate crimes continue to rise in the current political climate as
# continues research is being done and updated.

#Analysis
# Viewing the Anti-Islamic (Muslem) histogram and the Anti-Catholic histogram, we see that the level of Anti-Islamic
# hate crimes is skyrocketting much higher than those of the Anti-Catholic hate crimes. The Muslim hate crimes on
# average are in the hundreds wheraas those of the Catholics are below one hundred on average. 
# Going into the Anti-Islamic trend, we see that it hits an ultimate high right after 2000. This marks an 
#important event of 9/11 that were associated to terrorism acts in the United States. Many people generalized
#and associated violent people with a violent religion. Hate crimes towards Muslims increased after this because 
# fear that plagued America during this time. Until now we see that there is a higher level of hate crimes towards
# muslims after this event. Prior to this, there was not as many.
#With the Catholic hate crimes we see that there is
