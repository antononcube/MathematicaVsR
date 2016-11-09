
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
  
  
## Comparison observations

TBD
