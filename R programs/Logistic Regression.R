#load the output from the W22_P2_preprocessing.R file
load('processed_text.RData')

# Logistic Regression
library(glmnet)
library(tictoc)
set.seed(3)
tic()
library(doParallel)
registerDoParallel(cores=4)
cvfit=cv.glmnet(Xtrain, Ytrain, 
                nfolds = 5, family="multinomial",
                trace.it = 0)
glmnet.pred = predict(cvfit, newx = Xtest, s = "lambda.min", type = "class")
toc()

# write the file for kaggle submission
out.df <- data.frame(id = testID, genre = glmnet.pred)
colnames(out.df) <- c('id', 'genre')
write.csv(out.df, file = "W22_P2_sample_submission.csv", 
          row.names = FALSE)