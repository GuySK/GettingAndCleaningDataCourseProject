# Getting and Cleaning Data -  Course Project - 
# Scritp 0 - used to test scripts interactions         
#
print("Script 0 - Testing Scripts interactions")
PjDir <- "C:/Users/AAB330/Google Drive 2/Training/DataScience/GettingAndCleaningData/Project"
setwd(PjDir)
dir()              # get list of files
dir()              # => [15] "UCI HAR Dataset" 
setwd(dir()[15])   # access documentation
dir()              # => [1] "activity_labels.txt" "features.txt" "features_info.txt"  
                   #    [4] "README.txt"          "test"          "train"
setwd(PjDir)       # reset current dir
print("End of Script")
# end of script