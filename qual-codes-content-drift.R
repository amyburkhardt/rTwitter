# read in the spreadsheet
# create plots of the total count, and then the number that are not critical
library(readxl)

years <- c("2017", "2016", "2015", "2014", "2013")
months <- c("April")
setwd("~/Dropbox/rTwitter/")
tabs <- as.data.frame(c("All-Flagged","-","--","Ambiguous","Critical","Encouraging","Neutral","Pro-testing"), stringASFactors = FALSE)
colnames(tabs)[1] <- "code"
for (year in years)
{
  for (month in months)
  {
    tab <- paste0(year,"-",month)
    print(tab)
    tmp <- read_excel("mock-up-all_months_scored.xlsx", sheet = tab)
    print(nrow(tmp))
    tmptab <- as.data.frame(table(tmp$`Not Critical?`))
    flagged <- as.data.frame(cbind("All-Flagged", nrow(tmp)), stringASFactors = FALSE)
    colnames(flagged) <- c("Var1", "Freq") 


          if (tab == "2015-April")
            {
              tmptab$tmp <- NA
              tmptab$tmp <- ifelse(tmptab$Var1 == "0","Critical", tmptab$Var1)
              tmptab$tmp <- ifelse(tmptab$Var1 == "1","Pro-testing", tmptab$tmp)
              tmptab$Var1 <- NULL
              colnames(tmptab)[2] <- "Var1"
              tmptab <- rbind(tmptab,flagged)
              colnames(tmptab) <- c(tab, "Var1")
            }
          else
          {
            tmptab <- rbind(tmptab,flagged)
            colnames(tmptab) <- c("Var1", tab)
          }

          tabs <- merge(x=tabs,y=tmptab, by.x ="code", by.y ="Var1", all.x=TRUE)

  }
}


tabs$`2016-April` <- as.numeric(as.character(tabs$`2016-April`))
tabs[is.na(tabs)] <- 0
melted <- melt(tabs, "code")
melted$value <- as.numeric(melted$value)
#melted <- subset(melted, melted$code == "All-Flagged" | melted$code=="Pro-testing" | melted$code=="Encouraging" | melted$code=="Neutral" | melted$code=="Critical")
melted <- subset(melted, melted$code == "Critical"| melted$code=="Pro-testing"| melted$code=="Encouraging"  | melted$code=="Ambiguous" 
                 | melted$code=="Neutral")

ggplot(melted, aes(x = variable, y = value, fill = code,
                   ggplot(melted, aes(x = variable, y = value, 
                                      fill = code ))))+ 
  
  geom_bar(stat = 'identity', position = 'stack',  colour="black") + 
  theme_linedraw() +
  labs(x="Year-Month", y="Tweets classified as Not Critical")+
  scale_fill_manual(name="", values=c("black","white","light grey", "dark grey", "brown"), 
                    breaks=c("Critical", "Pro-testing", "Encouraging", "Ambiguous", "Neutral"),
                    labels = c("Critical", "In favor of testing", "Encouraging","Ambiguous", "Neutral")
                    ) +
  #facet_grid(~ variable)+
  
  theme(legend.position="bottom", text = element_text(size=16))

