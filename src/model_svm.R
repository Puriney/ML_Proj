#
# SVM
#
# - Support Vector Machines with Linear Kernel
#   Parameters: C (Cost) for soft margin
# - [SLOW-KILLED] Support Vector Machines with Polynomial Kernel
#   Parameters: degree (Polynomial Degree), scale (Scale), C (Cost)
# - Support Vector Machines with Radial Basis Function Kernel
#   Parameters: sigma (Sigma), C (Cost)
#
#
cat(">>>> Training: SVM(linear) \n")
mdl_svmLin <- train(Label ~ .,
                    data = train_df,
                    method = "svmLinear",
                    trControl = trCtrolRepCV,
                    preProcess = c('center', 'scale'),
                    metric = "ROC")

save(mdl_svmLin, file = "Model_svmLin.Robj")
# svmPolyGrid <- expand.grid(degree = 1:3,
#                            C = seq(0.2, 1, 0.2),
#                            scale = 1:3)
# mdl_svmPoly <- train(Label ~ .,
#                      data = train_df,
#                      method = "svmPoly",
#                      trControl = trCtrolRepCV,
#                      preProcess = c('center', 'scale'),
#                      metric = "ROC",
#                      tuneLength = 5)
                     # tuneGrid = svmPolyGrid)

cat(">>>> Training: SVM(radial)\n")
mdl_svmRad <- train(Label ~ .,
                    data = train_df,
                    method = "svmRadial",
                    trControl = trCtrolRepCV,
                    preProcess = c('center', 'scale'),
                    metric = "ROC",
                    verbose = FALSE)
cat(">>>> Ploting: SVM(radial) tuning process\n")
pdf("fig/svm_radial_tuning.pdf", 7, 7)
plot(mdl_svmRad)
dev.off()
save(mdl_svmRad, file = "Model_svmRad.Robj")
