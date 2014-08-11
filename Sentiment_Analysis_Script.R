## Load the libraries
library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)

## Download the pem authentication file
download.file(url="http://curl.haxx.se/ca/cacert.pem",
              destfile="certificate/cacert.pem")

## Store the key
my.key <- "c7ncGijIQC1WkwKxRpcCyVB9G"
my.secret <- "Dvo4SdopNLXPocTBfFtutdLxxi1LbrwzcazhZxwdiQ0qRDsOJY"

## Inititalize Authentication
cred <- OAuthFactory$new(consumerKey=my.key,
                         consumerSecret=my.secret,
                         requestURL='https://api.twitter.com/oauth/request_token',
                         accessURL='https://api.twitter.com/oauth/access_token',
                         authURL='https://api.twitter.com/oauth/authorize')

## Initialize handshake
cred$handshake(cainfo="certificate/cacert.pem")

## Save the verified handshake
save(cred, file="twitter authentication.Rdata")

## Register with the application
registerTwitterOAuth(cred)

## SEARCH LIMIT ON THE BELOW FUNCTION !
bigdata <- searchTwitter("#BigData", n=100, cainfo="cacert.pem")

# conversion from list to data frame
bigdata.df <- do.call(rbind, lapply(bigdata, as.data.frame))

bigdata_list <- sapply(bigdata, function(x) x$getText())

bigdata_corpus <- Corpus(VectorSource(bigdata_list))
bigdata_corpus <- tm_map(bigdata_corpus, content_transformer(tolower))
bigdata_corpus <- tm_map(bigdata_corpus, removePunctuation)
bigdata_corpus <- tm_map(bigdata_corpus,   function(x)removeWords(x,stopwords()))

## Create a palette
palette <- brewer.pal(8, "Accent")
palette <- palette[-(1:2)]

# Create a png and define where it will be saved and named
> png(filename="plots/wordcloud.png")

# Create a wordcloud and define the words and their frequencies as well as how those word sizes will scale.
> bb_wordcloud <- wordcloud(bigdata_corpus, colors=palette)
# dev.off will complete the plot and save the png
> dev.off()