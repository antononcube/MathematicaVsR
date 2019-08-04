(*
    Chernoff faces data browser Mathematica package

    Copyright (C) 2019  Anton Antonov

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

(* :Title: ChernoffFacesDataBrowser *)
(* :Context: ChernoffFacesDataBrowser` *)
(* :Author: Anton Antonov *)
(* :Date: 2019-08-03 *)

(* :Package Version: 1.0 *)
(* :Mathematica Version: 12.0 *)
(* :Copyright: (c) 2019 Anton Antonov *)
(* :Keywords: Chernoff faces, Multidimensional data visualization, Interactive interface *)
(* :Discussion:

    The code of this file is for the Mathematica part of the project:

      https://github.com/antononcube/MathematicaVsR/tree/master/Projects/BrowsingDataWithChernoffFaces .

    of the repository MathematicaVsR at GitHub:

      https://github.com/antononcube/MathematicaVsR .

    The function ChernoffFacesDataBrowser provided by this package is a "productized" version
    of the code in the file:

      https://github.com/antononcube/MathematicaVsR/blob/master/Projects/BrowsingDataWithChernoffFaces/Mathematica/DataBrowserWithChernoffFaces.m .

    Anton Antonov
    Windermere, FL, USA
    2019-08-03
*)


(* Created with Mathematica Plugin for IntelliJ IDEA *)

If[Length[DownValues[MathematicaForPredictionUtilities`GridTableForm]] == 0,
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m"]
];

