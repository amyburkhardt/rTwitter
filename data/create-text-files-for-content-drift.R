library(ggplot2)
library(scales)
library(WriteXLS)
library(openxlsx)
library(stringr)
setwd("~/Dropbox/rTwitter/data/")
year <- "2015"
df <- read.csv(paste0(year,".csv"))
print("read in all data: ")
print(nrow(df))
df$X <- NULL
df$X.1 <- NULL
df$date <- as.POSIXct(df$date, format = "%m/%d/%Y")

# remove duplicates
df <- df[!duplicated(df[,c("username","text")],fromLast=T),]
df$X <- NULL

print("number of observations after dedup")
print(nrow(df))

df$text <- as.character(df$text)
list_words <- read.delim("remove_tweets.txt", header = FALSE)


for (tweet_word in as.list(as.matrix(list_words)))
{
  df <- df %>% filter(str_detect(df$text, fixed(tweet_word, ignore_case=TRUE))==FALSE)
}


print("number of observations after removing keywords and phrases")
print(nrow(df))


df$month <- format(df$date, format= "%Y-%B")
time <- unique(df$month)
df$date <- as.Date(df$date)

df$id <- seq(1,nrow(df),1)

for (segment in time)
    
  {
    temp <- subset(df, df$month == segment)
    write_tsv(cbind.data.frame(temp$id, temp$text), paste0(segment,".txt"),col_names =FALSE)
  }
