# **Distribution extraction from a Gaussian noised mixture**

Anton Antonov  
[MathematicaForPrediction project at GitHub](https://github.com/antononcube/MathematicaForPrediction/)  
[MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR/)  
October 2016 

# Introduction

This document started as an answer for the *Mathematica* StackExchange discussion:

[http://mathematica.stackexchange.com/questions/108182/extracting-signal-from-gaussian-noise](http://mathematica.stackexchange.com/questions/108182/extracting-signal-from-gaussian-noise) .

We want to find the distribution of the variable $X$ that used to generate the data $Z := X +Y$, 
where is $Y$ has the distribution $N(0,\sigma)$. The standard deviation $\sigma$ is known. 
We are interested in finding the CDF and/or PDF of $X$.

Here is a surrogate distribution for the type of $X$ that is expected. This is defined:

    SeedRandom[1256]
    fSurvivalGompertzDistRand[\[Alpha]_, \[Beta]_] := 
     ProbabilityDistribution[(1/((E^(\[Alpha]/\[Beta]) Gamma[ 0, \[Alpha]/\[Beta]])/\[Beta]) E^(((1 - E^(t \[Beta])) \[Alpha])/\[Beta])), {t, 0, \[Infinity]}]

This generates the part for X:

    dataX = RandomVariate[fSurvivalGompertzDistRand[0.016, 0.65], {20000}];
    Histogram[dataX, 50, PlotTheme -> "Detailed"]

![ExtactionFromGaussianNoisedMixture-X](http://imgur.com/i.UbFyVrp.png)

Then we add some Gaussian noise:

    \[Sigma] = 2.5;
    dataNoise = dataX + RandomVariate[NormalDistribution[0, \[Sigma]], {20000}];
    Histogram[dataNoise, 50, PlotTheme -> "Detailed"]

![ExtactionFromGaussianNoisedMixture-Z](http://i.imgur.com/1WWarFX.png)

# Solution

The procedure below assumes that the original distribution $X$ (the "signal") is non-Gaussian, and $Y$ is Gaussian (normally distributed noise.)

## General procedure

The procedure is as follows:

1. Find a function $F$ that applied to a collection of real numbers produces one value (say, 0) for normally distributed data and other different values for non-normally distributed data.

2. Pick a sample $\{s_i\}_{i=1}^{n}$ of the noised data with a relatively small number of $n$ points (say $n \in [20,40]$). 

3. Formulate an optimization problem with $n$ variables $\{v_i\}_{i=1}^{n}$ that maximizes $ \lvert F(s-v) \rvert$ subject to constrains that would hold if $\{v_i\}_{i=1}^{n}$ come from a normal distribution (with known parameters).

4. Solve the optimization problem several times with different samples and accumulate the sets $\{s_i - v_i\}_{i=1}^{n}$ and $\{v_i\}_{i=1}^{n}$. Monitor the $\chi^2$ test over $\{v_i\}_{i=1}^{n}$.

5. Reconstruct the original distribution (the "signal") CDF and PDF using quantiles of the union of $\{s_i - v_i\}_{i=1}^{n}$ from all optimization runs.

## Step details

### Non-Gaussianity measure

First, we are going to adopt [exess kurtosis as a measure for non-Gaussianity](http://cis.legacy.ics.tkk.fi/aapo/papers/IJCNN99_tutorialweb/node13.html). For this we are going to rewrite excess kurtosis as

    ExKurtosis[inp_] := CentralMoment[inp, 4] - 3 CentralMoment[inp, 2]^2

For points comming from the Normal Distribution `ExKurtosis` is close to 0:

    In[1139]:= ExKurtosis[NormalDistribution[a, b]]
    Out[1139]= 0

So, excess kurtosis close to 0 means Gaussianity, excess kurtosis significantly larger than 0 means non-Gaussianity.

Other non-Gaussiany measures exist with better properties (theoretical justification, robustness, speed of computation). See this article ["Independent Component Analysis: A Tutorial"](http://cis.legacy.ics.tkk.fi/aapo/papers/IJCNN99_tutorialweb/IJCNN99_tutorial3.html) .

### Constraints for normally distributed noise

We should come up with constraints which would hold if the values given to the variables are normally distributed. Since we know the mean and the standard deviation of the noise we can write up several such constraints based on the properties of Normal Distribution. (Mean, StandardDeviation, Kurtosis, etc.)

### Constraints from "signal" knowlege

We can add constraints coming up from our knowledge of the distribution that is noised.

From the examples in the question we can add the constraints $\{s_i - v_i > 0\}_{i=1}^{n}$.

## Code

### Data generation

The data is generated as given in the question.

    SeedRandom[1256]

    fSurvivalGompertzDistRand[\[Alpha]_, \[Beta]_] := 
     ProbabilityDistribution[(1/((E^(\[Alpha]/\[Beta]) Gamma[
              0, \[Alpha]/\[Beta]])/\[Beta]) E^(((1 - 
               E^(t \[Beta])) \[Alpha])/\[Beta])), {t, 0, \[Infinity]}]
    
    data = RandomVariate[fSurvivalGompertzDistRand[0.016, 0.65], {20000}];

    \[Sigma] = 2.5;
    dataNoise = 
      data + RandomVariate[NormalDistribution[0, \[Sigma]], {20000}];

### (Re-)start the process

The results of the maximization step are gathered in the lists `signalVals` and `noiseVals`.

    SeedRandom[5456]
    signalVals = {};
    noiseVals = {};

### Maximization

Select a sample with "good enough" kurtosis. This is not necessary, simple random sampling would do, but it might help getting better results faster.

    hk = 1000;
    While[! (10 < Abs[hk] < 40),
     dnSample = RandomSample[dataNoise, 40];
     hk = ExKurtosis[dnSample];
     vars = Array[x, Length[dnSample]];
     ]
    hk


Solve the maximization problem:

    AbsoluteTiming[
     sol = Maximize[
       Join[
        {Abs[ExKurtosis[dnSample - vars]], Abs[ExKurtosis[vars]] < 0.1,
         Abs[Mean[vars]] < 0.05, 
         Abs[\[Sigma] - StandardDeviation[vars]] < 0.1, 
         Mean[Map[If[Abs[#] < \[Sigma], 1, 0] &, vars]] > 0.66 },
        Map[Abs[#] <= 3.1 \[Sigma] &, vars],
        Map[# > 0 &, dnSample - vars]
        ], vars]
     ]
    
    (* {79.7731, {0.931781, {x[1] -> 0.488303, x[2] -> 0.0693204, 
       x[3] -> -1.58657, x[4] -> -2.73186, x[5] -> -0.792337, 
       x[6] -> -0.301162, x[7] -> 0.0463628, x[8] -> 0.24009, 
       x[9] -> 2.15609, x[10] -> 0.844921, x[11] -> 0.877771, 
       x[12] -> -0.988591, x[13] -> 0.814648, x[14] -> -1.98969, 
       x[15] -> -0.0298853, x[16] -> -0.189145, x[17] -> 0.850365, 
       x[18] -> 0.521628, x[19] -> -1.80022, x[20] -> 0.607911, 
       x[21] -> 0.0872866, x[22] -> 0.68063, x[23] -> -0.0647998, 
       x[24] -> -2.32211, x[25] -> -2.8472, x[26] -> 1.95862, 
       x[27] -> 1.04585, x[28] -> -1.0081, x[29] -> 1.04367, 
       x[30] -> -0.140025, x[31] -> 1.44755, x[32] -> -0.540915, 
       x[33] -> 0.46877, x[34] -> 2.14427, x[35] -> 0.437988, 
       x[36] -> 0.99062, x[37] -> 0.462472, x[38] -> -0.11133, 
       x[39] -> 0.260179, x[40] -> 1.55722}}} *)

While doing the experiments I stopped the maximization process if I thought it takes too much time (more than ~3 minutes).

### Accumulate the results

    signalVals = Append[signalVals, dnSample - vars /. sol[[2]]];
    noiseVals = Append[noiseVals, vars /. sol[[2]]];
    
    opts = {ImageSize -> Medium, PlotRange -> All};
    Grid[{{Histogram[Flatten[signalVals], 20, "Probability", opts, 
        PlotLabel -> "Signal"], 
       Histogram[Flatten[noiseVals], 20, "Probability", opts, 
        PlotLabel -> "Noise"]}}]

### Reconstruct CDF and PDF

    qs = Range[0, 1, 0.1];
    xs = Quantile[Flatten[signalVals], qs]
    
    qCDF = Interpolation[Transpose[{xs, qs}], InterpolationOrder -> 1];
    
    Plot[{qCDF[t], 
      Evaluate@CDF[fSurvivalGompertzDistRand[0.016, 0.65], t]}, {t, 
      Min[xs], Max[xs]}, PlotTheme -> "Detailed", 
     PerformanceGoal -> "Speed"]
    
    Plot[{qCDF'[t], 
      Evaluate@PDF[fSurvivalGompertzDistRand[0.016, 0.65], t]}, {t, 
      Min[xs], Max[xs]}, PlotTheme -> "Detailed", 
     PerformanceGoal -> "Speed"]

### Monitoring the process

It is helpful to look at goodness of fit measures in order to evaluate the procedure's results. 

    PearsonChiSquareTest[Flatten[signalVals], 
     fSurvivalGompertzDistRand[0.016, 0.65]]    
    (* Out[1087]= 0.061774 *)
    
    PearsonChiSquareTest[Flatten[noiseVals], 
     NormalDistribution[0, \[Sigma]]]
    (* Out[1089]= 0.18782 *)
    
    PearsonChiSquareTest[#, 
       fSurvivalGompertzDistRand[0.016, 0.65]] & /@ signalVals    
    (* Out[1090]= {0.301886, 0.238065, 0.142501, 0.80441} *)
    
    PearsonChiSquareTest[#, NormalDistribution[0, \[Sigma]]] & /@ noiseVals    
    (* Out[1091]= {0.46331, 0.608089, 0.970406, 0.338096} *)

## Experimental results

### Noise with $\sigma = 2.5$

Using noise as provided in the question and making 4 maximization runs, these are the histograms of the obtained distributions:

[![enter image description here][1]][1]

Here are the reconstructed CDF and PDF:

[![enter image description here][2]][2]

### Noise with $\sigma = 1$

It seems that better results are obtained with smaller standard deviation of the noise. (As expected.) Again using 4 maximization runs. We can see that the CDF is much better approximated.

These are the histograms of the obtained distributions:

[![enter image description here][3]][3]

These are the reconstructed CDF and PDF:

[![enter image description here][4]][4]


  [1]: http://i.stack.imgur.com/vYpzw.png
  [2]: http://i.stack.imgur.com/q5g9f.png
  [3]: http://i.stack.imgur.com/TyntH.png
  [4]: http://i.stack.imgur.com/R8kbO.png
