library(ggplot2)

test  <- data.frame(training_samp=c("Not Critical", "Pro-testing", "Encouraging"), 
                    total_svm=c(1227,470,129), 
                    total_nb=c(1913,2300,277), 
                    match_svm=c(360,168,68) , 
                    match_nb=c(287,204,78),
                    other_svm=c(0,6,32) , 
                    other_nb=c(0,34,42))



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
                               "Tweets aligned to training set code",
                               "Tweets that contain positive sentiment \n but are not aligned to training set code" 
                              )) +
  facet_grid(~ traning_samplef)+

  theme(legend.position="bottom")



