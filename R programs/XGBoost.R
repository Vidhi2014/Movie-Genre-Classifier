#load the output from the W22_P2_preprocessing.R file
load('processed_text.RData')


#create a xgBoost model
library(xgboost)
library(caret)
trcontrol = trainControl(
  method = "cv",
  number = 5,  
  allowParallel = TRUE,
  verboseIter = FALSE,
  returnData = FALSE
)

xgbGrid <- expand.grid(nrounds = c(100,200),  # this is n_estimators in the python code above
                       max_depth = c(10, 15, 20, 25),
                       colsample_bytree = seq(0.5, 0.9, length.out = 5),
                       ## some of the values below are default values in the sklearn-api. 
                       eta = 0.05,
                       gamma=0,
                       min_child_weight = 1,
                       subsample = 0.5)
xgb_model = train(
  Xtrain, Ytrain,  
  trControl = trcontrol,
  tuneGrid = xgbGrid,
  method = "xgbTree"
)

# predict log duration
xgb_pred <- predict(xgb_model, Xtest)

mean(xgb_pred != Ytrain)

# write the file for kaggle submission
out.df <- data.frame(id = testID, genre = xgb_pred)
colnames(out.df) <- c('id', 'genre')
write.csv(out.df, file = "W22_P2_sample_submission.csv", 
          row.names = FALSE)
