# **Progressive jackpot modeling**

#### Anton Antonov   
#### [MathematicaForPrediction project at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
#### [MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR)  
#### October 2016

# Introduction

This document was made for the purposes of two projects:

1. the [MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR), \[[2](https://github.com/antononcube/MathematicaVsR)\], and 

2. the Wolfram Technology Conference 2016 presentation "Exemplifying the cultural differences between Statistics and Machine learning", \[[3](https://www.wolfram.com/events/technology-conference/2016/)\].

The document presents two perspectives of modeling a progressive jackpot problem:

-- the first based on a "neat math", statistical perspective,

-- the second based on simulation that comes from a operations research or machine learning perspective.

The formulation of the progressive jackpot problem is taken from \[1\]. Its modification being described and then the two solutions are shown.

The simulation solution of the modification of the original problem shows that using simulations instead of "neat math" we can address a wider set of operational goals and procedures and its easier to communicate their paths of achievement, effects, or evolution.

More concretely, the nice thing about the simulation approach is that it is easy to incorporate changes of the progressive jackpot process, like, inclusion of a withheld jump-starting jackpot, word-of-mouth modeling, dependence of the number of bets and/or its [heteroscedasticity](https://en.wikipedia.org/wiki/Heteroscedasticity) with respect to the accumulated jackpot value, etc.

# Problem formulation

## Original formulation

Here is  the game definition quoted from \[1\] :

The game is structured as follows. The value of the jackpot following the $n$-th hand is denoted by $J_{n}$. We refer to each play as a hand and a sequence of hands terminating in the jackpot being won is referred to as a game. Such games start with an initial amount of money in the jackpot provided by the casino which we denote by $J_{0}$. Setting the value of $J_{0}$ is one of the key decisions that the casino operators must make for the game. Hands are then played sequentially. Each player pays \$ $1$ to play, of which the casino takes $h$ and the remaining \$ $(1-h)$ is added to the jackpot. The casino can set the value of $h$ but the regulator bounds it between 0 and 0.3. A random mechanism then determines the winnings to the player, which comprise a) nothing, b) a fixed amount, or c) a proportion of the jackpot, which may include winning the entire jackpot. The probabilities associated with the prizes do not change throughout the game, but can be determined by the casino at the beginning. The winnings are removed from the jackpot and if the value of the jackpot is greater than 0, then the game continues.

(The symbols "$F$" and "£" in the original were replaced with "$J$" and "\$".) 

## Making it more concrete

You are required to design a new slot or lottery game with a progressive jackpot.

-- The start value is \$ 30000.

-- The contribution from each bet (player hand) is 10%. Assume all bets are \$ 1.

-- The expected value of the jackpot is planned to be \$ 1000000. 

## Questions

1. What does the total bet amount per month need to be in order for the jackpot to be won on average two times per year?

2. What is the probability that the jackpot will fall out before it reaches \$ 500000?

3. If you use 5% of the contribution (i.e. 0.5% of the bet) for a "withheld pot", that will be used to jump-start the game if the jackpot has been won. How does this withheld jackpot mechanism affect the answers to question 1 and 2 ?

4. What could be done in order to make the probability of a jackpot fall out while less than \$ 500000 to be smaller than 5%.

5. What is the jackpot distribution and where is the expected (the average) jackpot value in it? 

Below we answer most of the questions. (All except 5.)

# Notation

$J_{0}$ -- initial jackpot.

$p$ -- probability to win the jackpot with each \$ 1-bet.

$I_{i}$ -- random variable indicating whether the jackpot is won with the $i$-th \$ 1-bet.

$h$ -- is the fraction contributed to the jackpot from a bet (given to be %10).

$J_{i}$ -- the amount of the jackpot at the $i$-th \$ 1-bet.

# Initial, "neat math" model

In this section we loosely follow \[1\]. (The exposition, though, is self-contained.)

For the random variable $I_{n}$ we have 

$$ Pr(I_{n}=1)=p . $$

The expected value of the jackpot is

$$ E[J_{i}] $$

The probability that the jackpot is ***not*** won by the $n$-th \$ 1-bet is

$$ (1-p)^{n} $$

The probability to win the jackpot with the $(n+1)$-st \$ 1-bet for a first time is

$$ (1-p)^{n} p $$

We can also write that 

$$ Pr ( \sum_{k=1}^{n}I_{k}>0 )=1-(1-p)^{n} $$

In general we can model the probability to have $k$ jackpot wins after $n$ number of \$ 1-bets using the Binomial distribution:

$$ P(p, n, k)= {n \choose k} p^{k}(1-p)^{k} $$

or the Geometric distribution for the sum of variables each representing a sequence of failures followed by one success. (We can attempt to further investigate both.)

For the value of $J_{i}$ we have the recursive formula:

$$ J_{i}=(1-I_{i})(J_{i-1}+h)+I_{i}(0) $$

It is a good idea to obtain closed form formula for the expectation $E[J_{i}]$ of $J_{i}$. One of the approaches to do that is to look into the partitions of $n$ into a sum of integers and find out the average size of the terms. In a similar fashion, we can think of estimating the expectation of $E[J_{i}]$ in terms of $E[J_{i-1}]$. E.g. working with the equation

$$ E[J_{i}]=E[)1-I_{i})(J_{i-1}+h)+I_{i}(0)] $$

