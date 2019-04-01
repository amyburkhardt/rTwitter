library(data.table)
library(WriteXLS)
library(openxlsx)
library(readr)
setwd("~/Dropbox/rTwitter/input/")
set.seed(42)
all_files <- list.files()

# get POS training examples for march (by hand paste in with out the special character issue)

notcrit <- fread("/Users/amyburkhardt/Documents/NLP/Code/Classifiers-for-qual/classifier/POS-iter3a.txt")
notcrit$inTrain <- 1
colnames(notcrit)[1] <- "id"
colnames(notcrit)[2] <- "text"


march2015 <- read.csv("~/Dropbox/rTwitter/data/2015.csv")
march2015$date <- as.POSIXct(march2015$date, format = "%m/%d/%Y")
march20152 <- subset(march2015, march2015$dat >= "2015-03-01" & march2015$dat <= "2015-03-31")

matched <- merge(notcrit,march2015, by.x = "text", by.y = "text", all.x=TRUE)
write.csv(matched, "positive-2015_v2.csv")

# get NEG training examples for march

neg <- fread("/Users/amyburkhardt/Documents/NLP/Code/Classifiers-for-qual/classifier/NEG-iter3a.txt")
neg$inTrain <- 1
colnames(neg)[1] <- "id"
colnames(neg)[2] <- "text"

matched_neg <- merge(neg,march2015, by.x = "text", by.y = "text", all.x=TRUE)
write.csv(matched_neg, "negative-2015_v2.csv")


# get three neg training samples
neg2 <- fread("/Users/amyburkhardt/Documents/NLP/Code/Classifiers-for-qual/classifier/NEG-iter3b.txt")
neg3 <- fread("/Users/amyburkhardt/Documents/NLP/Code/Classifiers-for-qual/classifier/NEG-iter3c.txt")

match2 <- merge(neg, neg2, by.x="id", by.y="V1")
match3 <- merge(neg, neg3, by.x="id", by.y="V1")
