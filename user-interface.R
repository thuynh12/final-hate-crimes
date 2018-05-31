library(shiny)
library(leaflet) 
library(geojson) 
library(geojsonio) 

source("analysis.R")
source("rahma.kamel.R")

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
          strong("Click on a State for exact count."),
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
          h3("Mapping Hate Crimes In America"),
          p("The American South has some very intense stereotypes of being more
            racist and intolerant towards People of Color. This map is to explore the 
            concept and prenotion that Southerners are more racist than the rest
            of the countries. This mapping shows the distribution of hate crimes by 
            types of bias and year."),
          h3("Hate Crimes By Bias and Year", align = 'center'),
          leafletOutput('hate_map'), 
          strong("Click on a State to see exact number"),
          p("However, you can see that the most hate crimes commited lie outside the South.
            This may be due to the population and demographic of other states. Some states
            may have higher populations for different racial groups. In addition, this map 
            does not take account for state population, therefore for California and Texas
            being the most populous may have higher counts of hate crimes.")
        )
      )  
    ),
    tabPanel(
      "History and Hate Crimes", 
      mainPanel(
      h1("History and Hate Crimes", align = "center"),
      h3("Analyzing how different historical events have impacted hate crimes and how often they occur.
         Below we have chosen to analyze trends of hate crimes on Muslims before and after 9/11, hate
         crimes on LGBTQ+ overtime specifically analyzing 2000 when same sex marriage was passed in Vermont, 
         making it the first state to do so, and finally the correlation of hate crimes against white and black
         people overtime"),
      plotOutput("plot_9_11"),
      p(""),
      p("The above visualization documents the developement of Anti-Muslim hate crimes over the years. 
        The blue bar represents 2001 which is the year that 9/11 occured. Notably, after 2001 the count of
        crimes against Muslims increased significantly. This is because people connected an extremist claiming 
        to follow religion to justify his violence when in reality Islam is a very peaceful religion. The data
        clearly shows a constant increase and trend line forming after 2001."),
      plotOutput("LGBT"),
      p(""),
      p("Hate crimes against the LGBTQ+ community have always been constant. Depending on the year and the 
         political climate crimes will fluctuate averaging around 400 cases a year. The blue bar represents
        2000, which is the year that Vermont, was the first state to legalize same sex marriage. The count for
        that year is notably less than the other years. This could have something to do with the legalization of 
        same sex marriage or it can be an unrelated trend. This data very effectively visualizes the hardships that
        the LGBTQ+ community has had to go through and creates a pattern that we can work to avoid."),
      plotOutput("black_white"),
      p(""),
      p("Looking at the visualizations, anti-White hate crimes vary and are at times higher than
        that of anti-Black hate crimes. It is important to note the population accountability. 
        The sample of the White population includes many groups that were marginalized historically 
        in the United States. For instance, many Jewish, Italians and Greeks are taken into account 
        as White. Another note to make is that many anti-Black hate crimes are more frequently 
        underreported or are not accounted for in general because of the societal discrimination structures. 

        Moreover, from the years 1991-2014 anti-Black hate crimes are clearly high. 
        This is a crucial point that is being made through this analysis. Ant-Black hate crimes are 
        significantly higher and this is due to many historical and current events that happen day 
        to day in our contemporary society.")
      )
    ),
    tabPanel(
      "Religious Hate Crime",
      h3("Catholic Hate Crimes", align = 'center'),
      plotOutput('plot_catholic'),
      h3("Muslim Hate Crimes", align = 'center'),
      plotOutput('plot_muslim'),
      h3("Comparing Religious Hate Crimes", align = 'center'),
      p(" Viewing the Anti-Islamic (Muslem) histogram and the Anti-Catholic histogram, we see that the level of Anti-Islamic        hate crimes is skyrocketting much higher than those of the Anti-Catholic hate crimes. The Muslim hate crimes on 
      average are in the hundreds wheraas those of the Catholics are below one hundred on average. 
      Going into the Anti-Islamic trend, we see that it hits an ultimate high right after 2000. This marks an 
      important event of 9/11 that were associated to terrorism acts in the United States. Many people generalized
      and associated violent people with a violent religion. Hate crimes towards Muslims increased after this because 
      fear that plagued America during this time. Until now we see that there is a higher level of hate crimes towards
      muslims after this event. Prior to the 9/11 attacks, there was not as many.
      Another important note in the differences of hate crimes could be due to the fact that many Muslims are 
      more distinguishable than people of other religions (with exceptions). Some Muslim women wear the head scarf
      or hijab that covers their hair which makes them stand out more and can be an easy target for people to 
      unjustly associate them with the terrorism attacks that happen all over the world. 
      Being different has always created a fear in people. In this society, it so happens to be Muslims. The
      American population comprises of a greater percentage of people from the sects of Christianity than those of Muslims. 
      With the Catholic hate crimes we see that there is a pretty constant trend. They began to increase more or less
      in 2005. This could be due to religious views changing and moving towards a more liberal society that does
      not put as much value on religious beliefs. The value of religiousity has changed over time.")
    ),
    tabPanel(
      "General Data Table of Hate Crimes Against Select Minorities",
      sidebarLayout(
        sidebarPanel(
          h3("Selection"),
          selectInput(
            'm.year', 
            label = "Select Year",
            choices = unique(hate.crimes$year)
          ),
          width = 2
        ),
        mainPanel(
          h3("Hate Crimes Against Selected Minorities"),
          p("A hate crimes is defined as a crime against an individual based on their background or chracterstics which
            make that person diverse from the majority. In the United States many are targeted based 
            on such aspects which explains one main focus of our
            data which is bias motivation. The data table displays diverse groups
            (based on bias motivation) and the number of people within
            those groups who have been victimized by prejudice in the United States. The data was
            gathered from 1991-2014 and focuses on those who are Anti-Lesbian, Gay, Bisexual, 
            or Transgender, Mixed Group (LGBT), Anti-Catholic, Anti-Male Homosexual (Gay), 
            Anti-Female Homosexual (Lesbian), Anti-Islamic (Muslem),
            Anti-Black or African American. The plot displays a visual of the hate crimes
            throughout our chosen time period and it clearly shows
            that Ant-Black or African American bias remains the highest bias motivation throughout every 
            year from 1991-2014. The high numbers could be explained by the median attention given to the group. 
            Regardless of Whether the attention reflects positively or negatively on the
            group, those who are Anti-African American will react negatively. Overall, the data reveals consistently 
            high numbers of opression towards African Americans and the other groups also hold consistent numbers
            of crimes against them throughout the years"),
          tableOutput('minority_table'),
          strong("This is a table summarizing counts of hate crimes commited during a specific year. 
            You can select the year with the drop down menu on the left."),
          p(""),
          plotOutput('sum_plot'),
          p("This graph shows the overall hate crime distribution from 1991 to 2014"),
          p(""),
          h3("Resources:"),
          p(a("History of Hate Crime Tracking in the US"), href =  
                               "https://www.cnn.com/2017/01/05/health/hate-crimes-tracking-history-fbi/index.html")
          
        )
      )
    )
    
  )
  
)

