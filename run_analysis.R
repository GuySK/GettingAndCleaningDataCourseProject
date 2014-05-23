# Getting and Cleaning Data -  Course Project - 
#
# This script includes all necessary steps to complete the project task
# 
PjDir <- "C:/Users/AAB330/Google Drive 2/Training/DataScience/GettingAndCleaningData/Project"
setwd(PjDir)
#
# Script 1 - Unzips downloaded files and access documentation         
source("Script1.R")
#
# Script 2 - Creates a new test data set with selected features 
source("Script2.R")
#
# Script 3 - Creates a new train data set with selected features
source("Script3.R")
#
# Script 4 - Combines both train and test data sets and creates a 
#            new data set with averages for each subject, activity 
source("Script4.R")
# end of script
