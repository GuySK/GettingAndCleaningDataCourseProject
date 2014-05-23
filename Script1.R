# Getting and Cleaning Data -  Course Project - 
# Scritp 1 - Unzip downloaded files and access documentation         
#
PjDir <- "C:/Users/AAB330/Google Drive 2/Training/DataScience/GettingAndCleaningData/Project"
setwd(PjDir)
dir()              # get list of files
zipfn <- dir()[2]  # => [2] "getdata-projectfiles-UCI HAR Dataset (1).zip"  
unzip(zipfn)       # unzip file
dir()              # => [5] "UCI HAR Dataset" 
setwd(dir()[5])    # access documentation
dir()             # => [1] "activity_labels.txt" "features.txt" "features_info.txt"  
                  #    [4] "README.txt"          "test"          "train"
setwd(PjDir)       # reset current dir
# end of script