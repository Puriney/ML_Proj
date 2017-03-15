probFunction_y <- function(method, modelFit, newdata, preProc = NULL, param = NULL)
{
  if(!is.null(preProc)) newdata <- predict(preProc, newdata)
  print(dim(newdata))
  print(head(newdata))
  obsLevels <- levels(modelFit)
  
  classProb <- method$prob(modelFit = modelFit, 
                           newdata = newdata, 
                           submodels = param)  
  print(dim(classProb))
  print(head(classProb))
  if(!is.data.frame(classProb) & is.null(param))
  {
    classProb <- as.data.frame(classProb)
    if(!is.null(obsLevels)) classprob <- classProb[, obsLevels]
  }
  classProb
}
tempUnkProb_y <- probFunction_y(models[[i]]$modelInfo,
                                models[[i]]$finalModel, 
                                tempX, 
                                models[[i]]$preProcess) 
predict(mdl_pda$finalModel, test[1:10, ], type = 'posterior')
