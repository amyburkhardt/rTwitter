library(ggplot2)
library(scales)
library(WriteXLS)
library(openxlsx)
library(stringr)

year <- "2017"
df <- read.csv(paste0(year,".csv"))
df$text=str_replace_all(df$text,"[^[:graph:]]", " ") 
df$permalink=str_replace_all(df$permalink,"[^[:graph:]]", " ") 
df$date <- as.POSIXct(df$date, format = "%m/%d/%Y")

# remove duplicates
df <- df[!duplicated(df[,c("username","text")],fromLast=T),]

#remove off-topic 
list_words <- read.delim("remove_tweets.txt", header = FALSE)

for (tweet_word in as.list(as.matrix(list_words)))
{
  df <- df %>% filter(str_detect(df$text, fixed(tweet_word, ignore_case=TRUE))==FALSE)
}


date2 <- as.character(as.numeric(year)-1)

print(date2)
print(year)


p <- ggplot(df, aes(date, ..count..)) + 
  geom_histogram(bins = 28, col=I('white')) +
  theme_grey() + xlab(NULL) +
  scale_x_datetime(breaks = date_breaks("1 month"),
                   labels = date_format("%m/%d/%Y"),
                   limits = c(as.POSIXct(paste0(date2,"-12-31")), 
                              as.POSIXct(paste0(year,"-06-01"))))

p




df$month <- format(df$date, format= "%Y-%B")
time <- unique(df$month)
df$date <- as.Date(df$date)

i=0
dfnames <- NA


wb <- createWorkbook("CREATOR")
options("openxlsx.dateFormat" = "mm/dd/yyyy")
freezePane(wb, sheet, firstActiveRow = NULL, firstActiveCol = NULL,
           firstRow = FALSE, firstCol = FALSE)
hs1 <- createStyle(fgFill = "#DCE6F1", halign = "CENTER",
                   border = "Bottom")
addWorksheet(wb, "tweet_distribution")
insertPlot(wb, "tweet_distribution",width = 6, height = 4, xy = NULL, startRow = 1,
           startCol = 1, fileType = "png", units = "in", dpi = 300)

for (segment in time)
  
  {

    addWorksheet(wb, segment)
    temp <- subset (df, df$month == segment)

    writeData(wb, segment, temp, headerStyle = hs1)
    setColWidths(wb, sheet = segment, cols = 1:5, widths = "auto")
    


}

saveWorkbook(wb, file=paste0("tweet-results-by-month-",year,"_dups_ot_removed.xlsx"), overwrite = TRUE)

