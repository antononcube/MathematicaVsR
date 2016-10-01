# Time series analysis with Quantile regression
#### Anton Antonov
#### September, 2016

## Introduction

This project is for comparing *Mathematica* and R for the tasks of getting time series data (like weather data of stocks data) and applying Quantile Regression (QR) methods for analysing it.

For using QR in *Mathematica* see:

- [the MathematicaForPrediction blog posts category Quantile Regression](https://mathematicaforprediction.wordpress.com/?s=quantile+regression), or

- [the QR answers at Mathematica Stack Exchange](http://mathematica.stackexchange.com/search?q=QuantileRegression.m) using the package [`QuantileRegression.m`](https://github.com/antononcube/MathematicaForPrediction/blob/master/QuantileRegression.m) .

For using QR in R see:

- [the CRAN page of the package `quantreg`](https://cran.r-project.org/web/packages/quantreg/index.html), and

- the vignette ["Quantile regression in R: a vignette"](https://cran.r-project.org/web/packages/quantreg/vignettes/rq.pdf) by Koenker.

## Concrete steps

The concrete steps taken in the documents and scripts in this project are the following.

1. Get temperature (or other weather) data.

2. Fit regression quantile curves through it and plot them (together with data.)

3. Find top and bottom outliers in the data.

4. Reconstruct the conditional distributions (CDF and PDF) for the time series values at a given time.

5. Optionally, have make a dynamic interface for step 4.


## Comparison

The R QR implementations in the package [`quantreg`](https://cran.r-project.org/web/packages/quantreg/index.html) is much faster than the ones in [`QuantileRegression.m`](https://github.com/antononcube/MathematicaForPrediction/blob/master/QuantileRegression.m). A good case demonstrating the importance of this is a dynamic interface showing the conditional PDF and CDF with a slider over the time series time values.

The R implementation (`quantreg`) relies on the typical patterns of using R with formula objects and design matrices. The *Mathematica* implementation (`QuantileRegression.m`) has design that adheres to the built-in functions [`Fit`](https://reference.wolfram.com/language/ref/Fit.html) and [`NonlinearModelFit`](https://reference.wolfram.com/language/ref/NonlinearModelFit.html).


### Other dimensions

Note that in Mathematica we can relatively easily implement QR in [2D](https://mathematicaforprediction.wordpress.com/2014/11/03/directional-quantile-envelopes/) and [3D](https://mathematicaforprediction.wordpress.com/2014/11/16/directional-quantile-envelopes-in-3d/). That is not the case for R.

Here is an example 2D QR curves:

![2D Quantile regresssion](https://mathematicaforprediction.files.wordpress.com/2014/11/skewnormaldistributionringdatawithdirectionalquantileenvelopeslegended.png)

An interesting case where 2D and 3D QR are useful is [finding outliers in 2D and 3D data](https://mathematicaforprediction.wordpress.com/2016/04/30/finding-outliers-in-2d-and-3d-numerical-data/).

