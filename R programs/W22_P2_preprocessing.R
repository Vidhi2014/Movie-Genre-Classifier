# preprocess the data into a matrix form
library(tm)


# read file
train_file <- read.csv("W22_P2_train.csv", 
                       header = TRUE, colClasses = c("description" = "character"))
test_file <- read.csv("W22_P2_test.csv", 
                      header = TRUE, colClasses = c("description" = "character"))


#First, do some preprocessing
#See more details: https://cran.r-project.org/web/packages/tm/vignettes/tm.pdf
comb_dat <- Corpus(VectorSource(c(train_file$description,
                                  test_file$description)))
comb_dat <- tm_map(comb_dat, stripWhitespace)
comb_dat <- tm_map(comb_dat, removePunctuation)
comb_dat <- tm_map(comb_dat, content_transformer(tolower))
comb_dat <- tm_map(comb_dat, removeWords, stopwords("english"))
comb_dat <- tm_map(comb_dat, stemDocument)

inspect(comb_dat[1:3])

#Second, create word occurrence matrices: 
#each column corresponds to a word, and each row is a description of a movie
#(i,j)-th entry is the number of occurrence for word j in i-th movie

minDocFreq= 100 #0.01*length(comb_dat)
maxDocFreq = 800 #0.05*length(comb_dat)

comb_dtm <- DocumentTermMatrix(comb_dat, control = list(bounds = list(global = c(minDocFreq, maxDocFreq))))

#third, remove sparse terms
comb_mat = removeSparseTerms(comb_dtm, .99)
inspect(comb_mat)
findFreqTerms(comb_mat)

#create training and test data in the form of matrices and vectors
Xtrain = as.matrix(comb_mat[1:nrow(train_file),])
Ytrain = train_file$genre

Xtest = as.matrix(comb_mat[(nrow(train_file)+1):(nrow(train_file)+nrow(test_file)), ])
testID = test_file$id #use for output

#Output the preprocessed data for later analysis
save(file = 'processed_text.RData', 'Xtrain', 'Ytrain', 'Xtest', 'testID')