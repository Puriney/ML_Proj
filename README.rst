
************
Introduction
************

This is the R pipeline to reproduce my report for final project of graduate
course "Machine Learning", which is about applying any method and
model learnt from/out the course to solve a binary classification problem.

Note: the train and test dataset are well structured (which suggests more focus
on modeling rather than cleaning) and anonymized (which suggests the importance
of EDA and feature engineering).

.. figure:: https://raw.githubusercontent.com/Puriney/ML_Proj/master/fig/pipeline.png
    :scale: 50 %
    :align: center

    Workflow to solve the two-class classification problem.


The workflow is mainly composed of 4 layers (with different color indicated).

1. Import structured dataset and perform EDA to learn about basics of data.
    - whether labels are
2. Exploration
3. Modeling
4. Deploy. Applied model on evalution dataset to predict labels and report to
instructor. The final performance is invisible to me.

.. figure:: http://i.imgur.com/Gr1giVh.png
    :scale: 50
    :align: center

   t-SNE plot suggest that two classes are possibly separable.

