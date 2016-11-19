# Text analysis of Trump tweets
Anton Antonov  
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
[MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects)  
November, 2016


## Introduction

In this project we compare Mathematica and R over text analyses of Twitter messages made by Donald Trump (and his staff) before the USA president elections in 2016.

This project follows and extends the exposition and analysis of the R-based blog post ["Text analysis of Trump's tweets confirms he writes only the (angrier) Android half"](http://varianceexplained.org/r/trump-tweets/) by David Robinson at [VarianceExplained.org](http://varianceexplained.org); see [1].

The blog post \[[1](http://varianceexplained.org/r/trump-tweets/)\] links to several sources that claim that during the election campaign Donald Trump tweeted from his Android phone and his campaign staff tweeted from an iPhone. The blog post [1] examines this hypothesis in a quantitative way (using various R packages.) 

The hypothesis in question is well summarized with the tweet:

> Every non-hyperbolic tweet is from iPhone (his staff).  
> Every hyperbolic tweet is from Android (from him). [pic.twitter.com/GWr6D8h5ed](pic.twitter.com/GWr6D8h5ed)  
> -- Todd Vaziri (@tvaziri) August 6, 2016


### Links

- The Mathematica part: [PDF file](), [Markdown file]().

- The R part is comprised of :

   - the blog post \[[1](http://varianceexplained.org/r/trump-tweets/)\], and

   - the R-notebook given as [Markdown](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/TextAnalysisOfTrumpTweets/R/TextAnalysisOfTrumpTweets.Rmd) and [HTML](https://cdn.rawgit.com/antononcube/MathematicaVsR/master/Projects/TextAnalysisOfTrumpTweets/R/TextAnalysisOfTrumpTweets.nb.html).

## Concrete steps

The Mathematica-part of this project does not follow closely the blog post [1]. After the ingestion of the data provided in [1], the Mathematica-part applies alternative algorithms to support and extend the analysis in [1].

The sections in the [R-notebook](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/TextAnalysisOfTrumpTweets/R/TextAnalysisOfTrumpTweets.Rmd) correspond to some -- not all -- of the sections in the Mathematica-part.

The following list of steps is for the Mathematica-part. 

1. Data ingestion
 
    - The blog post [1] shows how the ingestion of Twitter data of Donald Trump messages is done in R.

    - That can be done in Mathematica too using the built-in function `ServiceConnect`,
      but since [1] provides a link to the ingested data used [1]:

       load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))

    - Which leads to the ingesting of an R data frame in the Mathematica-part using RLink.

2. Adding tags

    - We have extract device tags for the messages : each message is associated with one of the tags "Android", "iPad", or "iPhone".

    - Using the messages time-stamps each message is associated with time tags like month, hour, weekday, etc.

3. Classification into sentiment and Facebook topics

    - Using the built-in classifiers of Mathematica each tweet message is associated with a sentiment tag and a Facebook topic tag.

    - In [1] the results of this step are derived in several stages. 

4. Device-word associations

    - Using [Association rule learning](https://en.wikipedia.org/wiki/Association_rule_learning) device tags are associated with words in the tweets.

    - In the Mathematica-part these associations rules are not needed for the sentiment analysis (because of the built-in classifiers). 

    - This association rule mining is done mostly to support and extend the text analysis in [1] and, of course, for comparison purposes.

In [1] the sentiments are derived from the obtained device-word associations, so the order of steps is 1-2-4-3. In Mathematica we can do not need the 4th step in order to get the sentiments in the 3d step.

## Comparison

Using Mathematica for sentiment analysis is much more direct because of the built-in classifiers.

The R-based blog post [1] uses heavily the "pipeline" operator `%>%` which is kind of a recent addition to R (and it is both fashionable and convenient to use it.) In Mathematica the related operators are `Postfix` (`//`), `Prefix` (`@`), `Infix` (`~~`), `Composition` (`@*`), and `RightComposition` (`/*`).

Making the time series plots with the R package "ggplot2" requires making special data frames -- I find the Mathematica plotting of time series much more direct.

Generally speaking, the R package "arules" for Associations rule learning is somewhat awkward to use:

- it is data frame centric, does not work directly with lists of lists, and

- requires the use of factors.



## References

\[1\] David Robinson, ["Text analysis of Trump's tweets confirms he writes only the (angrier) Android half"](http://varianceexplained.org/r/trump-tweets/), (2016), [VarianceExplained.org](http://varianceexplained.org).

\[2\] Anton Antonov, ["Mosaic plots for data visualization"](https://mathematicaforprediction.wordpress.com/2014/03/17/mosaic-plots-for-data-visualization/), (2014), [MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com).
