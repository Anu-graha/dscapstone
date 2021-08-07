## load the libraries

library(data.table)
library(dplyr)
library(stringr)
library(sqldf)

## load the data

dict<-readRDS("model_dict")

clean_text<-function(text){
  text<-tolower(text)
  text <- gsub("@\\w+", "", text)
  text <- gsub("https?://.+", "", text)
  text <- gsub("\\d+\\w*\\d*", "", text)
  text <- gsub("#\\w+", "", text)
  text <- gsub("[^\x01-\x7F]", "", text)
  text <- gsub("[[:punct:]]", " ", text)
  text
}

getNextWord<-function(input_text){
  input_text<-clean_text(input_text)
  s<-unlist(str_split(input_text," "))
  n<-length(s)
  alpha<-1
  # the model uses only upto quadgrams. 
  if(n>3){
    input_text<-paste(tail(s,3),collapse=" ")
    n<-3
  }
  # backoff, if the word is not present in the corpus
  if(Unseen(input_text,n)==TRUE & n==3){
      v<-paste(tail(s,n-1),collapse=" ")
      n<-n-1
      alpha<-0.4*alpha
      if(Unseen(v,n)==TRUE)
      {
        v<-paste(tail(s,n-1),collapse=" ")
        n<-n-1
        alpha<-0.4*alpha
      }
      res_table<-getScore(v, n, alpha)
  }
  else if(Unseen(input_text,n)==TRUE & n==2){
    v<-paste(tail(s,n-1),collapse=" ")
    n<-n-1
    alpha<-0.4*alpha
    nxtWord<-getScore(v, n, alpha)
  }
  else{
  nxtWord<-getScore(input_text, n, alpha)
  }
    nxtWord  
  }
  
getScore<-function(txt,n=1,alpha=1){
    freq_corpus<-dict[Word==txt & ngram==n,Freq]
    res<-dict[str_starts(dict$Word,txt) & ngram==(n+1),Word, (Freq/freq_corpus)*alpha]
    score<-head(res[order(-Freq,Word)],1)
    nxtword<-tail(unlist(str_split(score$Word, " ")),1)
    nxtword
  }

Unseen<-function(txt,n){
  c<-dict[Word==txt & ngram==n, Freq]
  if(length(c)==0){TRUE}
  else
    FALSE
}
