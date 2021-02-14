# Mathematica vs R comparison over time series anomalies finding

Anton Antonov   
[MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR)   
2021-02-12   

## Introduction

A week ago I gave the presentation
["Anomalies, Breaks, and Outlier Detection in Time Series in R"](https://www.meetup.com/CU-DSUG/events/jgrrbpyccdbhb/)
for 
[Champaign-Urbana Data Science User Group](https://www.meetup.com/CU-DSUG), 
[ [AA1](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/tree/master/R/ChampaignUrbanaDataScienceUserGroup-Meetup-February-2021) ];
see the recording 
[[AAv2](https://www.youtube.com/watch?v=h_fLb6YU87c)].

Similar presentation with the same title was given on 2019-10-29 at the
[Wolfram Technology Conference 2019](http://www.wolfram.com/events/technology-conference/2019/)
see the recording
[
[AA1](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/blob/master/Presentations/WTC-2019/Anomalies-breaks-and-outliers-detection-in-time-series.md), 
[AAv1](https://www.youtube.com/channel/UCJekgf6k62CQHdENWf2NgAQ)
].

This article summarizes the algorithms for detection of anomalies in time series which
I presentated and discusses their implementations and applications 
in both 
[Mathematica](https://www.wolfram.com/mathematica/) 
and 
[R](https://www.r-project.org).

There are many algorithms and packages for detecting anomalies in time series, see [AA1] for references.
This article is more about comparing Mathematica and R over such algorithms.

Also, in this article, we focus quite a lot on algorithms that use 
[Quantile Regression (QR)](https://en.wikipedia.org/wiki/Quantile_regression), 
[Wk3, RK1, RK2]. Using QR is not necessary for detecting anomalies in time series, but QR's unique features
can inspire to make time series anomaly detection algorithms that are both simple and powerful. 


-----

## Anomalies definitions

There are many ways to define anomalies in time series. 
Here is a list the ones we focus on in this comparison:

- **Point Anomaly:** Simply an outlier of the values of the time series.

- **Contextual Anomaly:** An anomaly that is local to some sub-sequence of the time series.

- **Breakpoint / change-point:** A regressor value (time) of a time series where the mean of the values change. 
   
    - Also, consider:
      
      1. Shifts in trend, 
      2. Other changes in trend
      3. Changes in variance

- **Structural break:** Unexpected changes of the parameters of regression models.

### What is a structural break?

It looks like at least one type of “structural breaks“ are defined through regression models, 
[[Wk1](https://en.wikipedia.org/wiki/Structural_break)].

Roughly speaking a structural break point of time series is a regressor point that splits the time series 
in such way that the obtained two parts have very different regression parameters.

One way to test such a point is to use Chow test, [[Wk2](https://en.wikipedia.org/wiki/Chow_test)]. 
From [Wk2] we have the definition:

> The Chow test, proposed by econometrician Gregory Chow in 1960, is a test of whether the true coefficients
> in two linear regressions on different data sets are equal. 
> In econometrics, it is most commonly used in time series analysis to test for the presence of a structural break 
> at a period which can be assumed to be known a priori (for instance, a major historical event such as a war).

-----

## Algorithms brief descriptions

### The use of Quantile Regression

I prefer using Quantile Regression (QR) but that is not required:

- In general, for anomalies detection algorithms in times series

- For some of the algorithms outlined below

The main advantages of using the Mathematica and R QR packages used in this comparison are:

1. Use of automatic basis for the fitting
   
   - B-spline basis that is easy to modify by specifying number of knots and interpolation order 

2. Fitting of regression curves (called *regression quantiles*) at any probability 

   - Not just at 0.5 with the linear regression
   
3. Robust regression fitting, not easily influenced by outliers

4. Easy to estimate the dependence variance with respect to time

   - The time series can be [heteroscedastic](https://en.wikipedia.org/wiki/Heteroscedasticity)
    
### Outliers by regression quantiles

In some sense using QR provides the simplest outliers detection algorithm:

1. Fit regression quantiles at probabilities 0.01 and 0.99

2. Mark points "outside" of those regression quantiles as outliers

### Point anomalies by fit residuals

Another algorithm based on QR is :

1. Fit a regression quantile at certain probability 
   
   - The probability 0.5, the "median", is usually a good choice.

2. Find the residuals of the fit
  
   - Both relative and absolute values can be used.
    
3. Find outliers in the list of residuals -- they correspond to outliers in the original time series

   - The selection of outliers can be done by using a threshold or an outlier identifier.
    
**Remark:** This algorithm can be done with linear regression. 
That implies using only the "mean" for the fit and selection of a basis. 
 
### Variance anomalies by regression quantiles

This algorithm can be seen as fairly unique to QR:

1. Fit two regression quantiles, one "low" and one "high" 
   
   - For example, 0.1 and 0.9 for "low" and "high" respectively.
    
2. Find the time series of the variance evolution by difference of the values 
   of the "high" and "low" curves at the regressor points
   
3. Find outliers of the variance values

   - Alternatively, identification of point time series outliers can be used.

### Nearest neighbors over overlapping blocks

If we have an easy to invoke, reliable, robust anomaly detector for sets of multi-dimensional points,
then the following simple algorithm can applied:

1. Assume the time series is over an uniform time grid
   
2. Partition the values of the time series into overlapping sub-sequences of equal length

   - For example a time series of 1000 points can be partitioned into a set of 996 5-dimensional points:
    
```mathematica
In[1]:= Partition[RandomReal[1, 1000], 5, 1] // Length
Out[1]= 996
```    

3. Use the anomaly detector over the obtained set of multi-dimensional points.

### Structural breaks identification

Consider the problem of finding of all structural breaks in a given time series. 
That can be done (reasonably well) with the following procedure. 

1. Chose functions for testing for structural breaks (usually linear.)

2. Apply [Chow Test](https://en.wikipedia.org/wiki/Chow_test) over dense enough set of regressor points.

3. Make a time series of the obtained Chow Test statistics.

4. Find the local maxima of the Chow Test statistics time series.

5. Determine the most significant break point.

6. Plot the splits corresponding to the found structural breaks.

For more details see [[AA2](https://mathematicaforprediction.wordpress.com/2019/07/31/finding-all-structural-breaks-in-time-series/)].

The package [AAmp4] extends QRMon-WL with functionalities related to structural breaks finding.

### Multi-dimensional outlier identification

TBD...


-----

## Comparison observations

### Comparison by functionalities

The following table gives an overview of the built-in functions and packages used in the 
anomalies detection algorithms considered. 
With two pluses ("++") are marked packages that have very close resemblance in their functionalities and implementations.
With one plus ("+") are marked packages with similar but different functionalities and implementations.


| Functionality               | Type     | Mathematica                               | R                            |     |
| --------------------------- | -------- | ----------------------------------------- | ---------------------------- | --- |
| Anomaly detection           | function | `AnomalyDetection`                        |                              |     |
|                             | object   | `AnomalyDetectorFunction`                 |                              |     |
| Outlier 1D identification   | package  |  OutlierIdentifiers                       | OutlierIdentifiers           | ++ |
| Quantile Regression (QR)    | function | `ResourceFunction["QuantileRegression"]`  |                              |     |
|                             | package  |  QuantileRegression                       | quantreg                     |     |
| Monadic QR                  | package  |  QRMon-WL                                 | QRMon-R                      | ++  |
| Nearest Neighbors (NNs)     | function | `Nearest`                                 |                              |     |
| Monadic Geometric NNs       | package  |  GNNMon-WL                                | GNNMon-R                     | +   |
| Interactive interface       | function | `Manipulate`                              |                              |     |
|                             | package  |                                           | shiny, flexdashboard         |     |
| Plotting                    | function | `ListPlot`, `DateListPlot`                |                              |     |
|                             | package  |                                           | ggplot2                      |     |
| ROC functions               | package  |  ROCFunctions                             | ROCFunctions                 | +   |

### Observations

#### Interactive interfaces

The interactive interfaces made with Mathematica's 
[`Manipulate`](https://reference.wolfram.com/language/ref/Manipulate.html) 
and related functions most of the 
time can be reproduced with RStudio's [shiny](https://shiny.rstudio.com). 

RStudio's 
[shinyapps.io](https://rstudio.com/products/shinyapps/)
hosting service allows for "packaged" data, algorithms, and interactive interfaces to be shared 
easily with others. All interactive interfaces used in the R-presentation are published at
[shinyapps.io](https://rstudio.com/products/shinyapps/).

Similar Mathematica's interactive interfaces can be invoked by runing the notebooks in this project.
(The notebooks content can be seen on Wolfram Cloud.)


-----


## References

### Articles, books

[AA1] Anton Antonov,
["Anomalies, Breaks, and Outlier Detection in Time Series" for WTC-2019](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/blob/master/Presentations/WTC-2019/Anomalies-breaks-and-outliers-detection-in-time-series.md),
(2020),
["Simplified Machine Learning Workflows" book at GitHub](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/).

[AA2] Anton Antonov,
["Finding all structural breaks in time series"](https://mathematicaforprediction.wordpress.com/2019/07/31/finding-all-structural-breaks-in-time-series/),
(2019),
[MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

[Wk1] Wikipedia entry, [Structural breaks](https://en.wikipedia.org/wiki/Structural_break).

[Wk2] Wikipedia entry, [Chow test](https://en.wikipedia.org/wiki/Chow_test).

[Wk3] Wikipedia entry, [Quantile Regression](https://en.wikipedia.org/wiki/Structural_break).

[RK1] Roger Koenker, Gilbert Bassett, 
["Regression Quantiles"](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.470.9161&rep=rep1&type=pdf),
(1978),
Jr. Econometrica, Vol. 46, No. 1. (Jan., 1978), pp. 33-50.

[RK2] Roger Koenker, Quantile Regression, (2005), Cambridge University Press. ISBN 978-0-521-60827-5.

### Mathematica packages

[AAmp1] Anton Antonov, 
[Implementation of one dimensional outlier identifying algorithms in Mathematica](https://github.com/antononcube/MathematicaForPrediction/blob/master/OutlierIdentifiers.m), 
(2013),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAmp2] Anton Antonov, 
[Monadic Quantile Regression Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m),
(2018),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAmp3] Anton Antonov, 
[Monadic Quantile Regression Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m),
(2018),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAmp4] Anton Antonov, 
[Monadic Geometric Nearest Neighbors Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicGeometricNearestNeighbors.m),
(2019),
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAmp5] Anton Antonov, 
[Monadic Structural Breaks Finder Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicStructuralBreaksFinder.m), 
(2019), 
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

### R packages



[RKp1] Roger Koenker, 
[quantreg: Quantile Regression](https://cran.r-project.org/web/packages/quantreg/index.html),
(2021),
[CRAN](https://cran.r-project.org).

### Repositories  

[AAr1] Anton Antonov,
[ChampaignUrbanaDataScienceUserGroup-Meetup-February-2021 R-project](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/tree/master/R/ChampaignUrbanaDataScienceUserGroup-Meetup-February-2021),
(2021),
["Simplified Machine Learning Workflows" book at GitHub](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/).

[Nu2] Numenta, [The Numenta Anomaly Benchmark](https://github.com/numenta/NAB), [GitHub/numenta](https://github.com/numenta).
[Version v1.1 was released in 2019](https://github.com/numenta/NAB/releases/tag/v1.1).

### Videos

[AAv1] Anton Antonov,
["Anomalies, Breaks, and Outlier Detection in Time Series (in WL)"](https://www.youtube.com/watch?v=h_fLb6YU87c),
(2020),
[Wolfram Research Inc, at YouTube](https://www.youtube.com/channel/UCJekgf6k62CQHdENWf2NgAQ).

[AAv2] Anton Antonov,
["Anomalies, Breaks, and Outlier Detection in Time Series (in R)"](https://www.youtube.com/watch?v=h_fLb6YU87c),
(2021),
[YouTube](https://www.youtube.com/watch?v=KL0sCSrWEkM).