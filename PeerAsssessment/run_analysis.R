# 1) You should create one R script called run_analysis.
library(dplyr)    
library(plyr)    
# Download the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,method="curl",destfile="/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/test.zip")
fileDownload <- date()
# Unzip the data files
unzip("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/test.zip",exdir="/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/")
# Read the data
trainDat <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/train/X_train.txt")
trainLab <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/train/y_train.txt")
trainSub <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/train/subject_train.txt")

testDat <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/test/X_test.txt")
testLab <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/test/y_test.txt")
testSub <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/test/subject_test.txt")

# 2) Merge the training and the test sets to create one data set.
joinDat <- rbind(trainDat,testDat)
joinLab <- rbind(trainLab,testLab)
joinSub <- rbind(trainSub,testSub)

# 3) Extract only the measurements on the mean and standard deviation for each measurement.
featDat <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/features.txt")
names <- as.character(featDat[,2])
colnames(joinDat) <- names
    ind <- grep("mean\\(\\)|std\\(\\)", names)
        joinDatFin <- joinDat[,ind] 

names(joinDatFin) <- gsub("\\(\\)", "", names(joinDatFin))
names(joinDatFin) <- gsub("-", "", names(joinDatFin)) 
names(joinDatFin) <- gsub("mean", "Mean", names(joinDatFin)) 
names(joinDatFin) <- gsub("std", "Std", names(joinDatFin)) 
# 4) Uses descriptive activity names to name the activities in the data set.
act <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/activity_labels.txt")
    joinLab$ID <- as.numeric(rownames(joinLab))
        act2 <- arrange(inner_join(act,joinLab, by="V1"),ID)

# 5) Appropriately label the data set with descriptive variable names. 
finalDat <- cbind(joinSub,act2[,2],joinDatFin)
    colnames(finalDat)[1:2] <- c("Subject","Activity")
write.table(finalDat,"/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/complete_data.txt")

# 6) From the data set in step 4, create a second, independent tidy data set
# with the average of each variable for each activity and each subject.
theFinal <- ddply(finalDat, .(Subject,Activity), colwise(mean))
write.table(theFinal,"/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/table_means.txt", row.name=FALSE)