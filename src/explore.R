# ====== Step 2 ====== #

cat(">>>> ===== Step-2 ====== <<<<<\n")
cat(">>>> ===== Explore ====== <<<<<\n")

#
# Visualize the pattern of entire data set
# Linear Separable or not ?
#

# Approach 1 - t-SNE
cat(">>>> Running t-SNE\n")
# train-predictor cannot contain duplicate
tr <- cbind(train0, Label = train_lab0[, 1])
tr_uniq <- unique(tr)
tr_row <- rownames(tr) # union set
tr_uniq_row <- rownames(tr_uniq) # sub set
tr_uniq_idx <- (tr_row) %in% (tr_uniq_row)
tr_uniq <- tr[tr_uniq_idx, 1:77]
tr_lab <- tr[tr_uniq_idx, 78]

train_tsne_obj <- Rtsne(as.matrix(tr_uniq))
save(train_tsne_obj, file = "train_tsne.Robj")
train_tsne_dt <- as.data.frame(train_tsne_obj$Y)
colnames(train_tsne_dt) <- paste0("t_sne_", 1:2)
cat(">>>> Ploting: t-SNE\n")
pdf("fig/tsne.pdf", width = 7, height = 7)
train_tsne_fig <- ggplot(train_tsne_dt, aes(t_sne_1, t_sne_2))
train_tsne_fig +
  geom_point(aes(color = factor(tr_lab)), size = 3, alpha = 0.7) +
  labs(color = 'Labels')
dev.off()
# hopefully, yes, linearly separable

# Approach 2 - PCA
cat(">>>> Running PCA\n")
train_pca_obj <- prcomp(train0, scale = TRUE)
print("summary of results of PCA")
summary(train_pca_obj)
train_eigenvectors <- train_pca_obj$rotation
train_pca_sdev <- train_pca_obj$sdev
train_pca_var <- (train_pca_sdev)^2
VAR_EXPL <- 0.95
train_pca_cumuvar <- cumsum(train_pca_var) / sum(train_pca_var)
pca_k <- which(train_pca_cumuvar > VAR_EXPL)[1] # first good eigenvector
cat(">>>> Ploting: PCA and explained variance\n")
pdf("fig/pca_variance.pdf", 7, 7)
plot(train_pca_cumuvar, xlab = "PC", ylab = "Explained Variance %", type = "o",
     xlim = c(0, 78))
abline(v = pca_k, col = 'red', lty = 2)
abline(h = VAR_EXPL, col = 'blue', lty = 2)
axis(side = 1, at = pca_k, labels = pca_k, col = 'red')
axis(side = 2, at = VAR_EXPL, labels = VAR_EXPL, col = 'blue')
dev.off()

# For PCA dimension reduction - data visualization
cat(">>>> Choosing first 2 PCs to visualize data\n")
pca_vizk <- 2
train_eigenvector_k <- train_eigenvectors[, 1:pca_vizk]
train_pca_cmprs <- as.matrix(train0) %*% train_eigenvector_k # Nx77 . 77xk
cat(">>> Ploting: PCA and data visualization\n")
pdf("fig/pca_data_viz.pdf", 7, 7)
train_pca_fig <- ggplot(as.data.frame(train_pca_cmprs), aes(PC1, PC2))
train_pca_fig +
  geom_point(aes(color = factor(train_lab0[, 1])), size = 3, alpha = 0.7) +
  labs(color = 'Labels')
dev.off()
# Not ideal

save.image("data_and_explore.Robj")

