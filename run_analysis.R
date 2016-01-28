#########################################################################################################################################################################################
# Coursera-3-5: Getting and Cleaning Data
#########################################################################################################################################################################################
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
#########################################################################################################################################################################################

# setwd("C:\\Data\\Coursera\\proj") # this is for dev purposes only
currwd = getwd()

if (!require("reshape2")) { install.packages("reshape2") }
if (!require("data.table")) { install.packages("data.table") }
if (!require("dplyr")) { install.packages("dplyr") }

library("data.table")
library("reshape2")
library("dplyr")

# File Collection
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "AccData.zip")
unzip("AccData.zip")

#########################################################################################################################################################################################
# 1. Merges the training and the test sets to create one data set.
#########################################################################################################################################################################################

# Read Training Data
train_1 = read.table(paste0(getwd(), "/UCI HAR Dataset/train/X_train.txt"))
train_2 = read.table(paste0(getwd(), "/UCI HAR Dataset/train/y_train.txt"))
train_3 = read.table(paste0(getwd(), "/UCI HAR Dataset/train/subject_train.txt"))

# Read Test Data
test_1 = read.table(paste0(getwd(), "/UCI HAR Dataset/test/X_test.txt"))
test_2 = read.table(paste0(getwd(), "/UCI HAR Dataset/test/y_test.txt"))
test_3 = read.table(paste0(getwd(), "/UCI HAR Dataset/test/subject_test.txt"))

# Read Ancillary Data
features = read.table(paste0(getwd(), "/UCI HAR Dataset/features.txt"), stringsAsFactors = FALSE)
activity_labels = read.table(paste0(getwd(), "/UCI HAR Dataset/activity_labels.txt"), stringsAsFactors = FALSE)

# Merge Datasets
train = cbind(train_1, train_2, train_3)
test = cbind(test_1, test_2, test_3)
t_data = rbind(train, test)

# Garbage Clearing
rm(train_1, train_2, train_3)
rm(test_1, test_2, test_3)

# Name Datasets 
colnames(t_data) = c(features[,2], 'activityId', 'subjectId')
colnames(activity_labels) = c('activityId','activityType');

#########################################################################################################################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#########################################################################################################################################################################################

# Find the mean() and std() columns
t_data_cols = colnames(t_data)
t_data_features = c(grep("mean",tolower(t_data_cols)), grep("-std()",tolower(t_data_cols)))

# Extract Means and STDs (haha)
t_data_cols_filtered = t_data[, t_data_features]

#########################################################################################################################################################################################
# 3. Uses descriptive activity names to name the activities in the data set
#########################################################################################################################################################################################

# Descriptive activity names in data set
t_data_labelled = merge(t_data, activity_labels, by.x = "activityId", by.y = "activityId")

#########################################################################################################################################################################################
# 4. Appropriately labels the data set with descriptive variable names.
#########################################################################################################################################################################################

# Descriptive variable names
t_data_cols = colnames(t_data_labelled)
t_data_cols =
	gsub("\\__", "_",
	gsub("\\-", "",
	gsub("^angle\\(", "Angle_",
	gsub("\\)$", "",
	gsub("\\(\\)", "",
	gsub("Mag", "Magnitude",
	gsub("^f", "Frequency_", 
	gsub("^t", "Time_",
	gsub("Acc", "_Accelerometer_",
	gsub("Gyro", "_Gyroscope_",
	gsub("[mM]ean", "_Mean",
	gsub("std()", "_StDev",
	t_data_cols))))))))))))

# Relabel Dataset
colnames(t_data_labelled) = t_data_cols

#########################################################################################################################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#########################################################################################################################################################################################

# Forming a new dataset
# http://www.onthelambda.com/2014/02/10/how-dplyr-replaced-my-most-common-r-idioms/

t_data_labelled$activityType = factor(t_data_labelled$activityType)
t_data_labelled$subjectId = factor((t_data_labelled$subjectId))

t_data_labelled_melt = melt(t_data_labelled[, 2:ncol(t_data_labelled)], id=c("subjectId", "activityType"))
t_data_tbl = data.table(t_data_labelled_melt)

by_grp = group_by(t_data_tbl, subjectId, activityType, variable)
t_data_summary = summarise(by_grp, Variable_Rows_In_Mean = n(), Variable_Mean = mean(value))

# Saving the new dataset
write.table(t_data_summary, "t_data_summary.csv", row.names = FALSE, quote = FALSE, sep=',')

##########################################################################
# Rough Work (old code that I decided to store here)
##########################################################################

# # Merge Datasets
# data = rbind(cbind(train_1, train_2, train_3), cbind(test_1, test_2, test_3))

# # Find the mean() and std() columns
# t_data_cols_mean = grep("mean",tolower(t_data_cols)) 
# t_data_cols_std = grep("-std()",tolower(t_data_cols))
# double check: features[grep("mean",tolower(t_data_cols)), ]
# double check: features[grep("-std()",tolower(t_data_cols)), ]