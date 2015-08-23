Getting and Cleaning Data - Course project

Data for this project downloaded from the following link.

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

List of files used from the downloaded dataset for this project in the Folder "UCI HAR Dataset"
==============================================================================================

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity. 
- 'test/subject_test.txt': Each row identifies the subject who performed the activity.  

The file "run_analysis.R" contains all the required R code to perform all the 5 steps:
 
1.Merges the training and the test sets to create one data set.

2.Extracts only the measurements on the mean and standard deviation for each measurement. 

3.Uses descriptive activity names to name the activities in the data set

4.Appropriately labels the data set with descriptive variable names. 

5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TidyDataSet.txt is the final output file genarated from the this run_analysis.R code and uploaded to the course project submition

How the code works:
1. Code reads the meata data from the files:
   "UCI HAR Dataset/features.txt"
    "UCI HAR Dataset/activity_labels.txt"

2. Reads subject, features and activity data from train and test sub folders

3. Merges train and test data using 

4. Prepares completeData from features, activity and subject using cbind

5. Prepares a vector with requiredColumns

6. Uses descriptive activity names to name the activities in the data set

7. Elaborates column names by replacing acronyms

8. Creates a tidy data set with average of each variable

9. Writes this tidy data set into a file with tab delimiter
 
License:
========
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
