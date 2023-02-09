library(dplyr)

#get all data
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "code")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

# bind rows for xtrain and xtest
combineX<-rbind(x_train, x_test)
combineY<-rbind(y_train, y_test)
combineSubj<-rbind(subject_train, subject_test)
merged <- cbind(combineSubj, combineY, combineX)

#mean and std
clean = select(merged, subject, code, contains("mean"), contains("std"))

#use activity name for data set
clean$code <- activities[clean$code, 2]
names(clean)[2] = "activity"

#label data set
names(clean) <- gsub("^t", "Time", names(clean))
names(clean) <- gsub("^f", "Frequency", names(clean))
names(clean) <- gsub("-mean()", "Mean", names(clean))
names(clean) <- gsub("-std()", "Std", names(clean))
names(clean) <- gsub("-freq()", "Frequency", names(clean))
names(clean) <- gsub("\\.", "", names(clean))
names(clean) <- gsub("std", "Std", names(clean))
names(clean) <- gsub("mean", "Mean", names(clean))
names(clean) <- gsub("Acc", "Accelerometer", names(clean))
names(clean) <- gsub("Mag", "Magnitude", names(clean))
names(clean) <- gsub("BodyBody", "Body", names(clean))
names(clean) <- gsub("angle", "Angle", names(clean))
names(clean) <- gsub("tBody", "TimeBody", names(clean))
names(clean) <- gsub("gravity", "Gravity", names(clean))


#create second and independent data set with average of each variable for activity and subject
result <- clean %>% group_by(subject, activity) %>% summarize_all(list(mean))

#create a text file
write.table(result, "tidy_data.txt", row.name = FALSE)
