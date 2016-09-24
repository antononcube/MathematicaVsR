(*
    Statements saliency in podcasts Mathematica script
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
    antononcube @ gmail . com ,
    Windermere, Florida, USA.
*)

(* :Title: StatementsSaliencyInPodcastsScript *)
(* :Context: Global` *)
(* :Author: Anton Antonov *)
(* :Date: 2016-09-24 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2016 Anton Antonov *)
(* :Keywords: *)
(* :Discussion:

    This Mathematica script is part of the project

      "Statements saliency in podcasts",
      https://github.com/antononcube/MathematicaVsR/tree/master/Projects/StatementsSaliencyInPodcasts

    at

      MathematicaVsR at GitHub,
      https://github.com/antononcube/MathematicaVsR .


    This file was created by Mathematica Plugin for IntelliJ IDEA

    Anton Antonov
    September, 2016
*)


(*===========================================================*)
(* Libraries and code                                        *)
(*===========================================================*)

Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/DocumentTermMatrixConstruction.m"]

(*===========================================================*)
(* Scraping data from the selected source                    *)
(*===========================================================*)

(*-------------------------------------------------------*)
(* Download links                                        *)
(*-------------------------------------------------------*)
Clear[GetTranscriptLinksForPage]
GetTranscriptLinksForPage[i_Integer] :=
    Block[{url, links},
      If[i == 1,
        url = "http://www.freakonomics.com/category/podcast-transcripts/",
        url = "http://www.freakonomics.com/category/podcast-transcripts/page/" <> ToString[i] <> "/"
      ];
      links = Import[url, "Hyperlinks"];
      Union[Select[links, StringMatchQ[#, ___ ~~ "full-transcript/"] &]]
    ];

If[ !MatchQ[ allLinks, {_String..} ],
  Print["Download links..."];
  Print["\t\t...DONE, download time :", AbsoluteTiming[
    allLinks = Join @@ Table[GetTranscriptLinksForPage[i], {i, 1, 17}];
  ] ],

(*ELSE*)
  Print["Using already loaded links."]
];

Print["Length[allLinks] = ", Length[allLinks] ];

(*-------------------------------------------------------*)
(* Full transcripts texts                                *)
(*-------------------------------------------------------*)

If[ !MatchQ[ freakonomicsTexts, {_String..} ],

  Print["Import pages ..."]
  Print["\t\t...DONE, download time :", AbsoluteTiming[
    freakonomicsTexts = Map[Import[#, "Plaintext"] &, allLinks];
  ]],

(*ELSE*)
  Print["Using already loaded pages."]
];


(*-------------------------------------------------------*)
(* Getting the titles from the transcripts               *)
(*-------------------------------------------------------*)

(* This code downloads the titiles. It is better to extract them, though. *)
(*Print["Get page titles ..."]*)
(*Print["\t\t...DONE, download time :", AbsoluteTiming[*)
(*titles = Map[Import[#, "Title"] &, allLinks];*)
(*]];*)

t =
    Map[
      StringCases[#,(StartOfLine~~(t:__)~~" Full Transcript"~~___~~EndOfLine):>StringTrim[t]]&,
      StringSplit[#,"\n"]& /@ freakonomicsTexts,{2}];
titles = Map[Select[#,Length[#]>0&][[1,1]]&, t]

titles =
    StringTrim[
      StringReplace[#,
        "Full Transcript - Freakonomics Freakonomics" -> ""]] & /@ titles;

(* Histogram[StringLength /@ freakonomicsTexts, PlotRange -> All] *)

Print["Verification of lengths, Length[allLinks] == Length[freakonomicsTexts] == Length[titles] :"]
Print[Length[allLinks] == Length[freakonomicsTexts] == Length[titles] ]


(*===========================================================*)
(* Simple parsing of transcripts                             *)
(*===========================================================*)

Clear[TranscriptStatements]
Options[TranscriptStatements] = {"RemoveSpeakerNames" -> True};
TranscriptStatements[text_, opts : OptionsPattern[]] :=
    Block[{tlines,
      removeSpeakerNamesQ = OptionValue["RemoveSpeakerNames"]},
      tlines = StringSplit[text, "\n"];
      tlines = Select[tlines, ! StringMatchQ[#, "[" ~~ ___] &];
      If[removeSpeakerNamesQ,
        tlines =
            Map[StringCases[#,
              StartOfString ~~ ((WordCharacter ..) ~~
                  Whitespace ~~ (CharacterRange["A", "Z"] ..)) | (CharacterRange["A", "Z"] ..) ~~ ":" ~~
                  x___ :> x] &, tlines];
        tlines = Select[tlines, Length[#] > 0 &][[All, 1]],
      (*ELSE*)
        tlines =
            Select[tlines,
              StringMatchQ[#,
                StartOfString ~~ ((WordCharacter ..) ~~
                    Whitespace ~~ (CharacterRange["A", "Z"] ..)) | (CharacterRange["A", "Z"] ..) ~~ ":" ~~
                    x___] &]
      ];
      StringTrim /@ tlines
    ];

Clear[TranscriptSentences]
TranscriptSentences[text_] := TextSentences[text];
TranscriptSentences[statements : {_String ..}] := Flatten[TextSentences /@ statements];

(*-------------------------------------------------------*)
(* Tests                                                 *)
(*-------------------------------------------------------*)

ind = 11;
statements =
    TranscriptStatements[freakonomicsTexts[[ind]],
      "RemoveSpeakerNames" -> False];

Print["Example of parsed statements for title: \"", titles[[ind]], "\""];
Print[ColumnForm[RandomSample[#, 12] &@statements]];


(*===========================================================*)
(* Stop words                                                *)
(*===========================================================*)

If[ !MatchQ[ stopWords, {_String..} ],

  stopWords =
      ReadList["http://www.textfixer.com/resources/common-english-words.txt", "String"];
  stopWords = StringSplit[stopWords, ","][[1]],

  (*ELSE*)
  Print["Using already loaded stop words."]
];

(*===========================================================*)
(* MostImportantSentences                                    *)
(*===========================================================*)


Clear[MostImportantSentences]

Options[MostImportantSentences] = {"Granularity" -> "Statements",
  "RemoveSpeakerNames" -> True, "StopWords" -> None,
  "GlobalTermWeightFunction" -> "IDF",
  "SplittingCharacters" -> {Whitespace, " ", ".", ",", "!", "?", ":",
    ";", "-", "\"", "\\'", "(", ")", "\[OpenCurlyDoubleQuote]", "`",
    "\[Ellipsis]", " "},
  "PostSplittingPredicate" -> (StringLength[#] > 0 &)};

MostImportantSentences[transcript_String, nSentences_: 5, opts : OptionsPattern[]] :=
    Block[{stopWords, gwFunc, statements, dtmOpts, epMat, epTerms,
      wepMat, wepSMat, vals, U, svec, inds},

      stopWords = OptionValue["StopWords"];
      gwFunc = OptionValue["GlobalTermWeightFunction"];

      statements =
          TranscriptStatements[transcript,
            "RemoveSpeakerNames" -> OptionValue["RemoveSpeakerNames"]];

      If[TrueQ[OptionValue["Granularity"] == "Sentences"],
        statements = TranscriptSentences[statements];
      ];

      dtmOpts = {
        "SplittingCharacters" -> OptionValue["SplittingCharacters"],
        "PostSplittingPredicate" -> OptionValue["PostSplittingPredicate"]};

      Which[
        MatchQ[stopWords, {_String ..}],
        {epMat, epTerms} =
            DocumentTermMatrix[statements, {{}, stopWords}, dtmOpts],
        True,
        {epMat, epTerms} =
            DocumentTermMatrix[statements, {{}, {}}, dtmOpts]
      ];

      wepMat =
          WeightTerms[epMat, GlobalTermWeight[gwFunc, #1, #2] &, # &, If[Norm[#] > 0, #/Norm[#], #] &];

      U = SingularValueDecomposition[wepMat, 3][[1]];

      svec = U[[All, 1]];
      inds = Reverse@Ordering[Abs[svec], -nSentences];
      Transpose[{Abs[svec[[inds]]], statements[[inds]]}]
    ];


(*===========================================================*)
(* Examples                                                  *)
(*===========================================================*)

res = MostImportantSentences[freakonomicsTexts[[96]], 5, "StopWords" -> stopWords];
Grid[res, Dividers -> All, Alignment -> Left]