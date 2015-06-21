##########################################################################################################

## Coursera Getting and Cleaning Data Course Project (getdata-015)
## James Matarese
## 06-20-2015

# runAnalysis.R File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

##########################################################################################################
# 1. Merge the training and the test sets to create one data set.
setwd("C:/Users/Matarese_Desktop/Desktop/Job Search III/R/UCI HAR Dataset")

#Read in the training data
features <- read.table('./features.txt',header=FALSE)
actType  <- read.table('./activity_labels.txt',header=FALSE)
subTrain <- read.table('./train/subject_train.txt',header=FALSE)
xTrain   <- read.table('./train/x_train.txt',header=FALSE)
yTrain   <- read.table('./train/y_train.txt',header=FALSE)

colnames(actType)  <- c('activityId','activityType')
colnames(subTrain) <- "subjectId"
colnames(xTrain)   <- features[,2]
colnames(yTrain)   <- "activityId"

trData <- cbind(yTrain,subTrain,xTrain)

# Read in the test data
subTest  <- read.table('./test/subject_test.txt',header=FALSE)
xTest    <- read.table('./test/x_test.txt',header=FALSE)
yTest    <- read.table('./test/y_test.txt',header=FALSE)

colnames(subTest) <- "subjectId"
colnames(xTest)   <- features[,2]
colnames(yTest)   <- "activityId"

teData <- cbind(yTest,subTest,xTest)
Data <- rbind(trData,teData)

colNames <- colnames(Data)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# get only columns with mean() or std() in their names
m.std <- grep("-(mean|std)\\(\\)", names(Data))
Data_1 <- Data[,m.std]
Data_F <- cbind(Data[,1:2],Data_1)

# 3. Use descriptive activity names to name the activities in the data set
Data_F <- merge(Data_F,actType,by='activityId',all.x=TRUE)
colNames <- colnames(Data_F)

# 4. Appropriately label the data set with descriptive activity names. 
#done above...

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
avg_Data_F <- select(Data_F, -activityType)
tidyData <- aggregate(avg_Data_F[,names(avg_Data_F) != c('activityId','subjectId')],by=list(activityId=avg_Data_F$activityId,subjectId = avg_Data_F$subjectId),mean)
tidyData <- merge(tidyData,actType,by='activityId')
# Export 
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t')

