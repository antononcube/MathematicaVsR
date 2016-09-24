##     Statements saliency in podcasts R interactive interface
##   Copyright (C) 2016  Anton Antonov
##   
##   This program is free software: you can redistribute it and/or modify
##   it under the terms of the GNU General Public License as published by
##   the Free Software Foundation, either version 3 of the License, or
##   (at your option) any later version.
##   This program is distributed in the hope that it will be useful,
##   but WITHOUT ANY WARRANTY; without even the implied warranty of
##   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##   GNU General Public License for more details.
##   You should have received a copy of the GNU General Public License
##   along with this program.  If not, see <http://www.gnu.org/licenses/>.
##   
##   Written by Anton Antonov,
##   antononcube @ gmail . com ,
##   Windermere, Florida, USA.
##============================================================
## This R/Shiny script is part of the project
## 
##   "Statements saliency in podcasts",
##  https://github.com/antononcube/MathematicaVsR/tree/master/Projects/StatementsSaliencyInPodcasts
## 
## at MathematicaVsR at GitHub,
##   https://github.com/antononcube/MathematicaVsR .
##
##============================================================

library(shiny)
library(DT)

server <- function(input, output) {
  
  qIndex <- reactive( { input$index })
  
  ##   Using simple title search
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
