#
# Make fonts bigger
# 

theme_set(theme_gray(base_size = 26))

# balanced
load("data_and_explore.Robj")
train_lab_prop_fig <- ggplot(train_lab_prop, 
                             aes(x = train_lab0, y = Freq, fill = train_lab0))
cat(">>>> Ploting: whether data is balanced? ")
pdf(file = "fig/data_balance.pdf", width = 7, height = 7)
train_lab_prop_fig + geom_bar(position = 'dodge', stat = 'identity') +
  geom_text(aes(label = Freq), size = 10, position = 'dodge') + guides(fill = 'none') + 
  xlab('Label') + ylab('Proportion in Train data set') + ggtitle('Whether data is balanced?')
dev.off()

load("train_tsne.Robj")
train_tsne_dt <- as.data.frame(train_tsne_obj$Y)
colnames(train_tsne_dt) <- paste0("t_sne_", 1:2)
pdf("fig/tsne.pdf", width = 7, height = 7)
train_tsne_fig <- ggplot(train_tsne_dt, aes(t_sne_1, t_sne_2))
train_tsne_fig + 
  geom_point(aes(color = factor(tr_lab)), size = 3, alpha = 0.7) + 
  labs(color = 'Labels')
dev.off()

pdf("fig/pca_variance.pdf", 7, 7)
plot(train_pca_cumuvar, xlab = "PC", ylab = "Explained Variance %", type = "o",
     xlim = c(0, 78), cex.lab = 1.5)
abline(v = pca_k, col = 'red', lty = 2)
abline(h = VAR_EXPL, col = 'blue', lty = 2)
axis(side = 1, at = pca_k, labels = pca_k, col = 'red', cex.axis = 1.5)
axis(side = 2, at = VAR_EXPL, labels = VAR_EXPL, col = 'blue', cex.axis = 1.5)
dev.off()

# tuning cart
load("Model_CART.Robj")
pdf("fig/cart_tuning.pdf", 7, 7)
ggplot(mdl_cart)
dev.off()

# tuning rf
load("Model_RF.Robj")
pdf("fig/rf_tuning.pdf", 7, 7)
ggplot(mdl_rf)
dev.off()

# tuning svm
load("Model_svmLin.Robj")
# load("Model_svmRad.Robj")
# pdf("fig/svm_radial_tuning.pdf", 7, 7)
# ggplot(mdl_svmRad)
# dev.off()

load("deploy.Robj")
# tuning nn
cat(">>>> Ploting: NN tuning process")
pdf("fig/nn_tuning.pdf", 7, 7)
ggplot(mdl_nnet)
dev.off()

# performance
plot_models_valid_roc <- function(model_list, dt, dt_lab_fct, main = NULL) {
  n <- length(model_list)
  mycolors <- brewer.pal(ifelse(n < 3, 3, n), 'Set1')
  i <- 1
  model_auc <- rep(0, n)
  for (model in model_list) {
    roc_obj <- valid_roc_obj(model, dt, dt_lab_fct)
    if (i == 1) {
      plot.roc(roc_obj, col = mycolors[i], main = main, asp = 1,
               cex = 1.5, cex.lab=1.5, cex.axis=1.5)
    } else {
      lines.roc(roc_obj, col = mycolors[i])
    }
    model_auc[i] <- as.numeric(roc_obj$auc)
    i <- i + 1
  }
  model_auc <- format(model_auc, digits = 3)
  legend_labels <- paste0(names(model_list), " (", model_auc, ")")
  legend("bottomright", legend = legend_labels, col = mycolors[1:n], 
         cex = 1.8, lwd = 2, bty = "n")
  0
}
pdf("fig/hilit_subsampling.pdf", 7, 7)
plot_models_valid_roc(logreg_models_set1, valid, valid_lab_fct, 
                      main = "Subsampling is used v.s. unused \n(via Logistic regression on validation data)")
dev.off()
pdf("fig/hilit_repCV.pdf", 7, 7)
plot_models_valid_roc(logreg_models_setCV, valid, valid_lab_fct, 
                      main = "CV: 5-times 10-fold v.s. only 10-fold")
dev.off()
pdf("fig/compare_single_models.pdf", 7, 7)
plot_models_valid_roc(models_set, valid, valid_lab_fct, main = "Compare model performance over validation data set")
dev.off()

pdf("fig/blending_perfm.pdf", 7, 7)
plot.roc(blend_valid_roc, print.auc = TRUE, main = "Blending Model",
         max.auc.polygon=TRUE, auc.polygon.col="#DEEBE8", auc.polygon = TRUE, 
         print.auc.cex =  2, cex.lab = 1.5, cex.main = 1.5, cex.axis = 1.5)
dev.off()
