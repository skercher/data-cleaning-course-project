# Getting and Cleaning Data - Course Project 

This is the course project for Getting and Cleaning Data. 
The 'run_analysis.R executes the following:

1. Download all datasets unless already exists.
2. Load data
3. Loads both the training and test datasets
4. Loads the activity and subject data for each dataset and merges those columns with the dataset. 
5. Merges the two datasets
6. Converts 'activity and 'subject' columns into factors
7. Creats a tidy dataset that consists of the average (mean) value of each variable for each subject and activity pair.

The final result is in the file 'tidy.txt'