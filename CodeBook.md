Getting and Cleaning Data - Course project

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set.
The goal is to prepare tidy data set as mentioned in the Course Project Assignment.

Required Source data was downloaded from the fillowing link. 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Course Project Goal:
Create one R script called run_analysis.R that does the following. 
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 
5.From the data set in step 4, creates a second, independent tidy data set with the 
  average of each variable for each activity and each subject.

Downloaded zip file i.e. "getdata_projectfiles_UCI HAR Dataset.zip" was extracted into the directory 
"UCI HAR Dataset" and same was set as Working directory for the R Code
In my case output of getwd() is : "K:/R/R_Lab/UCI HAR Dataset"

Code File: run_analysis.R

This code usese two libraries: 
library(data.table) - Efficient in handling large data as tables
library(dplyr)      - Aggregate variables to create the tidy data set

Supporting Metadata read from the following two file:

featureNames <- read.table("UCI HAR Dataset/features.txt") - The name of the features and the name of the activities. They are loaded into variables featureNames and activityLabels.
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE) - the name of the activities

Both training and test data sets are split up into subject, activity and features. 
They are present in three different files.

Read training data

subjectTrain <- read.table("train/subject_train.txt", header = FALSE)
featuresTrain <- read.table("train/X_train.txt", header = FALSE)
activityTrain <- read.table("train/y_train.txt", header = FALSE)

Read test data
subjectTest <- read.table("test/subject_test.txt", header = FALSE)
featuresTest <- read.table("test/X_test.txt", header = FALSE)
activityTest <- read.table("test/y_test.txt", header = FALSE)

Step 1. Merges the training and the test sets to create one data set.

We can use combine the respective data in training and test data sets corresponding to 
subject, activity and features using rbind. The results are stored in subject, activity and features.

subject <- rbind(subjectTrain, subjectTest)
features <- rbind(featuresTrain, featuresTest)
activity <- rbind(activityTrain, activityTest)

The columns in the features data set named from the metadata in featureNames
colnames(features) <- t(featureNames[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"


The data in features,activity and subject are merged using cbind and the complete data is now stored in completeData.
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)

Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Extracting the column numbers that have mean or std.
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

Adding  activity and subject columns to the list completeData
requiredColumns <- c(columnsWithMeanSTD, 562, 563)

Creating extractedData with the selected columns in requiredColumns. 
extractedData <- completeData[,requiredColumns]

Step 3. Uses descriptive activity names to name the activities in the data set

The activity field in extractedData is originally of numeric type. 
Changing its type to character to add activity names and do factor. 
The activity names are taken from metadata activityLabels.
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
extractedData$Activity <- as.factor(extractedData$Activity)

Step 4.Appropriately labels the data set with descriptive variable names. 
Elaborating column names with description

names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))

Step 5. From the data set in step 4, creates a second, independent tidy data set with 
        the average of each variable for each activity and each subject.

Do factor Subject variable.
extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

Creating tidyData as a data set with average for each activity and subject. 
Then, we order the enties in tidyData and write it into data file Tidy.txt that contains the processed data.
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]

Writing tidyData into a file TidyDataSet.txt with tab delimiter
write.table(tidyData, file = "TidyDataSet.txt", row.names = FALSE, sep="\t")






