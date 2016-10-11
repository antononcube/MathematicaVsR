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
there are equivalent counter-parts.

## Where to begin

This presentation,
["Mathematica vs. R"](https://github.com/antononcube/MathematicaVsR/blob/master/RDocumentation/Presentations/WTC-2015/WTC-2015-Antonov-Mathematica-vs-R.pdf)
given at the
[Wolfram Technology Conference 2015](https://www.wolfram.com/events/technology-conference/2015/)
is probably a good start.

## Projects overview

### Abbreviations table
| Abbreviation | Definition                        |   | Abbreviation | Definition                        |
|--------------+-----------------------------------|---|--------------+-----------------------------------|
| BofW         | bag of words (model)              |   | NLP          | natural language processing       |
| Cl           | (machine learning) classification |   | Opt          | optimization                      |
| DA           | data analysis                     |   | Outl         | outliers                          |
| DIng         | data ingestion                    |   | Par          | parallel computing                |
| DWrang       | data wrangling                    |   | QR           | quantile regression               |
| Gr           | graphs                            |   | Rgr          | regression                        |
| HPC          | High Performance Computing        |   | RLink        | Mathematica's RLink`              |
| Img          | image processing                  |   | ROC          | receiver operating characteristic |
| IUI          | interactive user interface(s)     |   | Sim          | simulation(s)                     |
| LSA          | latent semantic analysis          |   | Str          | strings patterns and manipulation |
| MF           | matrix factorization(s)           |   | TS           | time series                       |
| NA           | numerical analysis                |   | Vis          | visualization                     |

### Projects overview table
| Project                                              | BofW | Cl | DA | DIng | DWrang | Gr | Img | IUI | Rgr | LSA | MF | NA | NLP | Opt | Outl | Par | QR | RLink | ROC | Sim | Str | TS | Vis |
|------------------------------------------------------|------|----|----|------|--------|----|-----|-----|-----|-----|----|----|-----|-----|------|-----|----|-------|-----|-----|-----|----|-----|
| HandwrittenDigitsClassificationByMatrixFactorization |      | X  |    | X    |        |    | X   |     |     | X   | X  |    |     |     |      | X   |    |       |     |     |     |    | X   |
| LinearRegressionWithROC                              |      | X  |    |      |        |    |     |     | X   |     |    |    |     |     |      |     |    |       | X   |     |     |    | X   |
| ODEsWithSeasonalities                                |      |    |    |      |        |    |     | X   |     |     |    | X  |     |     |      |     |    |       |     | X   |     |    | X   |
| StatementsSaliencyInPodcasts                         | X    |    |    | X    |        |    |     | X   |     |     |    |    | X   |     |      |     |    |       |     |     | X   |    |     |
| TimeSeriesAnalysisWithQuantileRegression             |      |    | X  | X    |        |    |     |     |     |     |    |    |     |     | X    |     | X  |       |     |     |     | X  | X   |

  

  


## *Mathematica*'s [`RLink`](https://reference.wolfram.com/language/RLink/tutorial/Introduction.html)

For more information about *Mathematica*'s [`RLink`](https://reference.wolfram.com/language/RLink/tutorial/Introduction.html)
see

- the YouTube video ["RLink: Linking Mathematica and R"](https://www.youtube.com/watch?v=5ppY7cTy71o),

- the set-up web page guide [Setting up RLink for Mathematica](http://szhorvat.net/pelican/setting-up-rlink-for-mathematica.html).


