# Getting and Cleaning Data -  Course Project - 
#
# This script includes all necessary steps to complete the project task
# 
# Change the following line if zip file name different from default
zipfile <- "getdata-projectfiles-UCI HAR Dataset.zip"
# 
PjDir <- getwd()                             # get working directory 
zipfn <- dir(pattern=zipfile)                # look for zip file
setwd(PjDir)                                 # check if work directory accessible
cat("Working directory is ", PjDir, "\n")    # Tell the user
#
if (length(zipfn) == 0) {                    # check if file present
    errmsg1 <- paste("<", zipfile, ">", sep="")
    stop(cat("File", errmsg1, "not found.", "\n"), call.=FALSE)
}
# Script 1 - Unzips downloaded files and access documentation
cat("\n>>>Script 1 - Unzips downloaded files and access documentation \n")
cat("Running Script 1 / 4", "\n")
unzip(zipfile)                               # unzip file
setwd("UCI HAR Dataset")                     # access documentation
unziplist <- dir()                           # list files
cat("Unzip files and dirs:\n")               # tell the user
cat(unziplist, "\n", sep=" / ")
setwd(PjDir)                                 # reset current dir
#
# Script 2 - Creates a new test data set with selected features 
#            Subjects and Activities.
#
cat("\n>>>Script 2 - Creates a new test data set with selected features \n") 
cat("Running Script 2 / 4 \n")
# Part 1 - Selects appropriate features (means and standard deviations)
# step 0 - Loads auxiliary functions
cat("Step 0 - Loading auxiliary functions\n")
setwd(PjDir)                                            # point to the right dir
source("AuxFunctions.R")                                # load auxiliary functions
#
# step 1 - read features txt
cat("step 1 - reading features txt\n")
setwd("UCI HAR Dataset")                                # UCI HAR Dataset dir
features <- read.table(dir()[2], sep=" ", header=FALSE) # read features.txt
features <- as.character(features[,2])                  # convert to chars
#
# step 2 - select features
cat("Step 2 - Selecting features\n")
library(stringr)                                       
means.f <- str_detect(features, "mean()")              # identify means
std.f <- str_detect(features, "std()")                 # identify stds
means.and.stds <- means.f | std.f                      # OR both vectors
rm(list=c("means.f", "std.f"))                         # remove unnecessary objects
#
# step 3 read x_test
cat("Step 3 - Reading x_test file by segments due to memory constraints\n")
# Production parameters follow. Uncomment for running in production mode
records <- 500
maxrecs <- 2947
# Testing parameters follow. Uncomment for running in testing mode
# records <- 50
# maxrecs <- 294
setwd("test")                                          # set directory
lx <- read_seg(filename="x_test.txt", nrecs=records, limit=maxrecs, # see auxiliary functs
               widths=rep(16, 561), feat.names=features,
               feat.select=means.and.stds)
# join all segments in a single data set
x_test_sel <- join.list(lx)                            # see auxiliary functions
# 
# Step4 - read Activity and Subject data sets
cat("Step4 - Reading Activity and Subject data sets\n")
dir() # => [1] "Inertial Signals" "subject_test.txt" "X_test.txt" "y_test.txt"
flist <- c(dir()[2], dir()[4])                         # set up list
ds.list <- read.all(func="table", sep=" ", list=flist) # read files
subject_test <- ds.list[[1]]                           # subjects
y_test <- ds.list[[2]]                                 # activities
# set up a complete data set with Subjects and Actitivies 
x_test <- cbind(subject_test[1:maxrecs,], y_test[1:maxrecs,], x_test_sel)      # add subj and act cols
colnames(x_test)[1] <- "subject"                       # name cols
colnames(x_test)[2] <- "activity"
View(x_test)                                           # show results
setwd(PjDir)                                           # reset curr dir to Project
#
# Script 3 - Creates a new train data set with selected features
cat("\n>>>Script 3 - Creates a new train data set with selected features \n")
cat("Running Script 3 / 4", "\n")
cat("step 0 - Loading auxiliary functions\n")
setwd(PjDir)
source("AuxFunctions.R")
setwd("UCI HAR Dataset")                                 # UCI HAR Dataset dir
#
# step 1 read x_train
cat("step 1 - reading x_train by segments due to memory constraints")
setwd("train")                                          # set directory
# Production parameters follow. Uncomment for running in production mode
records <- 500
maxrecs <- 7353
# Testing parameters follow. Uncomment for running in testing mode
# records <- 50
# maxrecs <- 735
lx <- read_seg(filename="x_train.txt", nrecs=records, limit=maxrecs, # see auxiliary functs
               widths=rep(16, 561), feat.names=features,
               feat.select=means.and.stds)
