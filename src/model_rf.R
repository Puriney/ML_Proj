#
# Random Forest
# 

# takes sometime to compute
cat(">>>> Training Random Forest\n")
rfGrid <- expand.grid(mtry = c(5, 25, 55))
mdl_rf <- train(Label ~ ., 
                data = train_df, 
                method = "rf",  
                trControl = trCtrolRepCV, 
                preProcess = c('center', 'scale'), 
                tuneGrid = rfGrid, 
                metric = "ROC", 
                verbose = TRUE)
cat(">>>> Ploting: tuning RF process\n")
pdf("fig/rf_tuning.pdf", 7, 7)
plot(mdl_rf)
dev.off()
save(mdl_rf, file = "Model_RF.Robj")
#
# CART
# 
cat(">>>> Training CART\n")
cartGrid <- expand.grid(maxdepth = c(10, 20))
mdl_cart <- train(Label ~ ., 
                data = train_df, 
                method = "rpart2",  
                trControl = trCtrolRepCV, 
                preProcess = c('center', 'scale'), 
                metric = "ROC")
# tuning parameters
cat(">>>> Ploting: tuning CART\n")
pdf("fig/cart_tuning.pdf", 7, 7)
plot(mdl_cart)
dev.off()
# tree-structure
cat(">>>> Ploting: actual CART model\n")
pdf("fig/cart_tree.pdf", 7, 7)
plot(mdl_cart$finalModel)
text(mdl_cart$finalModel)
dev.off()
save(mdl_cart, file = "Model_CART.Robj")