# ====== Step 3 Models and Performances ====== # 
# Model trainings are highly dependent on using "caret" package
# 
cat(">>>> ====== Step 3 ====== <<<<<\n")
cat(">>>> Training various models\n")
require(caret)
require(ROSE)
require(pROC)

#
# General training settings 
# 
# 
# 10-fold CV resampling with subsampling via ROSE approach
trCtrol <- trainControl(method = 'cv', number = 10, 
                        sampling = 'rose', 
                        classProbs = TRUE, summaryFunction = twoClassSummary)
# 10-fold CV resampling without subsampling
trCtrol2 <- trainControl(method = 'cv', number = 10,
                         classProbs = TRUE, summaryFunction = twoClassSummary)
# 5-times repeated 10-fold cv 
trCtrolRepCV <- trainControl(method = 'repeatedcv', number = 10, repeats = 5, 
                             sampling = 'rose', 
                             classProbs = TRUE, summaryFunction = twoClassSummary)

#
# Prepare data compatible with caret package
#
train <- as.data.frame(train)
train_df <- cbind(train, Label = factor(train_lab, levels = c(0, 1), 
                                        labels = c('c0', 'c1'))
)

# Using subsampling (within resampling (cv)
# 
# Single Models 
cat(">>>> Training single model \n")
# 
# Logistic Regression 
# source("src/model_logreg.R")
load("Model_logreg.Robj")
# LDA 
# source("src/model_lda.R")
load("Model_LDA.Robj")
# Random forest
# CART
# source("src/model_rf.R")
load("Model_RF.Robj")
load("Model_CART.Robj")
# SVM_linear
# SVM_Radial
# source("src/model_svm.R")
load("Model_svmLin.Robj")
# Neural Network
# source("src/model_nn.R")
load("Model_NN.Robj")
#
# Integrated Models
#
# Blending Ensembling approach
# 
source("src/model_blending.R")

#
# Performance
# 
source("src/model_perfm.R")
