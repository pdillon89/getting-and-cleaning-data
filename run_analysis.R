##download zip file##
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "Dataset.zip", method = "curl")
unzip("Dataset.zip")

###read tables into memory###
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/Y_train.txt")
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")

##label the variables##
headers<-features[,2]
names(x_test)<-headers
names(x_train)<-headers

##merge datatables
x_merge<-rbind(x_train, x_test)
y_merge<-rbind(y_train, y_test)
subject_merge<-rbind(subject_train, subject_test)

mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_merge<-x_merge[, mean_and_std_features]
names(x_merge)<-mean_and_std_features[,2]

merged_data<-cbind(subject_merge, y_merge, x_merge)
names(merged_data)[1]<-"SubjectId"
names(merged_data)[2]<-"Activity"

##label activities values##
merged_data$Activity<-factor(merged_data$Activity, labels=activity_labels[,2])

##tidy dataset: columns 3:68 contain the measurements
library(plyr)
tidy_data <- ddply(merged_data, .(SubjectId, Activity), function(x) colMeans(x[, 3:68]))

write.table(tidy_data, "UCI HAR Dataset/tidy_data.txt", row.name=FALSE)



