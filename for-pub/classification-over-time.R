library(ggplot2)
library(data.table)
library(WriteXLS)
library(openxlsx)
library(readr)



set.seed(42)
all_files <- list.files()

years <- c("2017", "2016", "2015", "2014", "2013")
months <- c("April", "February", "January", "March", "May")

# compute the total number of tweets
# compute the total number of tweets classified as Not Critical


saveinfo <- NA
for (year in years)
{
  for (month in months)
  {
    setwd("~/Dropbox/rTwitter/data/")
    tmp <- paste0(year,"-",month,".txt")
    tot <- nrow(fread(tmp, sep = "\t"))
    setwd("~/Dropbox/rTwitter/input/")
    tmp_class <- paste0(tmp,"_SVC-iter3a_out_class1.txt")
    classified <- nrow(fread(tmp_class, sep = "\t"))
    prop <- classified/tot
    info <- cbind(year, month, prop, classified)
    saveinfo <- rbind(saveinfo, info)
    
  }
  
}

saveinfo <- as.data.frame(saveinfo)
saveinfo <- subset(saveinfo, !is.na(saveinfo$year))
saveinfo$mth2 <- NA
saveinfo$mth2 <- ifelse(saveinfo$month == "January", "01", saveinfo$mth2)
saveinfo$mth2 <- ifelse(saveinfo$month == "February", "02", saveinfo$mth2)
saveinfo$mth2 <- ifelse(saveinfo$month == "March", "03", saveinfo$mth2)
saveinfo$mth2 <- ifelse(saveinfo$month == "April", "04", saveinfo$mth2)
saveinfo$mth2 <- ifelse(saveinfo$month == "May", "05", saveinfo$mth2)

saveinfo$date <- NA
saveinfo$date <- paste0(saveinfo$mth2,"/01/",substr(saveinfo$year,3,4))
saveinfo$date2 <- as.Date.character(saveinfo$date, "%m/%d/%y")
saveinfo$proportion <- as.numeric(as.character(saveinfo$prop))
row.names(saveinfo) <- NULL
saveinfo <- saveinfo[order(saveinfo$date2),]

saveinfo$datetext <- paste0(saveinfo$year,"-",saveinfo$month)
saveinfo$datetext <- reorder(saveinfo$datetext, as.numeric(rownames(saveinfo)))
rowreorder <- as.numeric(rownames(saveinfo))

classified <- saveinfo$classified
w.labels <- ggplot(aes(reorder(x=datetext,as.numeric(rownames(saveinfo))), y = saveinfo$proportion,group = 1, label=classified), data = saveinfo) + geom_line()+
  ylab("Proportion")+
  geom_text(aes(label=classified),hjust=0, vjust=0)+
  xlab("Month of tweets")+ theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  scale_x_discrete(limits = saveinfo$datetext)+
  ggtitle("Proportion (and counts) of text classified as 'Not Critical'")


tiff("~/Dropbox/jree-r-r/for-submission/Images/figure5.tiff", units="in", width=8, height=5, res=200)
# proportion of tweets classified as "Not Critical" by Month
ggplot(aes(reorder(x=datetext,as.numeric(rownames(saveinfo))), y = saveinfo$proportion,group = 1, label=classified), data = saveinfo) + geom_line()+
  ylab('Proportion of Tweets Classified as \n "Not Critical of Testing"')+
  xlab("Month of Tweets")+ theme(axis.text.x = element_text(angle = 90, hjust = 0))+
  scale_x_discrete(limits = saveinfo$datetext)+
  ggtitle("")

dev.off()
