#!/usr/bin/env Rscript
require(Rtsne)
require(plyr)
require(ggplot2)
require(RColorBrewer)
require(pROC)
require(caret)
require(ROSE)           # Subsampling to deal with unbalanced data
require(LogicReg)       # Logistic Regression
require(MASS)           # LDA
require(mda)            # PDA
require(randomForest)   # random forest
require(rpart)          # CART
require(kernlab)        # SVM
set.seed(2015)

# source("src/import_data.R")

# source("src/explore.R")

load("data_and_explore.Robj")

source("src/model_all.R")

source("src/deploy.R")