If[Length[DownValues[ChernoffFace`ChernoffFace]] == 0,
  Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/ChernoffFaces.m"]
];

BeginPackage["ChernoffFacesDataBrowser`"];

ChernoffFacesDataBrowser::usage = "ChernoffFacesDataBrowser[ ds_Association, opts___ ] makes an interactive \
interface for browsing the datasets in the provided association using Chernoff face diagrams.";

Begin["`Private`"];

Needs["MathematicaForPredictionUtilities`"];
Needs["ChernoffFaces`"];

Clear[ChernoffFacesDataBrowser];

Options[ChernoffFacesDataBrowser] = { ImageSize -> {1000, 520}, "NumberOfColumns" -> 10, "FaceImageSize" -> 60 };

ChernoffFacesDataBrowser[ aDatasets : Association[ (_String -> _Dataset) .. ], opts:OptionsPattern[] ] :=
    (*    Block[{imageSize, numberOfColumns, faceImageSize,*)
    (*      data, rdata, numCols, recordNames, recordNamesInds, qvals, cfFunc},*)
    DynamicModule[{ imageSize, ncols, faceImageSize,
      columnNames, numCols, data, data2, rdata, recordNames, recordNamesInds, qvals,
      medianFace, neutralFace, lowFace, highFace, firstQuFace, thirdQuFace,
      offset, pageSpan, cfFunc},

      imageSize = OptionValue[ ChernoffFacesDataBrowser, ImageSize];
      ncols = OptionValue[ ChernoffFacesDataBrowser, "NumberOfColumns" ];
      faceImageSize = OptionValue[ ChernoffFacesDataBrowser, "FaceImageSize" ];

      Manipulate[

        (* Get data and make it matrix if it is not. *)
        columnNames = Keys[Normal[aDatasets[dname][[1]]]];
        data = Normal[aDatasets[dname][Values]];

        (* Find, separate, and standardize numerical variables. *)
        numCols = Pick[Range[1, Dimensions[data][[2]]], VectorQ[#, NumericQ] & /@ Transpose[data]];
        Which[
          normalizationType == "MeanVar" && !clipOutliers,
          rdata = VariablesRescale[N@data[[All, numCols]]],
          normalizationType == "MeanVar" && clipOutliers,
          rdata = VariablesRescale[N@data[[All, numCols]],
            "StandardizingFunction" -> (Standardize[#1, Mean, StandardDeviation] &),
            "RescaleRangeFunction" -> ({-3, 3} StandardDeviation[#] &)],
          normalizationType == "MedianQuartile" && !clipOutliers,
          rdata = VariablesRescale[N@data[[All, numCols]],
            "StandardizingFunction" -> (Standardize[#1, Median, QuartileDeviation] &)],
          normalizationType == "MedianQuartile" && clipOutliers,
          rdata = VariablesRescale[N@data[[All, numCols]],
            "StandardizingFunction" -> (Standardize[#1, Median, QuartileDeviation] &),
            "RescaleRangeFunction" -> ({-3, 3} QuartileDeviation[#] &)]
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
        If[(page - 1) * itemsPerPage + 1 > Length[data], page = 1];
        pageSpan = (page - 1) * itemsPerPage + 1 ;; Min[page * itemsPerPage, Length[data]];

        data2 = data[[All, numCols]][[ pageSpan ]];

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
                    Tooltip[
                      ChernoffFace[#1, PlotLabel -> Style[#2, Small], ImageSize -> faceImageSize],
                      GridTableForm[Transpose[{Take[Keys[ChernoffFacePartsParameters[]], UpTo[Length[#3]]], columnNames[[numCols]], #3}]]
                    ]&,
                    {rdata, recordNames, data2}],
                  {Ceiling[Length[rdata] / ncols], ncols}, ""],
                  Alignment -> Center, Dividers -> All, FrameStyle -> GrayLevel[0.8]],
                colorMethod == "Label",
                (* Do face coloring by unique label values *)
                Grid[ArrayReshape[
                  MapThread[(
                    asc = AssociationThread[Take[Keys[ChernoffFace["FacePartsProperties"]], UpTo[Length[#1]]] -> #1];
                    asc = Join[asc, <|"FaceColor" -> ColorData[colorDataScheme][#3]|>];

                    Tooltip[
                      ChernoffFace[asc, PlotLabel -> Style[#2, Small], ImageSize -> faceImageSize],
                      GridTableForm[Transpose[{Take[Keys[ChernoffFacePartsParameters[]], UpTo[Length[#4]]], columnNames[[numCols]], #4}]]
                    ]
                  ) &, {rdata, recordNames, recordNamesInds, data2}],
                  {Ceiling[Length[rdata] / ncols], ncols}, ""],
                  Alignment -> Center, Dividers -> All, FrameStyle -> GrayLevel[0.8]],
                True,
                (* ELSE -- do face coloring by values*)
                Grid[ArrayReshape[
                  MapThread[
                    Tooltip[
                      ChernoffFaceAutoColored[#1, ColorData[colorDataScheme],
                        PlotLabel -> Style[#2, Small], ImageSize -> faceImageSize],
                      GridTableForm[Transpose[{Take[Keys[ChernoffFacePartsParameters[]], UpTo[Length[#3]]], columnNames[[numCols]], #3}]]
                    ]&, {rdata, recordNames, data2}],
                  {Ceiling[Length[rdata] / ncols], ncols}, ""], Alignment -> Center,
                  Dividers -> All, FrameStyle -> GrayLevel[0.8]]
              ], SpanFromAbove, SpanFromAbove}}, Alignment -> Top],
            ImageSize -> imageSize, Scrollbars -> True],
            "Summary" -> Pane[
              Grid[{{"Dataset name", dname},
                {"Dimensions", Dimensions[data]},
                {"Summary",
                  Multicolumn[RecordsSummary[N@data, columnNames], 5,
                    Appearance -> "Horizontal", Alignment -> Top, Dividers -> All,
                    FrameStyle -> GrayLevel[0.8]]}
              }, Alignment -> Left, Dividers -> All, FrameStyle -> GrayLevel[0.8]], ImageSize -> imageSize],
            "Data" -> Pane[
              GridTableForm[data[[pageSpan]],
                TableHeadings -> columnNames], ImageSize -> imageSize, Scrollbars -> True],
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
              ], ImageSize -> imageSize, Scrollbars -> True]
          }],
        {{dname, Keys[aDatasets][[1]], "Dataset name:"}, Keys[aDatasets], ControlType -> PopupMenu},
        {{normalizationType, "MeanVar", "Data normalization type:"},
          {"MeanVar" -> "by mean & standard deivation", "MedianQuartile" -> "by median & quartile deviation"}},
        {{clipOutliers, False, "Clip outliers:"}, {False, True}},
        {{colorDataScheme, "BrightBands", "Faces color scheme"},
          {"None", "BrightBands", "CoffeeTones",
            "IslandColors", "Rainbow", "RedBlueTones", "SouthwestColors",
            "StarryNightColors", "SunsetColors", "TemperatureMap", "WatermelonColors"}},
        {{colorMethod, "Value", "Face color:"}, {"Value" -> "by values", "Label" -> "by label"}},
        {{itemsPerPage, 50, "Faces per page:"}, {20, 50, 100, 200, 600}},
        {{page, 1, "Faces page:"},
          Dynamic[Range[1, Max[1, Ceiling[Length[aDatasets[dname]] / itemsPerPage]]],
            TrackedSymbols :> {dname, itemsPerPage}], ControlType -> PopupMenu}]
    ];


End[]; (*`Private`*)

EndPackage[]