Using the Geometric distribution for the probability to win the jackpot for a first time with a \$ 1-bet and the law of total probability we can derive the expectation of the jackpot value the winning bet.

$$ E[J_{n_{win}}]= \sum_{i=1}^{\infty}(1-p)^{i-1}p(J_{0}+i h)= \frac{h}{p}+J_{0} $$

where the term $i h$ is the jackpot value at the $i$-th bet, and the sums $ \sum_{i=1}^{\infty}(1-p)^{i-1}p $ and $ \sum_{i=1}^{\infty}(1-p)^{i-1}pi $ were computed with:

    Sum[(1 - p)^(i - 1) p , {i, 1, \[Infinity]}]

    (* 1 *)

    Sum[(1 - p)^(i - 1) p i, {i, 1, \[Infinity]}]

    (* 1/p *)

From $E[J_{n_{win}}]$ we can estimate $p$ since we know the initial jackpot $J_{0}=3 \times 10^{4}$, the jackpot expectation is expected to be \$ $10^{6}$, and the contribution to the jackpot from a \$ 1-bet is $h=0.1$ .

    Block[{J0 = 3 10^4, h = 0.1}, psol = Solve[h/p + J0 == 10^6, p][[1]]]

    (* {p -> 1.03093*10^-7} *)

Using the found probability $p \approx 1.0 \times 10^{-7}$ we can estimate the number of \$ 1-bets per day in order to get 2 wins per year:

    nDaySol = Solve[365*n*(p /. psol) == 2, n][[1]]

    (* {n -> 53150.7} *)

Further we can derive the monthly total bet amount estimate:

    (n /. nDaySol)*30.5

    (* 1.6211*10^6 *)

(Of course, we can use a more sophisticated estimation of the number of times the jackpot is won, e.g. Negative Binomial distribution.)

***We are going to abandon this "neat math" approach in favor of a different one based on stochastic processes simulation. The stochastic simulation approach is more useful if the model has to be expanded in order to incorporate different features and sub-processes.***

(This is further discussed below.)

# Modeling with Poisson processes

Instead of deriving closed form for the jackpot expectation from equations (7) and (8) we can use a different model that is not based on a grid of bets but on a grid of days. This can be seen as a more natural perspective because of the way the questions (problems) are formulated. 

Since the expectations are for the jackpot to be won rarely (twice a year) we can use Poisson process for the number of days (or hours, or seconds) in which the jackpot is won:

$$ P(p)=\frac{e^{-t\lambda}(t \lambda)^{t}}{t!} , $$

and we want that the expectation of that process to be 2 in a time interval of 365 days (or the corresponding numbers for hours and seconds):

$$ E[\frac{e^{-t\lambda}(t \lambda)^{t}}{t!}]= \lambda t = \frac{2}{365}t . $$

(I.e. $ \lambda =2/365 $ .)

From this point we can proceed to find the bet amount per month by parameter search with a function based on multiple Poison processes.

