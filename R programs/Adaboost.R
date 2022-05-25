#load the output from the W22_P2_preprocessing.R file
load('processed_text.RData')

#Adaboost
library(caret)
library(fastAdaboost)
library(tictoc)
set.seed(3)
tic()
library(doParallel)
registerDoParallel(cores=6)
ctrl <- trainControl(method = "cv", number = 10)
boost.Grid = expand.grid(nIter = seq(10, 100, length.out = 10), method = "M1")
boost.model = train(
  x = Xtrain[,1:10], y = Ytrain,  
  trControl = ctrl,
  tuneGrid = boost.Grid,
  method = "adaboost"
)
#train_data = cbind(Xtrain[,1:10], Ytrain)
#boost.model = fastAdaboost::adaboost(Ytrain ~ .,data=train_data, nIter = seq(10, 100, length.out = 10))
boost.model$bestTune
boost.pred = predict(boost.model, newdata =Xtest[,1:10])
toc()

# write the file for kaggle submission
out.df <- data.frame(id = testID, genre = boost.pred)
colnames(out.df) <- c('id', 'genre')
write.csv(out.df, file = "W22_P2_sample_submission.csv", 
          row.names = FALSE)