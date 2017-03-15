# ====== Step 1 ====== #

#
# Import data 
#
cat(">>>> ===== Step-1 ====== <<<<<\n")
cat(">>>> Import data ...\n")
train0 <- read.csv("data/train.csv", header=FALSE, stringsAsFactors=FALSE)
train_lab0 <- read.table('data/train_label.csv', quote="\"", 
                         comment.char="", stringsAsFactors=FALSE)
test <- read.csv("data/test.csv", header=FALSE, stringsAsFactors=FALSE)

#
# Whether NA exists in dataset? 
#
cat(">>>> Checking data ...\n")
n_miss <- function(x) sum(is.na(x))
colwise(n_miss)(train0)
colwise(n_miss)(test)
# Thus none NA exists - good news

#
# Data type of each feature: binary / numerical ? 
#
class_ft <- function(x) class(x)
colwise(class_ft)(train0)

is_binary <- function(x) length(unique(x)) == 2
is_binary_yes <- colwise(is_binary)(train0)
ft_binary_indx <- which(is_binary_yes == TRUE)
cat(c(">>>> Feature No.", ft_binary_indx, " are binary indicators"))
# Feature No. 43 44 45 46 47 48 49  are binary indicators


#
# [Optional] 
# Prepare subset data for proof-of-concept to build entire pipeline
#
cat(">>>> [optional] Subset data for runing through pipeline\n")
DATA_SIZE   = 50000
subset_size = 1500
set.seed(2015)
subset_indx = sort(sample(1:DATA_SIZE, subset_size, replace = FALSE),
                   decreasing = F)
train <- train0[subset_indx, ]
train_lab <- train_lab0[subset_indx, ]
train <- as.matrix(train)
# train <- train0
# train_lab <- train_lab0[1:DATA_SIZE, ]
# train <- as.matrix(train)

# 
# Data range of each feature
#
cat(">>>> Report Data range ...\n")
train_dt_range <- apply(train, 2, function(x) {
  c(min(x), median(x), mean(x), max(x))
})
rownames(train_dt_range) <- c('min', 'med', 'avg', 'max')
print(train_dt_range)

#
# Whether data is balanced? 
#
train_lab_prop <- as.data.frame(prop.table(table(train_lab0)))
train_lab_prop_fig <- ggplot(train_lab_prop, 
                             aes(x = train_lab0, y = Freq, fill = train_lab0))
cat(">>>> Ploting: whether data is balanced? ")
pdf(file = "fig/data_balance.pdf", width = 7, height = 7)
train_lab_prop_fig + geom_bar(position = 'dodge', stat = 'identity') +
  geom_text(aes(label = Freq), position = 'dodge') + guides(fill = 'none') + 
  xlab('Label') + ylab('Proportion in Train data set') + ggtitle('Whether data is balanced?')
dev.off()

#
# Whether training data contain duplicates
#
tr <- cbind(as.data.frame(train), Label = train_lab)
tr_uniq <- unique(tr)
tr_row <- rownames(tr) # union set
tr_uniq_row <- rownames(tr_uniq) # sub set
tr_uniq_idx <- (tr_row) %in% (tr_uniq_row)
train <- tr[tr_uniq_idx, 1:77]
train_lab <- train_lab[tr_uniq_idx]

#
# Data spliting. 80% for training; 20% for validating
#
train_indx <- createDataPartition(train_lab, p = .8, list = FALSE)
valid <- train[- train_indx,  ]
train <- train[train_indx, ]
valid_lab <- train_lab[- train_indx]
train_lab <- train_lab[train_indx]
valid_lab_fct <- factor(valid_lab, levels = c(0, 1), labels = c('c0', 'c1'))
train_lab_fct <- factor(train_lab, levels = c(0, 1), labels = c('c0', 'c1'))
