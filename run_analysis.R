# R script called run_analysis.R that does the following
# 1. Merges the training and the test sets to create one data set.

XdataTr <- read.table("train/X_train.txt")
XdataTe <- read.table("test/X_test.txt")
Xdata <- rbind(XdataTr, XdataTe)

dataTrS <- read.table("train/subject_train.txt")
dataTeS <- read.table("test/subject_test.txt")
Sdata <- rbind(dataTrS, dataTeS)

YdataTr <- read.table("train/y_train.txt")
YdataTe <- read.table("test/y_test.txt")
Ydata <- rbind(YdataTr, YdataTe)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

features <- read.table("features.txt")
names(Xdata) <- features[,2]
dataNumMeanStd <- features[grep("-mean\\(\\)|-std\\(\\)", features$V2, ignore.case=TRUE),]

XdataMS <- Xdata[,dataNumMeanStd[,2]]

# 3. Uses descriptive activity names to name the activities in the data set

activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", activities[, 2])
Ydata[,1] = activities[Ydata[,1], 2]
names(Ydata) <- "activity"
names(Sdata) <- "subject"

# 4. Appropriately labels the data set with descriptive activity names.

cleanedData <- cbind(Sdata, Ydata, XdataMS)
write.table(cleanedData, "cleanedData.txt")

# 5. Create a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
tempData <- data.table(cleanedData)
cleanedData2<-tempData[,lapply(.SD,mean),by="activity,subject"]
write.table(cleanedData2, "cleanedData2.txt")
