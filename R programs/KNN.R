#load the output from the W22_P2_preprocessing.R file
load('processed_text.RData')

# KNN
library(class)
knn.fit <- knn(Xtrain, Xtest, Ytrain, k=100)


# write the file for kaggle submission
out.df <- data.frame(id = testID, genre = knn.fit)
colnames(out.df) <- c('id', 'genre')
write.csv(out.df, file = "W22_P2_sample_submission.csv", 
          row.names = FALSE)
