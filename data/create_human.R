hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = ")..")
library(dplyr)


humandev <- rename(hd, HDIRank = HDI.Rank, Country = Country, HDI = Human.Development.Index..HDI. , LifeExpectancy = Life.Expectancy.at.Birth , ExpectedEducation= Expected.Years.of.Education , Education = Mean.Years.of.Education , GNI = Gross.National.Income..GNI..per.Capita , GNI_HDI =GNI.per.Capita.Rank.Minus.HDI.Rank )
dim(humandev)
str(humandev)


gender <- mutate(gii, GIIRank = as.integer(GII.Rank), 
              GII= as.numeric(Gender.Inequality.Index..GII.), 
              Mort = as.numeric(Maternal.Mortality.Ratio), 
              BR = as.numeric(Adolescent.Birth.Rate),
              Rep = as.numeric(Percent.Representation.in.Parliament),
              EduF = as.numeric(Population.with.Secondary.Education..Female.),
              EduM = as.numeric(Population.with.Secondary.Education..Male.),
              LabF = as.numeric(Labour.Force.Participation.Rate..Female.) ,
              LabM = as.numeric(Labour.Force.Participation.Rate..Male.))
gender <- select(gender, one_of(c("GIIRank","Country","GII","Mort","BR","Rep","EduF","EduM","LabF","LabM")))
gender <- mutate(gender, LabRatio = LabF / LabM, EduRatio = EduF / EduM)
dim(gender)
str(gender)

human <- inner_join(human,gender,by= "Country")
dim(human)
str(human)
