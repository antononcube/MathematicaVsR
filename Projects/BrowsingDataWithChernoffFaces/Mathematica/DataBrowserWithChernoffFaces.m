(*
    Data browser with Chernoff faces implementation in Mathematica

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

(* :Title: DataBrowserWithChernoffFaces *)
(* :Context: DataBrowserWithChernoffFaces` *)
(* :Author: Anton Antonov *)
(* :Date: 2016-11-05 *)

(* :Package Version: 1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2016 Anton Antonov *)
(* :Keywords: Chernoff faces, Multidimentional data visualization, Interactive interface *)
(* :Discussion:

    The code of this file is for the Mathematica part of the project:

      https://github.com/antononcube/MathematicaVsR/tree/master/Projects/BrowsingDataWithChernoffFaces

    of the repository MathematicaVsR at GitHub:

      https://github.com/antononcube/MathematicaVsR

    The data browser was made with the intent to be useful. Because of this the code is probably not that easy
    to read for beginners in Mathematica.

    A version of the function ChernoffFaceAutoColored should be probably included in the ChernoffFaces.m package.

    That function had also an implementation with Association data argument. I removed it because I consider
    the Association argument implementation redundant for the purposes of this source code/file.

    Anton Antonov
    Windermere, FL, USA
    2016-11-05
*)

(*
  TODO:
    1. Better explanations
    2. Make a simpler version of the browser code for didactic purposes.
    3. Consider optimizing the browser.
    4. Add, commit, remove standardization with median and quartile distance.
    5. Add optional outlier identification and removal. (e.g. "Clip outliers" checkbox.)
*)

(* Created with Mathematica Plugin for IntelliJ IDEA *)

If[Length[DownValues[MathematicaForPredictionUtilities`GridTableForm]] == 0,
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m"]
];

