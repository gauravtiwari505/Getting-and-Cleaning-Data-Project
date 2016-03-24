#Date: March 25, 2016
#Developer : Gaurav Tiwari
#Developed towards fulfilment of coursera Getting and Cleaning Data Course Project

#The goal of the script is to create a R script Run_analysis as follows

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names.
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#All these goals are dealt at the end of this script starting line 100 .
#Before we need to get and clean the data for which the whole process has been divided into 6 Steps

#Step 1 : Getting the data from the archive and unzipping it

##Setting the working directory and clearing the workspace
setwd("~/Documents/Coursera_Data_Science/Getting-and-Cleaning-Data-Project")
rm(list=ls())
require(plyr)
datafolder="UCI HAR Dataset"
outputfolder = "Output"

##Downloading the Data
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("UCI.zip"))
{
        print("Downloading File")
        download.file(url,destfile = "./UCI.zip")
        print("File downloaded")
} else
{
        print("File Already Downloaded")
}
#Step 2 Unzipping the file into the folder 

if(!file.exists("UCI HAR Dataset"))
{
        print("Unzipping the file")
        unzip("UCI.zip",list=FALSE,overwrite = TRUE)
        print("File Unzipped")
} else
{
        print("File already unzipped in the folder UCI HAR Dataset")
}

#Step 3 Create an output folder for putting the processed data
print("Checking for Output Folder")
if(!file.exists("output"))
{
        dir.create("Output")
        print("Output folder Created")
}else
{
        print("Output Folder Exists")
}


#Step 4 Read the files and convert into a data frame for better performance and handling

##Read the features.txt file to get the column mapping for the data(training and testing data)
features=read.table(paste(datafolder,"features.txt",sep = "/"),sep="",stringsAsFactors = FALSE)
print("Features.txt read succesfully")
##Read the training data set and its labels
###Subject Data
subject_train = read.table(paste(datafolder,"train","subject_train.txt",sep = "/"),sep="",stringsAsFactors = FALSE,col.names = "pk")
print("subject_train read succesfully")
###Data
x_train = read.table(paste(datafolder,"train","X_train.txt",sep = "/"),sep="",stringsAsFactors = FALSE,col.names = features$V2)
print("X_train read succesfully")
###Labels
y_train = read.table(paste(datafolder,"train","Y_train.txt",sep = "/"),sep="",stringsAsFactors = FALSE)
print("Y_train read succesfully")
##Read the test data set and its labels
###Subject Data
subject_test=read.table(paste(datafolder,"test","subject_test.txt",sep = "/"),sep="",stringsAsFactors = FALSE,col.names = "pk")
print("subject_test read succesfully")

###Data
x_test = read.table(paste(datafolder,"test","X_test.txt",sep = "/"),sep="",stringsAsFactors = FALSE,col.names = features$V2)
print("X_test read succesfully")
###Labels
y_test = read.table(paste(datafolder,"test","Y_test.txt",sep = "/"),sep="",stringsAsFactors = FALSE)
print("Y_test read succesfully")

#Step 5 Binding the data together with the labels and features
train= cbind(subject_train,y_train,x_train)
test= cbind(subject_test,y_test,x_test)
print("Testing and Training Data Binded")

#Step 6 Saving the final testing and training data in the output folder in csv formats
print("Writing Output/Train.csv")
write.csv(train,paste(outputfolder,"Train.csv",sep = "/"))
print("Writing Output/Test.csv")
write.csv(test,paste(outputfolder,"Test.csv",sep = "/"))

#Required Activities
#1. Merges the training and the test sets to create one data set.
merged <- rbind(train,test)
merged<-arrange(merged,pk)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std_data=merged[,c(1,2,grep("mean",colnames(merged)),grep("std",colnames(merged)))]

#3. Uses descriptive activity names to name the activities in the data set
activity_names <- read.table(paste(datafolder,"activity_labels.txt",sep = "/"))

#4. Appropriately labels the data set with descriptive variable names.
merged$activity <- factor(merged$activity, levels=activity_names$V1, labels=activity_names$V2)

#5. #From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_dataset <- ddply(mean_and_std, .(pk, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })

colnames(tidy_dataset)[-c(1:2)] <- paste(colnames(tidy_dataset)[-c(1:2)], "_mean", sep="")

write.csv(tidy_dataset,paste(outputfolder,"tidy_dataset.csv",sep="/"))
print("Tidy Data Set csv file written in the Output folder")



