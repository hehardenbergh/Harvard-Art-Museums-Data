library(shiny)
library(tidyverse)
library(knitr)
library(DT)
library(scales)
library(plotly) 

shiny_data <- read_rds("shiny_data.rds") %>% 
  replace_na(list(moves_2009 = 0,
                  moves_2010 = 0,
                  moves_2011 = 0,
                  moves_2012 = 0,
                  moves_2013 = 0,
                  moves_2014 = 0,
                  moves_2015 = 0,
                  moves_2016 = 0,
                  moves_2017 = 0,
                  moves_2018 = 0,
                  
                  pageviews_2009 = 0,
                  pageviews_2010 = 0,
                  pageviews_2011 = 0,
                  pageviews_2012 = 0,
                  pageviews_2013 = 0,
                  pageviews_2014 = 0,
                  pageviews_2015 = 0,
                  pageviews_2016 = 0,
                  pageviews_2017 = 0,
                  pageviews_2018 = 0,
                  
                  studycenterviews_2009 = 0,
                  studycenterviews_2010 = 0,
                  studycenterviews_2011 = 0,
                  studycenterviews_2012 = 0,
                  studycenterviews_2013 = 0,
                  studycenterviews_2014 = 0,
                  studycenterviews_2015 = 0,
                  studycenterviews_2016 = 0,
                  studycenterviews_2017 = 0,
                  studycenterviews_2018 = 0)) %>% 
  
  
  # Add a variable that sums a total of all the times an object has moved since
  # 2009.
  
  mutate(total_moves = 
           moves_2009 + 
           moves_2010 + 
           moves_2011 + 
           moves_2012 +
           moves_2013 + 
           moves_2014 + 
           moves_2015 + 
           moves_2016 + 
           moves_2017 + 
           moves_2018) %>% 
  
  # add another column for total number of pageviews, referring to number of
  # times an object was visited on the museum's public website on a given day
  # since 2009.
  
  mutate(total_pageviews = 
           pageviews_2009 +
           pageviews_2010 + 
           pageviews_2011 + 
           pageviews_2012 + 
           pageviews_2013 + 
           pageviews_2014 + 
           pageviews_2015 + 
           pageviews_2016 + 
           pageviews_2017 + 
           pageviews_2018) %>% 
  
  
  # Add a total study center views variable while keeping the yearly pageviews observations
  # intact with mutate.
  
  mutate(total_studycenterviews = 
           studycenterviews_2009 + 
           studycenterviews_2010 + 
           studycenterviews_2011 +
           studycenterviews_2012 + 
           studycenterviews_2013 + 
           studycenterviews_2014 + 
           studycenterviews_2015 + 
           studycenterviews_2016 + 
           studycenterviews_2017 + 
           studycenterviews_2018) %>% 
  
  # to plot artists nationalities more generally, broaden the geographic
  # location with which they identify for user accessibility.
  
  # case_when(shiny_data$personculture %% "NA" == 0 ~ "North American") %>% 
  
  mutate(personculture = fct_collapse(personculture, 
                                      `Europe` = c("German", "French", "British", "Swiss", "Danish", "Austrian"),
                                      `North America` = c("American", "Cuban"),
                                      `South America` = c("Argentinian", "Venezuelan", "Colombian", "Brazilian"),
                                      `Asia` = c("Japanese", "Chinese", "Palestinian"),
                                      `Australia` = "Australian",
                                      `Africa` = "African"
  )
  )

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Off the Wall: Artwork Activity at the Harvard Art Museum"),
  "How often do objects in the Modern and Contemporary Art Gallery circulate?",
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      selectInput("x", "Choose Values to Plot", 
                  choices = c("Online Page Visits" = "total_pageviews",
                              "In-Gallery Exhibitions" = "total_moves"),
                  selected = "total_moves"),
      
      tags$h6(helpText("To plot how many page visits an artwork has received on the Harvard Art Museum's website, select \"Online Page Visits.\" To show how many times an artwork has been viewed in the gallery, select \"In-Gallery Exhibitions.\" see the `About` tab for more details on the data."))
      
      
),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Graph", plotOutput("plot"),
                           htmlOutput("graph_summary")),
                  tabPanel("Gallery Data", dataTableOutput("table"),
                           htmlOutput("table_summary")),
                  tabPanel("About", htmlOutput("about"))
      )
      
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {
  
  # make x-axis label reactive according to input selected
  
  x_title <- reactive({
    if (input$x == "total_moves") {
      x_title = "In-Gallery Exhibition Frequency"
    } else if (input$x == "total_pageviews") {
      x_title = "Online Page Visits"
    }
  })
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$plot <- renderPlot({
      shiny_data %>%
        filter(personculture != "NA") %>% 
        ggplot(aes_string(x = input$x, fill = "personculture")) +
        geom_density(alpha = 0.5) +
        labs(x = x_title(),
             y = "Density Scale",
             title = "Relationships between Artwork Exhibition Rate, Online Pagevisits, and Artist's Nationality")
    
  })
  
  output$graph_summary <- renderUI({
    str1 = "<h3>Why look at Harvard's art?</h3>" 
    str2 = "This graph specifically considers artworks shown in the Modern and Contemporary Gallery on the first floor of the Fogg Museum. Artist's nationalities were categorized by continent. From this graphic, it is evident from the graphic above that there is no strong correlation between the artist's nationality and the amount of times their work has been displayed in the modern art gallery. However, there is a huge range in the frequencies that specific artworks were viewed, both online and in the gallery. See the 'Gallery Data' tab to find out which artworks are most popular among visitors."

    HTML(paste(str1, str2, sep = ''))
  })
  
  output$table_summary <- renderUI({
    str1 = "<h3>Which artworks are viewed the most?</h3>" 
    str2 = "In this table, there is a significant difference between the minimum and maximum times artworks have been viewed online. There is a slightly smaller range between artworks displayed on the walls of the gallery. Try looking for your artist or artwork, if you have one. How often has it been viewed in the last ten years?"

    HTML(paste(str1, str2, sep = ''))
  })
  
  # insert content for "about" tab
  output$about <- renderUI({
    
    str1 = "This app displays how often objects from the Modern and Contemporary Art galleries (rooms numbered 1120, 1110, 1100) are exhibited to question any correlation between the artist's nationality and the rate at which their artwork is viewed, both online and in-person, since 2009."
    str2 = "Concerning the data, there is unfortunately no way to discern which type of \"move\" an object undergoes, whether it is from one storage unit to another, or from one storage unit to the museum and vice versa. Unfortunately, this may skew results for my hypothesis about which types of artworks by different artists get viewed in the gallery more often. It is a compelling data set, nonetheless, with huge differences in how often selected modern and contemporary artworks have been viewed since 2009."
    str3 = "Thanks to the invaluable help from Jeff Steward, Director of Digital Infrastructure and Emerging Technology at the Harvard Art Museums, this data was gathered from the Museum’s API, which Mr. Steward oversees. The API can be found on the Harvard Art Museum website, here:"  
    str4 = a("Harvard Art Museums API information", href = "https://www.harvardartmuseums.org/collections/api")
    str5 = a("Harvard Art Museum API Github Repository", href = "https://github.com/harvardartmuseums/api-docs")
    
    HTML(paste(str1,
               str2,
               str3,
               str4,
               str5,
               sep = '<br/><br/>'))
   
  })


  # Generate an HTML table view of the data ----
  output$table <- renderDataTable({
    table_1_data <- shiny_data %>% 
      select(title,
             personname,
             personculture,
             total_moves,
             total_pageviews,
             total_studycenterviews)
   
    datatable(table_1_data, colnames = c(`Artwork Title` = "title",
                                         `Artist` = "personname",
                                         `Artist's Nationality` = "personculture",
                                         `Views in the Gallery` = "total_moves",
                                         `Views Online` = "total_pageviews",
                                         `Views in the 4th Floor Study Center` = "total_studycenterviews"))
   })
  
  output$value <- renderText({
    input$caption
  })
  
  
  
}

# Create Shiny app ----
shinyApp(ui, server)