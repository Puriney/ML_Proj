#
# Logistics Regression Training and Parameters Tuning
#
# Training Model
set.seed(2015)
cat(">>>> Training LogReg 1/3: with only-CV; with subsampling\n")
mdl_logreg <- train(Label ~ ., 
                    data = train_df, 
                    method = "glm",
                    family = 'binomial', 
                    trControl = trCtrol, 
                    preProcess = c('center', 'scale'), 
                    metric = "ROC"
)
# Prediction on validation date set
# pred_lab <- predict.train(mdl_logreg, newdata = valid)
# confusionMatrix(pred_lab, valid_lab_fct)

# Without using subsampling to deal with unbalanced data
cat(">>>> Training LogReg 2/3: with only-CV; without subsampling\n")
mdl_logreg_2 <- train(Label ~ ., 
                      data = train_df, 
                      method = "glm",
                      family = 'binomial', 
                      trControl = trCtrol2, 
                      preProcess = c('center', 'scale'), 
                      metric = "ROC"
)

# 5-times repeated 10-fold cv to train logreg
cat(">>>> Training LogReg 3/3: with repeated-CV; with subsampilng\n")
mdl_logreg_repcv <- train(Label ~ ., 
                    data = train_df, 
                    method = "glm",
                    family = 'binomial', 
                    trControl = trCtrolRepCV, 
                    preProcess = c('center', 'scale'), 
                    metric = "ROC"
)

save(mdl_logreg_repcv, file = "Model_logreg.Robj")
