##---
## Title: Statements saliency in podcasts
## Author: Anton Antonov
## Start date: 2016-09-17
##---

## The purpose of this file is to have an executable script that demonstrates 
##  1. the scraping (ingestion, processing) of a document collection from 
##     the web, and
##  2. the application of algebraic algorithms based on the Bag-of-words model
##     in order to  determine most important sentences within a document.

## The selected collection of documents is a set of podcast transcripts from 
## the Frekonomics radio site: http://freakonomics.com .

## For a full description of the algorithm for the determination of sentences 
## (statements) saliency see :
##   Chapter 13, "Automatic Key Word and Key Sentence Extraction" of the book 
##   Matrix Methods in Data Mining and Pattern Recognition, 2007, SIAM,
##   by Lars Elden.


library(plyr)
library(httr)
library(XML)
library(rvest)
library(irlba)
library(devtools)
library(lattice)

if ( !exists("SMRMakeDocumentTermMatrix") ) {
 source_url( "https://raw.githubusercontent.com/antononcube/MathematicaForPrediction/master/R/DocumentTermWeightFunctions.R" )
}
  
##===========================================================
## Get hyperlinks
##===========================================================
if ( FALSE || !exists("podcastLinks") ) {
  
  url <- "http://www.freakonomics.com/category/podcast-transcripts/page/2/"  
  x <- GET(url, add_headers('user-agent' = 'r'))
  res <- read_html( x = x )

  ## These two lines do the same thing:
  # hlinks <- res %>% html_nodes("a") %>% html_attr("href")
  # hlinks <- html_attr( html_nodes( res, "a"), "href")
  # hlinks <- grep( pattern = "full-transcript/$", x = hlinks, value = TRUE )

  podcastLinks <- 
    llply( 1:17, function(pg) { 
      url <- paste( "http://www.freakonomics.com/category/podcast-transcripts/page/", pg, sep="")
      x <- GET(url, add_headers('user-agent' = 'r'))
      res <- read_html( x = x )
      hlinks <- html_attr( html_nodes( res, "a"), "href")
      grep( pattern = "full-transcript/$", x = hlinks, value = TRUE )
    }, .progress = "time" ) 
  
  podcastLinks <- unlist(podcastLinks)
}


##===========================================================
## Get podcast transcripts
##===========================================================
if ( FALSE || !exists("podcastPages") ) {

  cat("\n\tDownloading podcast pages...\n")  

  if ( !exists("podcastPages") ) {
    cat( "computed 'podcastPages' again ... \n")
    podcastPages <-
      llply( podcastLinks, function(hl) {
        x <- GET( hl, add_headers('user-agent' = 'r'))
        read_html( x = x )
      }, .progress = "none" )
  }
  
  cat("\n\tParsing podcast pages texts...\n")  
  
  podcastTexts <- 
    llply( podcastPages, function(pg) {
      html_text( html_nodes( pg, "p" ) )
    }, .progress = "none" )
 
  cat("\n\tParsing podcast pages titles...\n")  
  
  podcastTitles <- 
    llply( podcastPages, function(pg) {
      html_text( html_nodes( pg, "title" ))
    }, .progress = "none" )
  
  pat <- "Full Transcript - Freakonomics Freakonomics"
  podcastTitles <- gsub( pattern = pat, replacement = "", x = podcastTitles, fixed = TRUE )
  podcastTitles <- gsub( pattern = paste( ":", pat ), replacement = "", x = podcastTitles, fixed = TRUE )
  
} else {
  cat("\n\tUsing previously downloaded pages...\n")  
}

##===========================================================
## Transcripts processing
##===========================================================
if ( FALSE || !exists("podcastTexts4") ) {
  
  cat("\n\tPodcast transcripts processing...\n")  
  
  ## The pattern "^\\[[[:upper:]]*" is used to remove lines like:
  ## "[MUSIC: Interkosmos, “Tickticktock” (from London Mix)]"
  podcastTexts2 <- 
    llply( podcastTexts, function(plines) {
      grep( pattern = "^\\[[[:upper:]]*", x = plines, invert = TRUE, value = TRUE )
    }, .progress = "time" )
  
  grep( pattern = "^\\[[[:upper:]]*", x = c("[MUSIC: Interkosmos, “Tickticktock” (from London Mix)]"), value = TRUE)

  gsub( "^[[:upper:]]*\\:", "", c("DUBNER: Among the many potential virtues of posting messages like these is the cost, which is very low.") )

  ## Select paragraphs that start with names like:
  ## DUBNER:
  ## Sarah BOLT:
  podcastTexts3 <- 
    llply( podcastTexts2, function(plines) {
      grep( pattern = "(^[[:upper:]]*\\:)|(^[[:alpha:]]\\W[[:upper:]]*\\:)", x = plines, value = TRUE )
    }, .progress = "time" )
  
  
  ## Optional dropping of the speker names
  podcastTexts4 <- 
    llply( podcastTexts3, function(plines) {
      res <- gsub( pattern = "^[[:upper:]]*\\:", replacement = "", x = plines )
      gsub( "^(\\W*)", "", res )
    }, .progress = "time" )
 
  ## After finishing the experiments with parsing we assign to the original variable.
  podcastTexts <- podcastTexts4
  
}


