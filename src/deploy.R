#
# Deploy blending model
# 
# Predict the label for provided test data set
# 
cat(">>>> ===== Step 4 Deploy ===== <<<<\n")
predict_blender <- function(blender_helper, models_set, data, class_focus){
  models_Preds <- lapply(models_set, get_pred_obj, 
                             dt = data, class_focus = class_focus)
  models_Preds <- do.call("cbind", models_Preds)
  blend_Preds <- predict(blender_helper, newdata = models_Preds)
  return(blend_Preds)
}

# valid_pred_labels <- predict_blender(blender_helper = mdl_blending_helper, models_set = models_set, data = valid, class_focus = 'c0')

# 
# Perform Prediciton on test data
# 
# bug: 10840
# for (i in 10836:10839) {
#   cat(">>>", i , "...", "j<<<\n")
#   test_pred_labels <- predict_blender(blender_helper = mdl_blending_helper, models_set = models_set, data = test[i, ], class_focus = 'c0')
# }
test_pred_labels <- predict_blender(blender_helper = mdl_blending_helper, models_set = models_set, data = test, class_focus = 'c0')
result <- as.numeric(gsub("c", "", as.character(test_pred_labels)))
result_path <- "res/test_label.csv"
cat(">>>> Writting: test labels\n")
write.table(x = result, file = result_path, row.names = FALSE, col.names = FALSE)

save.image("deploy.Robj")
