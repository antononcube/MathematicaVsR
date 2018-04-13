# Progressive machine learning examples

Anton Antonov
[MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com)
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)
[MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects)
April 2018

## Introduction

In this notebook (document) we are going follow several examples of doing [Progressive machine learning](https://en.wikipedia.org/wiki/Online_machine_learning#Progressive_learning) over several datasets.

[Progressive learning](https://en.wikipedia.org/wiki/Online_machine_learning#Progressive_learning) is a type of [Online machine learning](https://en.wikipedia.org/wiki/Online_machine_learning). For more details see [[Wk1](https://en.wikipedia.org/wiki/Online_machine_learning)]. The Progressive learning problem is defined as follows.

**Problem definition:**

   + Assume that the data is sequentially available. 

      + Meaning, at a given time only part of the data is available, and after a certain time interval new data can be obtained. 

      + In view of classification, it is assumed that at a given time not all class labels are presented in the data already obtained.

      + Let us call this a *data stream*.

   + Make a machine learning algorithm that updates its model continuously or sequentially in time over a given data stream.

      + Let us call such an algorithm a Progressive Learning Algorithm (PLA).

In comparison, the typical (classical) machine learning algorithms assume that representative training data is available and after training that data is no longer needed to make predictions. Progressive machine learning has more general assumptions about the data and its problem formulation is closer to how humans learn to classify objects.

Below we are shown the applications of two types of classifiers as PLA's. One is based on Tries with Frequencies (TF), [AAp2, AAp3, AA1], the other on a Sparse Matrix Recommender (SMR) framework [AAp4, AA2].

**Remark:** Note that both TF and SMR come from tackling Unsupervised machine learning tasks, but here they are applied in the context of Supervised machine learning.

### Additional introductory notes

#### Progressive learning definition from Wikipedia

Here is the definition of Progressive learning from [[Wk1](https://en.wikipedia.org/wiki/Online_machine_learning#Progressive_learning)]:

> Progressive learning is an effective learning model which is demonstrated by the human learning process. It is the process of learning continuously from direct experience. Progressive learning technique (PLT) in machine learning can learn new classes/labels dynamically on the run. Though online learning can learn new samples of data that arrive sequentially, they cannot learn new classes of data being introduced to the model. The learning paradigm of progressive learning, is independent of the number of class constraints and it can learn new classes while still retaining the knowledge of previous classes. Whenever a new class (non-native to the knowledge learnt thus far) is encountered, the classifier gets remodeled automatically and the parameters are calculated in such a way that it retains the knowledge learnt thus far. This technique is suitable for real-world applications where the number of classes is often unknown and online learning from real-time data is required.

#### On making Progressive learning algorithms

Simple statistical procedures like mean and standard deviation finding can be made "progressive" with recursive definitions. This implies that certain outlier finding algorithms can be made "progressive". Also, Progressive learning mean computation implies that the [K-means clustering](https://en.wikipedia.org/wiki/K-means_clustering) algorithm, [[Wk2](https://en.wikipedia.org/wiki/K-means_clustering)], can be made progressive too. 

Of course, (most) of the Naive Bayes Classifier (NBC) algorithms, [[Wk3](https://en.wikipedia.org/wiki/Naive_Bayes_classifier)], can be made progressive. The TF classification algorithm shown below is a NBC algorithm.

We can see that, in general, PLA's can be derived from different "standard" machine learning algorithms. A more comprehensive list is given in [[Wk1](https://en.wikipedia.org/wiki/Online_machine_learning#Progressive_learning)]. 

## Load packages

Here we load the packages used in this notebook. (See [AAp1-AAp9].)

    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/DocumentTermMatrixConstruction.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/SSparseMatrix.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/TriesWithFrequencies.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/JavaTriesWithFrequencies.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/SparseMatrixRecommenderFramework.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/ROCFunctions.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/ProgressiveMachineLearning/Mathematica/GetMachineLearningDataset.m"]

## Data

In this section we obtain and summarize the well known "Titanic" dataset and the "Mushroom" dataset.

The data for this project has been prepared with the Mathematica (Wolfram Language) package [AAp1].

### Titanic

This obtains the "Titanic" dataset (using [AAp1]):

    dsTitanic = GetMachineLearningDataset["Titanic", "RowIDs" -> True];

Here is  a sample of the dataset:

    RandomSample[dsTitanic, 6]

[![]()]()

Here is the dataset summary:

    RecordsSummary[dsTitanic]

Here is the summary of the dataset in long form:

    smat = ToSSparseMatrix[dsTitanic];
    RecordsSummary[SSparseMatrixToTriplets[smat], {"RowID", "Variable", "Value"}]

The dataset was ingested with row IDs; here we drop them:

    dsTitanic = dsTitanic[Values];

### Mushroom

This obtains the "Mushroom" dataset using [AAp1]:

    dsMushroom = GetMachineLearningDataset["Mushroom", "RowIDs" -> True];

Here is a random record of the dataset:

    RandomSample[dsMushroom, 1] // First

Here is the summary of the dataset in long form:

    smat = ToSSparseMatrix[dsMushroom];
    RecordsSummary[SSparseMatrixToTriplets[smat], {"RowID", "Variable", "Value"}, "MaxTallies" -> 12]

The dataset was ingested with row IDs; here we drop them:

    dsMushroom = dsMushroom[Values];

### Wine quality

In this sub-section is ingested an additional dataset -- "WineQuality".

    dsWine = GetMachineLearningDataset["WineQuality", "RowIDs" -> True];

Here we modify the class label column to be categorical (and binary):

    dsWine = dsWine[All, Join[#, <|"wineQuality" -> If[#wineQuality >= 7, "high", "low"]|>] &];

Here is random sample of records:

    Magnify[RandomSample[dsWine, 6], 0.6]

Here is the summary of the dataset in long form:

    smat = ToSSparseMatrix[dsWine];
    RecordsSummary[SSparseMatrixToTriplets[smat], {"RowID", "Variable", "Value"}, "MaxTallies" -> 12]

The dataset was ingested with row IDs; here we drop them:


    dsWine = dsWine[Values];

## General progressive learning simulation loop

In this notebook we simulate the data streams given to Progressive learning algorithms.

We are going to use the following steps (based on Tries with Frequencies, [AA1]):

   1. Get a dataset.

   2. Split the dataset into training and test datasets.

   3. Split the training dataset into disjoint datasets.

   4. Make an initial trie t1.

   5. Get a new training data subset.

   6. Make a new trie t2 with the new dataset.

   7. Merge trie t1 with trie t2.

   8. Classify the test data-set using t1.

   9. Output sizes of t1 and classification success rates.

   10. Accumulate ROC statistics.

   11.  Are there more training data subsets?

      1. If "Yes" go to step 5.    

      2. If "No" go to step 12.

   12. Display ROC plots.

The flow chart below follows the sequence of steps given above.

!["Progressive-machine-learning-with-Tries-flow-chart"](https://github.com/antononcube/MathematicaVsR/raw/master/Projects/ProgressiveMachineLearning/Diagrams/Progressive-machine-learning-with-Tries.jpg)

## Data sorting

We sort the training data and the training and sample indices in order to exaggerate the Progressive learning effect. 

With the data stream based on sorted data in the initial Progressive learning stages not all class labels and variable correlations would be seen.

    ordInds = Ordering[Normal@dsTitanic[All, 2 ;; -2]];
    dsTitanic = dsTitanic[ordInds];

    ordInds = Ordering[Normal@dsMushroom[All, 2 ;; -2]];
    dsMushroom = dsMushroom[ordInds];

    ordInds = Ordering[Normal@dsWine[All, 2 ;; -2]];
    dsWine = dsWine[ordInds];

## On the choice of algorithms

In this section we explain how Progressive learning classification can be done with two simple algorithms machine learning algorithms: Tries with Frequencies and Nearest Neighbors.

### Why use Tries with Frequencies?

Tries with Frequencies fit Progressive Learning pretty well. The incremental growth of a trie is exactly in the sequential, data streaming manner of Progressive Learning. 

The procedure in this sub-section is supported by operations of the packages [AAp2, AAp3].

Let us create  an example comprised of the following two steps:

   + a trie is made with a few dozen records, and 

   + that trie is extended with a new, single record.

For clarity in the rest of the sub-section we are going to drop the column "passengerAge" from the "Titanic" records.

    trainingColumnNames = {"passengerClass", "passengerSex", "passengerSurvival"};

Here we create a trie with a sample of records of the "Titanic" dataset, dsTitanic:

    SeedRandom[343]
    rInds = RandomInteger[{1, 300}, 42];
    tr = TrieCreate[Normal[dsTitanic[rInds, trainingColumnNames][Values]]];
    TrieForm[tr, ImageSize -> {Automatic, 250}]

[!["PLA-Trie-classification-with-small-trie-1"](https://i.imgur.com/nwwRMhJl.png)](https://i.imgur.com/nwwRMhJ.png)

Let us add a new record to that first trie. Here is another record:

    newInd = {RandomInteger[{301, 400}]};
    Normal[dsTitanic[newInd, trainingColumnNames][Values]]
    (* {{"2nd", "female", "survived"}} *)

And here is how the new, updated trie looks like:

    tr2 = TrieMerge[tr, TrieCreate[Normal[dsTitanic[newInd, trainingColumnNames][Values]]]];
    TrieForm[tr2, ImageSize -> {Automatic, 250}]

[!["PLA-Trie-classification-with-small-trie-2"](https://i.imgur.com/jAPIwrCl.png)](https://i.imgur.com/jAPIwrC.png)

**Remark:** Note that TF can be used to find conditional probabilities of the record elements.

Here we classify a (made up, partial) record with the trie made so far:

    TrieClassify[tr2, {"1st", "male"}, "Probabilities"] // N
    (* <|"died" -> 0.695652, "survived" -> 0.304348|> *)

(The function TrieClassify behaves like [Classify](https://reference.wolfram.com/language/ref/Classify.html) with built-in classifiers.)

At this point it is clear that Tries with Frequencies can be directly applied to Progressive learning in a fairly straightforward way.

### Why use a nearest neighbors classifier?

In this sub-section we are going to present a PLA algorithm based on Nearest Neighbours (NNs) and sparse matrix linear algebra. We are going to use extensively the package [SSparseMatrix.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/SSparseMatrix.m), [[AAp8](https://github.com/antononcube/MathematicaForPrediction/blob/master/SSparseMatrix.m)], that provides sparse matrices with named columns and rows and corresponding related operations. 

The procedure in this sub-section is supported by methods of the Sparse Matrix Recommender objects of the package [AAp4].

Here are 6 random records of the "Titanic" dataset, dsTitanic.

    SeedRandom[143]
    rInds = RandomInteger[{1, Length[dsTitanic]}, 10];
    dsTitanic[TakeDrop[rInds, 6][[1]]]

[!["PLA-Trie-small-NNs-classification-1"](https://i.imgur.com/CewT9MHl.png)](https://i.imgur.com/CewT9MH.png)

Assume that these records are the only records our PLA has seen so far.

Consider the following matrix made from those records. Each row corresponds of to a record and the values of the "id" column are row names. Note that the unique values of each column are "unfolded" into separate columns.

    smat = ColumnBind @@
       Map[ToSSparseMatrix[CrossTabulate[dsTitanic[TakeDrop[rInds, 6][[1]], {"id", #}]]] &, Rest[Normal[Keys[dsTitanic[1]]]]];
    MatrixForm[smat]

[!["PLA-Trie-small-NNs-classification-2"](https://i.imgur.com/GdZYiN6l.png)](https://i.imgur.com/GdZYiN6.png)

Assume we see a new set of records and make the corresponding matrix:

    smat2 = ColumnBind @@
       Map[ToSSparseMatrix[CrossTabulate[dsTitanic[TakeDrop[rInds, 6][[2]], {"id", #}]]] &, Rest[Normal[Keys[dsTitanic[1]]]]];
    MatrixForm[smat2]

[!["PLA-Trie-small-NNs-classification-3"](https://i.imgur.com/j9K4M8M.png)](https://i.imgur.com/j9K4M8M.png)

Let us combine by *row binding* the old matrix and the new matrix into one. For this we need to make sure they have the same column names in both matrices.

    allColNames = Union[Join[ColumnNames[smat], ColumnNames[smat2]]];
    smat = ImposeColumnNames[smat, allColNames];
    smat2 = ImposeColumnNames[smat2, allColNames];
    smat = RowBind[smat, smat2];
    MatrixForm[smat]

[!["PLA-Trie-small-NNs-classification-4"](https://i.imgur.com/EYHEJel.png)](https://i.imgur.com/EYHEJel.png)

Here the matrix making command above is repeated for a certain single record from the dataset:

    newInd = RandomSample[Complement[Range[Length[dsTitanic]], rInds], 1];
    svec = ColumnBind @@ 
       Map[ToSSparseMatrix[CrossTabulate[dsTitanic[newInd, {"id", #}]]] &, Rest[Normal[Keys[dsTitanic[1]]]]];
    MatrixForm[svec]

[!["PLA-Trie-small-NNs-classification-5"](https://i.imgur.com/wylrOYs.png)](https://i.imgur.com/wylrOYs.png)

Let us drop the survival columns:

    svec = svec[[All, Complement[ColumnNames[svec], {"died", "survived"}]]];
    MatrixForm[svec]

[!["PLA-Trie-small-NNs-classification-6"](https://i.imgur.com/bXqFutL.png)](https://i.imgur.com/bXqFutL.png)

Here we combine the column names of smat and svec:

    allColNames = Union[Join[ColumnNames[smat], ColumnNames[svec]]]

Note that generally not all of those column names are in smat and svec.

Here we the single row matrix, svec, is extended to have all of the columns:

    svec = ImposeColumnNames[svec, allColNames];
    MatrixForm[svec]

[!["PLA-Trie-small-NNs-classification-7"](https://i.imgur.com/nH2WaQm.png)](https://i.imgur.com/nH2WaQm.png)

Here is how we find the NNs scores for the search vector svec:

    res = smat.Transpose[svec];
    MatrixForm[res]
    
[!["PLA-Trie-small-NNs-classification-8"](https://i.imgur.com/Zobuy9U.png)](https://i.imgur.com/Zobuy9U.png)

Let us extract the actual records from the "Titanic" dataset.

    TakeLargest[RowSumsAssociation[res], 2]

    dsTitanic[Select[MemberQ[ToExpression /@ Keys[%], #id] &]]

[!["PLA-Trie-small-NNs-classification-9"](https://i.imgur.com/E4iayEx.png)](https://i.imgur.com/E4iayEx.png)

With the obtained records above we determine the class label to be assigned to the record represented with svec. (In this case "died".)

## Progressive learning classification by Tries with Frequencies

In order to have the code more general let use the variable ds for the selected dataset.

    ds = dsTitanic;

Here we set the classification label column:

    labelColumnName = "passengerSurvival";

Here we determine the class label to focus on:

    focusLabel = SortBy[Normal[Tally[ds[All, labelColumnName]]], #[[2]] &][[1, 1]]
    (* survived *)
    
### Data separation and preparation

Here we split the data into training and test parts.

    SeedRandom[1232]
    {dsTraining, dsTest} = ds[Sort@#] & /@ TakeDrop[RandomSample[Range[Length[ds]]], Floor[Length[ds] .75]];

In general, when using a trie for classification that process might be sensitive of the order the variables, especially for data with smaller number of records and/or large number of variables.
That is why here we select a permutation. (And make sure that the selected class label variable is the last index in the permutation.)

    perm = Complement[Range[1, Dimensions[ds][[2]]], Flatten[Position[Normal@Keys@ds[1], "id" | labelColumnName]]];
    perm = Join[perm, Flatten[Position[Normal@Keys@ds[1], labelColumnName]]]
    (* {2, 3, 4, 5} *)

    trTraining = Normal@dsTraining[[All, perm]][Values];
    trTest = Normal@dsTest[[All, perm]][Values];

    trTraining = Map[ToString, trTraining, {-1}] /. {_Missing -> "NA", x_?NumericQ :> ToString[x]};
    trTest = Map[ToString, trTest, {-1}] /. {_Missing -> "NA", x_?NumericQ :> ToString[x]};

    Dimensions[trTraining]
    Dimensions[trTest]
    (* {981, 4}
       {328, 4} *)
    
### Classification

Here are the training data splitting ranges:

    splitRanges = Map[# + {1, 0} &, Partition[Union@Join[Range[0, 300, 100], Range[300, Length[dsTraining], 200], {Length[dsTraining]}], 2, 1]];
    MatrixForm@ToSSparseMatrix[SparseArray@splitRanges, "ColumnNames" -> {"Begin", "End"}]

[!["PLA-Trie-run-training-data-split-ranges"](https://i.imgur.com/ceFzvEgl.png)](https://i.imgur.com/ceFzvEg.png)

    (*Inital trie creation.*)
    
    tr = TrieCreate[trTraining[[Span @@ First[splitRanges], All]]];
    
    (*For accumulation of ROC statistics.*)
    aROCStats = <||>;
    
    (*Main loop.*)
    Do[
     (*Train a new trie.*)
     
     tr2 = TrieCreate[trTraining[[Span @@ rng, All]]];
     
     (*Merge the new trie with the current trie.*)
     
     tr = TrieMerge[tr, tr2];
     
     (*Convert frequencies to probabilities.*)
     
     ptr = TrieNodeProbabilities[tr];
     
     (*Classify with the trie.*)
     
     clRes = Map[TrieClassify[ptr, #, "Default" -> "NA"] &, trTest[[All, 1 ;; Length[perm] - 1]]];
     
     (*Compute success rates.*)
     
     cPairs = Transpose[{Normal[dsTest[All, labelColumnName]], clRes}];
     ctMat = ToSSparseMatrix@CrossTabulate[cPairs];
     
     (*Proclaim.*)

     Print[Style[StringJoin@ConstantArray["-", 100], Blue]];
     Print[Style[Row[{"Iteration with range:", rng}], Blue]];
     Echo[TrieNodeCounts[ptr], "Size of trie:"];
     Echo[Tally[clRes], "Predicted tally:"];
     Echo[Count[Equal @@@ cPairs, True]/Length[cPairs] // N, "Accuracy:"];
     Echo[Row[{MatrixForm[ctMat], ", ", MatrixForm[ctMat*Transpose[SparseArray[Table[1./RowSums[ctMat], Dimensions[ctMat][[2]]]]]]}], "Actual vs predicted:"];

     (*Accumulate for ROC statistics.*)

     clRes = TrieClassify[ptr, trTest[[All, 1 ;; Length[perm] - 1]], "Probabilities", "Default" -> "NA"];
     clRes = Map[Join[AssociationThread[Normal[dsTest[All, labelColumnName]], 0], #] &, clRes];
     clDS = Dataset[KeyDrop[clRes, "NA"]];
     aROCStats = Join[aROCStats, <|rng -> ROCValues[clDS, trTest[[All, -1]], "ClassLabel" -> focusLabel]|>],

     {rng, Rest@splitRanges}]


[!["PLA-Trie-run"](https://i.imgur.com/II7lM1Hl.png)](https://i.imgur.com/II7lM1H.png)

### Plot ROC curves

Here we plot the Receiver Operating Characteristic (ROC) curves using the package [[AAp7](https://github.com/antononcube/MathematicaForPrediction/blob/master/ROCFunctions.m)]:

    ROCPlot[aROCStats, GridLines -> Automatic, PlotRange -> {{0, 1}, {0, 1}}]

[!["PLA-Trie-ROCs-thresholds"](https://i.imgur.com/ZSgHFUvl.png)](https://i.imgur.com/ZSgHFUv.png)

We can see that with the Progressive learning process does improve its success rates in time.

## Progressive learning classification by nearest neighbors

In order to have the code more general let use the variable ds for the selected dataset.

    ds = dsTitanic;

Here we assign a class label column name and a computation parameter (should we re-weight the matrix terms or not):

    labelColumnName = "passengerSurvival";
    useTFIDFQ = False;

Here we determine the class label to focus on:

    focusLabel = SortBy[Normal[Tally[ds[All, labelColumnName]]], #[[2]] &][[1, 1]]

### Data separation and preparation

    SeedRandom[1232]
    {dsTraining, dsTest} = Sort[ds][Sort@#] & /@ TakeDrop[RandomSample[Range[Length[ds]]], Floor[Length[ds] .75]];

    testRecords = Map[ToString /@ Values[KeyDrop[#, {"id", labelColumnName}]] &, Normal[dsTest]];

### Classification

Here are the training data splitting ranges:

    splitRanges = Map[# + {1, 0} &, Partition[Union@Join[Range[0, 300, 100], Range[300, Length[dsTraining], 200], {Length[dsTraining]}], 2, 1]];
    MatrixForm@ToSSparseMatrix[SparseArray@splitRanges, "ColumnNames" -> {"Begin", "End"}]

    (*First recommender object.*)
    
    mainSMR = MakeItemRecommender["titanic", dsTraining[splitRanges[[1]]], "id"];
    
    (*For accumulation of ROC statistics.*)
    aROCStats = <||>;
    aNNsROCStats = <||>;
    
    (*Main loop.*)
    Do[
     (*Make a recommender object with the new data.*)
     
     tempSMR = MakeItemRecommender["temp", dsTraining[Span @@ rng], "id"];
     
     (*Merge the new data recommender with the current one.*)

     mainSMR["RowBind"][tempSMR];
     
     (*Reweight matrix terms if specified.*)
     
     If[TrueQ[useTFIDFQ],mainSMR["M"] = WeightTerms[mainSMR["M"]]];
     
     (*Assign classifier parameters.*)
     
     mainSMR["classificationParameters"] = <|"tagType" -> labelColumnName, "nTopNNs" -> 12, "voting" -> False, "dropZeroScoredLabels" -> True|>;
     
     (*Classify with the current recommender.*)
     
     clRes = ItemRecommenderClassify[mainSMR, #, "Scores"] & /@ testRecords;
     
     (*Compute the success rates.*)
     
     cPairs = Transpose[{Normal[dsTest[All, labelColumnName]], Map[First@*Keys, clRes]}];
     ctMat = ToSSparseMatrix@CrossTabulate[cPairs];
     ctMat = ImposeColumnNames[ctMat, RowNames[ctMat]];
     
     (*Proclaim.*)

     Print[Style[StringJoin@ConstantArray["-", 100], Blue]];
     Print[Style[Row[{"Iteration with range:", rng}], Blue]];
     Echo[Tally[First@*Keys /@ clRes], "Predicted tally:"];
     Echo[Dimensions[mainSMR["M"]], "Dimensions[mainSMR[\"M\"]:"];
     Echo[Count[Equal @@@ cPairs, True]/Length[cPairs] // N, "Accuracy:"];
     Echo[Row[{MatrixForm[ctMat], ", ", MatrixForm[ctMat*Transpose[SparseArray[Table[1./RowSums[ctMat], Dimensions[ctMat][[2]]]]]]}], "Actual vs predicted:"];
     
     (*Accumulate for ROC statistics.*)
     
     (*clRes=ItemRecommenderClassify[mainSMR,#,"TopProbabilities"->2]&/@testRecords;*)
     
     clRes = ItemRecommenderClassify[mainSMR, #, "Scores"] & /@ testRecords;
     If[TrueQ[labelColumnName == "passengerSurvival"],
      clDS = Dataset[KeyDrop[clRes, "NA"]][All, <|"survived" -> #survived, "died" -> #died|> &], clDS = Dataset[clRes]
     ];
     aROCStats = Join[aROCStats, <|rng -> ROCValues[clDS, Normal[dsTest[All, labelColumnName]]]|>];

     (*ROC over the top NNs parameter.*)
     nnsROCStats =
      Table[(
        clRes = ItemRecommenderClassify[mainSMR, #, "Scores", "nTopNNs" -> i, "Normalize" -> True] & /@ testRecords;
        clDS = Dataset[clRes];
        Join[ROCValues[clDS, Normal[dsTest[All, labelColumnName]], {0.7}, "ClassLabel" -> focusLabel][[1]], <|"ROCParameter" -> i|>]
        ), {i, Range[5, 70, 5]}];
     aNNsROCStats = Join[aNNsROCStats, <|rng -> nnsROCStats|>],

     {rng, Rest@splitRanges}]

[!["PLA-SMR-run"](https://i.imgur.com/bMJkYpal.png)](https://i.imgur.com/bMJkYpa.png)

### ROC curves

Here are ROC plots for the threshold of selection.

    ROCPlot[aROCStats, "PlotJoined" -> True, GridLines -> Automatic, PlotRange -> {{0, 1}, {0, 1}}]

[!["PLA-SMR-ROCs-thresholds"](https://i.imgur.com/S6CPNMgl.png)](https://i.imgur.com/S6CPNMg.png)

Here are ROC plots over the number of top NNs used to determine the predicted class label.

    ROCPlot[aNNsROCStats, "PlotJoined" -> False, GridLines -> Automatic, PlotRange -> {{0, 1}, {0, 1}}]

[!["PLA-SMR-ROCs-NNs"](https://i.imgur.com/7ukpZJMl.png)](https://i.imgur.com/7ukpZJM.png)

## References

###  Packages

[AAp1] Anton Antonov, Obtain and transform Mathematica machine learning data-sets, [GetMachineLearningDataset.m](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/ProgressiveMachineLearning/Mathematica/GetMachineLearningDataset.m), (2018), [MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR).   

[AAp2] Anton Antonov, Tries with frequencies Mathematica package, [TriesWithFrequencies.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/TriesWithFrequencies.m), (2013), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).   

[AAp3] Anton Antonov, Java tries with frequencies Mathematica package,  [JavaTriesWithFrequencies.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/JavaTriesWithFrequencies.m), (2017), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).   

[AAp4] Anton Antonov, Sparse matrix recommender framework in Mathematica, [SparseMatrixRecommenderFramework.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/SparseMatrixRecommenderFramework.m), (2014),  [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).   

[AAp5] Anton Antonov, Variable importance determination by classifiers implementation in Mathematica, [VariableImportanceByClassifiers.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/VariableImportanceByClassifiers.m), (2015), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction). 

[AAp6] Anton Antonov, Receiver operating characteristic functions Mathematica package, [ROCFunctions.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/ROCFunctions.m), (2016), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction). 

[AAp7] Anton Antonov, [MathematicaForPrediction utilities ](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m)*[Mathematica ](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m)*[package](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m), [MathematicaForPredictionUtilities.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m), (2014), [MathematicaForPrediction at GitHub.](https://github.com/antononcube/MathematicaForPrediction)

[AAp8] Anton Antonov,  [SSparseMatrix Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/SSparseMatrix.m), [SSparseMatrix.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/SSparseMatrix.m), (2018), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[AAp9] Anton Antonov, [Implementation of document-term matrix construction and re-weighting functions in Mathematica](https://github.com/antononcube/MathematicaForPrediction/blob/master/DocumentTermMatrixConstruction.m), [DocumentTermMatrixConstruction.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/DocumentTermMatrixConstruction.m), (2013), [MathematicaForPrediction at GitHub.](https://github.com/antononcube/MathematicaForPrediction)

### Articles

[Wk1] Wikipedia entry, [Online machine learning](https://en.wikipedia.org/wiki/Online_machine_learning). 
	URL: https://en.wikipedia.org/wiki/Online_machine_learning .   

[Wk2] Wikipedia entry, [K-means clustering](https://en.wikipedia.org/wiki/K-means_clustering).
	URL: https://en.wikipedia.org/wiki/K-means_clustering .

[Wk3] Wikipedia entry, [Naive Bayes classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier).
	URL: https://en.wikipedia.org/wiki/Naive_Bayes_classifier .

[AA1] Anton Antonov, ["Tries with frequencies in Java"](https://mathematicaforprediction.wordpress.com/2017/01/31/tries-with-frequencies-in-java/), (2017), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).   
	URL: https://mathematicaforprediction.wordpress.com/2017/01/31/tries-with-frequencies-in-java/ .

[AA2] Anton Antonov, ["A Fast and Agile Item-Item Recommender: Design and Implementation"](http://library.wolfram.com/infocenter/Conferences/7964/), (2011), Wolfram Technology Conference 2011.
	URL: http://library.wolfram.com/infocenter/Conferences/7964/ .

