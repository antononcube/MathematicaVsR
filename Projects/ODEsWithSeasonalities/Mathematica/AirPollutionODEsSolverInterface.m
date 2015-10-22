(* Air Pollution ODE Solver Interface Mathematica Package *)

(* :Title: AirPollutionODEsSolverInterface *)
(* :Context: AirPollutionODEsSolverInterface` *)
(* :Author: Anton Antonov *)
(* :Date: 2015-10-22 *)

(* :Package Version: 0.1 *)
(* :Mathematica Version: *)
(* :Copyright: (c) 2015 Anton Antonov *)
(* :Keywords: air pollution, ODE, interface *)
(* :Discussion:

 For the background on this numerical simulation interface see the discussion

   "ODE w/seasonal forcing term",

   http://mathematica.stackexchange.com/questions/95015/ode-w-seasonal-forcing-term/

 This file was created with Mathematica Plugin for IntelliJ IDEA.

 Anton Antonov
*)

V = 28*10^6;
Manipulate[
  DynamicModule[{fsols, c, F, Cin},
    F[t_] := 10^6 (1 + 6*Sin[2 \[Pi] t]);
    Cin[t_] := 10^6*(10 + 10*Cos[2 \[Pi] t]);
    fsols =
        Table[Block[{sol},
          F[t_] := 10^6*(1 + 6.0*Sin[2 \[Pi] t]);
          Cin[t_] := 10^6 (10 + 10*Cos[2 \[Pi] t]);
          sol =
              NDSolve[{c'[t] == m*F[t]/V (Cin[t] - c[t]), c[0] == k*10^7.},
                c[t], {t, 0, tEnd}, Method -> Automatic];
          c[t] /. sol[[1]]
        ], {k, kMin, kMax, 0.05}];
    Plot[fsols/10^6, {t, 0, tEnd}, PlotRange -> {All, All}, AspectRatio -> 1/2]
  ],
  {{m, 6, "RHS factor"}, 0., 15, 0.5},
  {{kMin, 0, "min initial condition factor"}, 0, 2, 0.01},
  {{kMax, 0.6, "max initial condition factor"}, 0, 2, 0.01},
  {{tEnd, 8, "time interval (years)"}, 1, 20, 0.5}]