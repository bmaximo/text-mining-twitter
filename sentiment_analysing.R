library(syuzhet)

sentiments <- get_nrc_sentiment(tweetWords$term, language = "portuguese")

sentiments <- cbind("Words" = tweetWords$term, sentiments)

save(sentiments, file = "data/sentiments.RData")
load("data/sentiments.RData")

sentimentsScore <- data.frame("Score" = colSums(sentiments[2:11]))

totalSentiments <- cbind("Sentiment" = rownames(sentimentsScore), sentimentsScore)


library(ggplot2)

ggplot(data = totalSentiments) +
  geom_bar(aes(x = Sentiment, y = Score, fill = Sentiment), stat="identity")
