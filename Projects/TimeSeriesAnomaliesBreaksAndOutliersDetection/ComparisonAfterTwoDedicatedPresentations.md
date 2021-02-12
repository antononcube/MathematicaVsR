# Mathematica vs R comparison over time series anomalies finding

Anton Antonov   
[MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR)   
2021-02-12   

## Introduction

Exactly one week ago I gave the presentation
["Anomalies, Breaks, and Outlier Detection in Time Series in R"](https://www.meetup.com/CU-DSUG/events/jgrrbpyccdbhb/)
for 
[Champaign-Urbana Data Science User Group](https://www.meetup.com/CU-DSUG). See th

Similar presentation with the same title was given on 2019-10-29 at the
[Wolfram Technology Conference 2019](http://www.wolfram.com/events/technology-conference/2019/):
see 
[
[AA1](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/blob/master/Presentations/WTC-2019/Anomalies-breaks-and-outliers-detection-in-time-series.md), 
[AAv1](https://www.youtube.com/channel/UCJekgf6k62CQHdENWf2NgAQ)
].

-----

## Comparison by functionalities

| Functionality               | Type     | Mathematica                               | R                            |
| --------------------------- | -------- | ----------------------------------------- | ---------------------------- |
| Quantile Regression (QR)    | function | `ResourceFunction["QuantileRegression"]`  |                              |
|                             | package  |  QuantileRegression                       | quantreg                     |
|                             |          |                                           |                              |
| Monadic QR                  | package  |  QRMon-WL                                 | QRMon-R                      |
|                             |          |                                           |                              |
| Nearest Neighbors (NNs)     | function | `Nearest`                                 |                              |
|                             |          |                                           |                              |
| Monadic Geometric NNs       | package  |  GNNMon-WL                                | GNNMon-R                     |
|                             |          |                                           |                              |
| Outlier 1D identification   | package  |  OutlierIdentifiers                       | OutlierIdentifiers           |
|                             |          |                                           |                              |
| Interactive interface       | function | `Manipulate`                              |                              |
|                             | package  |                                           | shiny, flexdashboard         |
|                             | package  |                                           |                              |
|                             |          |                                           |                              |
| Plotting                    | function | `ListPlot`, `DateListPlot`                |                              |
|                             | package  |                                           | ggplot2                      |
|                             |          |                                           |                              |
| Anomaly detection           | function | `AnomalyDetection`                        |                              |
|                             | object   | `AnomalyDetectorFunction`                 |                              |
|                             |          |                                           |                              |

-----


## References

### Articles

[AA1] Anton Antonov,
["Anomalies, Breaks, and Outlier Detection in Time Series" for WTC-2019](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/blob/master/Presentations/WTC-2019/Anomalies-breaks-and-outliers-detection-in-time-series.md),
(2020),
["Simplified Machine Learning Workflows" book at GitHub](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/).


### Mathematica rackages

[AAmp1] Anton Antonov, 
[Implementation of one dimensional outlier identifying algorithms in Mathematica](https://github.com/antononcube/MathematicaForPrediction/blob/master/OutlierIdentifiers.m), 
(2013),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAmp2] Anton Antonov, 
[Monadic Quantile Regression Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m),
(2018),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).
 
[AAmp3] Anton Antonov, 
[Monadic Geometric Nearest Neighbors Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicGeometricNearestNeighbors.m),
(2019),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).


### R packages




### Repositories  

[AAr1] Anton Antonov,
[ChampaignUrbanaDataScienceUserGroup-Meetup-February-2021 R-project](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/tree/master/R/ChampaignUrbanaDataScienceUserGroup-Meetup-February-2021),
(2021),
["Simplified Machine Learning Workflows" book at GitHub](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/).


### Videos

[AAv1] Anton Antonov,
["Anomalies, Breaks, and Outlier Detection in Time Series (in WL)"](https://www.youtube.com/watch?v=h_fLb6YU87c),
(2020),
[Wolfram Research Inc, at YouTube](https://www.youtube.com/channel/UCJekgf6k62CQHdENWf2NgAQ).

[AAv2] Anton Antonov,
["Anomalies, Breaks, and Outlier Detection in Time Series (in R)"](https://www.youtube.com/watch?v=h_fLb6YU87c),
(2021),
[YouTube](https://www.youtube.com/watch?v=KL0sCSrWEkM).