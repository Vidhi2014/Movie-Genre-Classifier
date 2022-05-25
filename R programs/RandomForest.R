#load the output from the W22_P2_preprocessing.R file
load('processed_text.RData')


#create a random forest model
library(randomForest)
library(caret)
library(tictoc)
set.seed(3)
tic()
library(doParallel)
registerDoParallel(cores=4)
ctrl <- trainControl(method = "cv", number = 10)
rf.Grid = expand.grid(mtry = 6,
                      splitrule ='gini', 
                      min.node.size = 1)
rf.cv.model = train(
  Xtrain, Ytrain,  
  trControl = ctrl,
  tuneGrid = rf.Grid,
  method = "ranger"
)
rf.cv.model$bestTune

# predict log duration
rf_pred <- predict(rf.cv.model, Xtest)
toc()

# write the file for kaggle submission
out.df <- data.frame(id = testID, genre = rf_pred)
colnames(out.df) <- c('id', 'genre')
write.csv(out.df, file = "W22_P2_sample_submission.csv", 
          row.names = FALSE)
