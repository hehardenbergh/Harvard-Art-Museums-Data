library(shiny)
library(tidyverse)
library(knitr)
library(DT)
library(scales)

activity <- read_rds("shiny_data.rds")

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
                  choices = c("Aaron Siskind",
                              "Agnes Martin",
                              "Alice Hutchins",
                              "Alison Knowles",
                              "Anna Bella Geiger",
                              "Andy Warhol",
                              "Annette Lemieux",
                              "Arman (Armand Pierre Fernandez)",
                              "Arnulf Rainer",
                              "Ay-O",
                              "Ben Patterson",
                              "Ben Vautier",
                              "Bernd and Hilla Becher",
                              "Brice Marden",
                              "Bruce Nauman",
                              "Candida Höfer",
                              "Camille Graeser",
                              "Carmelo Arden Quin",
                              "Carrie Mae Weems",
                              "Catherine Wagner",
                              "Charlotte Posenenske",
                              "Clarence J. Laughlin",
                              "Corinne Wasmuht",
                              "Cy Twombly",
                              "Danny Lyon",
                              "David Smith",
                              "Dennis Oppenheim",
                              "Diane Arbus",
                              "Dick Higgins",
                              "Doris Salcedo",
                              "Edward Ruscha",
                              "Ellsworth Kelly",                
                              "Emmett Williams",                
                              "Ernesto Fernández",
                              "Eva Hesse",
                              "Faith Ringgold",
                              "Franz Erhard Walther",
                              "Gary Schneider",
                              "Gego (Gertrude Goldschmidt)",
                              "Geoffrey Hendricks",
                              "Georg Baselitz",                 
                              "George Brecht",                  
                              "George Maciunas",
                              "Gordon Matta-Clark",
                              "Graham Howe",
                              "Günther Uecker",
                              "Hanne Darboven",
                              "Henry Holmes Smith",
                              "Henry Wessel Jr.",
                              "Hi Red Center",
                              "Hollis Frampton",
                              "Howardena Pindell",              
                              "Jack Welpott",
                              "J.D. 'Okhai Ojeikere",
                              "Jock Reynolds",
                              "Joe Jones",
                              "John Cage",
                              "John Coplans",
                              "Josef Albers",                  
                              "Joseph Beuys",
                              "Joseph Kosuth",
                              "Karl-Heinz Chargesheimer",
                              "Ken Friedman",
                              "Kenneth Noland",
                              "Kerry James Marshall",
                              "Kiki Smith",
                              "Konrad Klapheck",
                              "La Monte Young",
                              "LaToya Ruby Frazier",
                              "Lorna Simpson",
                              "Lotte Jacobi",
                              "Louise Nevelson",
                              "Max Bill",
                              "Mel Bochner",
                              "Mimi Smith",
                              "Minor White",                    
                              "Mira Schendel",
                              "Mieko (Chieko) Shiomi",
                              "Mona Hatoum",
                              "Morris Louis",
                              "Nam June Paik",
                              "Otto Piene",
                              "Otto Steinert",
                              "Peter Keetman",
                              "Per Kirkeby",                    
                              "Rachel Whiteread",
                              "Ralston Crawford",
                              "Richard Avedon",
                              "Richard Tuttle",
                              "Robert Gober",
                              "Robert Rauschenberg",
                              "Robert Watts",
                              "Rosemarie Trockel",              
                              "Roy Lichtenstein",               
                              "Sigmar Polke",                   
                              "Sol LeWitt",
                              "Takehisa Kosugi",
                              "Teresita Fernandez",
                              "Thomas Struth",
                              "Todd Hido",
                              "Toni Schneiders",
                              "Vera Lutter",
                              "Werner Büttner",
                              "William A. Garnett",
                              "Yoko Ono",
                              "Various Artists",
                              "VALIE EXPORT",
                              "Victor Grippo",
                              "Zhang Xiaogang"),
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
      
      selectInput("viewtype", "Viewed Online or On the Wall in 2018?",
                  choices = c(`Online` = "total_pageviews",
                              `In the Museum` = "total_moves",
                              `4th Floor Study Center` = "studycenterviews_2018"))
      

    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Most Moves", dataTableOutput("table"))
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
      activity %>%
        ggplot(aes(x = input$personname, y = input$viewtype)) +
        geom_point() +
        labs(x = "Artist",
             y = "Object Activity",
             title = "How often do artworks by artists of color get viewed?")
  })
  
  # # display regression table
  # output$regression_table <- renderUI({
  #   filteredData <- reactive ({
  #     df <- app_data[app_data$state %in% input$state,]
    # })
  # })
  
  

  # Generate an HTML table view of the data ----
  output$table <- renderDataTable({
    activity %>% 
      select(title,
            personname,
            total_moves,
            total_pageviews,
            total_studycenterviews) %>% 
      mutate(inperson_views = sum(total_moves,
                                total_studycenterviews,
                                na.rm = T)) %>% 
      rename(online_views = total_pageviews)

    movetypes %>% 
      select(title,
             personname,
             inperson_views,
             online_views,
             total_studycenterviews) %>% 
      arrange(desc(inperson_views)) %>% 
      kableExtra::kable(col.names = c("Object Title",
                                    "Artist",
                                    "Total In-Person Exhibits",
                                    "Total Online Visits",
                                    "Visits in the 4th Floor Study Center"),
                      caption = "Most Moves in the Modern and Contemporary Art Gallery at the Fogg Museum")
    
  })
}

# Create Shiny app ----
shinyApp(ui, server)