
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

# Model Performance

![Imgur](http://i.imgur.com/Vs5EYZ4.png)
![Imgur](http://i.imgur.com/hhBuYHk.png)

---

# How to Enhance if possible?
