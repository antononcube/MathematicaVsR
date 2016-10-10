# **Linear regression with ROC**

### Anton Antonov   
### MathematicaForPrediction project at GitHub   
### MathematicaVsR project at GitHub   
### October 2016   

# Introduction

This document demonstrates how to do in Mathematica linear regression (easily using the built-in function `LinearModelFit`) and to tune the binary classification with the derived model through the so called [Receiver Operating Characteristic](https://en.wikipedia.org/wiki/Receiver_operating_characteristic) (ROC) framework, \[[5](https://en.wikipedia.org/wiki/Receiver_operating_characteristic),[6](https://ccrma.stanford.edu/workshops/mir2009/references/ROCintro.pdf)\].

The data used in this document is from \[[1](http://archive.ics.uci.edu/ml/datasets/Census+Income)\] and it has been analyzed in more detail in \[[2](https://mathematicaforprediction.wordpress.com/2014/03/30/classification-and-association-rules-for-census-income-data/)\]. In this document we only show to how to ingest and do very basic analysis of that data before proceeding with the linear regression model and its tuning. The package \[[4](https://github.com/antononcube/MathematicaForPrediction/blob/master/ROCFunctions.m)\] provides the needed ROC functionalities.

## Used packages

These commands load the packages \[[3](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m),[4](https://github.com/antononcube/MathematicaForPrediction/blob/master/ROCFunctions.m)\]:

    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/ROCFunctions.m"]

# Reading data

The code below imports the data.

    lines = Import["~/Datasets/adult/adult.data"];
    lines = Select[lines, Length[#] > 3 &];
    Dimensions[lines]

(* {32561, 15} *)

    linesTest = Import["~/Datasets/adult/adult.test"];
    linesTest = Select[linesTest, Length[#] > 3 &];
    Dimensions[linesTest]

(* {16281, 15} *)

    columnNames = StringSplit["age,workclass,fnlwgt,education,education-num,marital-status,occupation,relationship,race,sex,capital-gain,capital-loss,hours-per-week,native-country", ","]

(* {"age", "workclass", "fnlwgt", "education", "education-num", "marital-status", "occupation", "relationship", "race", "sex", "capital-gain", "capital-loss", "hours-per-week", "native-country"} *)          

    AppendTo[columnNames, "income"]

(* {"age", "workclass", "fnlwgt", "education", "education-num", "marital-status", "occupation", "relationship", "race", "sex", "capital-gain", "capital-loss", "hours-per-week", "native-country", "income"} *)

    aColumnNames = AssociationThread[columnNames -> Range[Length[columnNames]]];

    Magnify[#, 0.6] &@GridTableForm[lines[[1 ;; 12]], TableHeadings -> Map[Style[#, Blue, FontFamily -> "Times"] &, columnNames]]

[![AdultData1][1]][1]

    Magnify[#, 0.6] &@GridTableForm[linesTest[[1 ;; 12]], TableHeadings -> Map[Style[#, Blue, FontFamily -> "Times"] &, columnNames]]

[![AdultData2][2]][2]

# Assignment

As usual in classification and regression problems we work with two data sets: a training data set and a testing data set. Here we split the original training set into two sets training set and tuning set. The tuning set is going to be used to find a good value of a tuning parameter through ROC.

### Training data

    data = lines;
    data[[All, -1]] = Map[StringTrim, data[[All, -1]]];

    trainingInds = RandomSample[Range[Length[data]], Ceiling[Length[data]*0.75]];
    tuningInds = Complement[Range[Length[data]], trainingInds];
    trainingData = data[[trainingInds]];
    tuningData = data[[tuningInds]];

### Testing data

    testData = linesTest;
    testData[[All, -1]] = Map[StringDrop[StringTrim[#], -1] &, testData[[All, -1]]];

# Some preliminary data analysis

Before doing regression it is a good idea to do some preliminary analysis of the data. For that we are going to use functions defined in the package \[[3](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m)\]. 

    Magnify[#, 0.7] &@Grid[ArrayReshape[RecordsSummary[data, columnNames], {3, 5}], Dividers -> All, Alignment -> {Left, Top}]

[![BaseAnalyze1][3]][3]

    Magnify[#, 0.7] &@Grid[ArrayReshape[RecordsSummary[testData, columnNames], {3, 5}], Dividers -> All, Alignment -> {Left, Top}]

[![BaseAnalyze2][4]][4]

Looking at the column "income" we can see that for both datasets the people who earn more than $50000 is $ \approx 25% $ of all people. We will consider ">50" to be the more important class label for the classifiers built below.

For simplicity of the exposition below we are going to use only the columns "age", "education-num", "hours-per-week", "income".

    columnNamesExplantoryVars = {"age", "education-num", "hours-per-week"};
    columnNameResponseVar = "income";
    columnNamesForAnalysis = Append[columnNamesExplantoryVars, columnNameResponseVar];

Here is variable dependence grid for those variables:

    Magnify[#, 0.7] &@VariableDependenceGrid[data[[All, aColumnNames /@ columnNamesForAnalysis]], columnNamesForAnalysis]

[![VariableDependencies][14]][14]

We can see from the last row of the plot above that the variables "age", "education-num", "hours-per-week" can explain "income" at least to a degree. We see that higher values of "age", "education-num", "hours-per-week" are associated closer with ">50K". For more detailed analysis see \[[2](https://mathematicaforprediction.wordpress.com/2014/03/30/classification-and-association-rules-for-census-income-data/)\].

# LinearModelFit

`LinearModelFit` has several signatures. Doing Linear regression over the data we have is most convenient with the signature `LinearModelFit[{m,v}]` (using a [design matrix](https://en.wikipedia.org/wiki/Design_matrix) $m$ and a response vector $v$.)

As mentioned above in order to keep the exposition simple we do the regression with the three numerical columns "age", "education-num", and "hours-per-week". With the replacement rules \{"<=50K"->0,">50K"->1\} we convert the data column "income" into a vector of 0's and 1's. The result of `LinearModelFit` is a function based on the training set of data.

    lfmFunc = LinearModelFit[{trainingData[[All, aColumnNames /@ {"age", "education-num", "hours-per-week"}]], trainingData[[All, aColumnNames["income"]]] /. {"<=50K" -> 0, ">50K" -> 1}}]

[![LinearFit1][5]][5]

We use the model from the training data on the test data:

    tuningLables = tuningData[[All, aColumnNames["income"]]] /. {"<=50K" -> 0, ">50K" -> 1};

Next we are going to evaluate what is the classification success of the derived model.

    modelValues = lfmFunc @@@tuningData[[All, aColumnNames /@ {"age", "education-num", "hours-per-week"}]];

    modelValues[[1 ;; 12]]

(* {0.247367, 0.329018, 0.276566, 0.321543, 0.220014, 0.236299, 0.381438, 0.34737, 0.212317, 0.30707, 0.277886, 0.327077} *)

Although the response vector given to `LinearModelFit` is of 0's and 1's the regression model values are reals within a smaller than \[0,1\] range.

    RecordsSummary[modelValues]

[![LinearFit2][6]][6]

Here is a histogram of values from the regression model:

    Histogram[modelValues, Automatic, "Probability", PlotLabel -> "Regression model values\nover the test data", AxesLabel -> {"FittedModel values", "Probability"}]

[![RegressionHistogram][7]][7]

We pick a threshold above which the model values are considered to be 1's (and hence ">=50K").

    With[{\[Theta] = 0.3}, modelLabels = Map[If[# > \[Theta], 1, 0] &, modelValues]];

    modelLabels[[1 ;; 12]]

(* {0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1} *)

Here is a table that shows classification success of the regression model with chosen threshold:

    labelsROC = SortBy[Tally[Transpose[{tuningLables, modelLabels}]], First];
    labelsROC = Flatten /@MapThread[Append, {labelsROC, labelsROC[[All, 2]]/Total[labelsROC[[All, 2]]] // N}];
    TableForm[labelsROC, TableHeadings -> {{"true negative", "false positive", "false negative", "true positive"}, {"test labels", "model labels", "freq", "%"}}]

[![SuccessRate1][8]][8]

We want to determine the threshold that gives the best classification success. What is "best" can be viewed and determined in several ways. We are going to use the so called Receiver Operating Characteristic (ROC); see \[[5](https://en.wikipedia.org/wiki/Receiver_operating_characteristic)\].

(The table above is similar to the confusion matrix produced by *Mathematica*'s function `Classify` made available through `ClassifierMeasurements`. See the documentation for these function.)

# LinearModelFit with ROC

In this section we take a more systematic approach of determining the best threshold to be used to separate the regression model values. 

We are going to call ***positive*** the income values ">50K" and ***negative*** the income values "<=50K". Again see \[[2](https://mathematicaforprediction.wordpress.com/2014/03/30/classification-and-association-rules-for-census-income-data/)\]. As we mentioned above, we will consider ">50" to be the more important class label for the classifiers built below.

For the ROC functionalities are employed through the package \[[4](https://github.com/antononcube/MathematicaForPrediction/blob/master/ROCFunctions.m)\].

## Linear regression classification definitions

    Clear[ModelLabelsByThreshold]
    ModelLabelsByThreshold[modelValues_?VectorQ, \[Theta]_?NumberQ] := Map[If[# > \[Theta], 1, 0] &, modelValues];
    ModelLabelsByThreshold[lfmFunc_FittedModel, testData_?MatrixQ, aColumnNames_Association, \[Theta]_?NumberQ] :=
      Block[{t, testLables, modelValues, modelLabels},
      testLables = testData[[All, aColumnNames["income"]]] /. {"<=50K" -> 0, ">50K" -> 1};
      modelValues = lfmFunc @@@ testData[[All, aColumnNames /@ {"age", "education-num", "hours-per-week"}]];
      ModelLabelsByThreshold[modelValues, testLables, \[Theta]]
     ];

## Computations to find the best threshold

Looking at the histogram of classification values:

    Histogram[modelValues, Automatic, "Probability", PlotLabel -> "Regression model values\nover the test data", AxesLabel -> {"FittedModel values", "Probability"}]

[![RegressionHistogram][7]][7]

we decide to use the following a range of thresholds:

    thRange = Range[0.15, 0.42, 0.01];

Compute the model values

    AbsoluteTiming[
     tuningLabels = testData[[All, aColumnNames[columnNameResponseVar]]] /. {"<=50K" -> 0, ">50K" -> 1};
     modelValues = lfmFunc @@@ testData[[All, aColumnNames /@ columnNamesExplantoryVars]];
    ]

(* {2.02965, Null} *)

Compute the ROC data for each threshold of the range of thresholds, and convert the ROC data to associations convenient for the computation of ROC functions:

    aROCs = Table[ToROCAssociation[{1,0}, tuningLabels, ModelLabelsByThreshold[modelValues, \[Theta]]], {\[Theta], thRange}];

Here is an example of evaluating some of the ROC functions over one of the elements of `aROCs`:

    Through[ROCFunctions[{"PPV", "NPV", "ACC"}][aROCs[[3]]]]

(* {217/221, 639/2603, 1495/5427} *)

Plot of the functions PPV, NPV, TPR, SPC, ACC:

    ListLinePlot[Map[Transpose[{thRange, #}] &, Transpose[Map[Through[ROCFunctions[{"PPV", "NPV", "TPR", "ACC", "SPC"}][#]] &, aROCs]]],
     Frame -> True, FrameLabel -> Map[Style[#, Larger] &, {"threshold, \[Theta]", "rate"}], PlotLegends -> Map[# <> ", " <> (ROCFunctions["FunctionInterpretations"][#]) &, {"PPV", "NPV", "TPR", "ACC", "SPC"}], GridLines -> Automatic]

[![ThresholdPlot1][10]][10]

Using the plot above we can select a threshold for separating the model values into 0's and 1's ("<=50K" and ">50K" respectively). We can see that when the classification accuracy increases the positive predictive value decreases. A good threshold value is 0.3 because TPR and ACC have satisfactory, large enough values.

Let us find the intersection point of the curves PPV and TPR. Examining the plot above we can come up with the initial condition for $x$.

    Clear[\[Theta]]
    ppvFunc = Interpolation[Transpose@{thRange, ROCFunctions["PPV"] /@ aROCs}];
    tprFunc = Interpolation[Transpose@{thRange, ROCFunctions["TPR"] /@ aROCs}];
    sol = FindRoot[ppvFunc[\[Theta]] - tprFunc[\[Theta]] == 0, {\[Theta], 0.25}]

(* {\[Theta] -> 0.304195} *)

Here is a different plot used [typically](https://en.wikipedia.org/wiki/Receiver_operating_characteristic#/media/File:Roccurves.png) in ROC analysis:

    ROCPlot[thRange, aROCs, "PlotJoined" -> False, "ROCPointCallouts" -> True, "ROCPointTooltips" -> True, GridLines -> Automatic]

[![ThresholdPlot2][11]][11]

## Accuracy over the test data

We split the original training data into two parts for training and tuning. Using the found threshold, let us use evaluate the classification process over the test data.

    modelValues = lfmFunc @@@ testData[[All, aColumnNames /@ columnNamesExplantoryVars]];
    modelLabels = Map[If[# > (\[Theta] /. sol), ">50K", "<=50K"] &, modelValues];

Using the actual labels and the predicted labels (`modelLabels`) let us find the contingency values with `ToROCAssociation`:

    clRes = ToROCAssociation[{">50K", "<=50K"}, testData[[All, aColumnNames[columnNameResponseVar]]], modelLabels]

(* <|"TruePositive" -> 1998, "FalsePositive" -> 1867, "TrueNegative" -> 10568, "FalseNegative" -> 1848|> *)

Using the above result let us compute all of the ROC functions:

    GridTableForm[Transpose[{ROCFunctions["FunctionNames"], N@Through[ROCFunctions[][clRes]]}], TableHeadings -> {"name", "value"}]

[![AccuracyData1][12]][12]

## Using a built-in classifier

If we use one of the built-in classifiers we can see that we got better results for the important class label ">50K" through the ROC analysis using an inferior base classifier (linear regression).

    AbsoluteTiming[cf = Classify[data[[All, aColumnNames /@ columnNamesExplantoryVars]] -> data[[All, aColumnNames[columnNameResponseVar]]], Method -> "NeuralNetwork"]; 
     cfPredictedLabels = cf /@ testData[[All, aColumnNames /@ columnNamesExplantoryVars]];
    ]

(* {22.8904, Null} *)

    cfCLRes = ToROCAssociation[{">50K", "<=50K"}, testData[[All, aColumnNames[columnNameResponseVar]]], cfPredictedLabels]
    GridTableForm[Transpose[{ROCFunctions["FunctionNames"], N@Through[ROCFunctions[][cfCLRes]]}], TableHeadings -> {"name", "value"}]

(* <|"TruePositive" -> 1486, "FalsePositive" -> 870, "TrueNegative" -> 11565, "FalseNegative" -> 2360|> *)

[![AccuracyData2][13]][13]

# References

\[1\] Bache, K. & Lichman, M. (2013). UCI Machine Learning Repository. Irvine, CA: University of California, School of Information and Computer Science. Census Income Data Set, URL: http://archive.ics.uci.edu/ml/datasets/Census+Income .

\[2\] Anton Antonov, "Classification and association rules for census income data", (2014), MathematicaForPrediction at WordPress.com , URL: https://mathematicaforprediction.wordpress.com/2014/03/30/classification-and-association-rules-for-census-income-data/ .

\[3\] Anton Antonov, MathematicaForPrediction utilities, (2014), source code MathematicaForPrediction at GitHub, package MathematicaForPredictionUtilities.m.

\[4\] Anton Antonov, Receiver operating characteristic functions Mathematica package, (2016), source code MathematicaForPrediction at GitHub, package ROCFunctions.m .

\[5\] Wikipedia entry, Receiver operating characteristic. URL: http://en.wikipedia.org/wiki/Receiver_operating_characteristic .

\[6\] Tom Fawcett, An introduction to ROC analysis, (2006), Pattern Recognition Letters, 27, 861–874. ([Link to PDF](https://ccrma.stanford.edu/workshops/mir2009/references/ROCintro.pdf).)
<!---
[1]:AdultData1.png
[2]:AdultData2.png
[3]:BaseAnalyze1.png
[4]:BaseAnalyze2.png
[5]:LinearFit1.png
[6]:LinearFit2.png
[7]:RegressionHistogram.png
[8]:SuccessRate1.png
[10]:ThresholdPlot1.png
[11]:ThresholdPlot2.png
[12]:AccuracyData1.png
[13]:AccuracyData2.png
[14]:VariableDependencies.png
-->

[1]:http://i.imgur.com/LnO6ABA.png
[2]:http://i.imgur.com/X4zAG1Q.png
[3]:http://i.imgur.com/Xy1SNwf.png
[4]:http://i.imgur.com/VmAXIQN.png
[5]:http://i.imgur.com/NxNXiRC.png
[6]:http://i.imgur.com/j6kFfvH.png
[7]:http://i.imgur.com/IHIQbAN.png
[8]:http://i.imgur.com/uYFNyfb.png
[10]:http://imgur.com/Sv944Ll.png
[11]:http://imgur.com/tkavDIx.png
[12]:http://i.imgur.com/IKRsLni.png
[13]:http://i.imgur.com/Fn4qzDT.png
[14]:http://imgur.com/i3Sdg9g.png