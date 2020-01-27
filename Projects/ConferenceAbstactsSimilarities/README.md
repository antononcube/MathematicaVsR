# Conference abstracts similarities
 
Anton Antonov  
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
[MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR)  
November, 2020

## Introduction

In this project we discuss and exemplify finding and analyzing similarities between texts using 
Latent Semantic Analysis (LSA). Both Mathematica and R code is provided.

The LSA workflows are constructed and executed with the software monad LSAMon, \[AA1, AAp1, AAp2\]. 

The illustrating examples are based on conference abstracts from 
[rstudio::conf](https://rstudio.com/conference/) 
and 
[Wolfram Technology Conference (WTC)](https://www.wolfram.com/events/technology-conference/2019/), 
\[AAd1, AAd2\]. 
Since the number of rstudio::conf abstracts is small and since rstudio::conf 2020 is about to start 
at the time of preparing this notebook we focus on words and texts from R / RStudio ecosystem of packages and presentations.

## Statistical thesaurus for words from RStudio's ecosystem

Consider the focus words:

```mathematica
{"cloud","rstudio","package","tidyverse","dplyr","analyze","python","ggplot2","markdown","sql"}
```

Here is a statistical thesaurus for those words:

![0az70qt8noeqf](https://github.com/antononcube/MathematicaVsR/raw/master/Projects/ConferenceAbstactsSimilarities/Mathematica/Diagrams/0az70qt8noeqf-better.png) 


## Similarity analysis diagrams

As expected the abstracts from rstudio::conf tend to cluster closely -- 
note the square formed top-left in the plot of a similarity matrix based on extracted topics:

![1d5a83m8cghew](https://github.com/antononcube/MathematicaVsR/raw/master/Projects/ConferenceAbstactsSimilarities/Mathematica/Diagrams/1d5a83m8cghew.png) 

Here is clustering of a cluster found over the similarity graph corresponding to the matrix above:

![0rba3xgoknkwi](https://github.com/antononcube/MathematicaVsR/raw/master/Projects/ConferenceAbstactsSimilarities/Mathematica/Diagrams/0rba3xgoknkwi.png) 


## Notebooks

- Mathematica

  - [ConferenceAbstractsSimilarities.md](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ConferenceAbstactsSimilarities/Mathematica/ConferenceAbstractsSimilarities.md)

- R
  
  - [ConferenceAbstractsSimilarities.Rmd](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ConferenceAbstactsSimilarities/R/ConferenceAbstractsSimilarities.Rmd) 
  
  - [ConferenceAbstractsSimilarities.nb.html](https://htmlpreview.github.io/?https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ConferenceAbstactsSimilarities/R/ConferenceAbstractsSimilarities.nb.html)

## Comparison observations

***TBD...***

## References

### Articles

[AA1] Anton Antonov, 
[A monad for Latent Semantic Analysis workflows](https://github.com/antononcube/MathematicaForPrediction/blob/master/MarkdownDocuments/A-monad-for-Latent-Semantic-Analysis-workflows.md), 
(2019), 
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AA2] Anton Antonov, 
[Text similarities through bags of words](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/blob/master/Part-3-Example-Applications/Text-similarities-through-bags-of-words.md), 
(2020), 
[SimplifiedMachineLearningWorkflows-book at GitHub](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book).

### Data

[AAd1] Anton Antonov, 
[RStudio::conf-2019-abstracts.csv](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/blob/master/Data/RStudio-conf-2019-abstracts.csv), 
(2020), 
[SimplifiedMachineLearningWorkflows-book at GitHub](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book).

[AAd2] Anton Antonov, 
[Wolfram-Technology-Conference-2016-to-2019-abstracts.csv](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book/blob/master/Data/Wolfram-Technology-Conference-2016-to-2019-abstracts.csv), 
(2020), 
[SimplifiedMachineLearningWorkflows-book at GitHub](https://github.com/antononcube/SimplifiedMachineLearningWorkflows-book).

### Packages

[AAp1] Anton Antonov, 
[Monadic Latent Semantic Analysis Mathematica packag](https://github.com/antononcube/MathematicaForPrediction/blob/master/MonadicProgramming/MonadicLatentSemanticAnalysis.m),
(2017), 
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAp2] Anton Antonov, 
[Monadic Latent Semantic Analysis Mathematica packag](https://github.com/antononcube/R-packages/tree/master/LSAMon-R),
(2019), 
[R-packages at GitHub](https://github.com/antononcube/R-packages).