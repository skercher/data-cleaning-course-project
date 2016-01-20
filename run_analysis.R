#!/usr/bin/env Rscript

setwd("~/coursera/data-cleaning/data-cleaning-course-project")

fileName <- "getdata-projectfiles-UCI_HAR_Dataset.zip"
directory <- "UCI HAR Dataset"

if(!file.exists(fileName)){
	fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(fileUrl, fileName, method = 'curl')
}

if(!file.exists(directory)){
	unzip(fileName)
}

readData <- function(path) {
  read.table(paste(directory, path,sep=""),header=FALSE)
}

# Read data files into variables
features = readData("/features.txt");
activityType = readData("/activity_labels.txt"); 
subjectTrain = readData("/train/subject_train.txt");
xTrain       = readData("/train/x_train.txt"); 
yTrain       = readData("/train/y_train.txt"); 
subjectTest = readData("/test/subject_test.txt");
xTest       = readData("/test/x_test.txt"); 
yTest       = readData("/test/y_test.txt"); 

# Assign columns names
colnames(subjectTest) = "subjectId";
colnames(xTest)       = features[,2]; 
colnames(yTest)       = "activityId";
colnames(activityType)  = c('activityId','activityType');
colnames(subjectTrain)  = "subjectId";
colnames(xTrain)        = features[,2]; 
colnames(yTrain)        = "activityId";

# Merge train Data
trainingData = cbind(yTrain,subjectTrain,xTrain);

# Merge test data
testData = cbind(yTest,subjectTest,xTest);

# Merge training and test data
finalSet = rbind(trainingData,testData);

# Create vector for ColumnNames
colNames  = colnames(finalSet); 

# Create vector that contains TRUE for values ID, mean, stddev
vector = (grepl("activity",colNames) 
			   | grepl("subject",colNames) 
			   | grepl("-mean",colNames) & !grepl("-meanFreq",colNames) & !grepl("mean-",colNames) 
			   | grepl("-std",colNames) & !grepl("-std()-",colNames));

# Subset finalSet table based on the logicalVector to keep only desired columns
finalSet = finalSet[vector==TRUE];

# Merge finalSet with activityType
finalSet = merge(finalSet,activityType,by='activityId',all.x=TRUE);

colNames  = colnames(finalSet); 

# Cleaning variable names
for (i in 1:length(colNames)) {
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^t","time",colNames[i])
  colNames[i] = gsub("^f","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};


colnames(finalSet) = colNames;

# Create new table 
finalNoActivityType  = finalSet[,names(finalSet) != 'activityType'];

tidyData    = aggregate(finalNoActivityType[,names(finalNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalNoActivityType$activityId,subjectId = finalNoActivityType$subjectId),mean);
# Merging the tidyData with activityType to include descriptive acitvity names
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

# Export to tidyData.txt
write.table(tidyData, './tidyData.txt',row.names=FALSE,sep='\t');




