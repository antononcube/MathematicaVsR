# Crypto-currencies data acquisition with visualization

Anton Antonov   
[MathematicaVsR at GitHub](https://github.com/antononcube/MathematicaVsR/)   
[MathematicaForPrediction at WordPress](https://mathematicaforprediction.wordpress.com)   
June 2021

## Introduction

In this notebook we show how to obtain crypto-currencies data from several data sources and make some basic time series visualizations. We assume the described data acquisition workflow is useful for doing more detailed (exploratory) analysis.

There are multiple crypto-currencies data sources, but a small proportion of them give a convenient way of extracting crypto-currencies data automatically. I found the easiest to work with to be https://finance.yahoo.com/cryptocurrencies, [YF1]. Another easy to work with Bitcoin-only data source is  https://data.bitcoinity.org , [DBO1].

(I also looked into using https://www.coindesk.com/coindesk20. )

**Remark:** The code below is made with certain ad-hoc inductive reasoning that brought meaningful results. This means the code has to be changed if the underlying data organization in [YF1, DBO1] is changed.

## Yahoo! Finance 

### Getting cryptocurrencies symbols and summaries

In this section we get all crypto-currencies symbols and related metadata.

Get the data of all crypto-currencies in [YF1]:

```mathematica
AbsoluteTiming[
  lsData = Import["https://finance.yahoo.com/cryptocurrencies", "Data"]; 
 ]

(*{6.18067, Null}*)
```

Locate the data:

```mathematica
pos = First@Position[lsData, {"Symbol", "Name", "Price (Intraday)", "Change", "% Change", ___}];
dsCryptoCurrenciesColumnNames = lsData[[Sequence @@ pos]]
Length[dsCryptoCurrenciesColumnNames]

(*{"Symbol", "Name", "Price (Intraday)", "Change", "% Change", "Market Cap", "Volume in Currency (Since 0:00 UTC)", "Volume in Currency (24Hr)", "Total Volume All Currencies (24Hr)", "Circulating Supply", "52 Week Range", "1 Day Chart"}*)

(*12*)
```

Get the data:

```mathematica
dsCryptoCurrencies = lsData[[Sequence @@ Append[Most[pos], 2]]];
Dimensions[dsCryptoCurrencies]

(*{25, 10}*)
```

Make a dataset:

```mathematica
dsCryptoCurrencies = Dataset[dsCryptoCurrencies][All, AssociationThread[dsCryptoCurrenciesColumnNames[[1 ;; -3]], #] &]
```

![027jtuv769fln](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/027jtuv769fln.png)

### Get all time series

In this section we get all the crypto-currencies time series from [YF1].

```mathematica
AbsoluteTiming[
  ccNow = Round@AbsoluteTime[Date[]] - AbsoluteTime[{1970, 1, 1, 0, 0, 0}]; 
  aCryptoCurrenciesDataRaw = 
   Association@
    Map[
     # -> ResourceFunction["ImportCSVToDataset"]["https://query1.finance.yahoo.com/v7/finance/download/" <> # <>"?period1=1410825600&period2=" <> ToString[ccNow] <> "&interval=1d&events=history&includeAdjustedClose=true"] &, Normal[dsCryptoCurrencies[All, "Symbol"]] 
    ]; 
 ]

(*{5.98745, Null}*)
```

**Remark:** Note that in the code above we specified the upper limit of the time span to be the current date. (And shifted it with respect to the epoch start 1970-01-01 used by [YF1].)

Check we good the data with dimensions retrieval:

```mathematica
Dimensions /@ aCryptoCurrenciesDataRaw

(*<|"BTC-USD" -> {2468, 7}, "ETH-USD" -> {2144, 7}, "USDT-USD" -> {2307, 7}, "BNB-USD" -> {1426, 7}, "ADA-USD" -> {1358, 7}, "DOGE-USD" -> {2468, 7}, "XRP-USD" -> {2468, 7}, "USDC-USD" -> {986, 7}, "DOT1-USD" -> {304, 7}, "HEX-USD" -> {551, 7}, "UNI3-USD" -> {81, 7},"BCH-USD" -> {1428, 7}, "LTC-USD" -> {2468, 7}, "SOL1-USD" -> {436, 7}, "LINK-USD" -> {1369, 7}, "THETA-USD" -> {1250, 7}, "MATIC-USD" -> {784, 7}, "XLM-USD" -> {2468, 7}, "ICP1-USD" -> {32, 7}, "VET-USD" -> {1052, 7}, "ETC-USD" -> {1792, 7}, "FIL-USD" -> {1285, 7}, "TRX-USD" -> {1376, 7}, "XMR-USD" -> {2468, 7}, "EOS-USD" -> {1450, 7}|>*)
```

Check we good the data with random sample:

```mathematica
RandomSample[#, 6] & /@ KeyTake[aCryptoCurrenciesDataRaw, RandomChoice[Keys@aCryptoCurrenciesDataRaw]]
```

![12a3tm9n7hwhw](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/12a3tm9n7hwhw.png)

Here we add the crypto-currencies symbols and convert date strings into date objects.

```mathematica
AbsoluteTiming[
  aCryptoCurrenciesData = Association@KeyValueMap[Function[{k, v}, k -> v[All, Join[<|"Symbol" -> k, "DateObject" -> DateObject[#Date]|>, #] &]], aCryptoCurrenciesDataRaw]; 
 ]

(*{8.27865, Null}*)
```

### Summary

In this section we compute the summary over **all** datasets:

```mathematica
ResourceFunction["RecordsSummary"][Join @@ Values[aCryptoCurrenciesData], "MaxTallies" -> 30]
```

![05np9dmf305fp](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/05np9dmf305fp.png)

### Plots

Here we plot the “Low” and “High” price time series for each crypto-currency for the last 120 days:

```mathematica
nDays = 120;
Map[
  Block[{dsTemp = #[Select[AbsoluteTime[#DateObject] > AbsoluteTime[DatePlus[Now, -Quantity[nDays, "Days"]]] &]]}, 
    DateListPlot[{
      Normal[dsTemp[All, {"DateObject", "Low"}][Values]], 
      Normal[dsTemp[All, {"DateObject", "High"}][Values]]}, 
     PlotLegends -> {"Low", "High"}, 
     AspectRatio -> 1/4, 
     PlotRange -> All] 
   ] &, 
  aCryptoCurrenciesData 
 ]
```

![0xx3qb97hg2w1](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/0xx3qb97hg2w1.png)

Here we plot the volume time series for each crypto-currency for the last 120 days:

```mathematica
nDays = 120;
Map[
  Block[{dsTemp = #[Select[AbsoluteTime[#DateObject] > AbsoluteTime[DatePlus[Now, -Quantity[nDays, "Days"]]] &]]}, 
    DateListPlot[{
      Normal[dsTemp[All, {"DateObject", "Volume"}][Values]]}, 
     PlotLabel -> "Volume", 
     AspectRatio -> 1/4, 
     PlotRange -> All] 
   ] &, 
  aCryptoCurrenciesData 
 ]
```

![0djptbh8lhz4e](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/0djptbh8lhz4e.png)

## data.bitcoinity.org

In this section we ingest crypto-currency data from [data.bitcoinity.org](https://data.bitcoinity.org/), [DBO1].

### Metadata

In this sub-section we assign different metadata elements used in data.bitcoinity.org.

The currencies and exchanges we obtained by examining the output of: 

```
Import["https://data.bitcoinity.org/markets/price/30d/USD?t=l", "Plaintext"]
```

#### Assignments

```mathematica
lsCurrencies = {"all", "AED", "ARS", "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "COP", "CZK", "DKK", "EUR", "GBP", "HKD", "HRK", "HUF", "IDR", "ILS", "INR", "IRR", "JPY", "KES", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RON", "RUB", "RUR", "SAR", "SEK", "SGD", "THB", "TRY", "UAH", "USD", "VEF", "XAU", "ZAR"};
```

```mathematica
lsExchanges = {"all", "bit-x", "bit2c", "bitbay", "bitcoin.co.id", "bitcoincentral", "bitcoinde", "bitcoinsnorway", "bitcurex", "bitfinex", "bitflyer", "bithumb", "bitmarketpl", "bitmex", "bitquick", "bitso", "bitstamp", "btcchina", "btce", "btcmarkets", "campbx", "cex.io", "clevercoin", "coinbase", "coinfloor", "exmo", "gemini", "hitbtc", "huobi", "itbit", "korbit", "kraken", "lakebtc", "localbitcoins", "mercadobitcoin", "okcoin", "paymium", "quadrigacx", "therocktrading", "vaultoro", "wallofcoins"};
```

```mathematica
lsTimeSpans = {"10m", "1h", "6h", "24h", "3d", "30d", "6m", "2y", "5y", "all"};
```

```mathematica
lsTimeUnit = {"second", "minute", "hour", "day", "week", "month"};
```

```mathematica
aDataTypeDescriptions = Association@{"price" -> "Prince", "volume" -> "Trading Volume", "rank" -> "Rank", "bidask_sum" -> "Bid/Ask Sum", "spread" -> "Bid/Ask Spread", "tradespm" -> "Trades Per Minute"};
lsDataTypes = Keys[aDataTypeDescriptions];
```

### Getting BTC data

Here we make a template string that for CSV data retrieval from data.bitcoinity.org:

```mathematica
stDBOURL = StringTemplate["https://data.bitcoinity.org/export_data.csv?currency=`currency`&data_type=`dataType`&exchange=`exchange`&r=`timeUnit`&t=l&timespan=`timeSpan`"]

(*TemplateObject[{"https://data.bitcoinity.org/export_data.csv?currency=", TemplateSlot["currency"], "&data_type=", TemplateSlot["dataType"], "&exchange=", TemplateSlot["exchange"], "&r=", TemplateSlot["timeUnit"], "&t=l&timespan=", TemplateSlot["timeSpan"]}, CombinerFunction -> StringJoin, InsertionFunction -> TextString]*)
```

Here is an association with default values for the string template above:

```mathematica
aDBODefaultParameters = <|"currency" -> "USD", "dataType" -> "price", "exchange" -> "all", "timeUnit" -> "day", "timeSpan" -> "all"|>;
```

**Remark:** The metadata assigned above is used to form valid queries for the query string template. 

**Remark:** Not all combinations of parameters are “fully respected” by data.bitcoinity.org. For example, if a data request is with time granularity that is too fine over a large time span, then the returned data is with coarser granularity.

#### Price for a particular currency and exchange pair

Here we retrieve data by overwriting the parameters for currency, time unit, time span, and exchange:

```mathematica
dsBTCPriceData = 
  ResourceFunction["ImportCSVToDataset"][stDBOURL[Join[aDBODefaultParameters, <|"currency" -> "EUR", "timeUnit" -> "hour", "timeSpan" -> "7d", "exchange" -> "coinbase"|>]]]
```

![0xcsh7gmkf1q5](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/0xcsh7gmkf1q5.png)

Here is a summary:

```mathematica
ResourceFunction["RecordsSummary"][dsBTCPriceData]
```

![0rzy81vbf5o23](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/0rzy81vbf5o23.png)

#### Volume data

Here we retrieve data by overwriting the parameters for data type, time unit, time span, and exchange:

```mathematica
dsBTCVolumeData = 
  ResourceFunction["ImportCSVToDataset"][stDBOURL[Join[aDBODefaultParameters, <|"dataType" -> Volume, "timeUnit" -> "day", "timeSpan" -> "30d", "exchange" -> "all"|>]]]
```

![1scvwhiftq8m2](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/1scvwhiftq8m2.png)

Here is a summary:

```mathematica
ResourceFunction["RecordsSummary"][dsBTCVolumeData]
```

![1bmbadd8up36a](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/1bmbadd8up36a.png)

### Plots

#### Price data

Here we extract the non-time columns in the tabular price data obtained above and plot the corresponding time series:

```mathematica
DateListPlot[Association[# -> Normal[dsBTCPriceData[All, {"Time", #}][Values]] & /@Rest[Normal[Keys[dsBTCPriceData[[1]]]]]], AspectRatio -> 1/4, ImageSize -> Large]
```

![136hrgyroy246](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/136hrgyroy246.png)

#### Volume data

Here we extract the non-time columns (corresponding to exchanges) in the tabular volume data obtained above and plot the corresponding time series:

```mathematica
DateListPlot[Association[# -> Normal[dsBTCVolumeData[All, {"Time", #}][Values]] & /@ Rest[Normal[Keys[dsBTCVolumeData[[1]]]]]], PlotRange -> All, AspectRatio -> 1/4, ImageSize -> Large]
```

![1tz1hw81b2930](https://raw.githubusercontent.com/antononcube/MathematicaVsR/master/Projects/CryptoCurrenciesDataAcquisitionAndAnalysis/Mathematica/Diagrams/Crypto-currencies-data-acquisition-with-visualization/1tz1hw81b2930.png)

## References

[DBO1] https://data.bitcoinity.org.

[WK1] Wikipedia entry, [Cryptocurrency](https://en.wikipedia.org/wiki/Cryptocurrency).

[YF1] Yahoo! Finance, [Cryptocurrencies](https://finance.yahoo.com/cryptocurrencies).