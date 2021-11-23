library(stringr)
require(dplyr)
require(tidytext)
require(tm)
library(qdap)
library(ggplot2)
library(wordcloud2)

#Limpeza do texto com regex
tweetsDF$clean_text <- str_to_lower(tweetsDF$text)
#remove usuarios dos tweets que estão citados no texto
tweetsDF$clean_text <-str_replace_all(tweetsDF$clean_text,"@\\w+", " ")
#remove pontuação
tweetsDF$clean_text <- str_remove_all(tweetsDF$clean_text, "[[:punct:]]")
#remover letras repetidas que não são 'ss' e 'rr'
tweetsDF$clean_text <- str_replace_all(tweetsDF$clean_text,"([^rs])\\1+|(rr)(?=r+)|(ss)(?=s+)", "\\1")
#remover numeros
tweetsDF$clean_text <- str_replace_all(tweetsDF$clean_text,"[[:digit:]]", "")
#remover o que não é uma palavra
tweetsDF$clean_text <- str_replace_all(tweetsDF$clean_text,"\\W", " ")
#remover links
tweetsDF$clean_text <- str_replace_all(tweetsDF$clean_text,"http.+", "")
#remover espaços a mais
tweetsDF$clean_text <- str_squish(tweetsDF$clean_text)
tweetsDF$clean_text <- stringi::stri_trans_general(tweetsDF$clean_text,"Latin-ASCII")

#Remover palavras de parada
mystopwords <- c('rt', 'pra', 'ia', 'ta', 'td', 'q', 'to', 'n', 'k', 'to', stopwords("pt"))
tweetsDF$clean_text <- removeWords(tweetsDF$clean_text, mystopwords)

#Stemmização
tweetsDF$text_stemmer <- stemDocument(tweetsDF$clean_text, language = "portuguese")

#Salvar dataframe de palavras (Tokenização)
tweetWords <- tweetsDF %>%
  unnest_tokens(term, clean_text)

tweetWords <- tweetWords %>% 
  select(id_str, term)

tweetWords %>%
  count(term, sort = TRUE) %>%
  head(20)

#Salvar dataframe de palavras stemmizadas
tweetWords_stemmer <- tweetsDF %>%
  unnest_tokens(term, text_stemmer)

tweetWords_stemmer <- tweetWords_stemmer %>% 
  select(id_str, term)

tweetWords_stemmer %>%
  count(term, sort = TRUE) %>%
  head(20)


#Palavras com maior frequencia
tweetWords %>%
  count(term, sort = TRUE) %>%
  filter(n >= 1000) %>%
  mutate(term = reorder(term, n)) %>%
  ggplot(aes(term, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  theme_classic()

#Wordcloud
tweetWords %>% 
  count(term, sort = TRUE) %>% 
  filter(n > 300) %>%
  wordcloud2(size = 1, color='random-dark')
