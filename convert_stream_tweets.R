library(readtext)
library(jsonlite)
library(dplyr) 

#read txt archive
content <- file("data/your_strem_tweets.txt", open="rt")
res <- stream_in(content)

#convert txt to json
write(res$out, "data/output.json")

#read json and create create a twitter dataframe
tweetsDF <- readtext("data/output.json", source = "twitter")

#filter only portuguese content
tweetsDF <- tweetsDF %>% filter(lang == "pt")

#save dataframe
save(tweetsDF, file = "data/tweetsDF.RData")

#load dataframe
load("data/tweetsDF.RData")
