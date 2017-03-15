#
# Blending Method
# 
# Integrate all 8 models trained so far
# Under LogisticReg Wrapper
# 

cat(">>>> Constructing: Blending models")
get_pred_obj <- function(model, dt, class_focus = "c0"){
  pred_obj <- predict(model, dt, type = 'prob')[, class_focus]
  pred_obj
}

models_set <- list(LogisticReg = mdl_logreg_repcv, 
                   LDA = mdl_lda, 
                   #RDA = mdl_pda, 
                   CART = mdl_cart, 
                   RF = mdl_rf, 
                   SVM_Linear = mdl_svmLin, 
                   SVM_Radial = mdl_svmRad, 
                   NN = mdl_nnet)

models_trainPreds <- lapply(models_set, get_pred_obj, 
                       dt = train, 
                       class_focus = levels(train_lab_fct)[1])
models_trainPreds <- do.call("cbind", models_trainPreds)

models_trainPreds_df <- as.data.frame(models_trainPreds)
models_trainPreds_df <- cbind(models_trainPreds_df, Label = train_lab_fct)
mdl_blending_helper <- train(Label ~ ., 
                             data = models_trainPreds_df, 
                             method = "glm",
                             family = 'binomial', 
                             trControl = trCtrolRepCV, 
                             preProcess = c('center', 'scale'), 
                             metric = "ROC")

save(mdl_blending_helper, file = "Model_blending_help.Robj")
