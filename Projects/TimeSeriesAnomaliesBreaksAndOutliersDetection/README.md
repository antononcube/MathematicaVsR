# Time series nomalies, breaks, and outliers detection

## In brief

In this project we compare several non-parametric methods for finding anomalies, breaks,
and outliers in time series.

We are interested in finding anomalies in both single time series and collections of time series.

The following mind-map shows a summary and relations of the methods we are interested in.

## Definitions

There are many ways to define anomalies in time series. 
Here we are going to list the ones we look for in this project. 

**Point Anomaly:** Simply and outlier of the values of the time series.

**Contextual Anomaly:** An anomaly that is local to some sub-sequence of the time series.
 
**Breakpoint:** A regressor value (time) of a time series where the mean of the values change. 
(Also, consider (i) shifts in trend, (ii) other changes in trend and/or, (iii) changes in variance.)

**Structural break:** Unexpected changes of the parameters of regression models.

**Outlier:** *Left as an exercise...*


## References

[Wk1] Wikipedia, ["Structural break"](https://en.wikipedia.org/wiki/Structural_break).

[]