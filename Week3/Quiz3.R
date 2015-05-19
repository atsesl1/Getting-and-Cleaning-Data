# Weeek 3 - Quiz
#Question 1
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
#dir.create("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3")
download.file(url,destfile="/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3/test.csv",method="curl")

data <- read.csv2("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3/test.csv",header=TRUE,sep=",")
data$agricultureLogical <- ifelse(data$ACR == 3 & data$AGS == 6, TRUE, FALSE)
head(data[which(data$agricultureLogical==TRUE),1:2],3)
#Question 2
library(jpeg)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url,destfile="/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3/test.jpeg",method="curl")
data <- readJPEG("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3/test.jpeg",native=TRUE)
quantile(data,probs=c(.3,.8))

#Question 3
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

download.file(url1,destfile="/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3/test1.csv",method="curl")
download.file(url2,destfile="/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3/test2.csv",method="curl")
data1 <- read.csv2("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3/test1.csv", header=TRUE, sep=",",skip=4,colClasses="character", nrows=190)
    data1 <- data1[,-3]; data1 <- data1[,-(5:9)]
        colnames(data1) <- c("CountryCode","rank","fullname","GDP")
            data1[,1] <- as.character(data1[,1]); data1[,2] <- as.numeric(data1[,2])
data2 <- read.csv2("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/Week3/test2.csv", header=TRUE, sep=",")
    data2[,1] <- as.character(data2[,1])
library(dplyr)
mergedData <- merge(data1,data2,by.x="CountryCode",by.y="CountryCode",all=FALSE) %>% arrange(desc(rank))

#Question 4
library(dplyr)
mergedData[,6] <- as.character(mergedData[,6])
ddply(mergedData,.(Income.Group),summarize,mean=mean(rank,na.rm=TRUE))

#Question 5
mergedData$groups = cut(mergedData$rank,breaks=quantile(mergedData$rank,na.rm=TRUE))
table(mergedData$groups,mergedData$Income.Group)
