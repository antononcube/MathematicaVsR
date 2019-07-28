# Quantile Regression Workflows 

## Introduction

This project is for the comparison of the Mathematica and R implementation and utilization of 
software monads for the specification and execution of 
[Quantile Regression](https://en.wikipedia.org/wiki/Quantile_regression) 
workflows.

The project was aimed to mirror and aid the workshop 
["Quantile Regression Workshop"](https://www.meetup.com/Orlando-MLDS/events/258855219/?rv=ea1_v2&_xtd=gatlbWFpbF9jbGlja9oAJDM3Nzc3MWUyLTJlNmItNDg2NS1iNGEzLWZkYWZmMzc1ZTIxZA)
of the meetup
[Orlando Machine Learning and Data Science](https://www.meetup.com/Orlando-MLDS).

This project was also used for the presentation:
["Intro to Quantile Regression Workflows (Boston useR Group)"](https://www.meetup.com/Boston-useR/events/260162178)
of the meetup 
[Greater Boston useR Group (R Programming Language)](https://www.meetup.com/Boston-useR).
(That particular event was co-hosted by [ODSC](https://odsc.com/).)


The Mathematica / Wolfram Language monad `QRMon` is implemented with the package 
["MonadicQuantileRegression.m"](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m), 
[[AAp1](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m)],
and it is based on the package 
["QuantileRegression.m"](https://github.com/antononcube/MathematicaForPrediction/blob/master/QuantileRegression.m),
\[[AAp2](https://github.com/antononcube/MathematicaForPrediction/blob/master/QuantileRegression.m)\].
(Below this software monad is referenced as `QRMon-WL`.)

The R monad is also named `QRMon`, it is implemented with the package 
["QRMon-R"](https://github.com/antononcube/QRMon-R),
\[[AAp3](https://github.com/antononcube/QRMon-R)\],
and it is based on the Quantile Regression package 
[`quantreg`](https://cran.r-project.org/web/packages/quantreg/index.html),
[[RKp1](https://cran.r-project.org/web/packages/quantreg/index.html), 
[RK1](https://cran.r-project.org/web/packages/quantreg/vignettes/rq.pdf)];
it also utilizes the "pipeline" package 
[`magrittr`](https://magrittr.tidyverse.org).
(Below this software monad is referenced as `QRMon-R`.)


## Workshop mission statement

The goals of this workshop are to introduce the theoretical background of Quantile Regression (QR),
to demonstrate QR's practical (and superior) abilities to deal with "real life" time series data,
and to teach how to rapidly create QR workflows using Mathematica or R.

## Workshop plan

- Quantile Regression (QR) theory *(7-10 min)*

  - Brief outline

  - Warm-up examples

  - Linear programming problem formulation

    - Just a sketch

  - Analogies between Quantile Regression and Neural Networks

- Monadic programming *(5 min)*

  - Why use it?

  - What are the main benefits?

  - Monads vs pipelines

  - Why apply it to QR?

- Introduction to `QRMon` *(15 min)*

  - Installing the packages

  - Review of the look-and-feel

- Main benefits of QR (first wave examples) *(30-40 min)*

  - All done through monadic pipelines (workflows)

  - Time series analysis

  - Conditional PDF’s and CDF’s 

  - Outlier detection

  - Simulation of time series
  
- QR workflows (second wave examples) *(30 min)*

  - Using StackExchange questions (and data)

  - [Data cleaning](https://mathematica.stackexchange.com/q/188361/34008))

  - [Envelopes](https://mathematica.stackexchange.com/a/106173/34008)

  - [Picking points of interest](https://mathematica.stackexchange.com/a/189471/34008)
  
  - [Brute force identification of expansion terms](https://mathematica.stackexchange.com/a/191792/34008)
  
  - [Finding peaks](https://mathematica.stackexchange.com/a/189710/34008) 

  - [Data generation](https://mathematica.stackexchange.com/q/188958)


## Quantile Regression videos

For introduction to Quantile Regression see the YouTube video 
["Quantile Regression—Theory, Implementations, and Applications"](https://www.youtube.com/watch?v=GddvdXMJV9Y).

[Video of the "Quantile Regression Workflows" presentation at Boston useR! Meetup 2019.04.18](https://www.youtube.com/watch?v=FBhmtIF1bJY).

Here is a video for using the `QRMon-WL` monad.
 
Here is a video for using the `QRMon-R` monad.

## Package installations and usage guides

### Mathematica

  - Follow the GitHub Markdown article 
["A monad for Quantile Regression workflows"](https://github.com/antononcube/MathematicaForPrediction/blob/master/MarkdownDocuments/A-monad-for-Quantile-Regression-workflows.md).


  - Examine QRMon-WL's unit test files:
   
    - [MonadicQuantileRegression-Unit-Tests.wlt](https://github.com/antononcube/MathematicaForPrediction/blob/master/UnitTests/MonadicQuantileRegression-Unit-Tests.wlt) and
 
    - [MonadicQuantileRegressionRandomPipelinesUnitTests.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/UnitTests/MonadicQuantileRegressionRandomPipelinesUnitTests.m).
    
### R 

   - Download/follow the introductory notebook 
["Separation by regression quantiles"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/QuantileRegressionWorkflows/R/Separation-by-regression-quantiles.Rmd)
([html version](https://htmlpreview.github.io/?https://github.com/antononcube/MathematicaVsR/blob/master/Projects/QuantileRegressionWorkflows/R/Separation-by-regression-quantiles.nb.html)).


   - Read/follow the vignette 
["Rapid making of Quantile Regression workflows"](https://htmlpreview.github.io/?https://github.com/antononcube/QRMon-R/blob/master/notebooks/rapid-making-of-qr-workflows.html). 
  
   - Examine [QRMon-R's unit test files](https://github.com/antononcube/QRMon-R/tree/master/tests/testthat).

## Data

- If using Mathematica (and having an internet connection) the financial and weather data 
can obtained with the functions 
[`FinancialData`](https://reference.wolfram.com/language/ref/FinancialData.html)
and 
[`WeatherData`](https://reference.wolfram.com/language/ref/WeatherData.html).

- I using R: the [`QRMon-R`](https://github.com/antononcube/QRMon-R) 
package comes with three sample datasets (distribution, financial, and weather data.)
    
- The data used in the workshop examples can be obtained from this repository.

   - See the sub-directory ["Data"](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/QuantileRegressionWorkflows/Data). 


## Comparisons

### Monadic pipelines

Here is a monadic pipeline in Mathematica:

    qrmon =
       QRMonUnit[distData]⟹
       QRMonEchoDataSummary⟹
       QRMonQuantileRegression[12]⟹
       QRMonPlot;
      
Here is a monadic pipeline in R:

     qrmon <-
       QRMonUnit( dfTemperatureData ) %>%
       QRMonEchoDataSummary() %>%
       QRMonQuantileRegression( df = 16, degree = 3, quantiles = seq(0.1,0.9,0.2) ) %>%
       QRMonPlot( datePlotQ = TRUE, dateOrigin = "1900-01-01" )  
       
### Performance

Because of the specialized algorithms developed by Roger Koenker et al. the package `quantreg`, \[RKp1\],
produces Quantile Regression fits much faster than the package \[AAp3\]. 
(The latter uses the built-in Mathematica functions `LinearProgramming`, `Minimize`, and `NMinimize`.
`LinearProgramming` is the fastest.)
 

### Underlying algorithmic design          

#### The use B-spline basis

*TBD...*

#### Function evaluations vs. predictions 

*TBD...*

## References

###  Packages

[AAp1] Anton Antonov, [Monadic Quantile Regression Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicQuantileRegression.m), (2018), 
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAp2] Anton Antonov, [Quantile Regression Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/QuantileRegression.m), (2014), 
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAp3] Anton Antonov, [Quantile Regression workflows monad in R](https://github.com/antononcube/QRMon-R), (2018), 
[QRMon-R at GitHub](https://github.com/antononcube/QRMon-R).

[RKp1] Roger Koenker et al., ["quantreg: Quantile Regression"](https://cran.r-project.org/web/packages/quantreg/index.html), (2018).

### MathematicaForPrediction articles

[AA1] Anton Antonov, ["Monad code generation and extension"](https://github.com/antononcube/MathematicaForPrediction/blob/master/MarkdownDocuments/Monad-code-generation-and-extension.md), (2017),  [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AA2] Anton Antonov, ["Quantile regression through linear programming"](https://mathematicaforprediction.wordpress.com/2013/12/16/quantile-regression-through-linear-programming/), (2013), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

[AA3] Anton Antonov, ["Quantile regression with B-splines"](https://mathematicaforprediction.wordpress.com/2014/01/01/quantile-regression-with-b-splines/), (2014), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

[AA4] Anton Antonov, ["Estimation of conditional density distributions"](https://mathematicaforprediction.wordpress.com/2014/01/13/estimation-of-conditional-density-distributions/), (2014), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

[AA5] Anton Antonov, ["Finding local extrema in noisy data using Quantile Regression"](https://mathematicaforprediction.wordpress.com/2015/09/27/finding-local-extrema-in-noisy-data-using-quantile-regression/), (2015), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

[AA6] Anton Antonov, [A monad for Quantile Regression workflows](https://mathematicaforprediction.wordpress.com/2018/08/01/a-monad-for-quantile-regression-workflows/), (2018), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

### Other

[Wk1] Wikipedia entry, [Monad](https://en.wikipedia.org/wiki/Monad_(functional_programming)).

[Wk2] Wikipedia entry, [Quantile Regression](https://en.wikipedia.org/wiki/Quantile_regression)/

[Wk3] Wikipedia entry, [Chebyshev polynomials](https://en.wikipedia.org/wiki/Chebyshev_polynomials)/

[CN1] Brian S. Code and Barry R. Noon, ["A gentle introduction to quantile regression for ecologists"](http://www.econ.uiuc.edu/~roger/research/rq/QReco.pdf), (2003). Frontiers in Ecology and the Environment. 1 (8): 412-420. doi:10.2307/3868138.

[RK1] Roger Koenker, ["Quantile Regression in R: a vignette"](https://cran.r-project.org/web/packages/quantreg/vignettes/rq.pdf), (2018).

[RK2] Roger Koenker, [Quantile Regression](https://books.google.com/books/about/Quantile_Regression.html?id=hdkt7V4NXsgC), ‪Cambridge University Press, 2005‬.


