## Getting and Cleaning Data - Week 4, Project

By nsam0001

This file has been written in protest as part of the project submission for Johns Hopkins rather elaborate "Getting and Cleaning Data".

### Overview
#### Description
This project, allegedly a 30 min job that turned out to be a 3 hour punishment at the Premier Inn, serves to demonstrate how R can be used to collect 
and clean data which can then be analysed by people who did not exhaust themselves writing the transformation script.

Rather than further elaborate on the woes and throes of this assignment, I shall instead hand it over to the Johns Hopkins team who said:

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 
You will be graded by your peers on a series of yes/no questions related to the project. 
You will be required to submit: 
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
	You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#### What's in the box
This edge-of-seat package contains the following:
- run_analysis.R is the star of the show: the script that downloads and messes around with gyroscope data, only to save a second file.
- readme.rmd is the guide you are presently reading. 
- codebook.rmd explains the steps taken and provides other information that most Coursera peers will not read while marking this assignment.

### Running the Script
#### System Requirements
- Backend: R v3.2.3
- Package: reshape2
- Package: data.table
- Package: deplyr
- Package: memisc

#### Getting it running
If you would like to run the process from end to end, you will have to go through the following steps:
- Unless you want all the files to be downloaded and unzipped to your default working directly (which I'll assume is "My Documents"), you will need to uncomment the first line and set your directory of choice.
- Once that's done, you can either paste the script in your R editor or source the file using 
- If you would rather not open the file, open your favourite R editor and write the following command: [source("<path>\\run_analysis.R")]
- The R script will then download the files and unzip them, like a Turkish Love Explosion.
- You will be left with a mess of files and more pertinently, a tidy dataset called "t_data_summary.csv"
