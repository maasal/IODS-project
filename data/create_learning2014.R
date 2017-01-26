#Data wrangling, chapter 2

# read the data into memory
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

#explore structure
str(lrn14)

#Most data is in an integer form (Likert scale or age etc.) and gender is a factor

#explore dimensions
dim(lrn14)

#There are 183 observations and 60 variables

#Create analysis dataset in several steps with variables gender, age, attitude, deep, stra, surf, points (and bottom of meta.txt)
# First we access the dplyr library
library(dplyr)

# Second we specify the questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# 3rd.a) we select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# 3rd.b) Fourth select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# 3rd.c) select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# 4th. a) we scale down "Attitude"
lrn14$attitude <- lrn14$Attitude / 10

# 4th. b) we define the columns we need
keep_columns <- c("gender","Age","attitude","deep","stra","surf","Points")

# 4th. c) we combine the needed data to a skimmed dataframe
learning2014 <- select(lrn14,one_of(keep_columns))

# 4th. d) rename Age and Points
learning2014 <- rename(learning2014, age = Age, points = Points)

# 5th exclude observations where exam points = 0
learning2014 <- filter(learning2014, points > 0)

# Finally check the data
head(learning2014)
str(learning2014)
dim(learning2014)

#we got 166 observations and seven variables, nice!

#set working directory
setwd("~/Documents/IODS/git/IODS-project/data/")

#save dataset
write.csv(x = learning2014, file = "learning2014.csv")

#read the data with new name to check its integrity
test_data <- read.csv(file = "learning2014.csv",row.names = "X")
head(test_data)
str(test_data)


#Everything seems to be working fine
#Remove unused stuff
rm(deep_columns,lrn14,strategic_columns,surface_columns,test_data,deep_questions,keep_columns,strategic_questions,surface_questions)

