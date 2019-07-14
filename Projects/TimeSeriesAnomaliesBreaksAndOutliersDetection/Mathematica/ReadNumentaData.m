(* Mathematica Source File *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)
(* :Author: Anton Antonov *)
(* :Date: 2019-07-14 *)

(* Use proper directory name of the Numenta data like this one: *)
(* dataDirName = "~/GitHub/numenta/NAB/data";*)


ReadNumentaData[ dataDirName_String ] :=
    Block[{fullDirNames, dsDataFileNames, lsNumentaData},


      (* Read the data sub-directories. *)
      (* Drop README.md . *)

      fullDirNames = FileNames[All, dataDirName];
      fullDirNames =
          Complement[fullDirNames,
            Flatten@StringCases[fullDirNames, ___ ~~ "README" ~~ __]];

      (* Make a Dataset showing which file names is at which directory. *)

      dsDataFileNames =
          Dataset@
              Flatten@
                  Map[
                    Function[{dname},
                      fnames = FileNames[All, dname];
                      Map[<|"Directory" -> FileNameSplit[dname][[-1]],
                        "FileName" -> FileNameSplit[#][[-1]],
                        "FullFileName" -> #|> &, fnames]
                    ],
                    fullDirNames];

      (*Read the CSV files.*)

      Print @ AbsoluteTiming[
        lsNumentaData =
            Association[
              MapThread[{#1, #2} -> Import[#3] &,
                Transpose[Normal[dsDataFileNames[All, Values]]]]];
      ];


      (*Verify we have the same headers for all CSV files.*)

      Print @ Tally[Map[First, Values[lsNumentaData]]];


      (* Drop the headers. *)

      lsNumentaData = Rest /@ lsNumentaData;

      (*Convert all time-stamps to seconds.*)

      Print @ AbsoluteTiming[
        lsNumentaData =
            Map[Transpose[{Map[
              AbsoluteTime[{#, {"Year", "-", "Month", "-", "Day", " ", "Hour", ":",
                "Minute", ":", "Second"}}] &, #[[All, 1]]], #[[All, 2]]}] &,
              lsNumentaData];
      ];


      (*Convert to time series.*)

      Print @AbsoluteTiming[
        lsNumentaData = TimeSeries /@ lsNumentaData;
      ];

      <| "DataFileNames"->dsDataFileNames, "TimeSeries" -> lsNumentaData |>
    ];