Note that taking this perspective we do not need to have to explicitly find the probability for a bet to win the jackpot. We can set-up some sort of a brute force stochastic process simulation that finds the required amount per month for the jackpot to be \$ 1000000 on average (or have that expected value). The nice thing about this approach is that it is easy to incorporate changes of the progressive jackpot process, like, inclusion of a withheld jackpot, word-of-mouth modeling, dependence of the number of bets and/or its [heteroscedasticity](https://en.wikipedia.org/wiki/Heteroscedasticity) with respect to the accumulated jackpot value, etc.

# Parameter finding by simulation

## Jackpot increment per day/month

### Poisson processes sample

Here we produce several collections of processes that simulate the winnings of the jackpot within a given time interval (and a time grid). The time interval is one year and the conceptual grid we have in mind is days, but these can be easily changed to different length and granularity. (Note that `PoissonProcess` is producing continuous time points of the wins.)

    jackpotWinsProcesses20 = RandomFunction[PoissonProcess[2/365], {0, 365}, 20];
    jackpotWinsProcesses100 = RandomFunction[PoissonProcess[2/365], {0, 365}, 100];
    jackpotWinsProcesses1000 = RandomFunction[PoissonProcess[2/365], {0, 365}, 1000];
    jackpotWinsProcesses = RandomFunction[PoissonProcess[2/365], {0, 365}, 10000];

    Column[Map[
      Function[{jackpotWinsProcesses},(*the number of wins at the end of the time interval*)
       sd = jackpotWinsProcesses["SliceData", 365];
       sdt = SortBy[Tally[sd], First]; 
       GraphicsGrid[{{ListLinePlot[jackpotWinsProcesses, PlotRange -> All, BaseStyle -> Thin], BarChart[sdt[[All, 2]]/Total[sdt[[All, 2]]], ChartLabels -> sdt[[All, 1]], BarOrigin -> Left]}}, 
        PlotLabel -> Row[{"Mean: ", Mean[N@sd], "\nfor ", Length[jackpotWinsProcesses["Paths"]], " Poisson processes"}], ImageSize -> 600]
      ], {jackpotWinsProcesses20, jackpotWinsProcesses100, jackpotWinsProcesses1000, jackpotWinsProcesses}]]

[![LowPoissons][1]][1]

[![HighPoissons][2]][2]

### Jackpot amount expectation estimation from a Poisson processes sample

Because the jackpot "expected value is planned to be \$ 1000000" we have to decide how to evaluate it over the collection of processes. Is the expectation estimated over a year of at any given time interval (e.g. two weeks)? Do we look at each process separately or at all processes?

The jackpot amount estimation is computed by using moving average over a specified number of points in the time grid (e.g. 60 days). If we use 365 days then the moving average becomes the mean, i.e. a statistic corresponding to the jackpot expectation.

We are simulating uniform distribution of the jackpot increment over the time grid, but it is not hard to implement distributions that change with respect to the accumulated jackpot (e.g. the larger the jackpot the more it is incremented) and/or utilize some sort of word-of-mouth model. These simulation models can incorporate correlations found with data mining over (i) past progressive jackpot evolutions, (ii) related marketing campaigns, or (iii) and social media discussions of similar phenomena.

Note that the function below also has an argument for the fraction of the withheld pot increment that would become a new jackpot value when the accumulated jackpot is won.

    Clear[JackpotEstimation]
    JackpotEstimation[winProcesses_TemporalData, nAveragingPoints_Integer, jackpotIncrementPerPoint_?NumberQ, initialJackpot_?NumberQ, withheldPotFraction_: 0] :=
      Block[{tstart, tend, jackpotSeries, jackpotWinPoints, mas},
       {tstart, tend} = Floor[winProcesses["Times"][[{1, -1}]]];
       jackpotSeries =
        Map[Function[{ts},
          jackpotWinPoints = Ceiling[ts[[2 ;; -2, 1]]];
          FoldList[
            If[MemberQ[jackpotWinPoints, #2], 
              (* the jackpot is won *)
              {#1[[2]], 0},
              (* ELSE *)
              #1 + jackpotIncrementPerPoint {(1 - withheldPotFraction), withheldPotFraction}] &,
            {initialJackpot, 0},
            Range[tstart, tend]][[All, 1]]
         ],
         winProcesses["Paths"]
        ];
       mas = N@Map[MovingAverage[#, nAveragingPoints] &, jackpotSeries];
       Association[{Mean -> (Mean /@ mas), Median -> (Median /@ mas), StandardDeviation -> (StandardDeviation /@ mas)}]
      ];

Example run without withheld jackpot using moving average every 60 days:

    jpEst = JackpotEstimation[jackpotWinsProcesses20, 60, 10000, 30000]

    (* <|Mean -> {1.2954*10^6, 989069., 1.86*10^6, 983893., 1.85586*10^6, 857565., 1.1752*10^6, 1.07463*10^6, 972297., 1.86*10^6, 1.14807*10^6, 578929., 930958., 680958., 992273., 1.86*10^6, 942392., 1.50758*10^6, 1.10061*10^6, 716385.}, 
    Median -> {1.27*10^6, 949500., 1.86*10^6, 950000., 1.86*10^6, 600000., 1.18*10^6, 850000., 887500., 1.86*10^6, 1.13*10^6, 527583., 885000., 635000., 930000., 1.86*10^6, 750000., 1.51*10^6, 1.02*10^6, 524000.}, 
    StandardDeviation -> {658738., 621852., 890562., 619754., 884066., 605207., 681933., 637970., 562952., 890562., 656390., 322152., 413029., 316604., 588028., 890562., 665348., 716053., 783562., 370346.}|> *)

Example run with withheld pot accumulation using moving average of 365 days:

    jpEst = JackpotEstimation[jackpotWinsProcesses20, 365, 10000, 30000, 0.05]

    (* <|Mean -> {1.1362*10^6, 861447., 1.7685*10^6, 867686., 1.72358*10^6, 892190., 1.03818*10^6, 1.0985*10^6, 829478., 1.7685*10^6, 986496., 520829., 954733., 678148., 898111., 1.7685*10^6, 972996., 1.27551*10^6, 1.10227*10^6, 649305.}, 
    Median -> {1.1362*10^6, 861447., 1.7685*10^6, 867686., 1.72358*10^6, 892190., 1.03818*10^6, 1.0985*10^6, 829478., 1.7685*10^6, 986496., 520829., 954733., 678148., 898111., 1.7685*10^6, 972996., 1.27551*10^6, 1.10227*10^6, 649305.}, 
    StandardDeviation -> {89.0411, 72.6027, 9500., 2016.44, 515.068, 6286.3, 1168.49, 7000., 1268.49, 9500., 1368.49, 1439.73, 5767.12, 3605.48, 2378.08, 9500., 6698.63, 126.027, 7330.14, 546.575}|> *)

These commands calculate the mean of the jackpot evolution means, medians, and standard deviations.

    Mean@jpEst[Mean]
    Mean@jpEst[Median]
    Mean@jpEst[StandardDeviation]

    (* 1.08956*10^6 *)

    (* 1.08956*10^6 *)

    (* 3808.84 *)

It is a good idea to verify that our simulation produces jackpots that monotonically increase with respect to the daily increment argument. Here is a plot of such a check

    dailyIncrements = Range[5000, 30000, 1000];
    res = Map[JackpotEstimation[jackpotWinsProcesses20, 60, #, 30000] &, dailyIncrements];

    ListPlot[Map[Transpose[{dailyIncrements, #}] &, {Mean /@ Map[#[Mean] &, res], Mean /@ Map[#[Median] &, res], Mean /@ Map[#[StandardDeviation] &, res]}], PlotLegends -> SwatchLegend[{"Mean", "Median", "StandardDeviation"}]]

[![IncrementPlot][3]][3]

### Find the required jackpot increment amount per day / month 

Here we use simple iterative root finding for the mean of the means. We can use instead minimization algorithms that would have additional conditions for the parameter finding, like, tightness of the distribution etc.

With 20 Poisson processes

    sol = FindRoot[Mean[JackpotEstimation[jackpotWinsProcesses20, 60, x, 30000][Mean]] == 10^6, {x, 10000}]

    (* {x -> 8535.09} *)

    Mean[JackpotEstimation[jackpotWinsProcesses, 60, x /. sol, 30000][Mean]]

    (* 922072. *)

With 100 Poisson processes

    sol = FindRoot[Mean[JackpotEstimation[jackpotWinsProcesses100, 60, x, 30000][Mean]] == 10^6, {x, 10000}]

    (* {x -> 9154.07} *)

    Mean[JackpotEstimation[jackpotWinsProcesses, 60, x /. sol, 30000][Mean]]

    (* 988045. *)

With 300 Poisson processes (1st run)

    sol = FindRoot[Mean[JackpotEstimation[jackpotWinsProcesses, 60, x, 30000][Mean]] == 10^6, {x, 10000}]

    (* {x -> 9266.23} *)

    Mean[JackpotEstimation[jackpotWinsProcesses, 60, x /. sol, 30000][Mean]]

    (* 1.*10^6 *)

With 300 Poisson processes (2nd run)

    sol = FindRoot[Mean[JackpotEstimation[jackpotWinsProcesses, 60, x, 30000][Mean]] == 10^6, {x, 10000}]

    (* {x -> 9266.23} *)

    Mean[JackpotEstimation[jackpotWinsProcesses, 60, x /. sol, 30000][Mean]]

    (* 1.*10^6 *)

With 1000 Poisson processes

    sol = FindRoot[Mean[JackpotEstimation[jackpotWinsProcesses1000, 60, x, 30000][Mean]] == 10^6, {x, 10000}]

    (* {x -> 9274.31} *)

    Mean[JackpotEstimation[jackpotWinsProcesses1000, 60, x /. sol, 30000][Mean]]

    (* 1.*10^6 *)

With 10000 Poisson processes

    sol = FindRoot[Mean[JackpotEstimation[jackpotWinsProcesses, 60, x, 30000][Mean]] == 10^6, {x, 10000}]

    (* {x -> 9266.23} *)

    Mean[JackpotEstimation[jackpotWinsProcesses, 60, x /. sol, 30000][Mean]]

    (* 1.*10^6 *)

    sol = FindRoot[Mean[JackpotEstimation[jackpotWinsProcesses, 365, x, 30000][Mean]] == 10^6, {x, 10000}]

    (* {x -> 9557.37} *)

    Mean[JackpotEstimation[jackpotWinsProcesses, 365, x /. sol, 30000][Mean]]

    (* 1.*10^6 *)

    res = JackpotEstimation[jackpotWinsProcesses, 60, x /. sol, 30000];

Here are several plots of distributions of descriptive statistics over the simulated jackpot evolutions.

[![JackpotDist][4]][4]

### Empirical PDF and CDF 

Here we find the empirical PDF and CDF from the simulation

    bs = Range[30000, 2*10^6, 10000];
    bcs = BinCounts[res[Mean], {bs}];
    pdfPoints = Transpose[{Most@bs, bcs/Total[bcs]}];
    cdfPoints = Transpose[{Most@bs, Accumulate[bcs]/Total[bcs]}];
    GraphicsGrid[{{
       ListPlot[pdfPoints, Filling -> Axis, PlotLabel -> "PDF"],
       ListPlot[cdfPoints, Filling -> Axis, PlotLabel -> "CDF"]}}, ImageSize -> 600]

[![PDFCDF][5]][5]

    Length[Select[res[Mean], # <= 10^6 &]]/Length[res[Mean]] // N

    (* 0.5828 *)

### Jackpot increment per month

One estimate of the daily jackpot increment obtained with 1000 simulated Poisson processes is:

    jackpotDailyIncrement = x /. sol

    (* 9557.37 *)

The jackpot increment amount per month is:

    jackpotMonthlyIncrement = jackpotDailyIncrement*30.5

    (* 291500. *)

### Jackpot total bet per month

    dailyBet = jackpotDailyIncrement/0.1

    (* 95573.7 *)

    monthlyBet = dailyBet*30.5

    (* 2.915*10^6 *)

Note that these numbers are in the ball park of the ones found with the "neat math" approach using Geometric distribution (which are $ \approx 53150 $ and $ 1.6211 \times 10^{6} $. respectively)

## Probability to win per \$ 1-bet

Since %10 are kept for the jackpot from each bet we can estimate the number of \$ 1-bets per day:

    numberOfBets = jackpotDailyIncrement/(0.1)

    (* 95573.7 *)

From the number of bets per day we can estimate the probability to win with one bet

    pToWin = 2/(365*numberOfBets)

    (* 5.73322*10^-8 *)

(The neat math approach gives the probability $ 1.03093 \times 10^{-7} $.)

## Probability the jackpot to be won before it reaches a threshold

Consider the jackpot threshold \$ 500000. We interested to find the probability that jackpot will not be won before it reaches that threshold.

One way is, of course, to use the sample of simulated winning processes and make the estimate using the found jackpot daily increment.

Another way is to use the process formula (Poisson process) and the estimated number of days to reach the threshold with the estimated required jackpot increment. 

### Using Poisson process formulas

The jackpot daily increment is used to compute the number of days need to reach the threshold.

    nDaysToThreshold = 500000/jackpotDailyIncrement

    (* 52.3157 *)

Poisson process formula, i.e. distribution of number of x events to happen in the interval $[0,t]$ :

    PDF[PoissonProcess[\[Lambda]][t], x]

$$ \left\{\begin{matrix} \frac{e^{-t \lambda}(t \lambda )^{x}}{x!} & x\geq 0\\ 0 & \text{True} \end{matrix}\right. $$

The required probability is then computed with the sum:

    Clear[\[Lambda], t, t1, x]
    Sum[((E^(-t \[Lambda]) (t \[Lambda])^x)/x! /. t -> t1), {x, 1, \[Infinity]}]
    % /. {t1 -> nDaysToThreshold, \[Lambda] -> 2/365}

    (* E^(-t1 \[Lambda]) (-1 + E^(t1 \[Lambda])) *)

    (* 0.249234 *)

The probability can be also directly computed with the built-in function `NProbability`:

    NProbability[x[nDaysToThreshold] >= 1, x \[Distributed] PoissonProcess[2/365]]

    (* 0.249234 *)

We can get a more general formula with `Probability`:

    Probability[x[\[Theta]] >= 1, x \[Distributed] PoissonProcess[\[Lambda]]]

    (* 1 - E^(-\[Theta] \[Lambda]) *)

### Using Poisson process simulations

We have a collection of simulated Poisson processes. For each of them we can compute the jackpot at

    N@Length[Select[jackpotWinsProcesses["Paths"][[All, 2, 1]], # <= nDaysToThreshold &]]/Length[jackpotWinsProcesses["Paths"]]

    (* 0.2558 *)

## Dealing with the withheld jackpot

Because of the separate withheld pot we will have 

    dailyBetWithWithholding = jackpotDailyIncrement/(0.1 (1 - 0.05))

    (* 100604. *)

    monthlyBetWithBaby = dailyBetWithWithholding*30.5

    (* 3.06842*10^6 *)

Using the current, no-withholding model the probability for the jackpot to be won before it reaches \$ 500000 while the withheld pot is incremented can be modeled by fixing the daily bet found with the no-withholding contributions from the bet.

    NProbability[x[500000/(jackpotDailyIncrement 0.1/(0.1 (1 - 0.05)))] >= 1, x \[Distributed] PoissonProcess[2/365]]

    (* 0.238396 *)

A much better approach is to incorporate the withheld pot increment in the simulation process. This means re-writing the initial version of the function `JackpotEstimation` used above. (Already done in the implementation given above.) Here the 5% of the bet being put into the withheld pot are reflected in the last argument.

    sol = FindRoot[Mean[JackpotEstimation[jackpotWinsProcesses, 365, x, 30000, 0.05][Mean]] == 10^6, {x, 10000}, PrecisionGoal -> 2]

    (* {x -> 9812.32} *)

The probability for winning the jackpot before it reaches the threshold is: 

    Block[{jackpotDailyIncrement = x /. sol},
     NProbability[x[500000/(jackpotDailyIncrement*0.95)] >= 1, x \[Distributed] PoissonProcess[2/365]]
    ]

    (* 0.254655 *)

(The 0.95 factor reflects the fraction 0.05 for the withheld pot.)

# References

\[1\] John Quigley and Matthew Revie. "Risk Assessment of Progressive Casino Games", (2014), The Journal of Gambling Business and Economics 8.1. DOI: http://dx.doi.org/10.5750/jgbe.v8i1.784.

\[2\] Anton Antonov, [MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR), URL: https://github.com/antononcube/MathematicaVsR .

\[3\] Anton Antonov, "Exemplifying the cultural differences between Statistics and Machine learning", presentation at [Wolfram Technology Conference 2016](https://www.wolfram.com/events/technology-conference/2016/).

<!---
[1]:LowPoissons.png
[2]:HighPoissons.png
[3]:IncrementPlot.png
[4]:JackpotDist.png
[5]:PDFCDF.png
-->

[1]:http://i.imgur.com/hnZ6tuR.png
[2]:http://i.imgur.com/TJd3kdt.png
[3]:http://i.imgur.com/BOcT6pX.png
[4]:http://i.imgur.com/TRIWrNr.png
[5]:http://i.imgur.com/wN0hCpC.png
