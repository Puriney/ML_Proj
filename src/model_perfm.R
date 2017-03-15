#
# Wrapper to compare model performance on same validation date set
# 
# - highlight importance of dealing with unblanced data via logistics regression
# - highlight using n-times k-fold CV method (within same context as above)
# - compare different models to give potentially 'best' model
# 

#
# Customed functions to evaluate models (mainly via ROC curve/AUC)
#
# 
cat(">>>> Evaluating Models' Performance\n")
report_valid_roc <- function(model, dt, dt_lab_fct) {
  class_focus <- levels(dt_lab_fct)[1]
  roc_obj <- roc(dt_lab_fct, 
                predict(model, dt, type = 'prob')[, class_focus])
  ci(roc_obj)
}
valid_roc_obj <- function(model, dt, dt_lab_fct) {
  class_focus <- levels(dt_lab_fct)[1]
  roc_obj <- roc(dt_lab_fct, 
                 predict(model, dt, type = 'prob')[, class_focus])
  roc_obj
}
plot_models_valid_roc <- function(model_list, dt, dt_lab_fct, main = NULL) {
  n <- length(model_list)
  mycolors <- brewer.pal(ifelse(n < 3, 3, n), 'Set1')
  i <- 1
  model_auc <- rep(0, n)
  for (model in model_list) {
    roc_obj <- valid_roc_obj(model, dt, dt_lab_fct)
    if (i == 1) {
      plot.roc(roc_obj, col = mycolors[i], main = main, asp = 1)
    } else {
      lines.roc(roc_obj, col = mycolors[i])
    }
    model_auc[i] <- as.numeric(roc_obj$auc)
    i <- i + 1
  }
  model_auc <- format(model_auc, digits = 3)
  legend_labels <- paste0(names(model_list), " (", model_auc, ")")
  legend("bottomright", legend = legend_labels, col = mycolors[1:n], lwd = 2)
  0
}

# #
# # using logistics regression as example, roc as metric
# # to demontrate why we need carefully deal with unbalanced data
# #
# logreg_models_set1 <- list(subsampling_yes = mdl_logreg, 
#                            subsampling_no = mdl_logreg_2)
# logreg_models_set1_res <- lapply(logreg_models_set1, 
#                                  report_valid_roc, 
#                                  dt = valid, dt_lab = valid_lab_fct)
# logreg_models_set1_res <- lapply(logreg_models_set1_res, as.vector)
# logreg_models_set1_res <- do.call("rbind", logreg_models_set1_res)
# colnames(logreg_models_set1_res) <- c("lower", "ROC", "upper")
# print(logreg_models_set1_res)
# pdf("fig/hilit_subsampling.pdf", 7, 7)
# plot_models_valid_roc(logreg_models_set1, valid, valid_lab_fct, 
#                       main = "Subsampling is used v.s. unused \n(via Logistic regression on validation data)")
# dev.off()
# 
# #
# # 5-repeated 10-fold cv v.s. only 10-fold cv
# # to highlight the importance of using repeated k-fold cross validation
# # 
# logreg_models_setCV <- list(Rep5_10Fold = mdl_logreg_repcv, 
#                             Rep0_10Fold = mdl_logreg)
# pdf("fig/hilit_repCV.pdf", 7, 7)
# plot_models_valid_roc(logreg_models_setCV, valid, valid_lab_fct, 
#                       main = "CV: 5-times 10-fold v.s. only 10-fold")
# dev.off()
# 
# # 
# # LDA v.s. PDA
# # 
# # lda_models_set <- list(LDA = mdl_lda, PDA = mdl_pda)
# # pdf("fig/lda_pda.pdf",7, 7)
# # plot_models_valid_roc(lda_models_set, valid, valid_lab_fct, 
# #                       main = "LDA v.s. PDA")
# # dev.off()
# #
# # Random Forest
# # 
# tree_models_set <- list(CART = mdl_cart, RF = mdl_rf)
# pdf("fig/tree_based.pdf", 7, 7)
# plot_models_valid_roc(tree_models_set, valid, valid_lab_fct, main = "Tree-based")
# dev.off()

#
# SVM
# 
# svm_models_set <- list(LinearSVM = mdl_svmLin, RadialSVM = mdl_svmRad)
# pdf("fig/svm_based.pdf", 7, 7)
# plot_models_valid_roc(svm_models_set, valid, valid_lab_fct, main = "SVM")
# dev.off()
#
# Neuro-network
# 
# plot_models_valid_roc(list(nn=mdl_nnet), valid, valid_lab_fct, main = "NN")

#
# Compare all models
# 
models_set <- list(LogisticReg = mdl_logreg_repcv, 
                   LDA = mdl_lda, 
                   # RDA = mdl_pda, 
                   CART = mdl_cart, 
                   RF = mdl_rf, 
                   SVM_Linear = mdl_svmLin, 
                   SVM_Radial = mdl_svmRad, 
                   NN = mdl_nnet)
                   # 
                   # 
pdf("fig/compare_single_models.pdf", 7, 7)
plot_models_valid_roc(models_set, valid, valid_lab_fct, main = "Compare model performance over validation data set")
dev.off()
#
#  Performance of blending model
#
models_validPreds <- lapply(models_set, get_pred_obj, 
                            dt = valid, class_focus = levels(valid_lab_fct)[1])
models_validPreds <- do.call("cbind", models_validPreds)
blend_validPreds <- get_pred_obj(mdl_blending_helper, dt = models_validPreds,
                                 class_focus = levels(valid_lab_fct)[1])
blend_valid_roc <- roc(valid_lab_fct, blend_validPreds)
pdf("fig/blending_perfm.pdf", 7, 7)
plot.roc(blend_valid_roc, print.auc = TRUE, main = "Blending Model",
         max.auc.polygon=TRUE, auc.polygon.col="#DEEBE8", auc.polygon = TRUE)
dev.off()
