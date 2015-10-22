##---
## Title: Air Pollution ODE's Solver
## Author: Anton Antonov
## Start date: 2015-09-29
##---

library(deSolve)

Pi <- 3.14159265
V <- 28.0 *10.0^6;

Fr <- function(t) { 10.0^6 * ( 1.0 + 6.0 * sin(2*Pi*t) ) }
Cin <- function(t) { 10.0^6 * ( 10.0 + 10.0 * cos(2*Pi*t) ) }

PFunc <- function( t, y, m ) { list( m[1] * Fr(t) / V * ( Cin(t) - y[1] ) ) } 

## yini <- c( y1 = 10^7. )
## ysol <- ode( y = yini, func = PFunc, times = seq(0,10,0.01), parms = 6.0, method = "ode45" )

for( k in seq(0,0.6,0.05) ) {
  yini <- c( y1 = k*10^7. )
  ysol <- ode( y = yini, func = PFunc, times = seq(0,10,0.01), parms = 6.0, method = "ode45" )
  if ( k==0 )  {
    plot( ysol, type = "l", which = "y1", lwd = 2, ylab = "y", main = "ode45")
  } else { 
    lines( ysol, type = "l", lwd = 2, ylab = "y", main = "ode45")
  }
}