(*
    Statements saliency in podcasts Mathematica interactive interface
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

(* :Title: StatementsSaliencyInPodcastsInterface *)
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