# join all segments in a single data set
x_train_sel <- join.list(lx)                            # see auxiliary functions
# 
# step4 read Activity and Subject data sets
cat("Step4 - Reading Activity and Subject data sets \n")
dir() # => [1] "Inertial Signals" "subject_test.txt" "X_test.txt" "y_test.txt"
flist <- c(dir()[2], dir()[4])                          # set up list
ds.list <- read.all(func="table", sep=" ", list=flist)  # read files
subject_train <- ds.list[[1]]                           # subjects
y_train <- ds.list[[2]]                                 # activities
#
# Step 5 - set up a complete data set with Subjects and Actitivies 
cat("Step 5 - setting up a complete data set with Subjects and Actitivies \n") 
x_train <- cbind(subject_train[1:maxrecs,], y_train[1:maxrecs,], x_train_sel) # add cols subj, act
colnames(x_train)[1] <- "subject"                       # rename cols
colnames(x_train)[2] <- "activity"                      # this one too
# Present result                                        
View(x_train)                                         # show results  
setwd(PjDir)                                          # reset curr dir to Project
#
# Script 4 - Combines both train and test data sets,
#            creates a new data set with averages for 
#            each subject, activity 
#
cat("\n>>>Script 4 - Combines both train and test data sets \n")
cat("Running Script 4 / 4 \n")
# step 0 - Load auxiliary functions
cat("Step 0 - loading auxiliary functions \n")
setwd(PjDir)
source("AuxFunctions.R")
#
# step 1 - combines both data sets and label activities
cat("Step 1 - combining both data sets and labeling activities \n")
x_all <- rbind(x_train, x_test)                        # join both data sets
act.labels <- c("WALKING", "WALKING_UPSTAIRS",         # create activity labels
                "WALKING_DOWNSTAIRS", 
                "SITTING", "STANDING", "LAYING")
x_all[,2] <- factor(x_all[,2],labels=act.labels)       # label activities
x_all[,1] <- as.factor(x_all[,1])                      # subjects as factors
save(x_all,file=paste(PjDir,"x_All.RData", sep="/"))   # save object
write.table(x_all, "x_All.txt", sep=",")               # save it as a txt file
#
# Step 2 - Creates a second data set
cat("Step 2 - Creating a second data set \n")
split.list <- split(x_all, list(x_all$subject, x_all$activity)) # split list
# get means for all columns in the data frame with lapply
meansList <- lapply(split.list, function(x) c(x[1,1:2], colMeans(x[3:81])))
# join all dataframes in one single object using an aux function
means.Sub.Act <- join.list(meansList, data.frame)    # see Auxiliary functions
# they want it tidy, so let's sort it by Subject and Activity
means.Sub.Act <- means.Sub.Act[order(fac.as.numeric(means.Sub.Act[,1]), 
                                     as.character(means.Sub.Act[,2])),]
View(means.Sub.Act)    # check it out
save(means.Sub.Act,file=paste(PjDir,"Means.Subj.Act.RData", sep="/")) # save it
write.table(means.Sub.Act, "Means_Subj_Act.txt", sep=",") # save it as a txt file
setwd(PjDir)           # reset current dir to Project
# end of job
cat("End of Job. \n")
# end of main script #