##===========================================================
## Stop words 
##===========================================================
if ( FALSE || !exists("stopWords") ) {
  
  cat("\n\tObtaining stop words...\n")  
  
  stopWords <- read.table("http://www.textfixer.com/resources/common-english-words.txt", stringsAsFactors = FALSE)[[1]]
  stopWords <- strsplit( stopWords, "," )[[1]]
  # 
  # standardStopWords <- read.table("~/MathFiles/DataMining//stop_words", stringsAsFactors = FALSE)[[1]]
  # 
  
  if ( TRUE ) {
    cat("\n\t\tFinding new stop words...\n")
    cat("\n\t\t\tDocument-term matrix creation...\n")
    
    swMat <- SMRMakeDocumentTermMatrix( unlist(podcastTexts), split = "\\W", applyWordStemming = FALSE, minWordLength = 1 )
    swMat01 <- swMat; swMat01@x[ swMat01@x > 0 ] <- 1
    
    cat("\n\t\t\t\tDONE...\n")
    
    fr <- colSums(swMat01)/nrow(swMat01)
    quantile(fr)
    fr[order(-fr)[1:12]]
    
    newStopWords <- colnames(swMat01)[fr>0.14]
  } else {
    newStopWords <- NULL
  }
  
  stopWords <- unique( c( standardStopWords, newStopWords ) )
  
}

##===========================================================
## Words vs transcripts distributions 
##===========================================================
if ( FALSE || !exists("twMat") ) {
  
  twMat <- SMRMakeDocumentTermMatrix( laply( podcastTexts, function(x) paste( x, collapse = " ") ), split = "\\W", applyWordStemming = FALSE, minWordLength = 1 )
  twMat01 <- twMat; twMat01@x[ twMat01@x > 0 ] <- 1
  
  cat( "\n\tTranscripts x words :", dim(twMat), "\n" )
  
  print( histogram( log(colSums(twMat),10), type = "count", main = "Transcripts per word distribution", xlab = "lg(transcripts)", ylab = "words" ), split = c(1,1,1,2), more = TRUE )
  print( histogram( rowSums(twMat), type = "count", main = "Words per transcript distribution", xlab = "words", ylab = "transcripts" ), split = c(1,2,1,2), more = FALSE )

}  

##===========================================================
## Finding the most important sentences
##===========================================================
MostImportantSentences <- function( sentences, 
                                    nSentences = 5, 
                                    globalTermWeightFunction = "IDF", 
                                    split = "\\W", 
                                    applyWordStemming = FALSE,
                                    minWordLength = 2, 
                                    stopWords = NULL ) {
  
  swMat <- SMRMakeDocumentTermMatrix( documents = sentences, split = split, applyWordStemming = applyWordStemming, minWordLength = minWordLength )
  
  if ( !is.null(stopWords) ) {
    stopWords <- intersect( stopWords, colnames(swMat) )
    if ( length(stopWords) > 0 ) {
      swMat[, stopWords ] <- 0  
    }
  }
  
  
  wswMat <- SMRApplyTermWeightFunctions( docTermMat = swMat, 
                                         globalWeightFunction = globalTermWeightFunction, localWeightFunction = "None", normalizerFunction = "Cosine" )
  
  ## Using Eigenvector decomposition
  # wstSMat <- wswMat %*% t(wswMat)
  # eres <- eigen( wstSMat )
  # svec <- eres$vectors[,1]
  
  ## Using SVD
  svdRes <- irlba( A = wswMat, nv = nSentences )
  svec <- svdRes$u[,1]
  
  inds <- rev(order(abs(svec)))[1:nSentences]

  data.frame( Score = abs(svec)[inds], Sentence = sentences[inds], stringsAsFactors = FALSE)
}
  

if ( FALSE ) {
  
  qind <- 152
  podcastTitles[qind]
  res <- MostImportantSentences( sentences = podcastTexts[[qind]], nSentences = 5, stopWords = stopWords )
  res$Sentence
  plot(res$Score)

  MostImportantSentences( sentences = podcastTexts[[qind]], nSentences = 5, stopWords = stopWords, applyWordStemming = TRUE )
  MostImportantSentences( sentences = podcastTexts[[qind]], nSentences = 5, stopWords = NULL)
  MostImportantSentences( sentences = podcastTexts[[qind]], nSentences = 5, stopWords = NULL, applyWordStemming = TRUE)
  
}