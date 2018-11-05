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


data.2 <- read_csv("polls_IT-parliament_2018-10-01.csv")

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
     
     ggplot(data.2, aes(date, firm)) + geom_line()
    
})}

# Run the application 
shinyApp(ui = ui, server = server)

