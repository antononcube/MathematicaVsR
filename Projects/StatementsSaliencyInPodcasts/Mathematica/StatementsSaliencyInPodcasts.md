<!---
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

--->
<!---
    This Mathematica Markdown file is part of the project

      "Statements saliency in podcasts",
      https://github.com/antononcube/MathematicaVsR/tree/master/Projects/StatementsSaliencyInPodcasts

    at

      MathematicaVsR at GitHub,
      https://github.com/antononcube/MathematicaVsR .

    Anton Antonov
    September, 2016
--->


Libraries and code needed:                                       

    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/DocumentTermMatrixConstruction.m"]

## Introduction

This *Mathematica* Markdown file is part of the project [StatementsSaliencyInPodcasts](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/StatementsSaliencyInPodcasts/).

This *Mathematica*-part of the project has two goals:

1. to experiment (in *Mathematica*) with algebraic computations determination of the most important sentences in natural language texts, and

2. to compare the programming code of the developed functionalities with a similar project in R.

In order to make those experiments we have to find, choose, and download suitable text data. This document gives a walk through with code of the complete sequence of steps from intent to experimental results. 

The following concrete steps are taken.

1. Data selection of a source that provides high quality texts. (E.g. English grammar, spelling, etc.)

2. Download or scraping of the text data.

3. Text data parsing, cleaning, and other pre-processing.

4. Mapping of a selected document into linear vector space using the Bag-of-words model.

5. Finding sentence/statement saliency using matrix algebra.

6. Experimenting with the saliency algorithm over the data and making a suitable interactive interface. 


## Data source selection (Freakonomics podcasts transcripts)

We want to select a text data source from which we can easily obtain documents, the documents are easier pre-process, and -- most importantly -- with interesting content since we want to validate our summarization techniques and for that some fraction of the documents has to be read in full.

One such source is the archive of Freakonomics podcast transcripts available at [http://freakonomics.com/](http://freakonomics.com/).

( After the publication of the book "Freakonomics" its authors Levitt and Dubner wrote another books "SuperFreakonomics" and started a radio show. See [http://freakonomics.com/about/](http://freakonomics.com/about/) for more details. )

## Getting the data 

First we are going to find the links to the podcast transcripts and then download each transcript.
For both sub-tasks we are going to use the package [rvest](https://github.com/hadley/rvest) written by [Hadley Wickham](https://en.wikipedia.org/wiki/Hadley_Wickham).

### Podcast transcripts links

The code below goes through set of pages and extracts the hyperlinks that finish with the string "full-transcript/".

### Download links           

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

### Get podcast transcripts

The following code goes through each podcast link and downloads its content.

    If[ !MatchQ[ freakonomicsTexts, {_String..} ],
    
      Print["Import pages ..."]
      Print["\t\t...DONE, download time :", AbsoluteTiming[
        freakonomicsTexts = Map[Import[#, "Plaintext"] &, allLinks];
      ]],

    (*ELSE*)
      Print["Using already loaded pages."]
    ];

## Getting the titles from the transcripts

We can download the titles:

    (* This code downloads the titiles. It is better to extract them, though. *)
    (*Print["Get page titles ..."]*)
    (*Print["\t\t...DONE, download time :", AbsoluteTiming[*)
    (*titles = Map[Import[#, "Title"] &, allLinks];*)
    (*]];*)

Or we can obtain the titles from the downloaded pages:

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


##  Simple parsing of transcripts    

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


### Tests

    ind = 11;
    statements =
       TranscriptStatements[freakonomicsTexts[[ind]], "RemoveSpeakerNames" -> False];

    Print["Example of parsed statements for title: \"", titles[[ind]], "\""];
    Print[ColumnForm[RandomSample[#, 12] &@statements]];


##  Stop words

In order to get better result we have to remove the [stop words](https://en.wikipedia.org/wiki/Stop_words) [4] from the texts.
The following command downloads is a list stop words referenced in the Wikipedia entry "Stop words."

    If[ !MatchQ[ stopWords, {_String..} ],
    
      stopWords =
          ReadList["http://www.textfixer.com/resources/common-english-words.txt", "String"];
      stopWords = StringSplit[stopWords, ","][[1]],
    
      (*ELSE*)
      Print["Using already loaded stop words."]
    ];


## Function finding most important sentences

This function finds the most important sentences in a transcript.

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
              TranscriptStatements[transcript, "RemoveSpeakerNames" -> OptionValue["RemoveSpeakerNames"]];

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


## Examples

    res = MostImportantSentences[freakonomicsTexts[[96]], 5, "StopWords" -> stopWords];
    Grid[res, Dividers -> All, Alignment -> Left]


### Interactive interface

Running the file ["StatementsSaliencyInPodcastsInterface.m"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/StatementsSaliencyInPodcasts/Mathematica/StatementsSaliencyInPodcastsInterface.m) would produce a dynamic interactive interface that allows to see effects of different parameter combinations.

## References

[1] Anton Antonov, [MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR).

[2] Anton Antonov, ["Implementation of document-term matrix re-weighting functions in Mathematica"](https://github.com/antononcube/MathematicaForPrediction/blob/master/DocumentTermMatrixConstruction.m) (2014) at [MathematicaForPrediction project at GitHub](https://github.com/antononcube/MathematicaForPrediction).

[3] Wikipedia entry, [Bag-of-words model](https://en.wikipedia.org/wiki/Bag-of-words_model).

[4] Wikipedia entry, [Stop words](https://en.wikipedia.org/wiki/Stop_words).

[5] Lars Elden, Matrix Methods in Data Mining and Pattern Recognition, 2007, SIAM. 
See Chapter 13, "Automatic Key Word and Key Sentence Extraction". 

