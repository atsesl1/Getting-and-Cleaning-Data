#Question 1

library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at at
#    https://github.com/settings/applications. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp <- oauth_app("github",
                   key = "af282eb3cb49eb8c7859",
                   secret = "b90ad6e674cf2df3775f9fc1be0da4895522909f")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)

# curl -u Access Token:x-oauth-basic "https://api.github.com/users/jtleek/repos"
BROWSE("https://api.github.com/users/jtleek/repos",authenticate("Access Token","x-oauth-basic","basic"))


#Question 2
#Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?
library(sqldf)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv",destfile="/Users/alex/Documents/R directory/Getting and Cleaning Data/Week 2/test.csv", method="curl")
data <- read.csv("/Users/alex/Documents/R directory/Getting and Cleaning Data/Week 2/test.csv",header=TRUE)

data1 <- sqldf("select pwgtp1 from data where AGEP < 50")

#Question 3
#Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

#Question 4
# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page 
url <- "http://biostat.jhsph.edu/~jleek/contact.html"
  con <- url(url)
data <- readLines(con)
  close(con)
sapply(data[c(10,20,30,100)],nchar)

#Question 5
# Read this data set into R and report the sum of the numbers in the fourth of the nine columns. 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for",destfile="/Users/alex/Documents/R directory/Getting and Cleaning Data/Week 2/test2.csv",method="curl")
data <- read.csv("/Users/alex/Documents/R directory/Getting and Cleaning Data/Week 2/test2.csv",header=FALSE, colClasses="character",na.strings=NA, skip=2)
df <- read.fwf("/Users/alex/Documents/R directory/Getting and Cleaning Data/Week 2/test2.csv",widths=c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4),skip=4)
sum(df[,4])