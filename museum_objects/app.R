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
  
  mutate(personculture = fct_collapse(personculture, 
                                      `Europe` = c("German", "French", "British", "Swiss", "Danish", "Austrian"),
                                      `North America` = c("American", "Cuban", "NA"),
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

      radioButtons("plotdata", "Choose Values to Plot", 
                   choices = c("Artist Nationality" = "personculture",
                               "Artwork Type" = "classification"),
                   selected = "personculture")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Most Moves", dataTableOutput("table")),
                  tabPanel("About", htmlOutput("about"))
      )
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$plot <- renderPlot({
      shiny_data %>%
        select(total_moves, 
               classification, 
               personculture)%>% 
        ggplot(aes(x = total_moves, fill = personculture)) +
        geom_density(alpha = 0.3) +
        labs(x = "Views, Online and In-Person",
             title = "Relationships between Artwork Exhibition Rate and Artist's Nationality")
  })
  
  # insert content for "about" tab
  output$about <- renderUI({
    str1 = "This app displays how often objects from the Modern and Contemporary Art galleries (rooms numbered 1120, 1110, 1100) are exhibited to question any correlation between the artist's nationality and the rate at which their artwork is viewed, both online and in-person."
    str2 = "Thanks to the invaluable help from Jeff Steward, Director of Digital Infrastructure and Emerging Technology at the Harvard Art Museums, this data was gathered from the Museum’s API, which Mr. Steward oversees. The API can be found on the Harvard Art Museum website, here:"
    str3 = a("Harvard Art Museums API information", href = "https://www.harvardartmuseums.org/collections/api")
      
    HTML(paste(str1, str2, str3, sep = "<br> "))
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
  
  # output$value <- renderText({input$about})
}

# Create Shiny app ----
shinyApp(ui, server)