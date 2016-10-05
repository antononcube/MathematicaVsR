# Contingency tables creation examples

Anton Antonov  
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
[MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects)  
October, 2016

## Introduction

In statistics [contingency tables](https://en.wikipedia.org/wiki/Contingency_table) are matrices used to show the co-occurrence of variable values of multi-dimensional data. They are fundamental in many types of research. This document shows how to use several functions implemented in *Mathematica* for the construction of contingency tables.

### Code

In this document we are going to use the implementations in the package [MathematicaForPredictionUtilities.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m) from [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), [1].

    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m"]

The implementation of CrossTabulate in [1] is based on Tally, GatherBy, and SparseArray. The implementation of xtabsViaRLink in [1] is based on [R](https://www.r-project.org)'s function [xtabs](https://cran.r-project.org/web/packages/tigerstats/vignettes/xtabs.html) called via [RLink](https://reference.wolfram.com/language/RLink/guide/RLink.html).

Other package used in this document are [2] and [4] imported with these commands:

    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MosaicPlot.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/Misc/RSparseMatrix.m"]

For a different approach to implementing cross-tabulation than those taken in [1] see the [Stack Overflow](http://stackoverflow.com) answer [http://stackoverflow.com/a/8101951](http://stackoverflow.com/a/8101951) by Mr.Wizard.

## Using Titanic data

### Getting data

    titanicData = 
      Flatten@*List @@@ ExampleData[{"MachineLearning", "Titanic"}, "Data"];
    titanicData = DeleteCases[titanicData, {___, _Missing, ___}];

    titanicColumnNames = 
      Flatten@*List @@ ExampleData[{"MachineLearning", "Titanic"}, "VariableDescriptions"];
    aTitanicColumnNames = 
      AssociationThread[titanicColumnNames -> Range[Length[titanicColumnNames]]];

Note that we have removed the records with missing data (for simpler exposition).

### Data summary

    Dimensions[titanicData]
	(* {1046, 4} *)

    RecordsSummary[titanicData, titanicColumnNames]

[!["titanic-summary"](http://imgur.com/754X5CSl.png)](http://imgur.com/754X5CS.png)

### Using CrossTabulate

Assume that we want to group the people according to their passenger class and survival and we want to find the average age for each group.

We can do that by 

**1.** finding the counts contingency table $C$ for the variables "passenger class" and "passenger survival", 

**2.** finding the age contingency table $A$ for the same variables, and

**3.** do the element-wise division $\frac{A}{C}$.


    ctCounts = 
      CrossTabulate[
       titanicData[[All, aTitanicColumnNames /@ {"passenger class", "passenger survival"}]]];
    MatrixForm[#1, TableHeadings -> {#2, #3}] & @@ ctCounts

[!["ctCounts-matrix-form"](http://imgur.com/NONpPFLl.png)](http://imgur.com/NONpPFL.png)

    ctTotalAge = 
      CrossTabulate[
       titanicData[[All, 
        aTitanicColumnNames /@ {"passenger class", "passenger survival", 
          "passenger age"}]]];
    MatrixForm[#1, TableHeadings -> {#2, #3}] & @@ ctTotalAge

[!["ctTotalAge-matrix-form"](http://imgur.com/8QtrKGbl.png)](http://imgur.com/8QtrKGb.png)

    MatrixForm[
     ctTotalAge[[1]]/
      Normal[ctCounts[[1]]], 
     TableHeadings -> Values[Rest[ctTotalAge]]]

[!["mean-matrix-form"](http://imgur.com/5zBjIqql.png)](http://imgur.com/5zBjIqq.png)

(We have to make the sparse array `ctCounts` a regular array because otherwise we get warnings for division by zero because of the sparse array's default value.)

Let us repeat the steps above by dividing the passengers before-hand according to their sex.


    Association@
     Map[
      (mCount = 
         CrossTabulate[#[[All, aTitanicColumnNames /@ {"passenger class", "passenger survival"}]]]; 
       mAge = CrossTabulate[#[[All, aTitanicColumnNames /@ {"passenger class", "passenger survival", "passenger age"}]]];
       #[[1,  aTitanicColumnNames["passenger sex"]]] -> 
         MatrixForm[mAge[[1]]/Normal[mCount[[1]]], TableHeadings -> Values[Rest[mAge]]]) &, 
      GatherBy[titanicData, #[[aTitanicColumnNames["passenger sex"]]] &]]

[!["sex-cross-tables"](http://imgur.com/ZKpMN1ml.png)](http://imgur.com/ZKpMN1m.png)

### Using R's xtabs (via RLink)

The alternative of CrossTabulate is xtabsViaRLink that is uses R's function [xtabs](https://cran.r-project.org/web/packages/tigerstats/vignettes/xtabs.html) via RLink.


    Needs["RLink`"]
    RLinkResourcesInstall[]
    InstallR[]

    (* {Paclet[RLinkRuntime,9.0.0.0, <>]} *)

    ctCounts = 
      FromRXTabsForm@
       xtabsViaRLink[
        titanicData[[All, aTitanicColumnNames /@ {"passenger class", "passenger survival"}]],
		{"passenger.sex", "passenger.survival"},
		" ~ passenger.sex + passenger.survival"];
    MatrixForm[#1, TableHeadings -> {#2, #3}] & @@ ctCounts

[!["xtabs-output"](http://imgur.com/6WUQq4Nl.png)](http://imgur.com/6WUQq4N.png)

### Relation to mosaic plots

The graphical visualization of a dataset with mosaic plots, [2,3], is similar in spirit to contingency tables. Compare the following mosaic plot with the contingency table in the last section.

    MosaicPlot[
     titanicData[[All, aTitanicColumnNames /@ {"passenger class", "passenger survival"}]] ]

[!["titanic-class-survival-mosaic-plot"](http://imgur.com/xw303gRl.png)](http://imgur.com/xw303gR.png)

## Straightforward calling of MatrixForm

At this point we might want to be able to call MatrixForm more directly for the output of CrossTabulate and FromRXTabsForm. One way to do this is to define an up-value for Association .

    Unprotect[Association];
    MatrixForm[x_Association /; (KeyExistsQ[x, "XTABMatrix"] || KeyExistsQ[x, "XTABTensor"])] ^:= (MatrixForm[#1, TableHeadings -> Rest[{##}]] & @@ x);
    Protect[Association];

Now we can do this:

    MatrixForm @
     CrossTabulate[titanicData[[All, aTitanicColumnNames /@ {"passenger class", "passenger survival"}]]]

[!["ctCounts-matrix-form"](http://imgur.com/NONpPFLl.png)](http://imgur.com/NONpPFL.png)

**Remark:** Because of this up-value definition for Association with MatrixForm we have the associations returned by `CrossTabulate` and 
`FromRXTabsForm` to have the key "XTABMatrix" instead of "Matrix", the former assumed to be much more rarely to be used than the latter.

## Using larger data

Let us consider an example with larger data that has larger number of unique values in its columns. 

### Getting online retail invoices data

The following dataset is taken from [6].

    data = Import[ "/Volumes/WhiteSlimSeagate/Datasets/UCI Online Retail Data Set/Online Retail.csv"];
    columnNames = First[data];
    data = Rest[data];

    aColumnNames = AssociationThread[columnNames -> Range[Length[columnNames]]];

### Data summary

We have $\approx 66000$ rows and $8$ columns:  

    Dimensions[data]
    (* {65499, 8} *)

Here is a summary of the columns:

    Magnify[#, 0.75] &@RecordsSummary[data, columnNames]

[!["online-retail-summary"](http://imgur.com/CeDSKs3.png)](http://imgur.com/CeDSKs3.png)

### Contingency tables

#### Country vs. StockCode

There is no one-to-one correspondence between the values of the column "Description" and the column "StockCode" which can be seen with this command:

    MinMax@Map[Length@*Union, 
      GatherBy[data[[All, aColumnNames /@ {"Description", "StockCode"}]], First]]
    (* {1,144} *)

The way in which the column "StockCode" was ingested made it have multiple types for its values:

    Tally[NumberQ /@ data[[All, aColumnNames["StockCode"]]]]
    (* {{False,9009},{True,56490}} *)

So let us convert it to all strings:

    data[[All, aColumnNames["StockCode"]]] = 
      ToString /@ data[[All, aColumnNames["StockCode"]]];

Here we find the contingency table for "Country" and "StockCode" over "Quantity" using CrossTabulate:

    AbsoluteTiming[
     ctRes = CrossTabulate[
        data[[All, aColumnNames /@ {"Country", "StockCode", "Quantity"}]]];
    ]
    (* {0.256339,Null} *)

Here we find the contingency table for "Country" and "StockCode" over "Quantity" using xtabsViaRLink:

    AbsoluteTiming[
     rres = xtabsViaRLink[
       data[[All, aColumnNames /@ {"Country", "StockCode", "Quantity"}]],
	   {"Country", "StockCode", "Quantity"},
	   "Quantity ~ Country + StockCode"]; 
     ctRRes = FromRXTabsForm[rres];
    ]
    (* {0.843621,Null} *)

Both functions produce the same result:

    ctRRes["matrix"] == N@ctRRes[[1]]
    (* True *)

Note that `xtabsViaRLink` is slower but still fairly quick.

Here we plot the contingency table using MatrixPlot :

    MatrixPlot[ctRRes["matrix"], AspectRatio -> 1/1.5, 
      FrameTicks -> {{#, #} &@ Table[{i, ctRRes["rownames"][[i]]}, {i, Length[ctRRes["rownames"]]}], 
      {Automatic, Automatic}}, ImageSize -> 550]

[!["online-retail-country-vs-stockcode-table"](http://imgur.com/HubzXgv.png)](http://imgur.com/HubzXgv.png)

#### Country vs. Quarter

Let us extend the data with columns that have months and quarters corresponding to the invoice dates.

The following commands computing date objects and extracting month and quarter values from them are too slow.

    (*AbsoluteTiming[dobjs=DateObject[{#,{"Month","/","Day","/","Year"," \
    ","Hour",":","Minute"}}]&/@data[[All,aColumnNames["InvoiceDate"]]];
    ]*)
    (* {30.2595,Null} *)

    (*AbsoluteTiming[
    dvals=DateValue[dobjs,{"MonthName","QuarterNameShort"}];
    ]*)
    (* {91.1732,Null} *)

We can use the following ad hoc computation instead.

    dvals = StringSplit[#, {"/", " ", ":"}] & /@ 
       data[[All, 
        aColumnNames["InvoiceDate"]]];

This summary shows that the second value in the dates is day of month, and the first value is most likely month.

    Magnify[#, 0.75] &@ RecordsSummary[dvals[[All, 1 ;; 3]], "MaxTallies" -> 16]

[!["dvals-conjecture-summary"](http://imgur.com/jXj0CEPm.png)](http://imgur.com/jXj0CEP.png)

These commands extend the data and the corresponding column-name-to-index association.

    ms = DateValue[Table[DateObject[{2016, i, 1}], {i, 12}], "MonthName"];
    dvals = Map[{ms[[#]], "Q" <> ToString[Quotient[#, 4] + 1]} &, ToExpression @ dvals[[All, 1]]];
    dataM = MapThread[Join[#1, #2] &, {data, dvals}];
    aColumnNamesM = 
      Join[aColumnNames, <|"MonthName" -> (Length[aColumnNames] + 1), "QuarterNameShort" -> (Length[aColumnNames] + 2)|>];
    (* {0.054877,Null} *)

Here is the contingency table for "Country" vs "QuarterNameShort" over "Quantity".

    ctRes = CrossTabulate[ dataM[[All, aColumnNamesM /@ {"Country", "QuarterNameShort", "Quantity"}]]];
    Magnify[#, 0.75] &@ MatrixForm[#1, TableHeadings -> {#2, #3}] & @@ ctRes

[!["online-retail-country-vs-quarter-table"](http://imgur.com/cmxj7dL.png)](http://imgur.com/cmxj7dL.png)

## Uniform tables 

Often when making contingency tables over subsets of the data we obtain contingency tables with different rows and columns. For various reasons (programming, esthetics, comprehension) it is better to have the tables with the same rows and columns.

Here is an example of non-uniform contingency tables derived from the online retail data of the previous section. We split the data over the countries and find contingency tables of "MonthName" vs "QuarterNameShort" over "Quantity".

    tbs = Association @
     Map[
        (xtab = CrossTabulate[#[[All, aColumnNamesM /@ {"MonthName", "QuarterNameShort", "Quantity"}]]];
         #[[1, aColumnNamesM["Country"]]] -> xtab) &,
        GatherBy[ dataM, #[[aColumnNamesM[ "Country"]]] &]];

    Magnify[#, 0.75] &@
     Map[MatrixForm[#["Matrix"], TableHeadings -> (# /@ {"RowNames", "ColumnNames"})] &, tbs](*[[{1,12,-1}]]*)

[!["non-uniform-tables"](http://imgur.com/dx6tp3g.png)](http://imgur.com/dx6tp3g.png)

Using the object RSparseMatrix, see [4,5], we can impose row and column names on each table. 

First we convert the contingency tables into RSparseMatrix objects:

    tbs2 = Map[ ToRSparseMatrix[#["Matrix"], "RowNames" -> #["RowNames"], "ColumnNames" -> #["ColumnNames"]] &, tbs];

And then we impose the desired row and column names:

    tbs2 = Map[ ImposeColumnNames[ ImposeRowNames[#, {"January", "December"}], {"Q1", "Q2", "Q3", "Q4"}] &, tbs2];
    Magnify[#, 0.75] &@(MatrixForm /@ tbs2)

[!["uniform-tables"](http://imgur.com/NyxJRdW.png)](http://imgur.com/NyxJRdW.png)

## Generalization : CrossTensorate

A generalization of `CrossTabulate` is the function `CrossTensorate` implemented in [1] that takes a "formula" argument similar to R's [`xtabs`](https://stat.ethz.ch/R-manual/R-devel/library/stats/html/xtabs.html).

This finds number of people of different sub-groups of Titanic data:

    ctRes = CrossTensorate[Count == "passenger survival" + "passenger sex" + "passenger class", titanicData, aTitanicColumnNames];
    MatrixForm[ctRes]

[!["cross-tensorate-result"](http://imgur.com/db6EILB.png)](http://imgur.com/db6EILB.png)

We can verify the result using Count:

    Count[titanicData, {"1st", _, "female", "died"}]
    (* 5 *)

    Count[titanicData, {"2nd", _, "male", "survived"}]
    (* 23 *)

To split the cross-tensor across its first variable we can use this command:

    sctRes = Association@
      MapThread[Rule[#1, Join[<|"XTABTensor" -> #2|>, Rest@Rest@ctRes]] &, {ctRes[[2]], # & /@ ctRes["XTABTensor"]}];
    MatrixForm /@ sctRes

[!["cross-tensorate-split"](http://imgur.com/10nGQXY.png)](http://imgur.com/10nGQXY.png)

Or we can call the more general function `CrossTensorateSplit` implemented in [1]:

    Map[MatrixForm /@ CrossTensorateSplit[ctRes, #] &, Rest@Keys[ctRes]]

[!["crosstensoratesplit-example"](http://imgur.com/q2Wg0sj.png)](http://imgur.com/q2Wg0sj.png)    

`CrossTensorateSplit` can also be called with one argument that is a variable name.This will produce a splitting function. For example, the above command can be re-written as :

    Map[MatrixForm /@ CrossTensorateSplit[#] @ ctRes &, Rest@Keys[ctRes]]

## References

\[1\] Anton Antonov, [MathematicaForPrediction utilities](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m), (2014), source code [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)*, *package [MathematicaForPredictionUtilities.m](https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m).

\[2\] Anton Antonov, [Mosaic plot for data visualization implementation in Mathematica](https://github.com/antononcube/MathematicaForPrediction/blob/master/MosaicPlot.m), (2014), [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)*, *package [MosaicPlot.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/MosaicPlot.m). 

\[3\] Anton Antonov, ["Mosaic plots for data visualization"](https://mathematicaforprediction.wordpress.com/2014/03/17/mosaic-plots-for-data-visualization/), (2014), [MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com)*. *URL: [https://mathematicaforprediction.wordpress.com/2014/03/17/mosaic-plots-for-data-visualization/](https://mathematicaforprediction.wordpress.com/2014/03/17/mosaic-plots-for-data-visualization/) .

\[4\] Anton Antonov, [RSparseMatrix Mathematica package](https://github.com/antononcube/MathematicaForPrediction/blob/master/Misc/RSparseMatrix.m), (2015) [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction). URL: [https://github.com/antononcube/MathematicaForPrediction/blob/master/Misc/RSparseMatrix.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/Misc/RSparseMatrix.m) .

\[5\] Anton Antonov, ["RSparseMatrix for sparse matrices with named rows and columns"](https://mathematicaforprediction.wordpress.com/2015/10/08/rsparsematrix-for-sparse-matrices-with-named-rows-and-columns/), (2015), [MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com)*. *URL: [https://mathematicaforprediction.wordpress.com/2015/10/08/rsparsematrix-for-sparse-matrices-with-named-rows-and-columns/](https://mathematicaforprediction.wordpress.com/2015/10/08/rsparsematrix-for-sparse-matrices-with-named-rows-and-columns/) .

\[6\] Daqing Chen, [Online Retail Data Set](https://archive.ics.uci.edu/ml/datasets/Online+Retail), (2015), [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/index.html). URL: [https://archive.ics.uci.edu/ml/datasets/Online+Retail](https://archive.ics.uci.edu/ml/datasets/Online+Retail) .

