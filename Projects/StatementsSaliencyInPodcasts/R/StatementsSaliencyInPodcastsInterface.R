##---
## Title: Interactive interface for salient statements in podcasts
## Author: Anton Antonov
## Start date: 2016-09-18
##---

library(shiny)
library(DT)

source("./FreakonomicsPodcastsIngestion.R")

server <- function(input, output) {
  
  qIndex <- reactive( { input$index })
  
  ## Using simple title search
  output$view <-  DT::renderDataTable({ datatable({
    data.frame( Title = podcastTitles, stringsAsFactors = FALSE )
  }, rownames = TRUE, filter = 'top', options = list(pageLength = 8, autoWidth = FALSE) ) })
  
  
  output$title <- renderText( podcastTitles[[qIndex()]] )
    
  output$resDT <- 
    DT::renderDataTable({ datatable({ 
      MostImportantSentences( sentences = podcastTexts[[qIndex()]], 
                              nSentences = input$nStatements, 
                              globalTermWeightFunction = input$globalTermWeightFunction,
                              stopWords = if( input$removeStopWordsQ ) {stopWords} else {NULL}, 
                              applyWordStemming = input$applyWordStemmingQ )
    }, rownames = FALSE, options = list(pageLength = 10, autoWidth = TRUE) ) })
  
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      numericInput( "index", "podcast index:", value = 1, min = 1, max = length(podcastTexts), step = 1 ),
      numericInput( "nStatements", "Number of statements:", 10 ),
      radioButtons( "globalTermWeightFunction", "LSI global term-weight function:", choices = c("IDF","GFIDF","Entropy","None"), selected = "IDF"),
      checkboxInput( "removeStopWordsQ", "Remove stop words? : ", value = TRUE ),
      checkboxInput( "applyWordStemmingQ", "Apply word stemming? :", value = FALSE)
    ),
    mainPanel( 
      tabPanel( "Search results", DT::dataTableOutput("view") ),
      column( 12, 
                       h4( textOutput( "title" ) ), 
                       
                       DT::dataTableOutput("resDT") ) )
  )
)

shinyApp(ui = ui, server = server)