If[Length[DownValues[ChernoffFace`ChernoffFace]] == 0,
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/ChernoffFaces.m"]
];


Clear[ChernoffFaceAutoColored]

ChernoffFaceAutoColored[vec_?VectorQ, cdf_ColorDataFunction, opts : OptionsPattern[]] :=
    Block[{asc},
      asc = AssociationThread[Take[Keys[ChernoffFace["FacePartsProperties"]], UpTo[Length[vec]]] -> vec];
      Which[
        Length[vec] == 1,
        asc = Join[asc, <|"FaceColor" -> cdf[vec[[1]]]|>],
        Length[vec] <= 2,
        asc = Join[asc, <|"FaceColor" -> cdf[vec[[1]]], "IrisColor" -> cdf[vec[[2]]]|>],
        Length[vec] <= 6,
        asc = Join[asc, <|"FaceColor" -> cdf[Mean@vec[[1 ;; 2]]], "IrisColor" -> cdf[Mean@vec[[3 ;; -1]]]|>],
        True,
        asc = Join[asc, <|
          "FaceColor" -> cdf[Mean@vec[[1 ;; 2]]],
          "MouthColor" -> cdf[Mean@vec[[1 ;; 3]]],
          "IrisColor" -> cdf[Mean@vec[[4 ;; 6]]],
          "NoseColor" -> cdf[Mean@vec[[7 ;; -1]]]|>]
      ];
      ChernoffFace[asc, opts]
    ];

Manipulate[
  DynamicModule[{wsize = 1000, hsize = 520, ncols = 10, faceImageSize = 60,
    columnNames, numCols, data, rdata, recordNames, recordNamesInds, qvals,
    medianFace, neutralFace, lowFace, highFace, firstQuFace, thirdQuFace,
    offset, pageSpan, cfFunc},

    (* Get data and make it matrix if it is not. *)
    columnNames = ExampleData[dname, "ColumnHeadings"];
    data = ExampleData[dname];
    data = If[! MatrixQ[data], Transpose[{data}], data];

    (* Find, separate, and standardize numerical variables. *)
    numCols = Pick[Range[1, Dimensions[data][[2]]], VectorQ[#, NumericQ] & /@ Transpose[data]];
    If[normalizationType == "MeanVar",
      rdata = VariablesRescale[N@data[[All, numCols]]],
      rdata = VariablesRescale[N@data[[All, numCols]],
        "StandardizingFunction" -> (Standardize[#1, Median, QuartileDeviation] &)]
    ];

    (* Make record names to be used as labels in the Chernoff face images. *)
    recordNames =
        If[Length[numCols] == Dimensions[data][[2]],
          Range[Length[data]],
          (*ELSE*)
          Map[StringJoin @@ Riffle[ToString /@ #, ":"] &,
            data[[All, Complement[Range[1, Dimensions[data][[2]]], numCols]]]]
        ];
    recordNamesInds = Rescale[recordNames /. Thread[Union[recordNames] -> Range[Length[Union[recordNames]]]]];

    (* Find the median and quartile faces (used to help interpretation.) *)
    qvals = Map[Quartiles, Transpose[rdata]];
    If[TrueQ[colorDataScheme == "None" || colorMethod == "Label"],
      cfFunc = ChernoffFace[#1, PlotLabel -> #2, ImageSize -> faceImageSize] &,
      (*ELSE*)
      cfFunc = ChernoffFaceAutoColored[#1, ColorData[colorDataScheme], PlotLabel -> #2, ImageSize -> faceImageSize] &
    ];
    {firstQuFace, medianFace, thirdQuFace} = MapThread[cfFunc, {Transpose[qvals], {"1st Qu", "Median", "3d Qu"}}];
    {lowFace, neutralFace, highFace} =
        MapThread[cfFunc,
          {Transpose[ConstantArray[{0.25, 0.5, 0.75}, Length@Transpose[rdata]]],
          {"All 0.25", "All 0.5", "All 0.75"}}];

    (* The data -- Chernoff faces and data rows -- are browsed in pages. Find the page parameters. *)
    offset = Min[itemsPerPage, Length[data]];
    If[(page - 1)*itemsPerPage + 1 > Length[data], page = 1];
    pageSpan = (page - 1)*itemsPerPage + 1 ;; Min[page*itemsPerPage, Length[data]];

    (* Restrict the numerical data to the page to be shown. *)
    rdata = rdata[[pageSpan]];
    recordNames = recordNames[[pageSpan]];
    recordNamesInds = recordNamesInds[[pageSpan]];

    (* Tabular presentations of data views. *)
    TabView[
      {"Chernoff faces" -> Pane[
        Grid[Transpose@{
          {Magnify[#, 0.8] &@
              GridTableForm[
                Transpose[{Take[Keys[ChernoffFace["FacePartsProperties"]],
                  UpTo[Length[numCols]]], columnNames[[numCols]]}],
                TableHeadings -> {"Face feature", "Data column name"}],
            Row[{lowFace, neutralFace, highFace}],
            Row[{firstQuFace, medianFace, thirdQuFace}]},
          {Which[
            TrueQ[colorDataScheme == "None"],
            (* No face coloring *)
            Grid[ArrayReshape[
              MapThread[
                ChernoffFace[#1, PlotLabel -> Style[#2, Small], ImageSize -> faceImageSize] &,
                {rdata, recordNames}],
              {Ceiling[Length[rdata]/ncols], ncols}, ""],
              Alignment -> Center, Dividers -> All, FrameStyle -> GrayLevel[0.8]],
            colorMethod == "Label",
            (* Do face coloring by unique label values *)
            Grid[ArrayReshape[
              MapThread[(
                asc = AssociationThread[Take[Keys[ChernoffFace["FacePartsProperties"]], UpTo[Length[#1]]] -> #1];
                asc = Join[asc, <|"FaceColor" -> ColorData[colorDataScheme][#3]|>];

                ChernoffFace[asc, PlotLabel -> Style[#2, Small], ImageSize -> faceImageSize]
              ) &, {rdata, recordNames, recordNamesInds}],
              {Ceiling[Length[rdata]/ncols], ncols}, ""],
              Alignment -> Center, Dividers -> All, FrameStyle -> GrayLevel[0.8]],
            True,
            (* ELSE -- do face coloring by values*)
            Grid[ArrayReshape[
              MapThread[(
                ChernoffFaceAutoColored[#1, ColorData[colorDataScheme],
                  PlotLabel -> Style[#2, Small], ImageSize -> faceImageSize]
              ) &, {rdata, recordNames}],
              {Ceiling[Length[rdata]/ncols], ncols}, ""], Alignment -> Center,
              Dividers -> All, FrameStyle -> GrayLevel[0.8]]
          ], SpanFromAbove, SpanFromAbove}}, Alignment -> Top],
        ImageSize -> {wsize, hsize}, Scrollbars -> True],
        "Summary" -> Pane[
          Grid[{{"Dataset name", dname},
            {"Dimensions", Dimensions[data]},
            {"Summary:",
              Multicolumn[RecordsSummary[N@data, columnNames], 5,
                Appearance -> "Horizontal", Alignment -> Top, Dividers -> All,
                FrameStyle -> GrayLevel[0.8]]}
          }, Alignment -> Left, Dividers -> All, FrameStyle -> GrayLevel[0.8]], ImageSize -> {wsize, hsize}],
        "Data" -> Pane[
          GridTableForm[data[[pageSpan]],
            TableHeadings -> columnNames], ImageSize -> {wsize, hsize}, Scrollbars -> True],
        "Variable distributions" -> Pane[
          Grid[List /@
              MapThread[
                BoxWhiskerChart[Transpose[#1], PlotLabel -> #2,
                  ChartLabels ->
                    Placed[
                      MapIndexed[Grid[List /@ {Style[#2[[1]], Bold, Red, Larger]}] &, columnNames[[numCols]]
                      ], Above],
                  ChartStyle -> "SandyTerrain",
                  ChartLegends -> columnNames[[numCols]],
                  BarOrigin -> Bottom,
                  GridLines -> Automatic,
                  ImageSize -> Medium] &,
                {{data[[All, numCols]], rdata}, {"Original data", "Normalized data"}}
              ]
          ], ImageSize -> {wsize, hsize}, Scrollbars -> True]
      }]
  ],
  {{dname, {"Statistics", "FisherIris"}, "Dataset name:"}, ExampleData[ "Statistics"], ControlType -> PopupMenu},
  {{normalizationType, "MeanVar", "Data normalization type:"},
    {"MeanVar" -> "by mean & standard deivation", "MedianQuart" -> "by median & quartile deviation"}},
  {{colorDataScheme, "BrightBands", "Faces color scheme"},
    {"None", "BrightBands", "CoffeeTones",
     "IslandColors", "Rainbow", "RedBlueTones", "SouthwestColors",
     "StarryNightColors", "SunsetColors", "TemperatureMap", "WatermelonColors"}},
  {{colorMethod, "Value", "Face color:"}, {"Value" -> "by values", "Label" -> "by label"}},
  {{itemsPerPage, 50, "Faces per page:"}, {20, 50, 100, 200, 600}},
  {{page, 1, "Faces page:"},
    Dynamic[Range[1, Max[1, Ceiling[Length[ExampleData[dname]]/itemsPerPage]]],
      TrackedSymbols :> {dname, itemsPerPage}], ControlType -> PopupMenu}]