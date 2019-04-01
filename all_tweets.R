library(ggplot2)
library(scales)
library(stringr)
library(cowplot)
library(egg)
library(stringr)
library(dplyr)

# read in csvs from all time periods
# append together
# de-dup based on username and text 
# create on long presentation of the graph 
setwd("data")

dates = cbind("2013", "2014", "2015", "2016", "2017")
all_dates <- setNames(data.frame(matrix(ncol = 10, nrow = 0)), c("username","date","retweets", "favorites", "text", "geo", "mentions", 
                                                                 "hashtags", "id", "permalink"))
for (date in dates)
  {
    print("date")
    print(date)
    df <- read.csv(paste0(date,".csv"))
    print("read in all data: ")
    print(nrow(df))
    df$X <- NULL
    df$X.1 <- NULL
    df <- df[!duplicated(df[,c("username","text")],fromLast=T),]
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
  
    all_dates <- rbind.data.frame(all_dates, df)
    
  
}



dates = cbind("2013", "2014", "2015",
              "2016", "2017")

tiff("~/Dropbox/jree-r-r/for-submission/Images/figure2.tiff", units="in", width=10, height=2, res=300)
for (date in dates)

  {
  df <- read.csv(paste0(date,".csv"))
  df <- df[!(duplicated(df[c("username","text")])
           |duplicated(df[c("username","text")],
           fromLast=TRUE)),]
  df$date <- as.POSIXct(df$date, format = "%m/%d/%Y")
  date2 <- as.character(as.numeric(date)-1)

  
  p <- ggplot(df, aes(date, ..count..)) + 
    geom_histogram(bins = 25, col=I('black')) +
    theme_linedraw() +
    #theme_grey() + 
    xlab(NULL) +
    ylim(0,6000)+
    ggtitle(date)+
    labs(x="", y="")
    scale_x_datetime(breaks = date_breaks("1 month"),
                     labels = date_format("%m/%d/%Y"),
                     limits = c(as.POSIXct(paste0(date2,"-12-31")), 
                                as.POSIXct(paste0(date,"-05-31"))))
  
  assign(paste0("graph.",date), p)
}



ggarrange(graph.2013, graph.2014, graph.2015, graph.2016, graph.2017,
          
          ncol = 5)

dev.off()

