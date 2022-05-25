#load the output from the W22_P2_preprocessing.R file
load('processed_text.RData')

#GBM model
library(caret)
library(gbm)
library(tictoc)
set.seed(3)
tic()
library(doParallel)
registerDoParallel(cores=6)
ctrl <- trainControl(method = "cv", number = 10)
gbm.Grid = expand.grid(interaction.depth = 3, 
                       n.trees = 800, 
                       shrinkage = 0.005,
                       n.minobsinnode = 10)
gbm.cv.model = train(
  Xtrain, Ytrain,  
  trControl = ctrl,
  tuneGrid = gbm.Grid,
  method = "gbm"
)
gbm.cv.model$bestTune
gbm.cv.pred = predict(gbm.cv.model, newdata =Xtest)
toc()

# write the file for kaggle submission
out.df <- data.frame(id = testID, genre = gbm.cv.pred)
colnames(out.df) <- c('id', 'genre')
write.csv(out.df, file = "W22_P2_sample_submission.csv", 
          row.names = FALSE)