hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = ")..")
library(dplyr)
library(stringr)
library(tidyr)


# The data combines several indicators from most countries in the world

#"Country" = Country name

# Health and knowledge

#"GNI" = Gross National Income per capita
#"Life.Exp" = Life expectancy at birth
#"Edu.Exp" = Expected years of schooling 
#"Mat.Mor" = Maternal mortality ratio
#"Ado.Birth" = Adolescent birth rate

# Empowerment

#"Parli.F" = Percetange of female representatives in parliament
#"Edu2.F" = Proportion of females with at least secondary education
#"Edu2.M" = Proportion of males with at least secondary education
#"Labo.F" = Proportion of females in the labour force
#"Labo.M" " Proportion of males in the labour force

#"Edu2.FM" = Edu2.F / Edu2.M
#"Labo.FM" = Labo2.F / Labo2.M

str(hd$Gross.National.Income..GNI..per.Capita)

hd$Gross.National.Income..GNI..per.Capita <- str_replace(hd$Gross.National.Income..GNI..per.Capita, pattern=",", replace ="") %>% as.numeric

humandev <- rename(hd, HDIRank = HDI.Rank,
                   Country = Country,
                   HDI = Human.Development.Index..HDI. ,
                   Life.Exp = Life.Expectancy.at.Birth ,
                   Edu.Exp = Expected.Years.of.Education ,
                   Edu = Mean.Years.of.Education ,
                   GNI = Gross.National.Income..GNI..per.Capita ,
                   GNI.HDI =GNI.per.Capita.Rank.Minus.HDI.Rank )
dim(humandev)
str(humandev)
head(humandev)

gender <- mutate(gii, GIIRank = as.integer(GII.Rank),
              Country = Country, 
              GII = as.numeric(Gender.Inequality.Index..GII.), 
              Mat.Mor = as.numeric(Maternal.Mortality.Ratio), 
              Ado.Birth = as.numeric(Adolescent.Birth.Rate),
              Parli.F = as.numeric(Percent.Representation.in.Parliament),
              EduF = as.numeric(Population.with.Secondary.Education..Female.),
              EduM = as.numeric(Population.with.Secondary.Education..Male.),
              LabF = as.numeric(Labour.Force.Participation.Rate..Female.) ,
              LabM = as.numeric(Labour.Force.Participation.Rate..Male.))
gender <- select(gender, one_of(c("GIIRank","Country","GII","Mat.Mor","Ado.Birth","Parli.F","EduF","EduM","LabF","LabM")))
gender <- mutate(gender, Labo.FM = LabF / LabM, Edu2.FM = EduF / EduM)
dim(gender)
str(gender)
head(gender)

human <- inner_join(humandev,gender,by= "Country")
dim(human)
str(human)


keep <- c("Country", "Edu2.FM", "Labo.FM", "Life.Exp", "Edu.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

# select the 'keep' columns
human <- select(human, one_of(keep))
head(human)

# print out a completeness indicator of the 'human' data
comp <- complete.cases(human)
comp

# print out the data along with a completeness indicator as the last column
data.frame(human[-1], comp = comp)

# filter out all rows with NA values
human <- filter(human, comp)

# human without NA is available

# look at the last 10 observations of human
tail(human,10)

# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations, that is, no regions
human <- human[1:last, ]

# add countries as rownames
rownames(human) <- human$Country
human <- select(human, -Country)
head(human)

#now the data is clean without NA's, regions and unusefull variables


write.csv(x = human,file = "data/human.csv")
rm(gender,gii,human,humandev,hd,comp,keep,last)

test_data <- read.csv(file = "data/human.csv",row.names = "X")
head(test_data)
summary(test_data)

#csv-writing worked fine, we can continue with the analysis