
# Browsing data with Chernoff faces
Anton Antonov  
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
[MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects)  
November, 2016

## Introduction

Chernoff faces are an interesting way of visualizing data. The idea to use human faces in order to understand, evaluate, or easily discern (the records of) multidimensional data is very creative and inspirational. It is an interesting question how useful this approach is and it seems that there at least several articles discussing that; for example, see [7]. For more references and more extensive technical explanations see the blog post [[1](https://mathematicaforprediction.wordpress.com/2016/06/03/making-chernoff-faces-for-data-visualization/)].

The comparison task is for the following problem formulation:

> Make an interactive data browser for data tables; each data table row is visualized with a Chernoff face.

The Mathematica part of this project is the source file [DataBrowserWithChernoffFaces.m](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/BrowsingDataWithChernoffFaces/Mathematica/DataBrowserWithChernoffFaces.m) which if loaded in Mathematica FrontEnd produces and interactive interface for browsing statistical data that comes with Mathematica. The data standardizing and Chernoff faces visualization are done with the package [ChernoffFaces.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/ChernoffFaces.m); see [2].

For the R part of this project we are going to refer to several blog posts and implementations easily found on World Wide Web -- see [3,4,5]. All of them are based on the CRAN package [aplpack](https://cran.r-project.org/web/packages/aplpack/aplpack.pdf); see [6]. The blog post [[4](http://oddhypothesis.blogspot.com/2015/10/facing-your-data.html)] has detailed explanations with R code.


## The data browser implemented in Mathematica

Making the initial version of the Data Browser with Chernoff Faces (DBCF) implementation was straightforward. See the code in [SimpleDataBrowserWithChernoffFaces.m](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/BrowsingDataWithChernoffFaces/Mathematica/SimpleDataBrowserWithChernoffFaces.m).

Here are some images of the simple DBCF:

[!["SimpleDataBrowserWithChernoffFaces-EmployeeAttitude-Faces"](http://i.imgur.com/j5tSADxl.png)](http://i.imgur.com/j5tSADx.png)

[!["SimpleDataBrowserWithChernoffFaces-EmployeeAttitude-Summary"](http://i.imgur.com/V6FjU8fl.png)](http://i.imgur.com/V6FjU8f.png)

[!["SimpleDataBrowserWithChernoffFaces-EmployeeAttitude-DataTable"](http://i.imgur.com/vKJvYtyl.png)](http://i.imgur.com/vKJvYty.png)

In order to make that data browser work better with large data sets and have useful legends for examining the data a series of improvements had to be done. 
A list of the most significant improvements follows.

1. Using pages of Chernoff faces grids instead of one grid with all faces.
   - This both helps and optimizes the data browsing.   

2. Showing a legend table for the correspondence between face features and data columns.
   - Very useful to have if we want to interpret the individual faces not just to visually group or cluster them.

3. Plot labels for the faces derived from the categorical variables.

4. Coloring the faces according to row values or unique labels.
   - The R package "aplpack" does face coloring according to averages of the value subsets,
   - so it had to be made for the Mathematica part of the project too.
   - The face coloring does make the visualizations more engaging, and
   - it is sometimes very useful if done according to the values of the categorical variables. 

5. Showing a legend of faces based on statistics over the entire dataset. (E.g. median face.)
   - The (abstract of) article [7] says that people comprehend Chernoff faces collections better by examining the relative differences.  
   - In more technical terms, the recognition is a serial process and not a pre-attentive.
   - Having a legend of reference faces really helps the interpretation. E.g. see the [visualization of the dataset "EmployeeAttitude"](http://i.imgur.com/PFQf3aB.png).

6. Having a separate tab for variables distributions plots.
   - The Chernoff faces correspond to rows of the data. It is good idea to also have an impression of the distributions of the data columns.

7. Having different color schemes.
   - This is useful when certain low values are more important that high values or vice versa.
   - For example "RedBlueTones" are better suited for [the colored Chernoff faces for the dataset "EmployeeAttitude"](http://i.imgur.com/PFQf3aB.png) than, say, "TemperatureMap".

Here is a screenshot demonstrating the listed improvements:

[!["DataBrowserWithChernoffFaces-FisherIris"](http://i.imgur.com/pY1qm5fl.png)](http://i.imgur.com/pY1qm5f.png) .

Here is an album with all screenshots for this section : [http://imgur.com/a/AoLbw](http://imgur.com/a/AoLbw) . 

## Comparison

The Mathematica interface was made over a larger set of datasets. Because of that its usefulness was repeatedly examined and evaluated during the development process. From the exposition in [4] we assume that a similar level of evaluation effort has been made for the R package Shiny (R-Shiny) interface [5]. 

* Pages of faces
  - R-Shiny handles pages of items with its built-in functionality (e.g. data table). 
  - For the Mathematica part a special implementation of handling pages had to be done.
  - For both implementations using pages of faces optimizes the browsing. (See the section "Paginated faces" in [4].)

* Face coloring   
  - The automatic coloring of Chernoff faces is not a functionality the Mathematica package [2] provides. So it had to be programmed. 
  - The Chernoff face plot function of the R package [6] provides such (automatic) coloring.

* Embedded vs Javascript
   - Obvious different difference but has to be stated for completeness (or readers not familiar with one of the systems.)
   - The Mathematica interactive interfaces based on `Manipulate`\`Dynamic` are embedded in Mathematica's FrontEnd notebooks.       
   - R-Shiny produces Javascript code that can be run on a Internet browser (or in the [RStudio IDE](https://www.rstudio.com/products/rstudio/).)

## References

[1] Anton Antonov, ["Making Chernoff faces for data visualization"](https://mathematicaforprediction.wordpress.com/2016/06/03/making-chernoff-faces-for-data-visualization/), (2016), [MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com).

[2] Anton Antonov, [Chernoff Faces implementation in Mathematica](https://github.com/antononcube/MathematicaForPrediction/blob/master/ChernoffFaces.m), (2016), source code at [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), package [ChernofFacess.m](https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/ChernoffFaces.m).

[3] Nathan Yau, ["How to visualize data with cartoonish faces ala Chernoff"](http://flowingdata.com/2010/08/31/how-to-visualize-data-with-cartoonish-faces/), (2010), [Flowingdata](http://flowingdata.com).

[4] Lee Pang, ["Facing your data"](http://oddhypothesis.blogspot.com/2015/10/facing-your-data.html), (2015), [Oddhypothesis at Blogspot](http://oddhypothesis.blogspot.com).

[5] Lee Pang, [DFaceR](https://github.com/wleepang/DFaceR), (2015), GitHub. [Deployed Shiny app](https://oddhypothesis.shinyapps.io/DFaceR/).

[6] Hans Peter Wolf, Uni Bielefeld, [Package ‘aplpack’](https://cran.r-project.org/web/packages/aplpack/aplpack.pdf), (2015), CRAN.

[7] Christopher J. Morris; David S. Ebert; Penny L. Rheingans, ["Experimental analysis of the effectiveness of features in Chernoff faces"](http://www.research.ibm.com/people/c/cjmorris/publications/Chernoff_990402.pdf), Proc. SPIE 3905, 28th AIPR Workshop: 3D Visualization for Data Exploration and Decision Making, (5 May 2000); doi: 10.1117/12.384865.

