library(data.table)
library(WriteXLS)
library(openxlsx)
library(readr)
setwd("~/Dropbox/rTwitter/input/")
set.seed(42)
all_files <- list.files()

# get POS training examples for march

training <- fread("/Users/amyburkhardt/Documents/NLP/Code/Classifiers-for-qual/classifier/POS-iter3a.txt")
training$inTrain <- 1
colnames(training)[1] <- "id"
colnames(training)[2] <- "text"

#create workbook
workbook <- createWorkbook("CREATOR")
freezePane(workbook, sheet, firstActiveRow = NULL, firstActiveCol = NULL,
           firstRow = FALSE, firstCol = FALSE)
hs1 <- createStyle(fgFill = "#DCE6F1", halign = "CENTER",
                   border = "Bottom")
setColWidths(workbook, sheet = segment, cols = 1:5, widths = "auto")
total = 0
for (filename in all_files)
  {
  
    tabname <- gsub("(^[^.]*)([.])(.*)",'\\1',filename)

    addWorksheet(workbook, tabname)
    print(filename)
    temp <- read_tsv(filename, col_names = FALSE)

    temp<- temp[sample(nrow(temp), round(nrow(temp)*.1,0)), ]
    total = total + nrow(temp)
    print(total)
    if (filename == "2015-March.txt_SVC-iter3a_out_class1.txt")
      {
      matched <- merge(training,temp, by.x = "text", by.y = "X2", all.y=TRUE)
      matched$not_critical <- NA
      temp <- cbind.data.frame(matched$X1, matched$inTrain, matched$not_critical, matched$text)
      colnames(temp) <- c("ID", "In Training Sample", "Not Critical?", "Tweet")
      writeData(workbook, tabname, temp, headerStyle = hs1)
      setColWidths(workbook, sheet = tabname, cols = 1:4, widths = "auto")
      freezePane(workbook, sheet = tabname, firstActiveRow = 2, firstActiveCol = NULL,
                 firstRow = FALSE, firstCol = FALSE)
      }
    else
    {
      temp$not_critical <- NA
      temp <- cbind.data.frame(temp$X1, temp$not_critical, temp$X2)
      colnames(temp) <- c("ID", "Not Critical?", "Tweet")
      writeData(workbook, tabname, temp, headerStyle = hs1)
      setColWidths(workbook, sheet = tabname, cols = 1:3, widths = "auto")
      freezePane(workbook, sheet = tabname, 
                 firstRow = TRUE, firstCol = TRUE)
    }
  }
  
  
saveWorkbook(workbook, file=paste0("~/Dropbox/rTwitter/output/all_months_scored_random_sample.xlsx"), overwrite = TRUE)
