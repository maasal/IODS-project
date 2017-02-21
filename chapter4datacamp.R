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
# # principal components:
# 1st captures the most variability
# 2nd orthogonal and takes avay left variability
# This is true for each principal component. They are all uncorrelated and each is less important than the previous one, in terms of captured variance

# PCA, if PC is for example 70.23, this means 70,23% of the variance is captured by this component (PCA1) for example
# PCA has no criteria or target variable, unsupervised method (assumes larger variance => more important, STANDARDIZE)
# PCA is powerful at encapsulating correlations between the original features into a smaller number of uncorrelated dimensions

# modified human is available

# standardize the variables
human_std <- scale(human)

# print out summaries of the standardized variables
summary(human_std)

# perform principal component analysis (with the SVD method)
pca_human <- prcomp(human_std)

# draw a biplot of the principal component representation and the original variables
biplot(pca_human, choices = 1:2, cex = c(0.4, 0.6), col = c("grey40","deeppink2"))

#BIPLOTS
# displays: observations in a lower 2- dimensional represation and the original features and their relationships with both each other and the principal components
# the angle between the arrows representing the original features can be interpret as the correlation between the features. Small angle = high positive correlation.
# the angle between a feature and a PC axis can be interpret as the correlation between the two. Small angle = high positive correlation
# the length of the arrows are proportional to the standard deviations of the features
# biplot vizualises LDA, PCA, CA and multiple CA
# arrows near = high correlation, 90 degree corner => orthogonal
# features and principals, the features that are pointing towards the first principal component (PC1) are the ones that contribute to that dimension
# feature pointing to the second is the feature contributing to that dimension.
#A biplot is a way of visualizing the connections between two representations of the same data. First, a simple scatter plot is drawn where the observations are represented by two principal components (PC's). Then, arrows are drawn to visualize the connections between the original variables and the PC's. The following connections hold:

#The angle between the arrows can be interpret as the correlation between the variables.
#The angle between a variable and a PC axis can be interpret as the correlation between the two.
#The length of the arrows are proportional to the standard deviations of the variables

# pca_human, dplyr are available

# create and print out a summary of pca_human
s <- summary(pca_human)

s
# rounded percetanges of variance captured by each PC
pca_pr <- round(1*s$importance[2, ], digits = 3)*100

# print out the percentages of variance
pca_pr

# create object pc_lab to be used as axis labels
pc_lab <- paste0(names(pca_pr), " (", pca_pr, "%)")

# draw a biplot
biplot(pca_human, cex = c(0.8, 1), col = c("grey40", "deeppink2"), xlab = pc_lab[1], ylab = pc_lab[2])

#Multiple Correspondence Analysis
#Analyses the pattern of relationships of several categorical variables
#deals with categorical variables, continuous can be used as background variables
# uses frequencies

#categorical variables: indicator matrix (binary matrix), burt matrix (two-way-corss tabulations between all variables)
# eigenvalues: the variance oand the percentage of variances retained by each dimension
# individuals: the individuals coordinates, the dindividuals contribution (%) on the dimension and the cos2( the squared correlations) on the dimensions

#categories:  the coordinates of the varuable categories, the contribution (%), the cos2, v.test values. The v.test follows normal distribution. if the value is below or above 1.96 the coordinate is significantly different from zero
#categorical variables: the squared correlation between each variable and the dimensions. If the value is close to one it indicates a strong link with the variable and dimension

#plot.MCA() (FactoMineR)
# the distance between variable categories gives a measure of their similarity
# for example Lablel2 and Name2 are more similar than Label2 and Level2 and label3 is very different from all the other categories (farther away)

library(FactoMineR)

# the tea dataset and packages FactoMineR, ggplot2, dplyr and tidyr are available

# column names to keep in the dataset
keep_columns <- c("Tea", "How", "how", "sugar", "where", "lunch")

# select the 'keep_columns' to create a new dataset
tea_time <- select(tea, one_of(keep_columns))

# look at the summaries and structure of the data
summary(tea_time)
str(tea_time)

# visualize the dataset
gather(tea_time) %>% ggplot(aes(value)) + facet_wrap("key", scales = "free") + geom_bar() + theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8))


# tea_time is available

# multiple correspondence analysis
mca <- MCA(tea_time, graph = FALSE)

# summary of the model
summary(mca)

# visualize MCA
plot(mca, invisible=c("ind"), habillage = "quali")






























