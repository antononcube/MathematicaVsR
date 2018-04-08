(*
    Obtain and transform Mathematica machine learning datasets
    Copyright (C) 2018  Anton Antonov

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Written by Anton Antonov,
    antononcube @ gmail . com,
    Windermere, Florida, USA.
*)


(* :Title: GetMachineLearningDataset *)
(* :Context: GetMachineLearningDataset` *)
(* :Author: Anton Antonov *)
(* :Date: 2018-04-08 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2018 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:


  # In brief

  This Mathematica package has a function for getting machine learning data-sets and transforming them
  into Dataset objects with named rows and columns.

  The purpose of the function GetMachineLearningDataset is to produce data sets that easier to deal with
  in both Mathematica and R.


  # Details

  Some additional transformations are done do some variables for some data-sets.

  For example for "Titanic" the passenger ages are rounded to multiples of 10; missing ages are given the value -1.
  See below the line:

      ds = ds[Map[<|#, "passengerAge" -> If[! NumberQ[#passengerAge], -1, Round[#passengerAge/10]*10]|> &]];


  # Example

  This gets the "Titanic" dataset:

      dsTitanic = GetMachineLearningDataset["Titanic", "RowIDs" -> True];
      Dimensions[dsTitanic]
      (* {1309, 5} *)


  Here is a summary using the package [1]:

      RecordsSummary[dsTitanic[Values]]


  Here is a summary in long form with the packages [1] and [2]:

      smat = ToSSparseMatrix[dsTitanic];
      RecordsSummary[SSparseMatrixToTriplets[smat], {"RowID", "Variable", "Value"}]



  # References

  [1] Anton Antonov, MathematicaForPredictionUtilities.m, (2014),
      https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m

  [2] Anton Antonov, SSparseMatrix.m, (2018),
      https://github.com/antononcube/MathematicaForPrediction/blob/master/SSparseMatrix.m


  This file was created by Mathematica Plugin for IntelliJ IDEA.

  Anton Antonov
  Windermere, FL, USA
  2018-04-08

*)

BeginPackage["GetMachineLearningDataset`"]

GetMachineLearningDataset::usage = "GetMachineLearningDataset[dataName_String] gets data with \
ExampleData[{\"MachineLearning\", dataName}, \"Data\"] and transforms it into a Dataset object with named rows and columns. \
Some additional transformations are done do some variables for some data-sets."

Begin["`Private`"]

Clear[GetMachineLearningDataset]

Options[GetMachineLearningDataset] = {"RowIDs" -> False, "MissingToNA" -> True};

GetMachineLearningDataset[dataName_String, opts:OptionsPattern[]] :=
    Block[{rowNamesQ, missingToNAQ, exampleGroup, data, ds, varNames, dsVarNames},

      rowNamesQ = TrueQ[OptionValue[GetMachineLearningDataset,"RowIDs"]];
      missingToNAQ = TrueQ[OptionValue[GetMachineLearningDataset,"MissingToNA"]];

      exampleGroup = "MachineLearning";

      data = ExampleData[{exampleGroup, dataName}, "Data"];

      ds = Dataset[Flatten@*List @@@ ExampleData[{exampleGroup, dataName}, "Data"]];

      dsVarNames =
          Flatten[List @@
              ExampleData[{exampleGroup, dataName}, "VariableDescriptions"]];

      If[dataName == "FisherIris", dsVarNames = Most[dsVarNames]];

      If[dataName == "Satellite",
        dsVarNames =
            Append[Table["Spectral-" <> ToString[i], {i, 1, Dimensions[ds][[2]] - 1}], "Type Of Land Surface"]
      ];

      dsVarNames =
          StringReplace[dsVarNames,
            "edibility of mushroom (either edible or poisonous)" ~~ (WhitespaceCharacter ...) -> "edibility"];

      dsVarNames =
          StringReplace[dsVarNames,
            "wine quality (score between 1-10)" ~~ (WhitespaceCharacter ...) -> "wine quality"];

      dsVarNames =
          StringJoin[
            StringReplace[
              StringSplit[#], {WordBoundary ~~ x_ :> ToUpperCase[x]}]] & /@
              dsVarNames;

      dsVarNames =
          StringReplace[
            dsVarNames, {StartOfString ~~ x_ :> ToLowerCase[x]}];

      varNames = Most[dsVarNames] -> Last[dsVarNames];

      ds = ds[All, AssociationThread[dsVarNames -> #] &];

      ds = ds[MapIndexed[<|"id" -> #2[[1]], #|> &]];

      If[dataName == "Titanic",
        ds = ds[Map[<|#, "passengerAge" -> If[! NumberQ[#passengerAge], -1, Round[#passengerAge/10]*10]|> &]];
      ];

      If[ rowNamesQ,
        ds = Dataset[AssociationThread[ToString /@ Normal[ds[All, "id"]], Normal[ds]]];
      ];

      If[ missingToNAQ,
        ds = ds /. _Missing -> "NA"
      ];

      ds
    ]

End[] (* `Private` *)

EndPackage[]