# Mathematica vs. R

## In brief

This repository has example projects, code, and documents for comparing
[*Mathematica*](http://www.wolfram.com/mathematica/) with
[R](https://www.r-project.org).


### Mission statement

The development in this code repository aims to provide a collection
of relatively simple but non-trivial example projects that illustrate
the use of Mathematica and R in different statistical, machine
learning, scientific, and software engineering programming activities.

Each of the projects has implementations and documents made with both
Mathematica and R -- hopefully that would allow comparison and
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

Since Mathematica ships with R some projects would have only a
Mathematica-centric exposition of combining Mathematica and R
outputs into one Mathematica notebook.

Some projects have only Mathematica parts or only R parts. This is because
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

This presentation, ["Mathematica vs. R–Advanced Use Cases"](https://github.com/antononcube/MathematicaVsR/tree/master/RDocumentation/Presentations/WTC-2016) 
was given at
 [Wolfram Technology Conference 2016](https://www.wolfram.com/events/technology-conference/2016/) 
 was recorded: 

- YouTube : https://www.youtube.com/watch?v=NKpeOKxCUl4 .

- Wolfram Research : http://www.wolfram.com/broadcast/video.php?v=1745 .


As a warm-up of how to do the comparison see this mind-map (which is
made for Mathematica users):

[!["Mathematica-vs-R-mind-map-for-Mathematica-users"](http://i.imgur.com/oZobBxfm.png)](https://github.com/antononcube/MathematicaVsR/blob/master/Mathematica-vs-R-mind-map.pdf)



## Projects overview

### Abbreviations table

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="left" />

<col  class="left" />

<col  class="left" />

<col  class="left" />

<col  class="left" />
</colgroup>
<thead>
<tr>
<th scope="col" class="left">Abbreviation</th>
<th scope="col" class="left">Definition</th>
<th scope="col" class="left">&#xa0;</th>
<th scope="col" class="left">Abbreviation</th>
<th scope="col" class="left">Definition</th>
</tr>
</thead>

<tbody>
<tr>
<td class="left">ARL</td>
<td class="left">Association rules learning</td>
<td class="left">&#xa0;</td>
<td class="left">NA</td>
<td class="left">numerical analysis</td>
</tr>


<tr>
<td class="left">BofW</td>
<td class="left">bag of words (model)</td>
<td class="left">&#xa0;</td>
<td class="left">NLP</td>
<td class="left">natural language processing</td>
</tr>


<tr>
<td class="left">Cl</td>
<td class="left">(machine learning) classification</td>
<td class="left">&#xa0;</td>
<td class="left">Opt</td>
<td class="left">optimization</td>
</tr>


<tr>
<td class="left">DA</td>
<td class="left">data analysis</td>
<td class="left">&#xa0;</td>
<td class="left">Outl</td>
<td class="left">outliers</td>
</tr>


<tr>
<td class="left">DIng</td>
<td class="left">data ingestion</td>
<td class="left">&#xa0;</td>
<td class="left">Par</td>
<td class="left">parallel computing</td>
</tr>


<tr>
<td class="left">Distr</td>
<td class="left">distributions of variables</td>
<td class="left">&#xa0;</td>
<td class="left">QR</td>
<td class="left">quantile regression</td>
</tr>


<tr>
<td class="left">DWrang</td>
<td class="left">data wrangling</td>
<td class="left">&#xa0;</td>
<td class="left">Rgr</td>
<td class="left">regression</td>
</tr>


<tr>
<td class="left">GoF</td>
<td class="left">goodness of fit</td>
<td class="left">&#xa0;</td>
<td class="left">RLink</td>
<td class="left">Mathematica's RLink</td>
</tr>


<tr>
<td class="left">Gr</td>
<td class="left">graphs</td>
<td class="left">&#xa0;</td>
<td class="left">ROC</td>
<td class="left">receiver operating characteristic</td>
</tr>


<tr>
<td class="left">HPC</td>
<td class="left">High Performance Computing</td>
<td class="left">&#xa0;</td>
<td class="left">Sim</td>
<td class="left">simulation(s)</td>
</tr>


<tr>
<td class="left">Img</td>
<td class="left">image processing</td>
<td class="left">&#xa0;</td>
<td class="left">Str</td>
<td class="left">strings patterns and manipulation</td>
</tr>


<tr>
<td class="left">IUI</td>
<td class="left">interactive user interface(s)</td>
<td class="left">&#xa0;</td>
<td class="left">TS</td>
<td class="left">time series</td>
</tr>


<tr>
<td class="left">LSA</td>
<td class="left">latent semantic analysis</td>
<td class="left">&#xa0;</td>
<td class="left">Vis</td>
<td class="left">visualization</td>
</tr>


<tr>
<td class="left">MF</td>
<td class="left">matrix factorization(s)</td>
<td class="left">&#xa0;</td>
<td class="left">&#xa0;</td>
<td class="left">&#xa0;</td>
</tr>
</tbody>
</table>


### Projects overview table

In the following table the projects in italics are partially completed --
they have only a Mathematica or an R part.

| Project                                              | ARL | BofW | Cl | DA | DIng | Distr | DWrang | GoF | Gr | Img | IUI | Rgr | LSA | MF | NA | NLP | Opt | Outl | Par | QR | RLink | ROC | Sim | Str | TS | Vis |
|------------------------------------------------------|-----|------|----|----|------|-------|--------|-----|----|-----|-----|-----|-----|----|----|-----|-----|------|-----|----|-------|-----|-----|-----|----|-----|
| [BrowsingDataWithChernoffFaces](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/BrowsingDataWithChernoffFaces)                        |     |      |    | X  | X    | X     | X      |     |    |     |     |     |     |    |    |     |     | X    |     |    |       |     |     |     |    | X   |
| [DataWrangling](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/DataWrangling)                                        |     |      |    | X  | X    |       | X      |     |    |     |     |     |     |    |    |     |     |      |     |    |       |     |     |     |    | X   |
| [DistributionExtractionAFromGaussianNoisedMixture](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/DistributionExtractionAFromGaussianNoisedMixture)     |     |      |    |    |      | X     |        | X   |    |     |     |     |     |    |    |     | X   |      |     |    |       |     |     |     |    |     |
| [HandwrittenDigitsClassificationByMatrixFactorization](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/HandwrittenDigitsClassificationByMatrixFactorization) |     |      | X  |    | X    |       |        |     |    | X   |     |     | X   | X  |    |     |     |      | X   |    |       |     |     |     |    | X   |
| [ODEsWithSeasonalities](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/ODEsWithSeasonalities)                                |     |      |    |    |      |       |        |     |    |     | X   |     |     |    | X  |     |     |      |     |    |       |     | X   |     |    | X   |
| [ProgressiveJackpotModeling](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/ProgressiveJackpotModeling)                           |     |      |    |    |      | X     |        |     |    |     |     |     |     |    |    |     |     |      |     |    |       |     | X   |     |    |     |
| [RegressionWithROC](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/RegressionWithROC)                                    |     |      | X  |    |      |       |        |     |    |     |     | X   |     |    |    |     |     |      |     |    |       | X   |     |     |    | X   |
| [StatementsSaliencyInPodcasts](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/StatementsSaliencyInPodcasts)                         |     | X    |    |    | X    |       |        |     |    |     | X   |     |     |    |    | X   |     |      |     |    |       |     |     | X   |    |     |
| [TextAnalysisOfTrumpTweets](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/TextAnalysisOfTrumpTweets)                            | X   | X    | X  | X  | X    |       | X      |     |    |     |     |     |     |    |    |     |     |      |     |    | X     |     |     | X   |    | X   |
| [TimeSeriesAnalysisWithQuantileRegression](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/TimeSeriesAnalysisWithQuantileRegression)             |     |      |    | X  | X    |       |        |     |    |     |     |     |     |    |    |     |     | X    |     | X  |       |     |     |     | X  | X   |




## Mathematica's [`RLink`](https://reference.wolfram.com/language/RLink/tutorial/Introduction.html)

For more information about *Mathematica*'s [`RLink`](https://reference.wolfram.com/language/RLink/tutorial/Introduction.html)
see

- the YouTube video ["RLink: Linking Mathematica and R"](https://www.youtube.com/watch?v=5ppY7cTy71o),

- the set-up web page guide [Setting up RLink for Mathematica](http://szhorvat.net/pelican/setting-up-rlink-for-mathematica.html).


## Future projects

The future projects are listed in order of their completion time
proximity -- the highest in the list would be committed the soonest.

- Personal banking data obfuscation

- [Independent Component Analysis (ICA) programming and basic applications]
  (https://mathematicaforprediction.wordpress.com/?s=ICA)

- [Prefix trees (tries) programming and basic applications](https://mathematicaforprediction.wordpress.com/2013/12/06/tries-with-frequencies-for-data-mining/)

- High Performance Computing (HPC) projects -- Spark, H2O, etc. 

- [Comparison of PCA, NNMF, and ICA over image de-noising](https://mathematicaforprediction.wordpress.com/2016/05/26/comparison-of-pca-nnmf-and-ica-over-image-de-noising/)

- Informal verification of time series co-dependency

- [Functional parsers programming and basic applications](https://mathematicaforprediction.wordpress.com/?s=functional+parsers)

- Recommendation engines

- [Lebesgue numerical integration](https://mathematicaforprediction.wordpress.com/2016/07/01/adaptive-numerical-lebesgue-integration-by-set-measure-estimates/)

- [Conversational engines](https://mathematicaforprediction.wordpress.com/2014/11/29/simple-time-series-conversational-engine/)




