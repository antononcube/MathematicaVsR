(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: StatementsSaliencyInPodcastsInterface *)
(* :Context: StatementsSaliencyInPodcastsInterface` *)
(* :Author: antonov *)
(* :Date: 2016-09-24 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2016 antonov *)
(* :Keywords: *)
(* :Discussion:

   In order to run this dinamic interface run the following command:

    Get["https://github.com/antononcube/MathematicaVsR/blob/master/Projects/StatementsSaliencyInPodcasts/Mathematica/\
StatementsSaliencyInPodcastsScript.m"]

*)


Manipulate[
  DynamicModule[{res},
    res = MostImportantSentences[freakonomicsTexts[[pind]], nStatements,
      "Granularity" -> gr, "RemoveSpeakerNames" -> rmn,
      "StopWords" -> sw];
    Pane[Grid[res, Dividers -> All, Alignment -> Left],
      Scrollbars -> {True, True}, ImageSize -> {1000, 600}]
  ],
  {{pind, 1, "Podcast title:"},
    Thread[Range[Length[titles]] -> MapThread[StringJoin, {ToString[#]<>" "&/@Range[Length[titles]], titles}]]},
  {{nStatements, 5, "Number of statements:"}, 1, 20, 1},
  {{gr, "Statements", "Granularity:"}, {"Statements", "Sentences"}},
  {{sw, stopWords, "Stop words:"}, {None -> "None", stopWords -> "Standard"}},
  {{rmn, False, "Remove speaker names:"}, {True, False}}]