# Getting and cleaning data week 4 project

The purpose of this project is to collect and clean a data set. The R script (run_analysis.R) does the following:

1. Downloads the dataset from the URL if it does not already exist and unzips it
2. Opens the activity and feautes files
3. Opens the train and test files, reading only the mean and standard deviation columns
4. Opens the activity and subject data for each dataset and merges the columns with the dataset
5. Merges the two datasets
6. Converts the "activity" and "subject" columns into factors
7. Creates a tidy dataset that consists of the mean value of each variable for each activity and subject and exports it to tidydata.txt.