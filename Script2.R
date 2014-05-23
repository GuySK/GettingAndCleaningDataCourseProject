# Script 2 - Create a new test data set with selected features, 
#            Subjects and Activities.
#
# Part 1 - Select appropriate features (means and standard deviations)
# step 0 - Load auxiliary functions
print("Step 0 - Loading auxiliary functions")
PjDir <- "C:/Users/AAB330/Google Drive 2/Training/DataScience/GettingAndCleaningData/Project"
setwd(PjDir)                                            # point to the right dir
source("AuxFunctions.R")                                # load auxiliary functions
#
# step 1 - read features txt
print("step 1 - reading features txt")
setwd("UCI HAR Dataset")                                # UCI HAR Dataset dir
features <- read.table(dir()[2], sep=" ", header=FALSE) # read features.txt
features <- as.character(features[,2])                  # convert to chars
#
# step 2 - select features
print("Step 2 - Selecting features")
library(stringr)                                       
means.f <- str_detect(features, "mean()")              # identify means
std.f <- str_detect(features, "std()")                 # identify stds
means.and.stds <- means.f | std.f                      # OR both vectors
rm(list=c("means.f", "std.f"))                         # remove unnecessary objects
#
# step 3 read x_test
print("Step 3 - Reading x_test file")
setwd("test")                                          # set directory
lx <- read_seg(filename="x_test.txt", nrecs=500, limit=2947, # see auxiliary functs
               widths=rep(16, 561), feat.names=features,
               feat.select=means.and.stds)
# join all segments in a single data set
x_test_sel <- join.list(lx)                            # see auxiliary functions
# 
# Step4 - read Activity and Subject data sets
print("Step4 - Reading Activity and Subject data sets")
dir() # => [1] "Inertial Signals" "subject_test.txt" "X_test.txt" "y_test.txt"
flist <- c(dir()[2], dir()[4])                         # set up list
ds.list <- read.all(func="table", sep=" ", list=flist) # read files
subject_test <- ds.list[[1]]                           # subjects
y_test <- ds.list[[2]]                                 # activities
# set up a complete data set with Subjects and Actitivies 
x_test <- cbind(subject_test, y_test, x_test_sel)      # add subj and act cols
colnames(x_test)[1] <- "subject"                       # name cols
colnames(x_test)[2] <- "activity"
View(x_test)                                           # show results
setwd(PjDir)                                           # reset curr dir to Project
# end of script