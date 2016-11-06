(*
    Simple data browser with Chernoff faces implementation in Mathematica

    Copyright (C) 2016  Anton Antonov

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

(*
    Mathematica is (C) Copyright 1988-2016 Wolfram Research, Inc.

    Protected by copyright law and international treaties.

    Unauthorized reproduction or distribution subject to severe civil
    and criminal penalties.

    Mathematica is a registered trademark of Wolfram Research, Inc.
*)

(* :Title: SimpleDataBrowserWithChernoffFaces *)
(* :Context: SimpleDataBrowserWithChernoffFaces` *)
(* :Author: Anton Antonov *)
(* :Date: 2016-11-06 *)

(* :Package Version: 1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2016 Anton Antonov *)
(* :Keywords: Chernoff faces, Multidimentional data visualization, Interactive interface *)
(* :Discussion:

    The code of this file is for the Mathematica part of the project:

      https://github.com/antononcube/MathematicaVsR/tree/master/Projects/BrowsingDataWithChernoffFaces

    of the repository MathematicaVsR at GitHub:

      https://github.com/antononcube/MathematicaVsR

    The project comparison task is:

      Make an interactive data browser for data tables; each data table row is visualized with a Chernoff face.

    This is the first, simple version of the data browser for the project. It was committed in a separate file
    for didactic purposes. A similar but fuller data browser is in the file:

      https://github.com/antononcube/MathematicaVsR/blob/master/Projects/\
      BrowsingDataWithChernoffFaces/Mathematica/DataBrowserWithChernoffFaces.m

    Anton Antonov
    Windermere, FL, USA
    2016-11-06
*)

(* Created with Mathematica Plugin for IntelliJ IDEA *)

If[Length[DownValues[MathematicaForPredictionUtilities`GridTableForm]] == 0,
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m"]
];

If[Length[DownValues[ChernoffFace`ChernoffFace]] == 0,
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/ChernoffFaces.m"]
];

Manipulate[
  DynamicModule[{wsize = 800, hsize = 400, columnNames, data, numCols, rdata, recordNames, paneOpts},

    (*Get data.*)
    columnNames = ExampleData[ dname, "ColumnHeadings"];
    data = ExampleData[ dname];
    data = If[! MatrixQ[data], Transpose[{data}], data];

    (*Find,separate,and standardize numerical variables.*)
    numCols =
        Pick[Range[1, Dimensions[data][[2]]],
          VectorQ[#, NumericQ] & /@ Transpose[data]];
    rdata = VariablesRescale[N@data[[All, numCols]]];

    (*Tabular presentations of data views.*)
    paneOpts = {ImageSize -> {wsize, hsize}, Scrollbars -> True};
    TabView[
      {"Chernoff faces" -> Pane[
        Multicolumn[
          MapIndexed[
            ChernoffFace[#1, PlotLabel -> #2[[1]], ImageSize -> 65] &, rdata], 10,
          Appearance -> "Horizontal"], paneOpts],
        "Summary" -> Pane[
          Grid[{{"Dataset name", dname},
            {"Dimensions", Dimensions[data]},
            {"Summary", Multicolumn[RecordsSummary[N@data, columnNames], 5, Dividers -> All]}
          }, Alignment -> Left, Dividers -> All], paneOpts],
        "Data" -> Pane[
          GridTableForm[data, TableHeadings -> columnNames], paneOpts]
      }]
  ],
  {{dname, {"Statistics", "EmployeeAttitude"}, "Dataset name:"}, ExampleData["Statistics"], ControlType -> PopupMenu}]