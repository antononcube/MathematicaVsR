# Progressive Machine Learning Examples

Anton Antonov  
[MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR)  
April 2018


# Introduction

In this project we show how to do progressive machine learning using two types of classifiers based on:

- Tries with Frequencies, [AAp2, AAp3, AA1],

- Sparse Matrix Recommender framework [AAp4, AA2].

[Progressive learning](https://en.wikipedia.org/wiki/Online_machine_learning#Progressive_learning) is a type of [Online machine learning](https://en.wikipedia.org/wiki/Online_machine_learning).
For more details see [[Wk1](https://en.wikipedia.org/wiki/Online_machine_learning)]. The Progressive learning problem is defined as follows.

**Problem definition:**

   + Assume that the data is sequentially available.

      + Meaning, at a given time only part of the data is available, and after a certain time interval new data can be obtained.

      + In view of classification, it is assumed that at a given time not all class labels are presented in the data already obtained.

      + Let us call this a *data stream*.

   + Make a machine learning algorithm that updates its model continuously or sequentially in time over a given data stream.

      + Let us call such an algorithm a Progressive Learning Algorithm (PLA).

In comparison, the typical (classical) machine learning algorithms assume that representative training data is available and after training that data is no longer needed to make predictions.
Progressive machine learning has more general assumptions about the data and its problem formulation is closer to how humans learn to classify objects.

Below we are shown the applications of two types of classifiers as PLA's. One is based on Tries with Frequencies (TF), [AAp2, AAp3, AA1], the other on a Sparse Matrix Recommender (SMR) framework [AAp4, AA2].

**Remark:** Note that both TF and SMR come from tackling Unsupervised machine learning tasks, but here they are applied in the context of Supervised machine learning.

### Additional introductory notes

#### Progressive learning definition from Wikipedia

Here is the definition of Progressive learning from [[Wk1](https://en.wikipedia.org/wiki/Online_machine_learning#Progressive_learning)]:

> Progressive learning is an effective learning model which is demonstrated by the human learning process. It is the process of learning continuously from direct experience.
Progressive learning technique (PLT) in machine learning can learn new classes/labels dynamically on the run.
Though online learning can learn new samples of data that arrive sequentially, they cannot learn new classes of data being introduced to the model.
The learning paradigm of progressive learning, is independent of the number of class constraints and it can learn new classes while still retaining the knowledge of previous classes.
Whenever a new class (non-native to the knowledge learnt thus far) is encountered, the classifier gets remodeled automatically and the parameters are calculated in such a way that it retains the knowledge learnt thus far.
This technique is suitable for real-world applications where the number of classes is often unknown and online learning from real-time data is required.

#### On making Progressive learning algorithms

Simple statistical procedures like mean and standard deviation finding can be made "progressive" with recursive definitions.
This implies that certain outlier finding algorithms can be made "progressive".
Also, Progressive learning mean computation implies that the [K-means clustering](https://en.wikipedia.org/wiki/K-means_clustering) algorithm, [[Wk2](https://en.wikipedia.org/wiki/K-means_clustering)], can be made progressive too.

Of course, (most) of the Naive Bayes Classifier (NBC) algorithms, [[Wk3](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)], can be made progressive.
The TF classification algorithm shown below is a NBC algorithm.

We can see that, in general, PLA's can be derived from different "standard" machine learning algorithms.
A more comprehensive list is given in [[Wk1](https://en.wikipedia.org/wiki/Online_machine_learning#Progressive_learning)].


# General workflow

The Mathematica and R notebooks follow the steps in the following flow chart.

[!["Progressive-machine-learning-with-Tries"](https://i.imgur.com/cVpugALl.jpg)](https://github.com/antononcube/MathematicaVsR/raw/master/Projects/ProgressiveMachineLearning/Diagrams/Progressive-machine-learning-with-Tries.jpg)

For detailed explanations see any of the notebooks.


# Project organization

## Mathematica files

- [Progressive-machine-learning-examples.md](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ProgressiveMachineLearning/Mathematica/Progressive-machine-learning-examples.md)

- [Progressive-machine-learning-examples.pdf](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ProgressiveMachineLearning/Mathematica/Progressive-machine-learning-examples.pdf)

## R files

- [ProgressiveMachineLearningExamples.Rmd](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ProgressiveMachineLearning/R/ProgressiveMachineLearningExamples.Rmd),

- [ProgressiveMachineLearningExamples.nb.html](http://htmlpreview.github.com/?https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ProgressiveMachineLearning/R/ProgressiveMachineLearningExamples.nb.html).

# Example runs

(For details see
[Progressive-machine-learning-examples.md](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ProgressiveMachineLearning/Mathematica/Progressive-machine-learning-examples.md).)

### Using Tries with Frequencies

Here is an example run with Tries with Frequencies, [AAp2, AA1]:

[!["PLA-Trie-run"](https://i.imgur.com/II7lM1Hl.png)](https://i.imgur.com/II7lM1H.png)

Here are the obtained ROC curves:

[!["PLA-Trie-ROCs-thresholds"](https://i.imgur.com/ZSgHFUvm.png)](https://i.imgur.com/ZSgHFUv.png)

We can see that with the Progressive learning process does improve its success rates in time.

### Using an Item-item recommender system

Here is an example run with an Item-item recommender system, [AAp4, AA2]:

[!["PLA-SMR-run"](https://i.imgur.com/bMJkYpal.png)](https://i.imgur.com/bMJkYpa.png)

Here are the obtained ROC curves:

[!["PLA-SMR-ROCs-thresholds"](https://i.imgur.com/S6CPNMgm.png)](https://i.imgur.com/S6CPNMg.png)


# References

## Packages

[AAp1] Anton Antonov, Obtain and transform Mathematica machine learning data-sets, [GetMachineLearningDataset.m](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ProgressiveMachineLearning/Mathematica/GetMachineLearningDataset.m),
(2018), [MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR).

[AAp2] Anton Antonov, Java tries with frequencies Mathematica package, [JavaTriesWithFrequencies.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/JavaTriesWithFrequencies.m),
(2017), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAp3] Anton Antonov, Tries with frequencies R package, [TriesWithFrequencies.R](https://github.com/antononcube/MathematicaForPrediction/blob/master/R/TriesWithFrequencies.R),
(2014), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAp4] Anton Antonov, Sparse matrix recommender framework in Mathematica, [SparseMatrixRecommenderFramework.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/SparseMatrixRecommenderFramework.m),
(2014), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

## Articles

[Wk1] Wikipedia entry, [Online machine learning](https://en.wikipedia.org/wiki/Online_machine_learning).

[AA1] Anton Antonov, ["Tries with frequencies in Java"](https://mathematicaforprediction.wordpress.com/2017/01/31/tries-with-frequencies-in-java/),
(2017), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).

[AA2] Anton Antonov, ["A Fast and Agile Item-Item Recommender: Design and Implementation"](http://library.wolfram.com/infocenter/Conferences/7964/),
(2011), Wolfram Technology Conference 2011.