# Script 4 - Combines both train and test data sets,
#            creates a new data set with averages for 
#            each subject, activity 
#
# step 0 - Load auxiliary functions
print("Step 0 - loading auxiliary functions")
PjDir <- "C:/Users/AAB330/Google Drive 2/Training/DataScience/GettingAndCleaningData/Project"
setwd(PjDir)
source("AuxFunctions.R")
#
# step 1 - combines both data sets and label activities
print("step 1 - combining both data sets and labeling activities")
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
print("Step 2 - Creating a second data set")
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
print("End of Job.")
