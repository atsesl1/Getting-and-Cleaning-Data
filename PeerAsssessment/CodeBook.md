#Getting and Cleaning Data: Peer Assessment Project

=================


##1. Load the data 

```r
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,method="curl",destfile="/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/test.zip")
fileDownload <- date()
```
##2. Unzip the folder with the files.

```r
unzip("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/test.zip",exdir="/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/")

```
##3. Read the files into separate tables.

```r

trainDat <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/train/X_train.txt")
trainLab <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/train/y_train.txt")
trainSub <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/train/subject_train.txt")

testDat <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/test/X_test.txt")
testLab <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/test/y_test.txt")
testSub <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/test/subject_test.txt")
```


##4. Merge the training and the test sets to create one data set.

```r 
joinDat <- rbind(trainDat,testDat)
joinLab <- rbind(trainLab,testLab)
joinSub <- rbind(trainSub,testSub)
```
##5. Extract only the measurements on the mean and standard deviation for each measurement.
* First, load the features description file.
```r
featDat <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/features.txt")
```
* Then create a list of the features, and apply to the joined table we created previously.
```r
names <- as.character(featDat[,2])
colnames(joinDat) <- names
```
* Select only columns that provide **mean** and **std** values.
```r
ind <- grep("mean\\(\\)|std\\(\\)", names)
        joinDatFin <- joinDat[,ind] 
```
* Clean up the column names.
```r
names(joinDatFin) <- gsub("\\(\\)", "", names(joinDatFin))
names(joinDatFin) <- gsub("-", "", names(joinDatFin)) 
names(joinDatFin) <- gsub("mean", "Mean", names(joinDatFin)) 
names(joinDatFin) <- gsub("std", "Std", names(joinDatFin)) 
```
##6. Use descriptive activity names to name the activities in the data set.
* First, read in the file with activity labels.
```r
act <- read.table("/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/UCI HAR Dataset/activity_labels.txt")
```
* Prior to joining activity and activity labels table, create 'ID' column to keep the original order in activities are listed in the table.
```r
joinLab$ID <- as.numeric(rownames(joinLab))
        act2 <- arrange(inner_join(act,joinLab, by="V1"),ID)
```
##7. Appropriately label the data set with descriptive variable names. 
* Combine the needed columns in three tables, and name the columns appropriatelly.
```r
finalDat <- cbind(joinSub,act2[,2],joinDatFin)
    colnames(finalDat)[1:2] <- c("Subject","Activity")
```
* Then save the file into the folder.
```r
write.table(finalDat,"/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/complete_data.txt")
```

##8.From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
* ddply() function allows to subset and summarise the table by specifying the needed columns and applying mean() function to all the columns in the table.
```r
theFinal <- ddply(finalDat, .(Subject,Activity), colwise(mean))
```
* Save the file into the project folder.
```r
write.table(theFinal,"/Users/alex/Documents/R directory/Getting-and-Cleaning-Data/PeerAsssessment/table_means.txt")
```