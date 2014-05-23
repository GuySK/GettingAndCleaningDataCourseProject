# Script 3 - Create a new train data set with selected features, 
#            Subjects and Activities. 
#
# step 0 - Load auxiliary functions
print("step 0 - Loading auxiliary functions")
PjDir <- "C:/Users/AAB330/Google Drive 2/Training/DataScience/GettingAndCleaningData/Project"
setwd(PjDir)
source("AuxFunctions.R")
setwd("UCI HAR Dataset")                                 # UCI HAR Dataset dir
#
# step 1 read x_train
print("step 1 - reading x_train")
setwd("train")                                          # set directory
lx <- read_seg(filename="x_train.txt", nrecs=500, limit=7353, # see auxiliary functs
               widths=rep(16, 561), feat.names=features,
               feat.select=means.and.stds)
# join all segments in a single data set
x_train_sel <- join.list(lx)                            # see auxiliary functions
# 
# step4 read Activity and Subject data sets
print("Step4 - Reading Activity and Subject data sets")
dir() # => [1] "Inertial Signals" "subject_test.txt" "X_test.txt" "y_test.txt"
flist <- c(dir()[2], dir()[4])                          # set up list
ds.list <- read.all(func="table", sep=" ", list=flist)  # read files
subject_train <- ds.list[[1]]                           # subjects
y_train <- ds.list[[2]]                                 # activities
#
# Step 5 - set up a complete data set with Subjects and Actitivies 
print("Step 5 - setting up a complete data set with Subjects and Actitivies") 
x_train <- cbind(subject_train, y_train, x_train_sel)   # add cols subj, act
colnames(x_train)[1] <- "subject"                       # rename cols
colnames(x_train)[2] <- "activity"                      # this one too
# Present result                                        
View(x_train)                                         # show results  
setwd(PjDir)                                          # reset curr dir to Project
# end of script