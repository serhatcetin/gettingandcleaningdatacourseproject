setwd("~/R/Getting and Cleaning Data/Course Project")

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "dataset.zip")

unzip(zipfile = "dataset.zip")
path_rf <- file.path("UCI HAR Dataset")
files <- list.files(path_rf, recursive = TRUE)
files

## Read the activity files
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

## Read the subject files
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)

## Read Features files
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTest)
str(dataSubjectTrain)
str(dataFeaturesTest)
str(dataFeaturesTrain)


##Merges the training and the test sets to create one data set

dataSubject <- rbind(dataSubjectTest, dataSubjectTrain)
dataActivity <- rbind(dataActivityTest, dataActivityTrain)
dataFeatures <- rbind(dataFeaturesTest, dataFeaturesTrain)

names(dataSubject) <- c("subject")
names(dataActivity) <- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"), head = FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

mergedData <- cbind(dataSubject, dataActivity)
allData <- cbind(dataFeatures, mergedData)

##Extracts only the measurements on the mean and standard deviation for each measurement

subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activity")
allData <- subset(allData, select = selectedNames)
str(allData)

##Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"), header = FALSE)
head(allData$activity, 40)

##Appropriately labels the data set with descriptive variable names

names(allData)<-gsub("^t", "time", names(allData))
names(allData)<-gsub("^f", "frequency", names(allData))
names(allData)<-gsub("Acc", "Accelerometer", names(allData))
names(allData)<-gsub("Gyro", "Gyroscope", names(allData))
names(allData)<-gsub("Mag", "Magnitude", names(allData))
names(allData)<-gsub("BodyBody", "Body", names(allData))

names(allData)

##Creates a second,independent tidy data set and ouput it

library(plyr)
allData2 <- aggregate(. ~subject + activity, allData, mean)
allData2 <- allData2[order(allData2$subject, allData2$activity),]
write.table(allData2, file = "secondtidydata.txt", row.name = FALSE)

##Produce Codebook
library(knitr)
knit2html("CodeBook.md");
