library(shiny)
library(tidyverse)
library(knitr)
library(scales)

data <- read_rds("shiny_data.rds")

# Define UI for random distribution app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Off the Wall: Object Activity at the Harvard Art Museum"),
  "Looking at how often Modern and Contemporary Art Gallery objects circulate",
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: drop-down menu to display observations  ----
      # selectInput("x",
      #             "Year:",
      #             choices = c(`2009` = "moves"),
      #             
      #             "y",
      #             "Y-axis:",
      #             choices = c(`Predicted Democratic Advantage` = "poll_dem_advantage",
      #                         `Actual Democratic Advantage` = "actual_dem_advantage"),
      #             multiple = TRUE),
      
      checkboxInput("line", label = "Add linear model"),
      htmlOutput("see_table"),
      htmlOutput("regression_table"),
      
      
      # br() element to introduce extra vertical spacing ----
      br(),
      
      selectInput("personculture", "Artist Nationality",
                  choices = c("American",
                              "African",
                              "Argentinian",
                              "Australian",
                              "Austrian",
                              "Brazilian",
                              "British",
                              "Chinese",
                              "Colombian",
                              "Cuban",
                              "Danish",
                              "French",
                              "German",
                              "Japanese",
                              "Palestinian",
                              "Swiss",
                              "Venezuelan")
                  ),
      
      selectInput("personname", "Artist Name",
                  choices = c( "Mona Hatoum",
                               "Carrie Mae Weems",
                               "Gary Schneider",
                               "John Coplans",
                               "Annette Lemieux",
                               "LaToya Ruby Frazier",
                               "Gordon Matta-Clark",
                               "Werner Büttner",
                               "Mimi Smith",
                               "Zhang Xiaogang",
                               "Thomas Struth",
                               "Candida Höfer",
                               "J.D. 'Okhai Ojeikere",
                               "Todd Hido",
                               "Kiki Smith",
                               "Arnulf Rainer",
                               "Richard Tuttle",
                               "Joseph Beuys",
                               "Hanne Darboven",
                               "Bernd and Hilla Becher",
                               "Hollis Frampton",
                               "Henry Wessel Jr.",
                               "Günther Uecker",
                               "Sol LeWitt",
                               "Robert Rauschenberg",
                               "Dennis Oppenheim",
                               "Danny Lyon",
                               "Sigmar Polke",                   
                               "Franz Erhard Walther",
                               "Bruce Nauman",
                               "Edward Ruscha",
                               "Andy Warhol",
                               "Mira Schendel",
                               "Carmelo Arden Quin",
                               "Charlotte Posenenske",
                               "Otto Piene",
                               "Cy Twombly",
                               "Arman (Armand Pierre Fernandez)",
                               "Corinne Wasmuht",
                               "Rachel Whiteread",
                               "Catherine Wagner",
                               "Jack Welpott",
                               "Graham Howe",
                               "Georg Baselitz",                 
                               "Geoffrey Hendricks",
                               "Alice Hutchins",
                               "Jock Reynolds",
                               "George Maciunas",
                               "Joseph Kosuth",
                               "Ken Friedman",
                               "Karl-Heinz Chargesheimer",
                               "Ellsworth Kelly",                
                               "William A. Garnett",
                               "Peter Keetman",
                               "John Cage",
                               "Yoko Ono",
                               "Vera Lutter",
                               "Richard Avedon",
                               "Lotte Jacobi",
                               "Clarence J. Laughlin",
                               "Henry Holmes Smith",
                               "Toni Schneiders",
                               "Aaron Siskind",
                               "Minor White",                    
                               "Ralston Crawford",
                               "Robert Watts",
                               "Nam June Paik",
                               "George Brecht",                  
                               "Ay-O",
                               "Kerry James Marshall",
                               "Teresita Fernandez",
                               "Eva Hesse",
                               "Konrad Klapheck",
                               "Ben Vautier",
                               "Alison Knowles",
                               "Roy Lichtenstein",               
                               "Diane Arbus",
                               "Louise Nevelson",
                               "Various Artists",
                               "VALIE EXPORT",
                               "Mieko (Chieko) Shiomi",
                               "Ben Patterson",
                               "Takehisa Kosugi",
                               "Dick Higgins",
                               "Robert Gober",
                               "Joe Jones",
                               "Hi Red Center",
                               "Per Kirkeby",                    
                               "Anna Bella Geiger",
                               "Camille Graeser",
                               "Max Bill",
                               "Emmett Williams",                
                               "Gego (Gertrude Goldschmidt)",
                               "Otto Steinert",
                               "David Smith",
                               "Rosemarie Trockel",              
                               "Doris Salcedo",
                               "Ernesto Fernández",
                               "Lorna Simpson",
                               "La Monte Young",
                               "Mel Bochner",
                               "Faith Ringgold",
                               "Victor Grippo",
                               "Josef Albers",                   
                               "Brice Marden",
                               "Morris Louis",
                               "Kenneth Noland",
                               "Howardena Pindell",              
                               "Agnes Martin"),
                  selected = "Agnes Martin",
                  multiple = TRUE),
      
      selectInput("classification", "Type of Artwork",
                  choices = c("Sculpture",
                              "Photographs",
                              "Paintings",
                              "Audiovisual Works",
                              "Prints",
                              "Drawings",
                              "Multiples",
                              "Performance Artifacts",
                              "Books")),
      
      selectInput("viewtype2018", "Viewed Online or On the Wall in 2018?",
                  choices = c(`Online` = "pageviews_2018",
                              `In the Museum` = "moves_2018",
                              `4th Floor Study Center` = "studycenterviews_2018"))
      
      

    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Data", tableOutput("table"))
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
        ggplot(aes(x = input$personculture, y = input$viewtype2018)) +
        geom_point() +
        geom_smooth(method="lm", se=FALSE) +
        labs(x = "Nationality",
             y = "Views in 2018",
             title = "How often do artworks by artists of color get viewed?")
  })
  
  # # display regression table
  # output$regression_table <- renderUI({
  #   filteredData <- reactive ({
  #     df <- app_data[app_data$state %in% input$state,]
    # })
  # })
  
  # # Generate a summary of the data ----
  # output$summary <- renderPrint({
  #   
  #   shiny_data %>% 
  #     select(input$data) %>% 
  #     summary()
    
  # })
  # 
  # # Generate an HTML table view of the data ----
  # output$table <- renderTable({
  #   
  #   shiny_data %>% 
  #     
  #     
  # })
  
}

# Create Shiny app ----
shinyApp(ui, server)