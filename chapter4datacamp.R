# read the human data
human <- read.table("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt", sep  =",", header = T)

# look at the (column) names of human
names(human)

# look at the structure of human
str(human)

# print out summaries of the variables
summary(human)

library(tidyr)
library(stringr)

# access the stringr package
library(stringr)

# look at the structure of the GNI column in 'human'
str(human$GNI)

# remove the commas from GNI and print out a numeric version of it
str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

library(dplyr)

# human with modified GNI and dplyr are available

# columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns
human <- select(human, one_of(keep))

# print out a completeness indicator of the 'human' data
comp <- complete.cases(human)
comp

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = comp)

# filter out all rows with NA values
human_ <- filter(human, comp)

# human without NA is available

# look at the last 10 observations of human
tail(human,10)

# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human_ <- human[1:last, ]

# add countries as rownames
rownames(human_) <- human_$Country
human_

library(GGally)

# modified human, dplyr and the corrplot functions are available

# remove the Country variable
human_ <- select(human, -Country)

# Access GGally
library(GGally)

# visualize the 'human_' variables
ggpairs(human_)

# compute the correlation matrix and visualize it with corrplot
cor(human_) %>% corrplot


#Dimensionality reduction with PCA
# dimensionality = number of variables
# too much information
# reduce dimensions
# transform data to analyze principal components
# Singular Value Decomposition the most important tool
# SVD decomposes a matrix
# Correspondence Analysis (CA) uses categorical variables (same as LDA
# # principal componenst:
# 1st captures the most variability
# 2nd orthogonal and takes avay left variability
# This is true for each principal component. They are all uncorrelated and each is less important than the previous one, in terms of captured variance

# PCA, if PC is for example 70.23, this means 70,23% of the variance is captured by this component (PCA1) for example
# PCA has no criteria or target variable, unsupervised method (assumes larger variance => more important, STANDARDIZE)
# PCA is powerful at encapsulating correlations between the original features into a smaller number of uncorrelated dimensions





