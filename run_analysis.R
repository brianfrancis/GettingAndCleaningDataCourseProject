##reads in all the files needed and returns them as a list
get_data <- function(directory) {
        ##get codes for activity labels
        path <- paste(directory, "activity_labels.txt", sep="/")
        activitylabels <- read.table(path)
        
        ##get variable names
        path <- paste(directory, "features.txt", sep="/")
        features <- read.table(path, stringsAsFactors=FALSE)
        
        ##get data table for test data set
        path <- paste(directory, "test/X_test.txt", sep= "/")
        testdata <- read.table(path)
        
        ##get subject list for test data set
        path <- paste(directory, "test/subject_test.txt", sep= "/")
        testsubjects <- read.table(path)
        
        
        ##get activity list for test data set
        path <- paste(directory, "test/y_test.txt", sep= "/")
        testactivities <- read.table(path)
        
        ##get data table for train data set
        path <- paste(directory, "train/X_train.txt", sep= "/")
        traindata <- read.table(path)
        
        ##get subject list for train data set
        path <- paste(directory, "train/subject_train.txt", sep= "/")
        trainsubjects <- read.table(path)
        
        ##get activity list for train data set
        path <- paste(directory, "train/y_train.txt", sep= "/")
        trainactivities <- read.table(path)
        
        ##return list of data frames for each of the files read
        list(activitylabels=activitylabels, features=features, testdata=testdata, 
             testsubjects=testsubjects, testactivities=testactivities, 
             traindata=traindata, trainsubjects=trainsubjects, 
             trainactivities=trainactivities)
}

##merge data from files into a single data set (both test and train data)
##subset the file to just have mean and std measurements
##also label the column headers (the variable of the labels)
##finally convert the activities column to be a factor with labels
##returns the merged and labeled data frame for all observations
merge_data <- function(data) {
        
        ##combine the subjects, activities, and the rest of the data 
        ##for the test subjects into a single data frame
        test <- cbind(data$testsubjects, data$testactivities, data$testdata)
        
        ##combine the subjects, activities, and the rest of the data 
        ##for the train subjects into a single data frame
        train <- cbind(data$trainsubjects, data$trainactivities, data$traindata)
        
        ##combine the test and train data sets into a single data frame
        merged <- rbind(test, train)
        
        ##use the list of featues to label the column names of the dat fram
        colnames(merged) <- c("subjects", "activities", data$features[,2])
        
        ##return a logical vector of features with "mean()" in the name
        ##fixed= TRUE is used so that TRUE is returned 
        ##      only for values containing the full string "mean()" 
        x <- grepl("mean()", data$features[,2], fixed=TRUE)
        
        ##return a logical vector of features with "std()" in the name
        ##fixed= TRUE is used so that TRUE is returned 
        ##      only for values containing the full string "std()"
        y <- grepl("std()", data$features[,2], fixed=TRUE)
        
        ##return a a vector of column names that we want to include
        include <- c("subjects", "activities", data$features[x | y ,2])
        
        ##subset the columns to be just "subject", activities", and
        ##measurements conatining "mean()" or "std()"
        merged <- merged[,include]
        
        ##convert the "activities" column to a factor and label the levels
        ##using the activities labels
        merged$activities <- factor(merged$activities, 
                                        levels=data$activitylabels[,1]
                                        ,labels=data$activitylabels[,2])
        
        merged
}

## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean 
##      and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
##Creates a second, independent tidy data set with the 
##      average of each variable for each activity and each subject. 
run_analysis <- function(directory = "getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset") {
        
        ##get a list of data frames for all the files
        data <- get_data(directory)
        
        ##get the merged data set 
        ##subsetted to have the  columns we want
        ##and with labeling of columns and factors
        merged <- merge_data(data)
        
        ##write the merged data frame to a text file
        write.table(merged,"merged.txt", sep="\t", row.names=FALSE)
        
        ##get the number of columns in the merged data set
        n <- ncol(merged)
        
        ##return a tidy data set of the mean of each measurement
        ##for each subject and activity
        tidy <- aggregate(
                                x =  merged[,3:n,], 
                                by=merged[,1:2], 
                                FUN="mean"
                                )
        
        ##write the tidy data frame of summarized values to a text file
        write.table(tidy,"tidy.txt", sep="\t", row.names=FALSE)
        
}