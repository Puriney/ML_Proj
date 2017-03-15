start <- 10840
res <- rep('z0', DATA_SIZE)
for (i in start:start+10){
  if(inherits(try(get_pred_obj(mdl_pda, test[i, ], 'c0')), "try-error")){
    print(i)
  } else{
    res[i] <- try(get_pred_obj(mdl_pda, test[i, ], 'c0'))
  }
}

models <- list(pda = mdl_pda)
obsLevels <- levels(models[[1]])
objectNames <- names(models)
predProb <- predClass <- obs <- modelName <- dataType <- objName <- NULL
unkX <- test[start:(start+1), ]
# unkX <- test[i:i+1, ]
i <- 1
# if(!is.null(unkX))
# {
  if(!is.data.frame(unkX)) unkX <- as.data.frame(unkX)
  tempX <- unkX
  tempX$.outcome <- NULL
  
  tempUnkProb <- probFunction(models[[i]]$modelInfo,
                              models[[i]]$finalModel, 
                              tempX, 
                              models[[i]]$preProcess)  
  tempUnkPred <- apply(tempUnkProb, 1, which.max) #!!!! <- bug 
  tempUnkPred <- colnames(tempUnkProb)[tempUnkPred] #!!!! <- bug
  tempUnkPred <- factor(tempUnkPred, levels = obsLevels)
  predProb <- if(is.null(predProb)) tempUnkProb else rbind(predProb, tempUnkProb)      
  predClass <- c(predClass, as.character(tempUnkPred))         
  obs <- c(obs, rep(NA, length(tempUnkPred)))
  modelName <- c(modelName, rep(models[[i]]$method, length(tempUnkPred)))
  objName <- c(objName, rep(objectNames[[i]], length(tempUnkPred)))
  dataType <- c(dataType, rep("Unknown", length(tempUnkPred)))        
  
# }
  predClass <- factor(predClass, levels = obsLevels)
  obs <- factor(obs, levels = obsLevels)
  
  out <- data.frame(predProb)
  out$obs <- obs
  out$pred <- predClass
  out$model <- modelName
  out$dataType <- dataType
  out$object <- objName
  