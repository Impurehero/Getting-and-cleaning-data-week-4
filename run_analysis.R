
library(reshape2)

## In this part we check if the file exists and we unzip it, if not we download and unzip the file

filename <- "getdata.zip"

If (!file.exists(filename)) {
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileURL, "./getdata.zip", mode = "wb")
}

if (!file.exists("UCI HAR Dataset")) {
unzip("getdata.zip")
}

## Opening the activity labels and features and transofrm the second column into characters


activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")

activitylabels[,2] <- as.character(activitylabels[,2])

features <- read.table("UCI HAR Dataset/features.txt")

features[,2] <- as.character(features[,2])




## Extract only the data for mean and standard deviation and seperate the names into a different vector and column numbers
## into a different, so later they can be used for easier table extraction


featuresWanted <- grep(".*mean.*|.*std.*", features[,2]) # the column numbers for means and std for later use

featuresWanted.names <- features[featuresWanted,2]       # names that later will be used for the columns

featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)



## Open the remaining datasets for train and test

train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)


## Merge the datasets for train and test and insert labels

Mergedata <- rbind(train, test)
colnames(Mergedata) <- c("subject", "activity", featuresWanted.names)


## Transform activities and subjects into factors

Mergedata$activity <- factor(Mergedata$activity, levels = activitylabels[,1], labels = activitylabels[,2])
Mergedata$subject <- as.factor(Mergedata$subject)


Mergedata.melted <- melt(Mergedata, id = c("subject", "activity"))
Mergedata.mean <- dcast(Mergedata.melted, subject + activity ~ variable, mean)

write.table(Mergedata.mean, "tidydata.txt", row.names = FALSE, quote = FALSE)