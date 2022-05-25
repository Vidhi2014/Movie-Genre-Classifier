#load the output from the W22_P2_preprocessing.R file
load('processed_text.RData')

#SVM model
library(kernlab)
library(caret)
library(tictoc)
set.seed(3)
tic()
library(doParallel)
registerDoParallel(cores=6)
ctrl <- trainControl(method = "cv",
                     number = 10, allowParallel = TRUE)

lmSVM.Grid = expand.grid(C = 10)

lmSVM.cv.model <- train(
  Xtrain, Ytrain,  
  trControl = ctrl,
  tuneGrid = lmSVM.Grid,
  method = "svmLinear"
)
lmSVM.cv.model$bestTune
lmSVM.cv.pred = predict(lmSVM.cv.model, newdata =Xtest)
toc()

# write the file for kaggle submission
out.df <- data.frame(id = testID, genre = lmSVM.cv.pred)
colnames(out.df) <- c('id', 'genre')
write.csv(out.df, file = "W22_P2_sample_submission.csv", 
          row.names = FALSE)