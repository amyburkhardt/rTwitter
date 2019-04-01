library(readxl)
library(ggplot2)
library(data.table)
years <- c("2015")
months <- c("February", "March", "April")

setwd("~/Dropbox/rTwitter/")
tabs <- as.data.frame(c("All-Flagged","-","--","Ambiguous","Critical","Encouraging","Neutral","In favor of testing"), stringASFactors = FALSE)
colnames(tabs)[1] <- "code"
for (year in years)
{
  for (month in months)
  {
    tab <- paste0(year,"-",month)
    tmp <- read_excel("all_months_scored.xlsx", sheet = tab)
    tmp <- subset(tmp, !is.na(tmp$`Not Critical?`))
    if (month == "March")
      
    {
      tmp <- subset(tmp, is.na(tmp$`In Training Sample`)) # remove responses that were used in the training data
    }
    
    tmptab <- as.data.frame(table(tmp$`Not Critical?`))
    flagged <- as.data.frame(cbind("All-Flagged", nrow(tmp)), stringASFactors = FALSE)
    colnames(flagged) <- c("Var1", "Freq") 
    
    

    tmptab <- rbind(tmptab,flagged)
    print(paste(month, year,":"))
    print(tmptab)
    colnames(tmptab) <- c("Var1", tab)
    tabs <- merge(x=tabs,y=tmptab, by.x ="code", by.y ="Var1", all.x=TRUE)
    
  }
}

positive <- subset(tabs, tabs$code == "In favor of testing" | tabs$code == "Encouraging")
positive <- as.numeric(positive[1,2:4]) + as.numeric(positive[2,2:4])
total <- subset(tabs, tabs$code == "All-Flagged" | tabs$code == "--")
tot2 <- as.numeric(total[2,2:4]) -as.numeric(total[1,2:4]) 
prop <- round(positive/tot2,2)
pos <- rep(tot2, each=5)

labels <- unlist(lapply(as.character(prop), function(x) c(rep("", 4), x)))

tabs[is.na(tabs)] <- 0
melted <- melt(tabs, "code")
melted$value <- as.numeric(melted$value)
melted <- subset(melted, melted$code == "Critical"| melted$code=="In favor of testing"| melted$code=="Encouraging"  | melted$code=="Ambiguous" 
                 | melted$code=="Neutral")
melted$newcode <- NA
melted$newcode <- ifelse(melted$code == "Critical","a_Critical", melted$newcode)
melted$newcode <- ifelse(melted$code == "In favor of testing","e_In favor of testing", melted$newcode)
melted$newcode <- ifelse(melted$code == "Encouraging","d_Encouraging", melted$newcode)
melted$newcode <- ifelse(melted$code == "Ambiguous","b_Ambiguous", melted$newcode)
melted$newcode <- ifelse(melted$code == "Neutral","c_Neutral", melted$newcode)
melted$code <- NULL

melted$date <- NA
melted$date <- paste0("04/01/",substr(melted$variable,3,4))
melted$dat2 <- as.Date.character(melted$date, "%m/%d/%y")


melted <- melted[order(melted$dat2),]
row.names(melted) <- NULL
melted$variable <- reorder(melted$variable, as.numeric(rownames(melted)))
rowreorder <- as.numeric(rownames(melted))


tiff("~/Dropbox/rTwitter/for-pub/figure4.tiff", units="in", width=10, height=5, res=300)

ggplot(melted, aes(x = (reorder(x=variable,as.numeric(rownames(melted)))), y = value, fill = newcode)) + 
  geom_bar(stat = 'identity', position = 'stack',  colour="black") + 
  theme_linedraw() +
  geom_text(aes(y=pos,label=labels), vjust=0)+
  labs(x="", y="Coding of Tweets Automatically Classified as 'Not Critical'")+
  scale_fill_manual(name="", values=c("white","#D3D3D3","#A9A9A9", "#787878", "black"), 
                    breaks=c("a_Critical",
                             "b_Ambiguous",
                             "c_Neutral",
                             "d_Encouraging",
                             "e_In favor of testing"),
                    labels = c("Critical",
                               "Ambiguous", 
                               "Neutral",
                               "Encouraging", 
                               "In favor of testing")
  ) 


dev.off()
