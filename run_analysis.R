setwd("C:/Users/ericr/Google Drive/Coursera/Getting and Cleaning Data/Course Project")

# 1
## Download/unzip dataset and get list of files 
# if(!file.exists("data")){dir.create("data")}
# fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# fileDest <- "C:/Users/ericr/Downloads/Coursera Data/Getting and Cleaning Data/data/Dataset.zip"
# download.file(fileUrl, destfile = fileDest)
# unzip(zipfile = fileDest,
#       exdir = "C:/Users/ericr/Downloads/Coursera Data/Getting and Cleaning Data/data")
files <- list.files(
     "C:/Users/ericr/Downloads/Coursera Data/Getting and Cleaning Data/data/UCI HAR Dataset",
     recursive = TRUE)
dataDirectory <- "C:/Users/ericr/Downloads/Coursera Data/Getting and Cleaning Data/data/UCI HAR Dataset"

## Read the data files
dataActivityTest <- read.table(file.path(dataDirectory, "test/y_test.txt"), header = FALSE)
dataActivityTrain <- read.table(file.path(dataDirectory, "train/y_train.txt"), header = FALSE)
dataSubjectTest <- read.table(file.path(dataDirectory, "test/subject_test.txt"), header = FALSE)
dataSubjectTrain <- read.table(file.path(dataDirectory, "train/subject_train.txt"), header = FALSE)
dataFeaturesTest <- read.table(file.path(dataDirectory, "test/X_test.txt"), header = FALSE)
dataFeaturesTrain <- read.table(file.path(dataDirectory, "train/X_train.txt"), header = FALSE)

## Merge the training and the test sets to create one data set
dataActivity <- rbind(dataActivityTrain, dataActivityTest)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataFeatures <- rbind(dataFeaturesTrain, dataFeaturesTest)

## Set names to variables
names(dataSubject) <- "subject"
names(dataActivity) <- "activity"
dataFeaturesNames <- read.table(file.path(dataDirectory, "features.txt"), header = FALSE)
dataFeaturesNames <- dataFeaturesNames$V2
dataFeaturesNames <- as.character(dataFeaturesNames)
names(dataFeatures) <- dataFeaturesNames

## Merge Subject, Activity, and Features data into one data frame
AllData <- cbind(dataSubject, dataActivity, dataFeatures)

## 2 - Extract only the mean and standard deviation for each measurement
# Isolate the Features with "mean()" OR "std()" in the variable name
subsetFeaturesNames <- grep("-(mean|std)\\(\\)", dataFeaturesNames, value = TRUE)
selectedColumns <- c("subject", "activity", subsetFeaturesNames)
RelevantData <- subset(AllData, select = selectedColumns)

## 3 - Use descriptive activity names in the data set
activityNames <- read.table(file.path(dataDirectory, "activity_labels.txt"), header = FALSE)
RelevantData$activity <- factor(x = RelevantData$activity, 
    levels = activityNames$V1, labels = activityNames$V2)

## 4 - Appropriately label the data set with descriptive variable names
# Activity and subject labels have already been taken care of.
# Here, we will label the Features data with more descriptive variable names
names(RelevantData) <- gsub("^t", "time", names(RelevantData))
names(RelevantData) <- gsub("^f", "frequency", names(RelevantData))
names(RelevantData) <- gsub("Acc", "Acceleration", names(RelevantData))
names(RelevantData) <- gsub("Gyro", "Gyroscope", names(RelevantData))
names(RelevantData) <- gsub("Mag", "Magnitude", names(RelevantData))
names(RelevantData) <- gsub("BodyBody", "Body", names(RelevantData))

# 5 - create a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
library(plyr)
TidyData <- aggregate(. ~subject + activity, RelevantData, mean)
TidyData <- TidyData[order(TidyData$subject,TidyData$activity), ]
write.table(TidyData, file = "tidydata.txt", row.name=FALSE)





