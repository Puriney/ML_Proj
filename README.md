
# Introduction

This is the R pipeline to *reproduce* my report for final project of graduate course CS-GY-6923 "Machine Learning", which is about applying any method and model learned from/out the course to solve a binary classification problem.

Note: the train and test datasets are well structured (which suggests more focus on modeling rather than cleaning) and anonymized (which suggests the importance of EDA and feature engineering).

# Work flow

![](https://raw.githubusercontent.com/Puriney/ML_Proj/master/fig/pipeline.png)

Fig: Work flow to solve the two-class classification problem: 1) Import data and investigate. 2) Exploration. 3) Modeling. 4) Deploy.

# Run

Run in R console:

```r
> source('yy1533.R')
```

or run in terminal:

```bash
$ Rscript yy1533.R
```


# Import Data and Investigate

Here data investigation (or part of EDA) is different from the philosophy of "Trash-in, trash-out" which highlights the importance of data cleaning. This step is asking: **Given the well-structured and clean dataset, is there still any more space for us to think about, so that reaching to a even better start point before applying the actual machine learning models?**

I think, yes. And examine the following 4 questions would make a huge difference to help me reach a "clean and clear" mind status.

**Q1: Whether classes are balanced?** Most machine learning models assume balance classes. If there exists minority and not being taken into account, the trained classifier would be less likely to generalize the properties of dataset.

![](http://i.imgur.com/wEr60RH.png)

Fig: 80% is Label-0 while 20% is Label-1.

In industry , <2% suggests data imbalance, but here I still used two strategies to combat data imbalance: 1) random down sampling the majority, 2) Random Over-Sampling Examples (ROSE).

**Q2: Whether there exists duplicate?** One of most straightforward reasons to check duplicates is that duplicates prohibit performing t-SNE in R.

**Q3: Whether N/A values widely exist in sample-wise or feature-wise?** If so, do we need think about data imputation, or just throw away these features or samples, or keep them in separate classes with special care?

**Q4: Data type of features?** Are they numerical/categorical/ordinal? For example, If categorical features exist, one common suggested approach of feature engineering is to accordingly create dummy binary variables.

# Data Exploration


![](http://i.imgur.com/Gr1giVh.png)

t-SNE plot suggest that two classes are possibly separable.

# Model Tuning using `caret` package

Package `caret` provides a seamless pipeline for performing preprocessing, training (with CV supported), explicit parameter tuning all at one.

The <kbd>src</kbd> folder lists all the models used in this project. For example, the random forest model in <kbd>model_rf.R</kbd>:

``` r
# Training scheme: 10-fold Cross Validation for 5 repeated times
# with ROSE sampling to combat data imbalance
trCtrolRepCV <- trainControl(method = 'repeatedcv', number = 10,
                             repeats = 5,
                             sampling = 'rose',
                             classProbs = TRUE,
                             summaryFunction = twoClassSummary)
# Parameter settings to be explicit tuned
rfGrid <- expand.grid(mtry = c(5, 25, 55))

# Perform actual training
mdl_rf <- train(Label ~ .,
                data = train_df,
                method = "rf",                     # "rf" = random forest
                trControl = trCtrolRepCV,          # training control
                preProcess = c('center', 'scale'), # preprocessing
                tuneGrid = rfGrid,                 # tuning parameter
                metric = "ROC",
                verbose = TRUE)
```

The rest model trainings follow the same syntax.

# Model Performance

![Imgur](http://i.imgur.com/0gDiXzZ.png)

---

# How to Enhance if possible?

- Change training metric to Kappa index, rather than ROC. My final ensemble model can achieve AUC=0.99, so I cannot help wondering what is the most possible reason to make this god-almost-alike classifier?
- My model is working pretty well, so what if my model fails, do I have any other strategies to use? Since feature selection is not still much involved, I would think about creating dummy variables for binary features, investigate feature importance to select features, etc.




