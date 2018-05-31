library(dplyr)
library(ggplot2)
library(leaflet)
library(tigris)
library(maps)

### Additional Source For Report : https://ucr.fbi.gov/hate-crime/2015/home 

### DO YOUR ANALYSIS AND WRANGLING HERE FOR NEATNESS
hate.crimes <- read.csv(file = "hate_crime.csv", stringsAsFactors = FALSE)

year <- unique(hate.crimes$year)


# Counting all hate crimes by year

count.by.year <- function(df, result) {
  for (n in year) {
    narrow <- filter(df, year == n)
    sum <- select(narrow, count) %>% sum()
    result[year == n, ]$hate_crimes = sum
  }
  return(result)
}

by.year <- count.by.year(hate.crimes, data.frame(year, hate_crimes = 0))

  



# Rahma's Section











# Meesha's Section


select_groups <- filter(hate.crimes, bias_motivation == c("Anti-Lesbian, Gay, Bisexual, or Transgender, Mixed Group (LGBT)", "Anti-Catholic",
                                                          "Anti-Male Homosexual (Gay)","Anti-Female Homosexual (Lesbian)","Anti-Islamic (Muslem)",
                                                          "Anti-Black or African American"))

bias_motivation_stats <- summarize(select_groups , mean = mean(count, na.rm = TRUE),
                                   median = median(count, na.rm = TRUE), min = min(count, na.rm = TRUE), 
                                   max = max(count, na.rm = TRUE))








# Ghina's Section

#Compare the trend of anti-Muslim hate crimes crimes over time. 

#Filtering the data for Muslim only motivated hate crimes
muslim_motivation <- filter(hate.crime, bias_motivation == c('Anti-Islamic (Muslem)')) %>% 
  select(c(year, bias_motivation, count)) %>% 
  group_by(year)


#Creating the data visualization for Muslim hate crimes over time

ggplot(muslim_motivation) + 
  geom_histogram(mapping = aes(x = year, y = count, fill= bias_motivation), stat ="identity") + scale_fill_brewer(
    palette = "Greens") + theme(legend.position = "none")


#Compare the trend of anti-Catholic hate crimes over time.

#Filtering the data for Catholic only motivated hate crimes
catholic_motivation <- filter(hate.crime, bias_motivation == c('Anti-Catholic')) %>% 
  select(c(year, bias_motivation, count)) %>% 
  group_by(year)

#Creating the data visualization for Catholic hate crimes over time

ggplot(catholic_motivation) + 
  geom_histogram(mapping = aes(x = year, y = count, fill= bias_motivation), stat ="identity") + scale_fill_brewer(
    palette = "Blues") + theme(legend.position = "none")

#Analysis
# Viewing the Anti-Islamic (Muslem) histogram and the Anti-Catholic histogram, we see that the level of Anti-Islamic
# hate crimes is skyrocketting much higher than those of the Anti-Catholic hate crimes. The Muslim hate crimes on
# average are in the hundreds wheraas those of the Catholics are below one hundred on average. 
# Going into the Anti-Islamic trend, we see that it hits an ultimate high right after 2000. This marks an 
#important event of 9/11 that were associated to terrorism acts in the United States. Many people generalized
#and associated violent people with a violent religion. Hate crimes towards Muslims increased after this because 
# fear that plagued America during this time. Until now we see that there is a higher level of hate crimes towards
# muslims after this event. Prior to the 9/11 attacks, there was not as many.
# Another important note in the differences of hate crimes could be due to the fact that many Muslims are 
# more distinguishable than people of other religions (with exceptions). Some Muslim women wear the head scarf
# or hijab that covers their hair which makes them stand out more and can be an easy target for people to 
# unjustly associate them with the terrorism attacks that happen all over the world. 
# Being different has always created a fear in people. In this society, it so happens to be Muslims. The
# American population comprises of a greater percentage of people from the sects of Christianity than those of Muslims. 
# With the Catholic hate crimes we see that there is a pretty constant trend. They began to increase more or less
# in 2005. This could be due to religious views changing and moving towards a more liberal society that does
# not put as much value on religious beliefs. The value of religiousity has changed over time.

# Tracy's Section

# Map work




data("state.fips")
list.state <- state.fips %>% 
  select(abb, polyname) %>% 
  filter(!polyname %in% c("massachusetts:martha's vineyard", "massachusetts:nantucket",
                          "michigan:north", "new york:manhattan", "new york:staten island",
                          "new york:long island", "north carolina:knotts", "north carolina:spit",
                          "virginia:chesapeake", "virginia:chincoteague", "washington:san juan island",
                          "washington:lopez island", "washington:orcas island", "washington:whidbey island"))

# Changing items manually
list.state[20,]$polyname = "massachusetts"
list.state[21,]$polyname = "michigan"
list.state[31,]$polyname = "new york"
list.state[32,]$polyname = "north carolina"
list.state[45,]$polyname = "virginia"
list.state[46,]$polyname = "washington"
list.state[50,] = c("AK", "alaska")
list.state[51,] = c("HI", "hawaii")

# alphabetically
list.state <- arrange(list.state, abb)

list.state$polyname <- stringr::str_to_title(list.state$polyname)

new.map <- full_join(hate.crimes, list.state, by = c("state_postal_abbr" = "abb"))
new.map[is.na(new.map)] <- 0

narrow.map <- new.map  %>% 
  filter(bias_motivation == "Anti-Black or African American" & year == 2010)
  
states <- states(cb = T)

hate.map <- narrow.map %>% 
  group_by(polyname) %>% 
  select(state_postal_abbr, count)

merger <- geo_join(states, hate.map, "STUSPS", "state_postal_abbr")

merger <- subset(merger, !is.na(count))
pal <- colorNumeric("Reds", domain = merger$count)
pop.up <- paste0("Total:", as.character(merger$count))

leaflet() %>%
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

# OVERALL HATE CRIMES

# all hate crimes committed that year by state

# filtering years 


poly.comb <- full_join(list.state, hate.crimes, by = c("abb" = "state_postal_abbr"))
  

year_combined <- poly.comb %>% 
  filter(year == 2005) %>% 
  group_by(polyname) %>% 
  summarize(count = sum(count))

year_distribution <- full_join(list.state, year_combined, by = c("polyname" = "polyname"))

year_distribution[is.na(year_distribution)] <- 0

combined.year <- geo_join(states, year_distribution, "STUSPS", "abb")

combined.year <- subset(combined.year, !is.na(count))

pal <- colorNumeric("Reds", domain = combined.year$count)
pop.up <- paste0("Total:", as.character(combined.year$count))

leaflet() %>%
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
            title = "Hate Crimes By Year")
