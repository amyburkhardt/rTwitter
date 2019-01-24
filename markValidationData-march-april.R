library(data.table)
library(WriteXLS)
library(openxlsx)

iteration <- "iter3"
code <- "corporations"

setwd("~/Documents/NLP/Code/Classifiers-for-qual/classifier")


neg <- fread(paste0("output/reasons/SVC-march-",iteration,"_out_class0.txt"))
pos <- fread(paste0("output/reasons/SVC-march-",iteration,"_out_class1.txt"))
colnames(neg)[2] <- "text"
colnames(pos)[2] <- "text"

# read in the POS training data

training <- fread(paste0("/Users/amyburkhardt/Documents/NLP/Code/Classifiers-for-qual/reasons/POS-",iteration,"-reasons.txt"))
training$inTrain <- 1
colnames(training)[1] <- "id"
colnames(training)[2] <- "text"
#training$`Tweet text` <- NULL

matched <- merge(training,pos, by.x = "text", by.y = "text", all.y=TRUE)

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

saveWorkbook(wb, file=paste0("output/reasons/","results-march",iteration,"-",code,".xlsx"), overwrite = TRUE)
