#
# LDA-based approach
#
# - Linear Discriminant Analysis
#   no tuning parameters

# a) S_w is singular. Any discriminant vector that is in the null space of S_w but not in the null
# space of S_b can result in an arbitrarily large value of the objective.
# b) The resulting classifier is not interpretable when p (# of features) is very large, because the discriminant vectors contain p elements that have no particular structure.
# 

#
# Training LDA
# 
cat(">>>> Training: LDA\n")
mdl_lda <- train(Label ~ ., 
                 data = train_df, 
                 method = "lda",  
                 trControl = trCtrolRepCV, 
                 preProcess = c('center', 'scale'), 
                 metric = "ROC")
save(mdl_lda, file = "Model_LDA.Robj")
#
# Training RDA
# 
# cat(">>>> Training RDA\n")
# rdaGrid <- expand.grid(gamma = 0.02, 
#                        lambda = 0.1)
# mdl_pda <- train(Label ~ ., 
#                  data = train_df, 
#                  method = "rda",
#                  trControl = trCtrolRepCV, 
#                  preProcess = c('center', 'scale'),
#                  tuneGrid = rdaGrid,
#                  metric = "ROC")
# 
# save(mdl_pda, file = "Model_RDA.Robj")
