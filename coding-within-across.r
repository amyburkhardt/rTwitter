# read in the spreadsheet
# create plots of the total count, and then the number that are not critical
library(readxl)
library(ggplot2)
library(cowplot)

setwd("~/Dropbox/rTwitter/")

get_melted <- function(months, years, within_2015)
  
    {
          tabs <- as.data.frame(c("All-Flagged","-","--","Ambiguous","Critical","Encouraging","Neutral","In favor of testing"), stringASFactors = FALSE)
          colnames(tabs)[1] <- "code"
          for (year in years)
          {
            for (month in months)
            {
              tab <- paste0(year,"-",month)
              tmp <- read_excel("all_months_scored.xlsx", sheet = tab)
              tmp <- subset(tmp, !is.na(tmp$`Not Critical?`))
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
          
          if (within_2015 == 0)
              {
                  positive <- as.numeric(positive[1,2:6]) + as.numeric(positive[2,2:6])
                  total <- subset(tabs, tabs$code == "All-Flagged" | tabs$code == "--")
                  tot2 <- as.numeric(total[2,2:6]) -as.numeric(total[1,2:6]) 
                  prop <- round(positive/tot2,2)
                  pos <- rep(tot2, each=5)
                  labels <- unlist(lapply(as.character(prop), function(x) c(rep("", 4), x)))
                  tabs$`2016-April` <- as.numeric(as.character(tabs$`2016-April`))
                  tabs[is.na(tabs)] <- 0
                  melted <- melt(tabs, "code")
                
          }
          
          
          if (within_2015 == 1)
          {
              positive <- subset(tabs, tabs$code == "In favor of testing" | tabs$code == "Encouraging")
              positive <- as.numeric(positive[1,2:4]) + as.numeric(positive[2,2:4])
              total <- subset(tabs, tabs$code == "All-Flagged" | tabs$code == "--")
              tot2 <- as.numeric(total[2,2:4]) -as.numeric(total[1,2:4]) 
              prop <- round(positive/tot2,2)
              pos <- rep(tot2, each=5)
              labels <- unlist(lapply(as.character(prop), function(x) c(rep("", 4), x)))
              tabs[is.na(tabs)] <- 0
              melted <- melt(tabs, "code")
          }

          melted$newcode <- NA
          melted$newcode <- ifelse(melted$code == "Critical","a_Critical", melted$newcode)
          melted$newcode <- ifelse(melted$code == "In favor of testing","e_In favor of testing", melted$newcode)
          melted$newcode <- ifelse(melted$code == "Encouraging","d_Encouraging", melted$newcode)
          melted$newcode <- ifelse(melted$code == "Ambiguous","b_Ambiguous", melted$newcode)
          melted$newcode <- ifelse(melted$code == "Neutral","c_Neutral", melted$newcode)
          melted$code <- NULL
          
          melted$value <- as.numeric(melted$value)
          melted <- subset(melted, melted$newcode == "a_Critical"| melted$newcode=="e_In favor of testing"| melted$newcode=="d_Encouraging"  | melted$newcode=="b_Ambiguous" 
                           | melted$newcode=="c_Neutral")
          
          
          
          melted$date <- NA
          melted$date <- paste0("04/01/",substr(melted$variable,3,4))
          melted$dat2 <- as.Date.character(melted$date, "%m/%d/%y")
          
          
          melted <- melted[order(melted$dat2),]
          row.names(melted) <- NULL
          melted$variable <- reorder(melted$variable, as.numeric(rownames(melted)))
          rowreorder <- as.numeric(rownames(melted))
          return(list(melted, pos, labels))
      
    }


melted_across <- get_melted(months <- c("April"), years <- c("2017", "2016", "2015", "2014", "2013"),0)
melted_within <- get_melted(months <- c("February", "March", "April"), years <- c("2015"),1)

tiff("~/Dropbox/rTwitter/for-pub/figure4.tiff", units="in", width=10, height=5, res=300)


legend_title <- "Composition of Tweets"

 
melted <- as.data.frame(melted_across[1])
pos <-as.numeric(unlist(melted_across[2]))
labels <- as.character(unlist(melted_across[3]))

across <- ggplot(melted, aes(x = (reorder(x=variable,as.numeric(rownames(melted)))), y = value, fill = newcode)) + 
  geom_bar(stat = 'identity', position = 'stack') + 
  theme_linedraw() +
  theme(legend.position="none")+
  geom_text(aes(y=rev(pos),label=rev(labels)), vjust=0)+
  labs(x="Across Years", y=paste0("Count of Tweets Automatically Classified as 'Not Critical'","\n","(Precision)"))+
  scale_fill_grey(start = .9, end = 0,labels = c("Critical",
                                                 "Ambiguous", 
                                                 "Neutral",
                                                 "Encouraging", 
                                                "In favor of testing")
            

                  
  ) 

melted_w <- as.data.frame(melted_within[1])
pos_w <-as.numeric(unlist(melted_within[2]))
label_w <- as.character(unlist(melted_within[3]))

within <- ggplot(melted_w, aes(x = (reorder(x=variable,as.numeric(rownames(melted_w)))), y = value, fill = newcode)) + 
  geom_bar(stat = 'identity', position = 'stack') + 
  theme_linedraw() +
  theme(legend.position="right")+
  geom_text(aes(y=pos_w,label=label_w), vjust=0)+
  labs(x="Within Year", y="")+
  scale_fill_grey(legend_title, start = .9, end = 0,labels = c("Critical",
                                                  "Ambiguous", 
                                                  "Neutral",
                                                  "Encouraging", 
                                                  "In favor of testing")
                  
  ) 

plot_grid(across, within, labels="")

dev.off()
