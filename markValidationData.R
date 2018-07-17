library(data.table)
library(WriteXLS)
library(openxlsx)

iteration <- "iter4b"
code <- "encouragement"

setwd("~/Documents/NLP/Code/Classifiers-for-qual/classifier")

# read in the output file of the classification
april <- fread("april_tweets.txt")
test <- fread("april_tweets_withdups_ot.txt")
neg <- fread(paste0("output/",iteration,"/","SVC-",iteration,"_out_class0.txt"))
pos <- fread(paste0("output/",iteration,"/","SVC-",iteration,"_out_class1.txt"))
colnames(neg)[2] <- "text"
colnames(pos)[2] <- "text"

# read in the POS training data

training <- fread(paste0("POS-",iteration,".txt"))
training$inTrain <- 1
training$`Tweet text` <- NULL
# identify the responses in pos that are also in training 

matched <- merge(training,pos, by.x = "id", by.y = "V1", all.y=TRUE)
missing <- nomatch_a <- training[ !training$id %in% unique(pos$V1) , ]

# write out file: tab 1 positives and tab 2 negatives
wb <- createWorkbook("CREATOR")

freezePane(wb, sheet, firstActiveRow = NULL, firstActiveCol = NULL,
           firstRow = FALSE, firstCol = FALSE)
hs1 <- createStyle(fgFill = "#DCE6F1", halign = "CENTER",
                   border = "Bottom")
addWorksheet(wb, code)
writeData(wb, code, matched, headerStyle = hs1)
addWorksheet(wb, "Negative")
writeData(wb, "Negative", neg, headerStyle = hs1)

saveWorkbook(wb, file=paste0("output/",iteration,"/","results-",iteration,"-",code,".xlsx"), overwrite = TRUE)
