require(caret)
require(kernlab)
# ===== sample codes from ksvm
# x <- rbind(matrix(rnorm(120),ncol =  2), matrix(rnorm(120, mean = 3), ncol = 2))
# y <- c(rep(1, 60), rep(-1, 60))
# 
# # ===== train linear svm model via three wrappers
# 
# #===
# #dedicated to caret because if I am not preparing data in this way, 
# #caret reports errors and stop training with following messages: 
# #Error in train.default(x, y, weights = w, ...) : 
# #At least one of the class levels is not a valid R variable name; This will cause errors when class 
# #probabilities are generated because the variables names will be converted to  X.1, X1 . Please use 
# #factor levels that can be used as valid R variable names  (see ?make.names for help).
# dat0 <- data.frame(x = x, y= factor(y, levels = c(-1, 1), labels = c('c0', 'c1')))
# svp0 <- ksvm(y~., dat0,  type = 'C-svc', kernel = 'vanilladot')
# 
# dat <- data.frame(x = x, y = as.factor(y))
# svp <- ksvm(y~., dat, type = 'C-svc', kernel = 'vanilladot')
# 
# svp1 <- ksvm(x, y, kernel = 'vanilladot', type = 'C-svc')
# 
# kernlab::plot(svp0, data = dat0) # works
# kernlab::plot(svp, data = dat) # works
# kernlab::plot(svp1, data = x) # works
# 
# ctr <- trainControl(method='cv',
#                     number=5, 
#                     classProbs=TRUE,
#                     summaryFunction=twoClassSummary 
# )
# svp.c <- train(y ~., dat0, method = "svmLinear",  
#                trControl = ctr, 
#                preProcess = c('center', 'scale'),
#                metric = "ROC")
# kernlab::plot(svp.c$finalModel, data = dat0) #Not working
# # Error in seq.default(min(sub[, 2]), max(sub[, 2]), length = grid) : 
# # 'from' cannot be NA, NaN or infinite
# # 
# # kernlab::plot(svp.c$finalModel)
# # 

# data("iris")
# iris_dt <- iris[1:100, ]
# iris_dt$Species <- factor(as.character(iris_dt$Species))
# iris_svm <- train(Species ~ . , 
#                   iris_dt, 
#                   method = 'svmLinear', 
#                   trControl = ctr,
#                   preProcess = c('center', 'scale'),
#                   metric = "ROC")



#Create our own test da
set.seed (1)
x <- rbind(matrix(rnorm(120),ncol =  3), matrix(rnorm(120, mean = 3), ncol = 3), matrix(rnorm(120, mean = 3), ncol = 3))
y <- c(rep(1, 50), rep(-1, 70))
dat <- data.frame(x=x,y=as.factor(y))
# ctr <- trainControl(method = 'cv', number = 5, summaryFunction = twoClassSummary, classProbs = TRUE)
ctr <- trainControl(method = 'repeatedcv', number = 10, repeats = 5, 
                    sampling = 'rose', 
                    classProbs = TRUE, summaryFunction = twoClassSummary)
svm.c <- train(y ~., dat,
               method='svmRadial',
               preProcess = c('center', 'scale'),
               trControl=ctr,
               metric="ROC",
               verbose = TRUE)
# Plot src code
# https://github.com/cran/kernlab/blob/efd7d91521b439a993efb49cf8e71b57fae5fc5a/R/ksvm.R#L2900-L2989
plot(svm.c$finalModel, slice = list(x.3 = 0))

svm2d <- ksvm(y~., dat[, -3],  type = 'C-svc', kernel = 'vanilladot')
plot(svm2d)
svm3d <- ksvm(y~., dat,  type = 'C-svc', kernel = 'vanilladot')
plot(svm3d, data = dat, slice = list(x.3 = 0))
