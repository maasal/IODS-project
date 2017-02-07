# Mikko Salonen
# 7.2.2017
# data of student alcohol consumption from https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

#Set working directory
setwd("~/Documents/IODS/git/IODS-project/data/")

#Read data1
mat <- read.csv("student-mat.csv",sep = ";",header = TRUE)
dim(mat)
str(mat)

#Read data2
por <- read.csv("student-por.csv", sep = ";", header = TRUE)
dim(por)
str(por)

library(dplyr)

join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")


#inner join keeps only students present in each data set
joined_data <- inner_join(mat,por,by = join_by, suffix= c(".mat",".por")) 
head(joined_data)
glimpse(joined_data)

#select right columns
alc_data <- select(joined_data, one_of(join_by))
glimpse(alc_data)

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns

#This loop takes the average of numerical values and first value if not numerical...takes care of dublicate answers
# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(joined_data, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc_data[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc_data[column_name] <- first_column
  }
}

#Let's take a look at the newly formed data frame
glimpse(alc_data)

#create alc_use (alcohol usage as an average of weekday and weekend consumption)
alc_data <- mutate(alc_data, alc_use = (Dalc + Walc) / 2)
#create high_use (TRUE if alc_use higher than 2)
alc_data <- mutate(alc_data, high_use = alc_use > 2)

#Now we have the correct amount of observations (382) and variables (35)
glimpse(alc_data)

#write the data to a .csv and test by reading it to test_data
write.csv(x = alc_data,file = "alc.csv")
test_data <- read.csv(file = "alc.csv",row.names = "X")
head(test_data)

#everything works fine, remove unnecessary variables and data frames
rm(joined_data,mat,por,test_data,two_columns,column_name,first_column,join_by,notjoined_columns)
