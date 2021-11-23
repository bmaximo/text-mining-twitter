packages <- c("stringr", "dplyr", "tidytext", "tm", "qdap", 
              "ggplot2", "wordcloud2", "readtext", "jsonlite", 
              "syuzhet", "lexiconPT", "magrittr")

if(sum(as.numeric(!packages %in% installed.packages())) != 0){
  instalador <- packages[!packages %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()
  }
  sapply(packages, require, character = T) 
} else {
  sapply(packages, require, character = T) 
}


