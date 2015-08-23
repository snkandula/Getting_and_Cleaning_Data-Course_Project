#Downloaded zip file i.e. "getdata_projectfiles_UCI HAR Dataset.zip" was extracted into the directory 
#"UCI HAR Dataset" and same was set as Working directory
#In my case output of getwd() is : "K:/R/R_Lab/UCI HAR Dataset"

# run_analysis.R
# Loading Required Libraries

library(data.table)
library(dplyr)

#Reading MetaData from features.txt and activity_lables.txt file

featureNames <- read.table("features.txt")
activityLabels <- read.table("activity_labels.txt", header = FALSE)

#Reading Training Data. X_train.txt as featuresTrain and y_train.txt as activityTrain

subjectTrain <- read.table("train/subject_train.txt", header = FALSE)
featuresTrain <- read.table("train/X_train.txt", header = FALSE)
activityTrain <- read.table("train/y_train.txt", header = FALSE)

#Reading Test Data. X_test.txt as featuresTest and y_test.txt as activityTest

subjectTest <- read.table("test/subject_test.txt", header = FALSE)
featuresTest <- read.table("test/X_test.txt", header = FALSE)
activityTest <- read.table("test/y_test.txt", header = FALSE)

# 1.Merges the training and the test sets to create one data set.

#Additing Train and Test Data
subject <- rbind(subjectTrain, subjectTest)
features <- rbind(featuresTrain, featuresTest)
activity <- rbind(activityTrain, activityTest)

#Naming the Columns
colnames(subject) <- "Subject"
colnames(features) <- t(featureNames[2])
colnames(activity) <- "Activity"

#Creating One Data Set
completeData <- cbind(features,activity,subject)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.

# Extracting Column nummbers with Mean or Std
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)

#Add Activity and Subject Columns to the List
requiredColumns <- c(columnsWithMeanSTD, 562, 563)

#Extracting Data for the Required Columns
extractedData <- completeData[,requiredColumns]


# 3.Uses descriptive activity names to name the activities in the data set

#Converting Activity data type from Numberic to Charater to accept Activity Names
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
extractedData$Activity <- as.factor(extractedData$Activity)


# 4.Appropriately labels the data set with descriptive variable names

# Elaborating Columns Names
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

# 5.From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "TidyDataSet.txt", row.names = FALSE, sep="\t")

