url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
dest <- "/Users/alex/Documents/R directory/quiz4.csv"
download.file(url, destfile=dest,method="curl")

data <- read.csv(dest,header=T,sep=",")

# Question 1
string <- "wgtp"

list1 <- strsplit(names(data),string,fixed=T)

list1[123]

# Question 2
url2 <-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
dest <- "/Users/alex/Documents/R directory/quiz4-2.csv"

download.file(url2, destfile=dest,method="curl")

data2 <- read.csv(dest,header=T,sep=",",skip=4)
data2 <- data2[1:215,]
GDP <- as.numeric(gsub(",","",data2[,5]))
GDP <- GDP[complete.cases(GDP)]
mean(GDP)

# Question 3
grep("^United",data2[,4],value=T)

# Question 4
url3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
dest <- "/Users/alex/Documents/R directory/quiz4-3.csv"
download.file(url3, destfile=dest,method="curl")

data3 <- read.csv(dest,header=T,sep=",")
names(data3)

data2[,1] <- as.character(data2[,1])
data3[,1] <- as.character(data3[,1])
dataMer <- merge(data2,data3, by.x="X",by.y="CountryCode")
res4 <-grep("[Ff]iscal+.+[Ee]nd+.+[Jj]une",dataMer$Special.Notes) # EZ
length(res4)

#Question 5
library(lubridate) 
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 

dataAMZN <- as.data.frame(amzn)
    dataAMZN$Date <- as.Date(rownames(dataAMZN),"%Y-%m-%d")
dat2012 <- grep("2012",dataAMZN$Date)

wData <- dataAMZN[dat2012,]
a <- wday(wData$Date)==2
table(a)
