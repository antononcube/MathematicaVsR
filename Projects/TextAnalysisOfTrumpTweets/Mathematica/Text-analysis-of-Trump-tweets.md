# **Text analysis of Trump tweets**

Anton Antonov  
[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction)  
[MathematicaVsR project at GitHub](https://github.com/antononcube/MathematicaVsR)  
November, 2016

# Introduction

This Mathematica notebook is part of the [MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR/tree/master/Projects) project [TextAnalysisOfTrumpTweets](https://github.com/antononcube/MathematicaVsR/tree/master/Projects/TextAnalysisOfTrumpTweets). The notebook follows and extends the exposition and analysis of the R-based blog post ["Text analysis of Trump's tweets confirms he writes only the (angrier) Android half"](http://varianceexplained.org/r/trump-tweets/) by David Robinson at VarianceExplained.org; see \[[1](http://varianceexplained.org/r/trump-tweets/)\].

The blog post \[[1](http://varianceexplained.org/r/trump-tweets/)\] links to several sources that claim that Donald Trump tweets from his Android phone and his campaign staff tweets from an iPhone. The blog post \[[1](http://varianceexplained.org/r/trump-tweets/)\] examines this hypothesis in a quantitative way (using various R packages.) 

The hypothesis in question is well summarized with the tweet:

> Every non-hyperbolic tweet is from iPhone (his staff).  
> Every hyperbolic tweet is from Android (from him). [pic.twitter.com/GWr6D8h5ed](pic.twitter.com/GWr6D8h5ed)  
> -- Todd Vaziri (@tvaziri) August 6, 2016


In this Mathematica notebook (document) we are going to use the data provided in \[[1](http://varianceexplained.org/r/trump-tweets/)\] and confirm the hypothesis with same approaches as in \[[1](http://varianceexplained.org/r/trump-tweets/)\] but using alternative algorithms. For example, the section "Breakdown by sentiments" contains Bayesian statistics visualized with mosaic plots for device-vs-sentiment and device-vs-sentiment-vs-weekday -- those kind of statistics and the related time tags are not used in \[[1](http://varianceexplained.org/r/trump-tweets/)\].

## Concrete steps

This notebook does not follow closely the blog post \[1\]. After the ingestion of the data provided in \[1\], here we apply 
alternative algorithms to support and extend the analysis in \[1\].

The sections in the [R-part notebook](https://github.com/antononcube/MathematicaVsR/blob/master/Projects/TextAnalysisOfTrumpTweets/R/TextAnalysisOfTrumpTweets.Rmd) correspond to some -- not all -- of the sections in this notebook.

The following list of steps is followed in this notebook (document). 

1. **Data ingestion**
 
    - The blog post \[1\] shows how to do in R the ingestion of Twitter data of Donald Trump messages.

    - That can be done in Mathematica too using the built-in function `ServiceConnect`,
      but that is not necessary since [1] provides a link to the ingested data used [1]:

        load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))

    - Which leads to the ingesting of an R data frame in this notebook using RLink.

2. **Adding tags**

    - We have to extract device tags for the messages -- each message is associated with one of the tags "Android", "iPad", or "iPhone".

    - Using the message time-stamps each message is associated with time tags corresponding to the creation time month, hour, weekday, etc.

3. **Time series and time related distributions**

    - We can make several types of time series plots for general insight and to support the main conjecture.


4. **Classification into sentiments and Facebook topics**

    - Using the built-in classifiers of Mathematica each tweet message is associated with a sentiment tag and a Facebook topic tag.

    - In \[1\] the results of this step are derived in several stages. 

5. **Device-word association rules**

    - Using [Association rule learning](https://en.wikipedia.org/wiki/Association_rule_learning) device tags are associated with words in the tweets.

    - In this notebook these associations rules are not needed for the sentiment analysis (because of the built-in classifiers.) 

    - The association rule mining is done mostly to support and extend the text analysis in [1] and, of course, for comparison purposes.

In \[1\] the sentiments are derived from computed device-word associations, so in \[1\] the order of steps is 1-2-3-5-4. In Mathematica we do not need the steps 3 and 5 in order to get the sentiments in the 4th step.

# Load packages

These commands load the packages \[[2](https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m),[3](https://github.com/antononcube/MathematicaForPrediction/blob/master/MosaicPlot.m),[4](https://github.com/antononcube/MathematicaForPrediction/blob/master/AprioriAlgorithm.m)\] used in this notebook:

    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MosaicPlot.m"]
    Import["https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/AprioriAlgorithm.m"]

# Getting Twitter messages 

The blog post \[[1](http://varianceexplained.org/r/trump-tweets/)\] shows how the ingestion of Twitter data of Donald Trump messages is done in R. This can be done in Mathematica too using the built-in function `ServiceConnect`, but since \[[1](http://varianceexplained.org/r/trump-tweets/)\] provides a link to the ingested data used \[[1](http://varianceexplained.org/r/trump-tweets/)\] we going use it through RLink.

## Using ServiceConnect

This sub-section has a cursory list of commands for setting-up ingestion of Twitter messages with `ServiceConntect`.

    twitterConn = ServiceConnect["Twitter", "New"]

[![TwitterServiceConnect][1]][1]

"Thank you for authorizing WolframConnector. Your service object with id XXXX-XXXX-XXXX-XXXX is now authenticated. Return to the Wolfram Language to use it."

    twitterConn["UserData", "Username" -> "realDonaldTrump"]

    (* {<|"ID" -> 25073877, "Name" -> "Donald J. Trump", "ScreenName" -> "realDonaldTrump", "Location" -> "New York, NY", "FollowersCount" -> 15020674, "FriendsCount" -> 41, "FavouritesCount" -> 46|>} *)

## Directly from the [Variance Explained blog post](http://varianceexplained.org/r/trump-tweets/)

This subsection shows the ingestion of an R data frame in Mathematica using RLink.

    Needs["RLink`"]
    InstallR[]

Ingest the data frame from \[[1](http://varianceexplained.org/r/trump-tweets/)\] in the R session set-up above:

    REvaluate["load(url('http://varianceexplained.org/files/trump_tweets_df.rda'))"]

    (* {"trump_tweets_df"} *)

Get the data frame object:

    trumpTweetsDF = REvaluate["trump_tweets_df"];

Extract column names:

    colNames = "names" /. trumpTweetsDF[[2, 1]]

    (* {"text", "favorited", "favoriteCount", "replyToSN", "created", "truncated", "replyToSID", "id", "replyToUID", "statusSource", "screenName", "retweetCount", "isRetweet", "retweeted", "longitude", "latitude"} *)

Make an `Association` object in order to have more clear code below:

    aColNames = AssociationThread[colNames -> Range[Length[colNames]]]

    (* <|"text" -> 1, "favorited" -> 2, "favoriteCount" -> 3, "replyToSN" -> 4, "created" -> 5, "truncated" -> 6, "replyToSID" -> 7, "id" -> 8, "replyToUID" -> 9, "statusSource" -> 10, "screenName" -> 11, "retweetCount" -> 12, "isRetweet" -> 13, "retweeted" -> 14, "longitude" -> 15, "latitude" ->16|> *)

Verify columns number and columns lengths:

    Length[trumpTweetsDF[[1]]]

    (* 16 *)

    Length /@ trumpTweetsDF[[1]]

    (* {1512, 1512, 1512, 1512, 2, 1512, 1512, 1512, 1512, 1512, 1512, 1512, 1512, 1512, 1512, 1512} *)

One of the columns is given as a vector object -- extract the values for that column in order to get a matrix/table form of the data:

    trumpTweetsDF[[1, 5]] = trumpTweetsDF[[1, 5, 1]];

An R data frame is a list of columns. Using `Transpose` we get the usual Mathematica list of records form: 

    trumpTweetsTbl = Transpose[trumpTweetsDF[[1]]];

Visualize the obtained, ingested data frame:

    Magnify[#, 0.6] &@TableForm[trumpTweetsTbl[[1 ;; 12, All]], TableHeadings -> {None, colNames}]

[![TrumpTweets][2]][2]

# Data wrangling -- extracting source devices and adding time tags

## Sources (devices)

As done in the blog post \[[1](http://varianceexplained.org/r/trump-tweets/)\] we project the data to four columns and we modify the values of the column "statusSource" to have the device name.

    trumpTweetsTbl = Transpose[trumpTweetsDF[[1]]][[All, aColNames /@ {"id", "statusSource", "text", "created"}]];

Examining how the second column looks like:

    RecordsSummary@trumpTweetsTbl[[All, 2]]

[![TweetingDevice][3]][3]

we can just the take the device names using string pattern matching:

    sourceDevices = StringCases[trumpTweetsTbl[[All, 2]], RegularExpression["Twitter for (.*?)<"] :> "$1"];
    Tally[sourceDevices]

    (* {{{"Android"}, 762}, {{"iPhone"}, 628}, {{}, 121}, {{"iPad"}, 1}} *)

Looking at the `Tally` result we see that there are strings that do not match the device source pattern -- we simply remove the corresponding rows: 

    trumpTweetsTbl = Pick[trumpTweetsTbl, Length[#] > 0 & /@ sourceDevices];

and replace the values of the "statusSource" column with the values of `sourceDevices`:

    trumpTweetsTbl[[All, 2]] = Flatten[sourceDevices];

## Time tags

The addition time tag (like "hour of the day" and "weekday") is not necessary for the sentiment analysis over devices but would provide the time axis for useful or interesting statistics.

Next we convert the creation times in the column "created":

    RecordsSummary@trumpTweetsTbl[[All, 4]]

[![TweetingTime][4]][4]

to a list of date lists using Unix time conversion:

    dateLists = DateList[FromUnixTime[#]] & /@ trumpTweetsTbl[[All, 4]];
    Shallow@dateLists

    (* {{2016, 8, 8, 15, 20, 44.}, {2016, 8, 8, 13, 28, 20.}, {2016, 8, 8, 0, 5, 54.}, {2016, 8, 7, 23, 9, 8.}, {2016, 8, 7, 21, 31, 46.}, {2016, 8, 7, 13, 49, 29.}, {2016, 8, 7, 2, 19, 37.}, {2016, 8, 7, 2, 3, 39.}, {2016, 8, 7, 1, 53, 45.}, {2016, 8, 6, 20, 4, 8.}, <<1381>>} *)

We join the rows of the tweets with the rows of the time tag matrix `dateLists`:

    trumpTweetsTbl = MapThread[Join, {trumpTweetsTbl, dateLists}];

In a similar fashion as date lists let us also add weekdays:

    weekdays = DateString[FromUnixTime[#], "DayName"] & /@ trumpTweetsTbl[[All, 4]];
    Shallow@weekdays

    (* {"Monday", "Monday", "Monday", "Sunday", "Sunday", "Sunday", "Sunday", "Sunday", "Sunday", "Saturday", <<1381>>} *)

    trumpTweetsTbl = MapThread[Append, {trumpTweetsTbl, weekdays}];

Here we create an `Association` object for easy access to the columns of the data:

    aTrumpTweetsTblColNames = AssociationThread[{"id", "source", "text", "created", "year", "month", "day", "hour", "minute", "second", "weekday"} -> Range[Dimensions[trumpTweetsTbl][[2]]]]

    (* <|"id" -> 1, "source" -> 2, "text" -> 3, "created" -> 4, "year" -> 5, "month" -> 6, "day" -> 7, "hour" -> 8, "minute" -> 9, "second" -> 10, "weekday" -> 11|> *)

Here is a summary of the data:

    Magnify[#, 0.6] &@RecordsSummary[trumpTweetsTbl, Keys[aTrumpTweetsTblColNames]]

[![TextAnalysisOfTrumpTweets-trumpTweetsTbl-Summary][5]][5]

# Time series and time related distributions

In this section we simply derive the time series discussed in \[[1](http://varianceexplained.org/r/trump-tweets/)\]. The statistics in this section are not needed to do the sentiment analysis but they provide additional insight into the tweeting patterns in the data.

First, we can plot the time series of number of tweets per hour within the time span of the data:

    DateListPlot[Map[Tally[Cases[trumpTweetsTbl, {__, #, __}][[All, aTrumpTweetsTblColNames /@ {"year", "month", "hour"}]]] &, {"Android", "iPhone"}], PlotRange -> All, PlotTheme -> "Detailed", PlotLegends -> {"Android", "iPhone"}]

[![PlainListPlots][6]][6]

The time series plot above can be modified into a more informative one using moving average (with `TimeSeries` and `Manipulate`):

    Manipulate[DateListPlot[Map[MovingAverage[#, w] &@TimeSeries@Tally[Cases[trumpTweetsTbl, {__, #, __}][[All, aTrumpTweetsTblColNames /@ {"year", "month", "hour"}]]] &, {"Android", "iPhone"}], PlotRange -> All, PlotTheme -> "Detailed", 
      PlotLabel -> Row[{"Trump tweet counts averaged over ", w, " hours"}], PlotLegends -> {"Android", "iPhone"}],
     {{w, 6, "Window size (hours):"}, 1, 48, 1, Appearance -> {"Open"}}, Deployed -> True]

[![ManipListPlots][7]][7]

Next, as in \[[1](http://varianceexplained.org/r/trump-tweets/)\], for each device we can plot the fraction of the tweets made at different hours of the day:

    DateListPlot[{
       #/{1, Length[trumpTweetsTbl]} & /@Tally[Flatten[Cases[trumpTweetsTbl, {__, "Android", __}][[All,  aTrumpTweetsTblColNames /@ {"hour"}]]]], #/{1,   Length[trumpTweetsTbl]} & /@Tally[Flatten[Cases[trumpTweetsTbl, {__, "iPhone", __}][[All, aTrumpTweetsTblColNames /@ {"hour"}]]]]}, PlotTheme -> "Detailed", PlotRange -> All, FrameLabel -> {"Hour of the day", "Fraction of all messages"}, PlotLegends -> {"Android", "iPhone"}]

[![TextAnalysisOfTrumpTweets-iPhone-Android-freq-tweets-time-series-per-hour][8]][8]

Alternatively, we can use mosaic plots that fit better the discrete nature of those statistics:

    GraphicsGrid[{{
       MosaicPlot[trumpTweetsTbl[[All, aTrumpTweetsTblColNames /@ {"source", "hour"}]]],
       MosaicPlot[trumpTweetsTbl[[All, aTrumpTweetsTblColNames /@ {"hour", "source"}]], ColorRules -> {2 -> ColorData[7, "ColorList"]}]}}, ImageSize -> 600]

[![Mosaic-TimeDevice][9]][9]

Using the weekdays column we can plot the distributions of the number of tweets per day of the week:

    Block[{device = #, d},
       d = Cases[trumpTweetsTbl, {__, device, __}][[All, aTrumpTweetsTblColNames /@ {"year", "month", "hour", "weekday"}]];
       d = GatherBy[d, Last];
       d = SortBy[Map[{#[[1, 1, -1]], #[[All, 2]]} &, Tally /@ d], #[[1]] /. {"Monday" -> 1, "Sunday" -> 7, "Saturday" -> 6, "Friday" -> 5, "Wednesday" -> 3, "Tuesday" -> 2, "Thursday" -> 4} &];
       DistributionChart[d[[All, 2]], ChartLabels -> Map[Rotate[#, \[Pi]/12] &, d[[All, 1]]], FrameLabel -> {None, "Number of tweets"}, PlotRange -> {0, 20}, PlotLabel -> device, ImageSize -> 300]
      ] & /@ {"Android", "iPhone"}

[![TextAnalysisOfTrumpTweets-Weekday-TweetsNumber-Distributions-ViolinPlots][10]][10]

# Breakdown by sentiments

We can simply use the Mathematica built-in classifier for sentiments and plot some Bayesian statistics for sentiment-and-device pairs.

Note that this section uses alternative algorithms those of the section "Sentiment analysis: Trump's tweets are much more negative than his campaign's" in \[[1](http://varianceexplained.org/r/trump-tweets/)\]. Also, note that because of Mathematica's built-in classifiers we do not need to go through the steps in the section "Comparison of words" of \[[1](http://varianceexplained.org/r/trump-tweets/)\].

## Sentiments

First we add to the data a column with sentiments:

    trumpTweetsTbl = MapThread[Append, {trumpTweetsTbl, Classify["Sentiment", trumpTweetsTbl[[All, aTrumpTweetsTblColNames["text"]]]]}];

and extend the Association object for column names:

    aTrumpTweetsTblColNames = Join[aTrumpTweetsTblColNames, <|"sentiment" -> Length[aTrumpTweetsTblColNames] + 1|>]

    (* <|"id" -> 1, "source" -> 2, "text" -> 3, "created" -> 4, "year" -> 5, "month" -> 6, "day" -> 7, "hour" -> 8, "minute" -> 9, "second" -> 10, "weekday" -> 11, "sentiment" -> 12|> *)

## Sentiment vs. device

Then we make a mosaic plot to visualize the conditional probabilities:

    MosaicPlot[trumpTweetsTbl[[All, aTrumpTweetsTblColNames /@ {"sentiment", "source"}]]]

[![TextAnalysisOfTrumpTweets-MosaicPlot-Sentiment-Device][11]][11]

We can see in the plot above that there are much more negative tweets published through Android.

## Sentiment vs. time

We can make a similar conditional probabilities plot sentiments and using time tags.

    GraphicsGrid[
     {{MosaicPlot[trumpTweetsTbl[[All, aTrumpTweetsTblColNames /@ {"sentiment", "hour"}]]],
    MosaicPlot[trumpTweetsTbl[[All, aTrumpTweetsTblColNames /@ {"sentiment", "weekday"}]], "LabelRotation" -> {{1, 0.6}, {0, 1}}]}}, ImageSize -> 600]

[![Mosaic-TimSentiments][12]][12]

## Sentiment breakdown over devices and time tags

    MosaicPlot[trumpTweetsTbl[[All, aTrumpTweetsTblColNames /@ {"source", "weekday", "sentiment"}]], "LabelRotation" -> {{1, 0.6}, {1, 0.6}}, ColorRules -> {3 -> ColorData[7, "ColorList"]}]

[![TextAnalysisOfTrumpTweets-MosaicPlot-Device-Weekday-Sentiment][13]][23]

## Conclusions

We can see that the conjecture formulated in the introduction is confirmed by the sentiment-device mosaic plots in this section. We can see the Twitter messages from iPhone are much more likely to be neutral, and the ones from Android are much more polarized. As Christian Rudder (one of the founders of [OkCupid](https://www.okcupid.com/), a dating website) explains in the chapter "Death by a Thousand Mehs" of the book "Dataclysm", \[10\], polarization as a very good strategy to engage online audience:

> [...] And the effect isn't small-being highly polarizing will in fact get you about 70 percent more messages. That means variance allows you to effectively jump several "leagues" up in the dating pecking order - [...]*

# Facebook topics

Another built-in classifier in Mathematica classifies to Facebook topics. Let us apply that classifier to the Trump Twitter data:

    trumpTweetsTbl = MapThread[Append, {trumpTweetsTbl, Classify["FacebookTopic", trumpTweetsTbl[[All, aTrumpTweetsTblColNames["text"]]]]}];

This extends the Association object for the column names to include the Facebook column:

    aTrumpTweetsTblColNames = Join[aTrumpTweetsTblColNames, <|"FBtopic" -> Length[aTrumpTweetsTblColNames] + 1|>]

    (* <|"id" -> 1, "source" -> 2, "text" -> 3, "created" -> 4, "year" -> 5, "month" -> 6, "day" -> 7, "hour" -> 8, "minute" -> 9, "second" -> 10, "weekday" -> 11, "sentiment" -> 12, "FBtopic" -> 13|> *)

Let us cross-tabulate the obtained topics vs. the device of publishing.

    ctRes = CrossTabulate[trumpTweetsTbl[[All, aTrumpTweetsTblColNames /@ {"FBtopic", "source"}]]];
    Magnify[MatrixForm[ctRes], 0.6]

[![FacebookTopicMatrix][14]][14]

With the following [Pareto law](https://en.wikipedia.org/wiki/Pareto_principle) plot (for the function definition and other Mathematica examples see \[[6](https://mathematicaforprediction.wordpress.com/2016/11/17/pareto-principle-adherence-examples/)\]) we can see that the top 4 topics are the class labels of 80% of the tweets:

    ParetoLawPlot[Total[ctRes["XTABMatrix"], {2}]]

[![FacebookParetoLawPlot][15]][15]

Similarly, the top 7-8 topics are the class labels of $ \approx 90% $ of the tweets. Here are those topics (the fifth one is "Indeterminate" and is removed):

    topFBTopics = Drop[ctRes["RowNames"][[Reverse[Ordering[Total[ctRes["XTABMatrix"], {2}], -8]]]], {5}]

    (* {"Politics", "Technology", "CareerAndMoney", "SpecialOccasions", "Music", "Sports", "Television"} *)

Here we make rules for mapping the non-top-Pareto topics into "Other":

    toOtherTopicRules = Thread[Complement[ctRes["RowNames"], topFBTopics] -> "Other"];

Now we can make a mosaic plot for device-vs-Facebook topic:

    MosaicPlot[trumpTweetsTbl[[All, aTrumpTweetsTblColNames /@ {"source", "FBtopic"}]] /. toOtherTopicRules, "LabelRotation" -> {{1, 0.6}, {0, 1}}, ColorRules -> {2 -> ColorData[7, "ColorList"]}]

[![FacebookMosaic][16]][16]

Further, we can combine the sentiment classification results with the Facebook topics classification results:

    MosaicPlot[DeleteCases[trumpTweetsTbl, {___, "iPad", ___}][[All, aTrumpTweetsTblColNames /@ {"source", "FBtopic", "sentiment"}]] /. toOtherTopicRules, "LabelRotation" -> {{1, 0.4}, {0.2, 0.8}}, ColorRules -> {3 -> ColorData[7, "ColorList"]}, ImageSize -> 400]

[![TextAnalysisOfTrumpTweets-MosaicPlot-Device-FBTopic-Sentiment][17]][22]

# Comparison by used words

This section demonstrates a way to derive word-device associations that is alternative to the approach in \[[1](http://varianceexplained.org/r/trump-tweets/)\]. The [Association rules learning](https://en.wikipedia.org/wiki/Association_rule_learning) algorithm Apriori is used through the package "[AprioriAlgorithm.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/AprioriAlgorithm.m)", \[[4](https://github.com/antononcube/MathematicaForPrediction/blob/master/AprioriAlgorithm.m)\]. For documentation and examples how the functions of the package \[[4](https://github.com/antononcube/MathematicaForPrediction/blob/master/AprioriAlgorithm.m)\] see \[[8](https://github.com/antononcube/MathematicaForPrediction/blob/master/Documentation/MovieLens%20genre%20associations.pdf)\].

First we split the tweets into "bags of words" (or "baskets") and remove stop words:

    tweetWords = Select[#, StringLength[#] > 1 &] &@*DeleteStopwords@*StringSplit /@trumpTweetsTbl[[All, aTrumpTweetsTblColNames["text"]]];

(Further cleaning of the words can be done, but from the experiments shown below that does not seem necessary.)

Next to each bag-of-words we add the corresponding device tag:

    tweetWordsAndSources = MapThread[Append, {Union@*ToLowerCase /@ tweetWords, trumpTweetsTbl[[All, aTrumpTweetsTblColNames["source"]]]}];

We are ready to apply Apriori. The following command finds the pairs of words (frequent sets of two elements) that appear in at least in 1% of the messages (i.e. 13 messages):

    {ares, wordToIndexRules, indexToWordRules} = AprioriApplication[tweetWordsAndSources, 0.01, "MaxNumberOfItems" -> 2];

The following commands find the association rules based on the found frequent sets.

    arules = AssociationRules[tweetWordsAndSources /. wordToIndexRules, ares[[2]], 0.6, 0.007] /. indexToWordRules;
    aARulesColNames = Association[MapIndexed[#1 -> #2[[1]] &, {"Support", "Confidence", "Lift", "Leverage", "Conviction", "Antecedent", "Consequent"}]];

These are association rules for "Android" being the consequent given in descending confidence order:

    Magnify[#, 0.7] &@Pane[
      GridTableForm[SortBy[#, -#[[2]] &] &@Cases[arules, {___, {"Android"}, ___}, \[Infinity]], TableHeadings -> Keys[aARulesColNames]],
      ImageSize -> {800, 400}, Scrollbars -> True]

[![TextAnalysisOfTrumpTweets-Android-DeviceVsWords-AssocRules][18]][24]

These are the association rules for "iPhone" being the consequent:

    Magnify[#, 0.7] &@Pane[
      GridTableForm[SortBy[#, -#[[2]] &] &@Cases[arules, {___, {"iPhone"}, ___}, \[Infinity]],
       TableHeadings -> Keys[aARulesColNames]],
      ImageSize -> {800, 400}, Scrollbars -> True]

[![TextAnalysisOfTrumpTweets-iPhone-DeviceVsWords-AssocRules][19]][19]

Note that an association rule with confidence 1 means that the rule is a logical rule.

In order to make word comparison plots (paired bar charts) similar to those in \[[1](http://varianceexplained.org/r/trump-tweets/)\] we can write the following function:

    Clear[DeviceWords]
    DeviceWords[device_String, sortAxis_Integer, upTo_Integer, opts : OptionsPattern[]] :=
      DeviceWords[tweetWordsAndSources, device, sortAxis, upTo, opts];
    DeviceWords[tweetWordsAndSources_, device_String, sortAxis_Integer, upTo_Integer, opts : OptionsPattern[]] := Block[{words, ctRes},
       (* Select the words most associatiated with the specified device. *)
       words = Flatten@Cases[arules, {___, {device}, ___}, \[Infinity]][[All, -2]];
   
       (* For each device and word find in how many tweets they appear together. *)

   
       ctRes = Outer[
         Function[{d, w},
          Length[Select[tweetWordsAndSources, Length[Intersection[#, {w, d}]] == 2 &]]
         ], {"Android", "iPhone"}, words];
   
       (* Sort the data according to the found frequencies. *)
       ctRes = Append[ctRes, words];
       ctRes = Transpose[Reverse@Take[SortBy[Transpose[ctRes], -#[[sortAxis]] &], UpTo[upTo]]];
   
       (* Make the paired bar chart. *)
       PairedBarChart[{ctRes[[1]]}, {ctRes[[2]]},
        ChartLabels -> {Placed[{"Android", "iPhone"}, Above], None, Placed[ctRes[[3]], "RightAxis"]},
        AxesLabel -> {"frequency", "words"},
        ChartStyle -> {{Blue, Red}, None, None},
        opts]
      ];

Using the function defined above we can plot this comparison bar chart based on words most associated with Android:

    DeviceWords["Android", 1, 30, ImageSize -> 600, AspectRatio -> 0.8]

[![TextAnalysisOfTrumpTweets-AndroidMostFrequentWords-PairedBarChart][20]][20]

And here is a comparison bar chart based on words most associated with iPhone:

    DeviceWords["iPhone", 2, 20, ImageSize -> 600, AspectRatio -> 0.8]

[![TextAnalysisOfTrumpTweets-iPhoneMostFrequentWords-PairedBarChart][21]][21]

We can see the from the paired bar charts that the frequency distributions of the words in tweets from Android are much different from those coming from an iPhone. The messages from iPhone seem more "official" since their most frequent words are hash-tagged.

# Summary and further analysis

For general observations and conclusions over the data and the statistics see \[[1](http://varianceexplained.org/r/trump-tweets/)\]. In this document those observations and conclusions are supported or enhanced with more details.

Using Mathematica's built classifiers it was easier to do the sentiment analysis proposed in \[[1](http://varianceexplained.org/r/trump-tweets/)\]. With the more detailed time tags the mosaic plots provided some interesting additional insights. Using association rules mining is a more direct ways of investigating the device-word associations in the Twitter data.

Possible extensions of the analysis are (1) to do dimension reduction over the "bags of words" derived in the previous section, and (2) to apply importance of variables investigation, \[[9](https://github.com/antononcube/MathematicaForPrediction/blob/master/Documentation/Importance-of-variables-investigation-guide.pdf)\], to the "bag of words" records. That latter analysis extension is more in the spirit of the text analysis in \[[1](http://varianceexplained.org/r/trump-tweets/)\].

# References

\[1\] David Robinson, ["Text analysis of Trump's tweets confirms he writes only the (angrier) Android half"](http://varianceexplained.org/r/trump-tweets/), (2016), [VarianceExplained.org](http://varianceexplained.org/).

\[2\] Anton Antonov, [MathematicaForPrediction utilities](https://github.com/antononcube/MathematicaForPrediction/blob/master/MathematicaForPredictionUtilities.m), (2014), source code [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), package [MathematicaForPredictionUtilities.m](https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/MathematicaForPredictionUtilities.m).

\[3\] Anton Antonov, [Mosaic plot for data visualization implementation in Mathematica](https://github.com/antononcube/MathematicaForPrediction/blob/master/MosaicPlot.m), (2014),[MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), package [MosaicPlot.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/MosaicPlot.m). 

\[4\] Anton Antonov, [Implementation of the Apriori algorithm in Mathematica](https://github.com/antononcube/MathematicaForPrediction/blob/master/AprioriAlgorithm.m), (2014), source code at [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), package [AprioriAlgorithm.m](https://github.com/antononcube/MathematicaForPrediction/blob/master/AprioriAlgorithm.m).

\[5\] Anton Antonov, ["Mosaic plots for data visualization"](https://mathematicaforprediction.wordpress.com/2014/03/17/mosaic-plots-for-data-visualization/), (2014), [MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com/). URL: https://mathematicaforprediction.wordpress.com/2014/03/17/mosaic-plots-for-data-visualization/ .

\[6\] Anton Antonov, ["Pareto principle adherence examples"](https://mathematicaforprediction.wordpress.com/2016/11/17/pareto-principle-adherence-examples/), (2016), [MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com/). URL: https://mathematicaforprediction.wordpress.com/2016/11/17/pareto-principle-adherence-examples/ .

\[7\] Anton Antonov, ["Mosaic plots for data visualization"](https://mathematicaforprediction.wordpress.com/2014/03/17/mosaic-plots-for-data-visualization/), (2014), [MathematicaForPrediction at WordPress blog](https://mathematicaforprediction.wordpress.com/). URL: https://mathematicaforprediction.wordpress.com/2014/03/17/mosaic-plots-for-data-visualization/ .

\[8\] Anton Antonov, ["MovieLens genre associations"](https://github.com/antononcube/MathematicaForPrediction/blob/master/Documentation/MovieLens%20genre%20associations.pdf), (2013),  [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), https://github.com/antononcube/MathematicaForPrediction, folder [Documentation](https://github.com/antononcube/MathematicaForPrediction/tree/master/Documentation).

\[9\] Anton Antonov, ["Importance of variables investigation guide"](https://github.com/antononcube/MathematicaForPrediction/blob/master/Documentation/Importance-of-variables-investigation-guide.pdf), (2016),  [MathematicaForPrediction at GitHub](https://github.com/antononcube/MathematicaForPrediction), https://github.com/antononcube/MathematicaForPrediction, folder [Documentation](https://github.com/antononcube/MathematicaForPrediction/tree/master/Documentation).

\[10\] Christian Rudder, [Dataclysm](http://dataclysm.org), Crown, 2014. ASIN: B00J1IQUX8 .
<!---

[1]:TwitterServiceConnect.png
[2]:TrumpTweets.png
[3]:TweetingDevice.png
[4]:TweetingTime.png
[5]:TextAnalysisOfTrumpTweets-trumpTweetsTbl-Summary.png
[6]:PlainListPlots.png
[7]:ManipListPlots.png
[8]:TextAnalysisOfTrumpTweets-iPhone-Android-freq-tweets-time-series-per-hour.png
[9]:Mosaic-TimeDevice.png
[10]:TextAnalysisOfTrumpTweets-Weekday-TweetsNumber-Distributions-ViolinPlots.png
[11]:TextAnalysisOfTrumpTweets-MosaicPlot-Sentiment-Device.png
[12]:Mosaic-TimSentiments.png
[13]:TextAnalysisOfTrumpTweets-MosaicPlot-Device-Weekday-Sentiment.png
[14]:TextAnalysisOfTrumpTweets-FBTopic-vs-Device-CrossTable.png
[15]:FacebookParetoLawPlot.png
[16]:FacebookMosaic.png
[17]:TextAnalysisOfTrumpTweets-MosaicPlot-Device-FBTopic-Sentiment.png
[18]:TextAnalysisOfTrumpTweets-Android-DeviceVsWords-AssocRules.png
[19]:TextAnalysisOfTrumpTweets-iPhone-DeviceVsWords-AssocRules.png
[20]:TextAnalysisOfTrumpTweets-AndroidMostFrequentWords-PairedBarChart.png
[21]:TextAnalysisOfTrumpTweets-iPhoneMostFrequentWords-PairedBarChart.png

--->

[1]:http://i.imgur.com/T64zeMX.png
[2]:http://i.imgur.com/zzWL0PV.png
[3]:http://i.imgur.com/VpvCCAV.png
[4]:http://i.imgur.com/5bUy8vY.png
[5]:http://i.imgur.com/yMtdphT.png
[6]:http://i.imgur.com/edvusUk.png
[7]:http://i.imgur.com/ENlsfFm.png
[8]:http://i.imgur.com/oDv5Cm0.png
[9]:http://i.imgur.com/ZleZLg3.png
[10]:http://i.imgur.com/UGMy4EW.png
[11]:http://i.imgur.com/eKjxlTv.png
[12]:http://i.imgur.com/NcXl3aK.png
[13]:http://i.imgur.com/RMfuNNt.png
[14]:http://i.imgur.com/YJCZTBZ.png
[15]:http://i.imgur.com/MD4zlT3.png
[16]:http://i.imgur.com/h36R1hJ.png
[17]:http://i.imgur.com/IjfHGLc.png
[18]:http://i.imgur.com/dxy3zmf.png
[19]:http://i.imgur.com/nI12wmV.png
[20]:http://i.imgur.com/h6IwSiT.png
[21]:http://i.imgur.com/MbFWlOw.png
[22]:http://i.imgur.com/dMxSpHa.png
[23]:http://i.imgur.com/NHrh9UG.png
[24]:http://i.imgur.com/hgtnfVP.png
