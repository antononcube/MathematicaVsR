# MathematicaVsR data

## "Standard" data
   
- [Mushroom dataset](./MathematicaVsR-Data-Mushroom.csv).

- [Titanic dataset](./MathematicaVsR-Data-Titanic.csv).

- [Wine quality data](./MathematicaVsR-Data-WineQuality.csv). 

## Text data

### [Shakespeare's play "Hamlet" (1604)](./MathematicaVsR-Data-Hamlet.csv).

The text of "Hamlet" is available in Mathematica through `ExampleData`. 
[This CSV file](./MathematicaVsR-Data-Hamlet.csv), 
though, consists of separate play parts. (223 records.)  
   
### [USA presidential speeches](./MathematicaVsR-Data-StateOfUnionSpeeches.JSON.zip).
  
Here is how to ingest the zipped JSON data in Mathematica:

```mathematica
url = "https://github.com/antononcube/MathematicaVsR/blob/master/Data/MathematicaVsR-Data-StateOfUnionSpeeches.JSON.zip?raw=true";
str = Import[url, "String"];
filename = First@Import[StringToStream[str], "ZIP"];

aUSASpeeches = Association[Import[StringToStream[str], {"ZIP", filename, "JSON"}]];
Length[aUSASpeeches]
```
   
Here is how to ingest the zipped JSON data in R:

```r
library(jsonlite)
temp <- tempfile()
download.file("https://github.com/antononcube/MathematicaVsR/blob/master/Data/MathematicaVsR-Data-StateOfUnionSpeeches.JSON.zip?raw=true",temp)
jsonRes <- jsonlite::fromJSON(unz(temp, "MathematicaVsR-Data-StateOfUnionSpeeches.JSON"))
length(jsonRes)
```

## R data packages

Here is corresponding R data package: 
[MathematicaVsRData](https://github.com/antononcube/R-packages/tree/master/MathematicaVsRData).  