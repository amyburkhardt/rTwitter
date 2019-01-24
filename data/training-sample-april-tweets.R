library(ggplot2)
library(reshape2)

test  <- data.frame(training_samp=c("Not Critical", "Pro-testing", "Encouraging"), 
                    total_svm=c(1227,470,128), 
                    total_nb=c(1913,2300,277), 
                    match_svm=c(360,168,68) , 
                    match_nb=c(318,239,78),
                    other_svm=c(0,6,32) , 
                    other_nb=c(0,35,42))



melted <- melt(test, "training_samp")

melted$cat <- ''
melted[melted$variable == 'total_svm',]$cat <- "SVM"
melted[melted$variable == 'total_nb',]$cat <- "NB"
melted[melted$variable == 'match_svm',]$cat <- "SVM"
melted[melted$variable == 'match_nb',]$cat <- "NB"
melted[melted$variable == 'other_svm',]$cat <- "SVM"
melted[melted$variable == 'other_nb',]$cat <- "NB"
melted$variablef <- factor(melted$variable, levels=c(
                           "total_svm",
                           "total_nb",
                           "other_svm",
                           "other_nb",
                           "match_svm",
                           "match_nb"
                           ))
melted$traning_samplef = factor(melted$training_samp, 
                                levels = c("Not Critical", "Pro-testing", "Encouraging"))

tiff("~/Desktop/JREE-manuscript/figure2.tiff", units="in", width=10, height=5, res=300)
#insert ggplot code

ggplot(melted, aes(x = cat, y = value, fill = variablef,
                   ggplot(melted, aes(x = cat, y = value, 
                                      fill = variable ))))+ 
                                      
  geom_bar(stat = 'identity', position = 'stack',  colour="black") + 
  theme_linedraw() +
  labs(x="Classifier", y="Number of Tweets")+
  scale_fill_manual(name="", values=c("white","white","gray33","gray33","gray", "gray"), 
                    breaks=c("total_svm",
                             "match_svm",
                             "other_svm"),
                    labels = c("Tweets positively classified by model",
                               "Tweets align to training set code",
                               "Tweets contain positive sentiment \n but do not align to training set code" 
                              )) +
  facet_grid(~ traning_samplef)+

  theme(legend.position="bottom", text = element_text(size=16))

dev.off()

