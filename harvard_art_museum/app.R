#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(httr)
library(tidyverse)
library(jsonlite)
library(rjson)
library(shiny)

myapikey <- "33fb5b60-e095-11e8-8b7a-1f4f3883b636"

#get data for moves in activity resource from API
raw.data <- GET("https://api.harvardartmuseums.org/activity",
                query = list(search = "moves",
                             "pageviews",
                             api_key=myapikey))

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Tracking Artwork at the Harvard Art Museum"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
         
         
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
   
     #generate a plot that shows ...
     
     ggplot(data.2, aes(pageviews, moves)) + geom_line()
    
})}

# Run the application 
shinyApp(ui = ui, server = server)

