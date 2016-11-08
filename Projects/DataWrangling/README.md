# Data wrangling
Anton Antonov  
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
[MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects)  
November, 2016

## Introduction

This project has multiple sub-projects for the different data wrangling tasks needed to statistics (machine learning and data mining).


## Comparison

Data wrangling R is heavily influenced by the creation (publication and description) of the packages ["plyr"](https://cran.r-project.org/web/packages/plyr/index.html), [1,2], and ["reshape2"](https://cran.r-project.org/web/packages/reshape2/index.html), [3].

The need in R for a package like "plyr" is because of R's central data structures, (vectors, lists, data frames) and the complicated system data structure transformation functions. (See, for example, Circle 4 of the book "The R inferno", [4].) In Mathematica the functionalities in "plyr" are easily programmed with common, base Mathematica functions.

Nevertheless, the know-how of data wrangling in R is much more streamlined -- both in base functions and packages -- and there are multiple easy to find resources on Internet for doing particular data wrangling tasks (with R.) 

A list of some basic comparison documents and codes.

- Mathematica

  - *"Simple missing functionalities in Mathematica"*

  - ["Contingency tables creation examples"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/DataWrangling/Mathematica/Contingency-tables-creation-examples.md)

  - *"Automatically generated data ingestion report"*

- R

  - "Simple data reading and analysis functionalities"(https://cdn.rawgit.com/antononcube/MathematicaVsR/master/Projects/DataWrangling/R/SimpleDataReadingAndAnalysisFunctionalities.html), ([RMarkdown file](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/DataWrangling/R/SimpleDataReadingAndAnalysisFunctionalities.Rmd))

  - *"Automatically generated data ingestion report"*

## References

[1] Hadley Wickham, ["plyr: Tools for Splitting, Applying and Combining Data"](https://cran.r-project.org/web/packages/plyr/index.html), CRAN. Also see [http://had.co.nz/plyr/](http://had.co.nz/plyr/).

[2] Hadley Wickham, ["The Split-Apply-Combine Strategy for Data Analysis"](https://www.jstatsoft.org/article/view/v040i01/v40i01.pdf), (2011), Volume 40, Issue 1, Journ. of Stat. Soft.

[3] Hadley Wickham, ["reshape2: Flexibly Reshape Data: A Reboot of the Reshape Package"](https://cran.r-project.org/web/packages/reshape2/index.html), CRAN.

[4] Patrick Burns, [The R inferno](http://www.burns-stat.com/documents/books/the-r-inferno/), 2012, [free PDF link](http://www.burns-stat.com/pages/Tutor/R_inferno.pdf).

