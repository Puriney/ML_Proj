#
# Neural Network via caret / mxnet package
# - caret: nnet (nerual network)
#   para: size (#hidden units); decay (weight decay)
# - [to-do] mxnet: neural network. if data size is way too big
# 
cat(">>>> Training: Neural Network\n")
mdl_nnet <- train(Label ~ ., 
                    data = train_df, 
                    method = "nnet",  
                    trControl = trCtrolRepCV, 
                    preProcess = c('center', 'scale'), 
                    metric = "ROC", 
                    verbose = FALSE)
cat(">>>> Ploting: NN tuning process")
pdf("fig/nn_tuning.pdf", 7, 7)
plot(mdl_nnet)
dev.off()

save(mdl_nnet, file = "Model_NN.Robj")
