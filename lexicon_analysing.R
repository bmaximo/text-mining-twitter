library(lexiconPT)
library(magrittr)

data("sentiLex_lem_PT02")
data("oplexicon_v3.0")

op30 <- oplexicon_v3.0
sent <- sentiLex_lem_PT02


tweet_polarity <- tweetWords %>% 
  inner_join(op30, by = "term") %>% 
  inner_join(sent %>% select(term, lex_polarity = polarity), by = "term") %>% 
  group_by(id_str) %>% 
  summarise(
    comment_sentiment_op = sum(polarity),
    comment_sentiment_lex = sum(lex_polarity),
    n_words = n()
  ) %>% 
  ungroup() %>% 
  rowwise() %>% 
  mutate(
    most_neg = min(comment_sentiment_lex, comment_sentiment_op),
    most_pos = max(comment_sentiment_lex, comment_sentiment_op)
  )

head(tweet_polarity)


tweet_polarity %>% 
  ggplot(aes(x = comment_sentiment_op, y = comment_sentiment_lex)) +
  geom_point(aes(color = n_words)) + 
  scale_color_continuous(low = "green", high = "red") +
  labs(x = "Polaridade no OpLexicon", y = "Polaridade no SentiLex") +
  geom_smooth(method = "lm") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_hline(yintercept = 0, linetype = "dashed")


tweet_polarity %<>% filter(between(comment_sentiment_op, -10, 10))

# comentario mais positivo e mais negativo
most_pos <- which.max(tweet_polarity$most_pos)
most_neg <- which.min(tweet_polarity$most_neg)

# mais positivo
cat(tweetsDF$screen_name[tweetsDF$id_str == tweet_polarity$id_str[most_pos]], ': ',
    tweetsDF$text[tweetsDF$id_str == tweet_polarity$id_str[most_pos]])

# mais negativo
cat(tweetsDF$screen_name[tweetsDF$id_str == tweet_polarity$id_str[most_neg]], ': ',
    tweetsDF$text[tweetsDF$id_str == tweet_polarity$id_str[most_neg]])
