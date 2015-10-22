##---
## Title: Air Pollution ODE's Solver Interface
## Author: Anton Antonov
## Start date: 2015-09-29
##---

library(shiny)
library(deSolve)

Pi <- 3.14159265
V <- 28.0 * 10.0^6;

Fr <- function(t) { 10.0^6 * ( 1.0 + 6.0 * sin(2*Pi*t) ) }
Cin <- function(t) { 10.0^6 * ( 10.0 + 10.0 * cos(2*Pi*t) ) }

PFunc <- function( t, y, m ) { list( m[1] * Fr(t) / V * ( Cin(t) - y[1] ) ) } 

server <- function(input, output) {
  
  output$solutionPlot <- renderPlot({
    if ( input$kmin < input$kmax) {
      for( k in seq( input$kmin, input$kmax, 0.05 ) ) {
        yini <- c( y1 = k*10^7. )
        ysol <- ode( y = yini, func = PFunc, times = seq( 0, input$tend, 0.01 ), parms = input$m, method = "ode45" )
        if ( k == input$kmin )  {
          plot( ysol, type = "l", which = "y1", lwd = 2, ylab = "concentration", main = "", ylim = c( 0, 1 * input$kmax * Cin(0) ) )
        } else { 
          lines( ysol, type = "l", lwd = 2 )
        }
      }
    }
  })
}

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("m", "RHS factor:", min = 0, max = 15, step = 0.5, value = 6.0 ),
      sliderInput("kmin", "min initial condition factor:", min = 0, max = 2, step = 0.01, value = 0 ),
      sliderInput("kmax", "max initial condition factor:", min = 0, max = 2, step = 0.01, value = 0.6 ),
      sliderInput("tend", "time interval (years):", min = 1, max = 10, step = 0.5, value = 8 )      
    ),
    mainPanel( plotOutput("solutionPlot") )
  )
)

shinyApp(ui = ui, server = server)
