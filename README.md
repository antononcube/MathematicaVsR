# Mathematica vs. R

## In brief

This repository has examples, code, and documents for comparing
[*Mathematica*](http://www.wolfram.com/mathematica/) with
[R](https://www.r-project.org).


### Mission statement

The development in this code repository aims to provide a collection
of relatively simple but non-trivial example projects that illustrate
the use of *Mathematica* and R in different statistical, machine
learning, scientific, and software engineering programming activities.

Each of the projects has implementations and documents made with both
*Mathematica* and R -- hopefully that would allow comparison and
knowledge transfer.


## License matters

All code files and executable documents are with the license GPL 3.0.
For details  see [http://www.gnu.org/licenses/](http://www.gnu.org/licenses/) .

All documents are with the license Creative Commons Attribution 4.0
International (CC BY 4.0). For details see
[https://creativecommons.org/licenses/by/4.0/](https://creativecommons.org/licenses/by/4.0/) .


## Projects organization

Each project has an introductory page (README.md) that lists the
project goals, concrete steps, and links to documents and scripts with
full explanations and code.

Generally, an introductory page would also have sections with comparison
observations and development history.

Each project (generally) has two directories named "Mathematica" and
"R" that have corresponding documents and code.

Since *Mathematica* ships with R some projects would have only a
*Mathematica*-centric exposition of combining *Mathematica* and R
outputs into one *Mathematica* notebook.

Some projects have only *Mathematica* or only R parts. This is because
there are no equivalent counter-parts.

There is an attempt the corresponding Mathematica and R codes to be
very close in structure and steps flow. Often enough the structure and
flow would be different because each programming language would make certain
particular techniques easier to apply or because of certain language idioms.

## Where to begin

This presentation,
["Mathematica vs. R"](https://github.com/antononcube/MathematicaVsR/blob/master/RDocumentation/Presentations/WTC-2015/WTC-2015-Antonov-Mathematica-vs-R.pdf)
given at the
[Wolfram Technology Conference 2015](https://www.wolfram.com/events/technology-conference/2015/)
is probably a good start.

As a warm-up of how to do the comparison see this mind-map (which is
made for *Mathematica* users):

[!["Mathematica-vs-R-mind-map-for-Mathematica-users"](http://i.imgur.com/oZobBxfm.png)](https://github.com/antononcube/MathematicaVsR/blob/master/Mathematica-vs-R-mind-map.pdf)



## Projects overview

### Abbreviations table

| Abbreviation | Definition                        | | Abbreviation | Definition                        |
|--------------|-----------------------------------| |--------------|-----------------------------------|
| BofW         | bag of words (model)              | | NA           | numerical analysis                |
| Cl           | (machine learning) classification | | NLP          | natural language processing       |
| DA           | data analysis                     | | Opt          | optimization                      |
| DIng         | data ingestion                    | | Outl         | outliers                          |
| Distr        | distributions of variables        | | Par          | parallel computing                |
| DWrang       | data wrangling                    | | QR           | quantile regression               |
| GoF          | goodness of fit                   | | Rgr          | regression                        |
| Gr           | graphs                            | | RLink        | Mathematica's RLink`              |
| HPC          | High Performance Computing        | | ROC          | receiver operating characteristic |
| Img          | image processing                  | | Sim          | simulation(s)                     |
| IUI          | interactive user interface(s)     | | Str          | strings patterns and manipulation |
| LSA          | latent semantic analysis          | | TS           | time series                       |
| MF           | matrix factorization(s)           | | Vis          | visualization                     |


### Projects overview table

| Project                                              | BofW | Cl | DA | DIng | Distr | DWrang | GoF | Gr | Img | IUI | Rgr | LSA | MF | NA | NLP | Opt | Outl | Par | QR | RLink | ROC | Sim | Str | TS | Vis |
|------------------------------------------------------|------|----|----|------|-------|--------|-----|----|-----|-----|-----|-----|----|----|-----|-----|------|-----|----|-------|-----|-----|-----|----|-----|
| [BrowsingDataWithChernoffFaces](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/BrowsingDataWithChernoffFaces)                        |      |    | X  | X    | X     | X      |     |    |     |     |     |     |    |    |     |     | X    |     |    |       |     |     |     |    | X   |
| [DataWrangling](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/DataWrangling)                                        |      |    | X  | X    |       | X      |     |    |     |     |     |     |    |    |     |     |      |     |    |       |     |     |     |    | X   |
| [DistributionExtractionFromAGaussianNoisedMixture](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/DistributionExtractionAFromGaussianNoisedMixture)     |      |    |    |      | X     |        | X   |    |     |     |     |     |    |    |     | X   |      |     |    |       |     |     |     |    |     |
| [HandwrittenDigitsClassificationByMatrixFactorization](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/HandwrittenDigitsClassificationByMatrixFactorization) |      | X  |    | X    |       |        |     |    | X   |     |     | X   | X  |    |     |     |      | X   |    |       |     |     |     |    | X   |
| [ODEsWithSeasonalities](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/ODEsWithSeasonalities)                                |      |    |    |      |       |        |     |    |     | X   |     |     |    | X  |     |     |      |     |    |       |     | X   |     |    | X   |
| [ProgressiveJackpotModeling](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/ProgressiveJackpotModeling)                           |      |    |    |      | X     |        |     |    |     |     |     |     |    |    |     |     |      |     |    |       |     | X   |     |    |     |
| [RegressionWithROC](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/RegressionWithROC)                                    |      | X  |    |      |       |        |     |    |     |     | X   |     |    |    |     |     |      |     |    |       | X   |     |     |    | X   |
| [StatementsSaliencyInPodcasts](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/StatementsSaliencyInPodcasts)                         | X    |    |    | X    |       |        |     |    |     | X   |     |     |    |    | X   |     |      |     |    |       |     |     | X   |    |     |
| [TimeSeriesAnalysisWithQuantileRegression](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/TimeSeriesAnalysisWithQuantileRegression)             |      |    | X  | X    |       |        |     |    |     |     |     |     |    |    |     |     | X    |     | X  |       |     |     |     | X  | X   |



## *Mathematica*'s [`RLink`](https://reference.wolfram.com/language/RLink/tutorial/Introduction.html)

For more information about *Mathematica*'s [`RLink`](https://reference.wolfram.com/language/RLink/tutorial/Introduction.html)
see

- the YouTube video ["RLink: Linking Mathematica and R"](https://www.youtube.com/watch?v=5ppY7cTy71o),

- the set-up web page guide [Setting up RLink for Mathematica](http://szhorvat.net/pelican/setting-up-rlink-for-mathematica.html).


