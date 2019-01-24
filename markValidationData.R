library(data.table)
library(WriteXLS)
library(openxlsx)

iteration <- "iter6"

code <- "narrowing"

setwd("~/Documents/NLP/Code/Classifiers-for-qual/classifier")


pos_april <- fread(paste0("output/reasons/SVC-april-",iteration,"_out_class1.txt"))
pos_march <- fread(paste0("output/reasons/SVC-march-",iteration,"_out_class1.txt"))

colnames(pos_april)[2] <- "text"
colnames(pos_march)[2] <- "text"

# read in the POS training data
training <- fread(paste0("/Users/amyburkhardt/Documents/NLP/Code/Classifiers-for-qual/reasons/POS-",iteration,"-reasons.txt"))
training$inTrain <- 1
colnames(training)[1] <- "id"
colnames(training)[2] <- "text"
#training$`Tweet text` <- NULL

matched_april <- merge(training,pos_april, by.x = "text", by.y = "text", all.y=TRUE)
matched_april$V1 <- NULL
matched_april$id <- NULL

matched_march <- merge(training,pos_march, by.x = "text", by.y = "text", all.y=TRUE)
matched_march$V1 <- NULL
matched_march$id <- NULL
#missing <- nomatch_a <- training[ !training$id %in% unique(pos$V1) , ]

# write out file: tab 1 positives and tab 2 negatives
wb <- createWorkbook("CREATOR")

freezePane(wb, sheet, firstActiveRow = NULL, firstActiveCol = NULL,
           firstRow = FALSE, firstCol = FALSE)
hs1 <- createStyle(fgFill = "#DCE6F1", halign = "CENTER",
                   border = "Bottom")
addWorksheet(wb, "March")
writeData(wb, "March", matched_march, headerStyle = hs1)
addWorksheet(wb, "April")
writeData(wb, "April", matched_april, headerStyle = hs1)

saveWorkbook(wb, file=paste0("output/reasons/","results-march-april-",iteration,"-",code,".xlsx"), overwrite = TRUE)
