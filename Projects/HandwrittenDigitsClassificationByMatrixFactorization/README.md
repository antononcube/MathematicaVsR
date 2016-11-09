
## Handwritten digits recognition by matrix factorization
Anton Antonov  
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
[MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects)  
September, 2016


## Introduction

This project is for comparing *Mathematica* and R for the tasks of classifier creation, execution, and
evaluation using the [MNIST database](http://yann.lecun.com/exdb/mnist/) of images of
handwritten digits.

Here are the bases built with two different classifiers:

- Singular Value Decomposition (SVD)

[!["SVD-basis-for-5](http://i.imgur.com/nqyjjPjl.png)](http://i.imgur.com/nqyjjPj.png)

- Non-Negative Matrix Factorization (NNMF)

[!["NNMF-basis-for-5"](http://i.imgur.com/chAojFul.png)](http://i.imgur.com/chAojFu.png)

Here are the confusion matrices of the two classifiers:

- SVD

[!["SVD-confusion-matrix"](http://i.imgur.com/odFdCmXl.png)](http://i.imgur.com/odFdCmX.png)

- NNMF

[!["NNMF-confusion-matrix"](http://i.imgur.com/k42FmHCl.png)](http://i.imgur.com/k42FmHC.png)

The blog post
["Classification of handwritten digits"](https://mathematicaforprediction.wordpress.com/2013/08/26/classification-of-handwritten-digits/)
has a related more elaborated discussion over a much smaller database
of handwritten digits.

## Concrete steps

The concrete steps taken in scripts and documents of this project follow.

1. Ingest the **binary** data files into arrays that can be visualized
as digit images.

  - We have two sets: 60,000 training images and 10,000 testing images.

2. Make a linear vector space representation of the images by simple
unfolding.

3. For each digit find the corresponding representation matrix and
   factorize it.

4. Store the matrix factorization results in a suitable data
structure. (These results comprise the classifier training.)

  - One of the matrix factors is seen as a new basis. 

5. For a given test image (and its linear vector space representation)
   find the basis that approximates it best. The corresponding digit
   is the classifier prediction for the given test image.

6. Evaluate the classifier(s) over all test images and compute
accuracy, F-Scores, and other measures.


## Scripts

There are scripts going through the steps listed above:

- *Mathematica* : ["./Mathematica/Handwritten-digits-classification-by-matrix-factorization.md"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/HandwrittenDigitsClassificationByMatrixFactorization/Mathematica/Handwritten-digits-classification-by-matrix-factorization.md)

- R : ["./R/HandwrittenDigitsClassificationByMatrixFactorization.Rmd"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/HandwrittenDigitsClassificationByMatrixFactorization/R/HandwrittenDigitsClassificationByMatrixFactorization.Rmd).

## Documents

The following documents give an exposition that is suitable for
reading and following of steps and corresponding results.

- *Mathematica* : ["./Mathematica/Handwritten-digits-classification-by-matrix-factorization.pdf"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/HandwrittenDigitsClassificationByMatrixFactorization/Mathematica/Handwritten-digits-classification-by-matrix-factorization.pdf).

- R :
["./R/HandwrittenDigitsClassificationByMatrixFactorization.pdf"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/HandwrittenDigitsClassificationByMatrixFactorization/R/HandwrittenDigitsClassificationByMatrixFactorization.pdf),
["./R/HandwrittenDigitsClassificationByMatrixFactorization.html"](https://cdn.rawgit.com/antononcube/MathematicaVsR/master/Projects/HandwrittenDigitsClassificationByMatrixFactorization/R/HandwrittenDigitsClassificationByMatrixFactorization.html).
  
  
## Observations

### Ingestion

I figured out first in R how to ingest the data in the binary files of the
[MNIST database](http://yann.lecun.com/exdb/mnist/). There were at
least several online resources (blog posts, GitHub repositories) that
discuss the MNIST binary files ingestion.

After that making the corresponding code in Mathematica was easy.

### Classification results

Same in Mathematica and R for for SVD and NNMF. (As expected.)

### NNMF

NNMF classifiers use the [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction/)
implementations:
[NonNegativeMatrixFactorization.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/NonNegativeMatrixFactorization.m)
and [NonNegativeMatrixFactorization.R](https://github.com/antononcube/MathematicaForPrediction/blob/master/R/NonNegativeMatrixFactorization.R).
 
### Parallel computations

Both Mathematica and R have relatively simple set-up of parallel computations.

### Graphics

It was not very straightforward to come up MNIST images visualization
in R. The Mathematica visualization is much more flexible when it
comes to plot labeling.

## Going further

### Comparing with other classifiers

Using Mathematica's built-in classifiers it was easy to compare the
SVD and NNMF classifiers with neural network ones and others. (The SVD
and NNMF are much faster to built and bring comparable precision.)

It would be nice to repeat that in R using one or several of neural
network classifiers provided by Google, Microsoft, H2O, Baidu, etc.

### Classifier ensembles

Another possible extension is to use [classifier ensembles and Receiver Operation Characteristic
(ROC)](https://mathematicaforprediction.wordpress.com/2016/10/15/roc-for-classifier-ensembles-bootstrapping-damaging-and-interpolation/) to create better classifiers. (Both in Mathematica and R.)


### Importance of variables

Using
[classifier agnostic importance of variables procedure](https://mathematicaforprediction.wordpress.com/2016/01/11/importance-of-variables-investigation/)
we can figure out :

- which NNMF basis vectors (images) are most important for
classification precision,

- which image rows or columns are most important for each digit, or similarly

- which image squares of a 3x3 image grid are most important.




