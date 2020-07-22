library(dplyr)

# Merge subject
subjecttest<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names="Subject")
subjecttrain<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names="Subject")
subject<-rbind(subjecttrain,subjecttest)

# Merge training and test set
features<-read.table("UCI HAR Dataset/features.txt",col.names=c("id","variables"))
xtest<-read.table("UCI HAR Dataset/test/X_test.txt",col.names=features$variables)
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt",col.names=features$variables)
x<-rbind(xtrain,xtest)

# Merge training and test labels
activity<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c("id","Activity"))
ytest<-read.table("UCI HAR Dataset/test/y_test.txt",col.names="id")
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt",col.names="id")
y<-rbind(ytrain,ytest)

# 1. Merges the training and the test sets to create one data set
dataset<-cbind(subject,y,x)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
dataset<-select(dataset,Subject,id,contains("mean"),contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set
dataset$id<-activity[dataset$id,2]
View(dataset)

# Tidy data set
dataset<-arrange(dataset,Subject,id)

# 4. Appropriately labels the data set with descriptive variable names
names(dataset)[2]="Activity"
names(dataset)<-gsub("^t","Time",names(dataset))
names(dataset)<-gsub("^f","Frequency",names(dataset))
names(dataset)<-gsub("angle","Angle",names(dataset))
names(dataset)<-gsub("Acc","Accelerometer",names(dataset))
names(dataset)<-gsub("Gyro","Gyroscope",names(dataset))
names(dataset)<-gsub("Mag","Magnitude",names(dataset))
names(dataset)<-gsub("BodyBody","Body",names(dataset))
names(dataset)<-gsub("mean()","Mean",names(dataset))
names(dataset)<-gsub("std()","Standard Deviation",names(dataset))
names(dataset)<-gsub("-Freq()","Frequency",names(dataset))
names(dataset)<-gsub("tBody","TimeBody",names(dataset))
names(dataset)<-gsub("gravity","Gravity",names(dataset))

# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject

averagedata<-group_by(dataset,Subject,Activity)
averagedata<-summarise_all(averagedata,list(mean))
write.table(averagedata,"AverageData.txt",row.name=FALSE)

# Preview data
View(averagedata)
head(tibble::as_tibble(averagedata))
tail(tibble::as_tibble(averagedata))
summary(averagedata)
str(averagedata)






