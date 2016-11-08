# Statements saliency in podcasts
Anton Antonov  
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
[MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects)  
September, 2016

## Mission statement

This project has two goals:

1. to show how to experiment in *Mathematica* and R with algebraic computations determination of the most important sentences (or paragraphs) in natural language texts, and

2. to compare the *Mathematica* and R codes (built-in functions, libraries, programmed functions) for doing these experiments.

In order to make those experiments we have to find, choose, and download suitable text data. This project uses [Freakonomics radio](http://freakonomics.com) podcasts transcripts.

The project executable documents and source files give a walk through with code and explanations of the complete sequence of steps, from intent to experimental results. 

The following concrete steps are taken.

1. Data selection of a source that provides high quality texts. (E.g. English grammar, spelling, etc.)

2. Download or scraping of the text data.

3. Text data parsing, cleaning, and other pre-processing.

4. Mapping of a selected document into linear vector space using the Bag-of-words model.

5. Finding sentence/statement saliency using matrix algebra.

6. Experimenting with the saliency algorithm over the data and making a suitable interactive interface. 

(*All code and documents of this project GitHub directory are under GPL 3.0 -- see the last section.*)

## Comparison

### Scripts

The following scripts can be executed to go through all the steps listed above.

- *Mathemaitca* script : ["./Mathematica/StatementsSaliencyInPodcastsScript.m"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/StatementsSaliencyInPodcasts/Mathematica/StatementsSaliencyInPodcastsScript.m).

- R script : ["./R/StatementsSaliencyInPodcastsScript.R"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/StatementsSaliencyInPodcasts/R/StatementsSaliencyInPodcastsScript.R).


### Documents

- See the PDF document ["./Mathematica/StatementsSaliencyInPodcasts.pdf"]() for using *Mathematica*. 

- See the HTML document ["./R/StatementsSaliencyInPodcasts.html"](https://rawgit.com/antononcube/MathematicaVsR/master/Projects/StatementsSaliencyInPodcasts/R/StatementsSaliencyInPodcasts.html) for using R.

### Interactive interfaces

After executing the scripts listed above the executing following scripts would produce interactive interfaces that allow to see the outcomes of different parameter selections.

- *Mathematica* interactive interface : ["./Mathematica/StatementsSaliencyInPodcastsInterface.m"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/StatementsSaliencyInPodcasts/Mathematica/StatementsSaliencyInPodcastsInterface.m).

- R / Shiny interactive interface : ["./R/StatementsSaliencyInPodcastsInterface.R"](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/StatementsSaliencyInPodcasts/R/StatementsSaliencyInPodcastsInterface.R).

## Observations and conclusions

TBD

## License

