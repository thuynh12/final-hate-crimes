library(dplyr)
library(tidyr)
library(ggplot2)
library(RColorBrewer)


hate_crimes <- read.csv(file = 'hate_crime.csv', stringsAsFactors = FALSE)

data_9_11 <-select(hate_crimes, c(year, bias_motivation, count)) %>% 
  filter(bias_motivation == c("Anti-Islamic (Muslem)"))

plot_9_11 <- ggplot(data_9_11) +
             geom_histogram(mapping = aes(x = year, y = count, fill = year == 2001),
                            stat = "identity") +
             theme(legend.position = "none") +
             labs(
               title = "Pre and Post 9/11 Hate Crimes Against Muslims in America",
               y = "Count (Number of Single Crimes Committed)",
               x = "Year (1991 - 2014)"
             )
             

data_LGBTQ <- select(hate_crimes, c(year, bias_motivation, count)) %>% 
  filter(bias_motivation == c("Anti-Lesbian, Gay, Bisexual, or Transgender, Mixed Group (LGBT)", 
                              "Anti-Male Homosexual (Gay)", "Anti-Female Homosexual (Lesbian)"))

LGBT <- ggplot(data_LGBTQ) +
        geom_histogram(mapping = aes(x = year, y = count, fill = year == 2000), stat = "identity") +
        theme(legend.position = "none") +
        labs(
        title = "Hate Crimes Against the LGBTQ+ Community",
        y = "Count (Number of Single Crimes Committed)",
        x = "Year (1991 - 2014)"
      )

data_black_white <-select(hate_crimes, c(year, bias_motivation, count)) %>% 
  filter(bias_motivation == c("Anti-Black or African American", "Anti-White"))


black_white <- ggplot(data_black_white) +
               geom_histogram(mapping = aes(x = year, y = count, fill = bias_motivation), 
                              stat = "identity", position = "dodge") +
               labs(
               title = "Comparing Hate Crimes Against Whites and Blacks",
               y = "Count (Number of Single Crimes Committed)",
               x = "Year (1991 - 2014)", 
               fill = "Motivation of Hate Crimes"
              ) 





