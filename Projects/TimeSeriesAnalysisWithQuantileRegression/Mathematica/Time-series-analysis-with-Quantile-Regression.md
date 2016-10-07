# Time series analysis with Quantile regression

#### Anton Antonov   
#### [MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects)    
#### October, 2016   


## Introduction

This document (*Mathematica* notebook) is made for the *Mathematica*-part of the [MathematicaVsR](https://github.com/antononcube/MathematicaVsR/) project ["Time series analysis with Quantile Regression"](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/TimeSeriesAnalysisWithQuantileRegression).

The main goal of this document is to demonstrate how to do in *Mathematica*:

1. getting weather data (or other time series data),

2. fitting Quantile Regression (QR) curves to time series data, and

3. using QR to find outliers and conditional distributions.

## Get weather data


Assume we want to obtain temperature time series data for Atlanta, Georgia, USA for the time interval from 2011.04.01 to 2016.03.31 .

We can download that weather data in the following way.

First we find weather stations identifiers in Atlanta, GA:

    Dataset@Transpose[{WeatherData[{{"Atlanta", "GA"}, 12}],
       WeatherData[{{"Atlanta", "GA"}, 12}, "StationDistance"]}]

[![WeatherData1][1]][1]

Because in [the R-part](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/TimeSeriesAnalysisWithQuantileRegression/R) of the project we used "KATL" we will use it here too.

    location = "KATL";(*{"Atlanta","GA"}*)
    {startDate, endDate} = {{2011, 4, 1}, {2016, 3, 31}};
    tempData = WeatherData[location, "MeanTemperature", {startDate, endDate, "Day"}]

[![WeatherData2][2]][2]

    DateListPlot[tempData, PlotRange -> All, AspectRatio -> 1/3, PlotTheme -> "Detailed", ImageSize -> 500]

[![KATLPlot1][3]][3]

Convert to Fahrenheit in order to get results similar to those in [the R-part](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/TimeSeriesAnalysisWithQuantileRegression/R).

    tempDataArray = tempData["Path"];
    tempDataArray[[All, 2]] = UnitConvert[Quantity[tempDataArray[[All, 2]], "DegreesCelsius"], "DegreesFahrenheit"] /. Quantity[v_, _] :> v;

Here we are going to plot the time series data array and re-use the obtained plot below. (Not necessary, but convenient and makes the plotting commands shorter.)

    dateTicks = AbsoluteTime /@Union[Append[DateRange[{2011, 4, 1}, {2016, 3, 31}, "Month"][[1 ;; -1 ;; 12]], {2016, 3, 31}]];
    grDLP = ListLinePlot[tempDataArray, PlotRange -> All, AspectRatio -> 1/3, PlotTheme -> "Scientific", FrameLabel -> {"Date",
        "Mean temperature, F\[Degree]"},
      PlotStyle -> GrayLevel[0.6],
      GridLines -> {dateTicks, Automatic}, FrameTicks -> {{Automatic, Automatic}, {Map[{AbsoluteTime[#], DateString[#, {"Year", "/", "Month", "/", "Day"}]} &, dateTicks], None}}, ImageSize -> 500]

[![KATLPlot2][4]][4]

## Fitting Quantile regression curves and finding outliers

This command loads the package \[[1](https://github.com/antononcube/MathematicaForPrediction/blob/master/QuantileRegression.m)\] with QR implementations:

    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/QuantileRegression.m"]

How to use the function QuantileRegression from that package is explained in \[[2](https://mathematicaforprediction.wordpress.com/2014/01/01/quantile-regression-with-b-splines/)\].

First we choose quantiles:

    qs = {0.02, 0.1, 0.25, 0.5, 0.75, 0.9, 0.98}
    (* {0.02, 0.1, 0.25, 0.5, 0.75, 0.9, 0.98} *)

Then we find the QR curves -- called regression quantiles -- at these quantiles:

    AbsoluteTiming[
     qFuncs = QuantileRegression[N@tempDataArray, 30, qs, Method -> {LinearProgramming, Method -> "CLP", Tolerance -> 10^-8.}];
    ]
    (* {1.47838, Null} *)

At this point finding the outliers is simple -- we just pick the points (dates) with temperatures higher than the 0.98regression quantile (multiplied by some factor close to 1, like 1.005.)

    outlierInds = Select[Range[Length[tempDataArray]], tempDataArray[[#, 2]] > 1.005 qFuncs[[-1]][tempDataArray[[#, 1]]] &]
    (* {62, 149, 260, 330, 458, 576, 981, 1177, 1293, 1375, 1617, 1732} *)

Plot time series data, regression quantiles, and outliers:

    Show[{
      grDLP,
      Plot[Evaluate[Through[qFuncs[x]]], {x, Min[tempDataArray[[All, 1]]], Max[tempDataArray[[All, 1]]]}, PerformanceGoal -> "Speed", PlotPoints -> 130, PlotLegends -> qs],
      ListPlot[tempDataArray[[outlierInds]], PlotStyle -> {Red, PointSize[0.007]}]}, ImageSize -> 500]

[![Outliers1][5]][5]

(The identified outliers are given with red points.)

## Reconstruction of PDF and CDF at a given point

### CDF re-construction function definitions

    Clear[CDFEstimate]
    CDFEstimate[qs_, qFuncs_, t0_] :=
      Interpolation[Transpose[{Through[qFuncs[t0]], qs}], InterpolationOrder -> 1];

Using the CDF function obtained with CDFEstimate we can find the PDF function by differentiation.

### Plot definition

    Clear[CDFPDFPlot]
    CDFPDFPlot[t0_?NumberQ, qCDFInt_InterpolatingFunction, qs : {_?NumericQ ..}, opts : OptionsPattern[]] :=
      Block[{},
       Plot[{qCDFInt[x], qCDFInt'[x]}, {x, qCDFInt["Domain"][[1, 1]], qCDFInt["Domain"][[1, 2]]}, PlotRange -> {0, 1}, Axes -> False, Frame -> True, PlotLabel -> "Estimated CDF and PDF for " <> DateString[t0, {"Year", ".", "Month", ".", "Day"}], opts]
      ];

### QR with for lots of quantiles

Consider the quantiles:

    qs = Join[{0.02}, FindDivisions[{0, 1}, 20][[2 ;; -2]], {0.98}] // N
    (* {0.02, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 0.98} *)

    AbsoluteTiming[
     qFuncs = QuantileRegression[N@tempDataArray, 25, qs, Method -> {LinearProgramming, Method -> "CLP"}, InterpolationOrder -> 3];
    ]
    (* {3.22185, Null}*)

### CDF and PDF re-construction

At this point we are ready to do the reconstruction of CDF and PDF for selected dates and plot them.

    Map[CDFPDFPlot[#, CDFEstimate[qs, qFuncs, #], qs, ImageSize -> 300] &, tempDataArray[[{100, 200}, 1]]]

[![CDFPDF1][6]][6]

## References

\[1\] Anton Antonov, [Quantile regression Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/QuantileRegression.m),  (2014), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), package [QuantileRegression.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/QuantileRegression.m) .

\[2\] Anton Antonov, ["Quantile regression with B-splines"](https://mathematicaforprediction.wordpress.com/2014/01/01/quantile-regression-with-b-splines/), (2014), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com/).

<!--
[1]:WeatherData1.png
[2]:WeatherData2.png
[3]:KATLPlot1.png
[4]:KATLPlot2.png
[5]:Outliers1.png
[6]:CDFPDF1.png
-->

[1]:http://i.imgur.com/crktb3S.png
[2]:http://i.imgur.com/urFIxy3.png
[3]:http://i.imgur.com/WCmzteF.png
[4]:http://i.imgur.com/EUY02Qy.png
[5]:http://i.imgur.com/7FaumjN.png
[6]:http://i.imgur.com/JwFaCb0.png