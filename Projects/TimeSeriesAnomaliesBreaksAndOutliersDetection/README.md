# Time series anomalies, breaks, and outliers detection

## In brief

In this project we show, explain, and compare several non-parametric methods for finding 
anomalies, breaks, and outliers in time series.

We are interested in finding anomalies in both single time series and collections of time series.

The following mind-map shows a summary and relations of the methods we are interested in.

![AnomaliesMindMap](https://github.com/antononcube/MathematicaVsR/raw/master/Projects/TimeSeriesAnomaliesBreaksAndOutliersDetection/Diagrams/Time-Series-anomalies-mind-map.png)

Good warm-up reads are [PT1], [Wk1].

## Definitions

There are many ways to define anomalies in time series. 
Here we are going to list the ones we focus on in this project. 

**Point Anomaly:** Simply and outlier of the values of the time series.

**Contextual Anomaly:** An anomaly that is local to some sub-sequence of the time series.
 
**Breakpoint:** A time of a time series where the mean of the values change. 
Also, consider: (i) shifts in trend, (ii) other changes in trend and/or, (iii) changes in variance.

**Structural break:** Unexpected changes of the parameters of regression models.

**Outlier:** *Left as an exercise...*

## Methods chosen

"Non-parametric methods" means more data-driven and ad hoc methods.
For example, K-Nearest Neighbors (KNN) and Quantile Regression (QR).

Because structural breaks are defined through regression, we use Statistical tests 
(like [Chow Test](https://en.wikipedia.org/wiki/Chow_test).)

**Remark:** I like/prefer to use QR in many situations. 
Outlier detection with QR is something I have discussed elsewhere, but here I am also
show typical examples in which I think it is hard to get good results without using QR.


## References

[Wk1] Wikipedia, ["Structural break"](https://en.wikipedia.org/wiki/Structural_break).

[PT1] Pavel Tiunov, ["Time Series Anomaly Detection Algorithms"](https://blog.statsbot.co/time-series-anomaly-detection-algorithms-1cef5519aef2),
(2017), [Stats and Bolts](https://blog.statsbot.co).