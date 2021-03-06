## Introduction

The course project for Getting and Cleaning Data course
requires that for a set of files located here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
we construct an R script called `run_analysis.R` that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## The functions

The script run_analysis.R contains the following functions

1.  get_data
2.  merge_data
3.  run_analysis

### get_data

get_data reads in all the files we need for the analysis and returns a list of data frames, one for each file.
The directory the files are located in is passed as a parameter.

It is called by run_analysis.  The files read in are the following:

1. activity_lables.txt - contains the descriptive label for the activities stored y_test.txt and y_train.txt
2. features.txt - contains descriptions for the measurements in the columns of X_test.txt and X_train.txt
3. X_test.txt - data set of the 561 different varible measurements taken on each of the test subjects for each of the activities
4. subject_test.txt -  contains the subjects for each row of measurements in X_test.txt
5. y_test.txt - contains the activities performed (as a number) for each row of measurements in X_test.txt
6. X_train.txt - data set of the 561 different varible measurements taken on each of the test subjects for each of the activities
7. subject_train.txt -  contains the subjects for each row of measurements in X_train.txt
8. y_train.txt - contains the activities performed (as a number) for each row of measurements in X_train.txt



### merge_data

merge_data receives as a parameter the list of data frames created by get_data.

The function then does the following:

1. Combines the subjects, activities, and measurements for the training subjects into different colummns of a data frame.
Does the same thing for thet test subjects in a second data frame.
2. Combines the rows of observations in the two data frames created in step 1 for test and train subjects into a single data frame
3. Labels the data set with descriptive variable names using the values found in features.txt
4. Subsets the dataset to only include measurements containing exactly `mean()` or `std()` in their variable label by setting the `fixed` parameter of the `grepl` function to FALSE.
	* Variables with `meanFreq` were not included as I did not interpret this weighted average of the frequency components to be a "mean" of the measurements.
	* Similiarly features such as `angle(X,gravityMean)` were not included.
5. Uses descriptive activity names in the activity_labels.txt file to name the activities in the data set by converting them to a factor and using the character vector as the labels for the levels.

This tiddy data frame which still contains a row for each observation in X_test.txt and X_train.txt is then returned by the function

### run_analysis

This is the main function in the script and call both get_data and merge_data.  
It receives a directory as a parameter with a default of `getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset`

It does the following:

1. Calls get_data, passing the directory name and stores the returned list of data frames for each of the files in a local variable called data.
2. Calls merge_data, passing the list of data frames returned by get_data and stores the returned data frame in a local variable called merged.
3. Writes to the working directory the data frame returned by merge_data as a tab delimited text file called merged.txt.
4. Creates a second, independent tidy data set with the average of each variable for each activity and each subject by using the aggregate function.
5. Writes this second tidy data set to the working directory as a tab delimited text file called tidy.txt.


## Instructions

1. Download the raw data to your working directory https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

2. Unzip the raw data in your working directory and name the folder: `getdata-projectfiles-UCI HAR Dataset`

3. Download run_analysis.R to your working directory from https://github.com/brianfrancis/GettingAndCleaningDataCourseProject

4. In R run: `source("run_analysis.R");`

5. In R run: `run_analysis();`

This will produce the tab delimited tidy data set as the file `tidy.txt` in the working directory.