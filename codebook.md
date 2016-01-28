## Getting and Cleaning Data - Week 4, Project Codebook

By nsam0001

This is a codebook guide to what I did and how I did it.

### Source Data
An explanation of the data can be found [here.](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

### Package Setup
The following code will ensure that the three key packages are installed and deployed to R at runtime. 
- reshape2 was used to melt the data (R's native "aggregate" could have also done the job)
- data.table was used for merging and melting
- dplyr was used to summarise the data and calculate the mean (R's native "aggregate" could have also done the job) 
```{r eval=FALSE}
if (!require("reshape2")) { install.packages("reshape2") }
if (!require("data.table")) { install.packages("data.table") }
if (!require("dplyr")) { install.packages("dplyr") }

library("data.table")
library("reshape2")
library("dplyr")
```

### Raw Data Collection
This code downloads the .zip file and unzips it to the current working directory. The output of this block is a folder called "UCI HAR Dataset" containing the raw data.
```{r eval=FALSE}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "AccData.zip")
unzip("AccData.zip")
```

### Read Data
This block reads the training and testing data files (six in total) as well as the labels and column names. I'm assuming that the subject and activity label are part of the dataset.
```{r eval=FALSE}
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
```

At this point, the data is:
- split across different files
- still in its raw format

### Merging Dataset
This code merges the data together and gets rid of the trimmings. It also names the columns so as to avoid having to deal with messy data frames. I chose to name both joining keys "activityId" in order to make joining easier later on.
```{r eval=FALSE}
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
```

At this point:
- the data is merged together to form a numerical dataset and a label set
- all columns are now named

### Extracting Mean and Standard Deviation Measures
This code using regular expressions to find all column names containing Mean or STD. In order to ease my search, I extracted the data frame's names into a separate vector and searched that. I used the results from *grep* to filter the data frame.

```{r eval=FALSE}
# Find the mean() and std() columns
t_data_cols = colnames(t_data)
t_data_features = c(grep("mean",tolower(t_data_cols)), grep("-std()",tolower(t_data_cols)))

# Extract Means and STDs (haha)
t_data_cols_filtered = t_data[, t_data_features]
```

### Merging Descriptive Activity Names
I took this to mean joining in the activity names into the dataset. Which is what I did below. I named both joining keys activityId in order to ease joining.

```{r eval=FALSE}
# Descriptive activity names in data set
t_data_labelled = merge(t_data, activity_labels, by.x = "activityId", by.y = "activityId")
```

At this point:
- the data is merged together to form one large dataset

### Labelling Data Appropriately
I took this to mean renaming the columns. I wasn't sure what to do, so I just improvised with a lot of chained *gsub* calls.

```{r eval=FALSE}
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
```

At this point:
- the data structure remains unchanged
- the column names have been cleaned up

### Creating an Independent Tidy Dataset
In order to conform to the bible of tidiness, I elected to store each variable in a separate line. There are two trains of thought here - the one I chose and storing the data in a multi-variate time series format. I was short on time and melting the dataset seemed like the obvious thing to do.
*Melt* will "fold" the variables, or more technically, unpivot the dataset. *Summarise* will find the mean values of each variable (grouped by subject and activity) and count the number of rows used to compute each average.
```{r eval=FALSE}
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
```

At this point:
- the dataset was unpivoted to form a simpler dataset
- the mean value for each variable was computed
- the result was stored in a .csv file called "t_data_summary"

