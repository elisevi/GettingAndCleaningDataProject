# Load files
dSTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt");
dXTrain <- read.table("./UCI HAR Dataset/train/X_train.txt");
dYTrain <- read.table("./UCI HAR Dataset/train/y_train.txt");

dSTest <- read.table("./UCI HAR Dataset/test/subject_test.txt");
dXTest <- read.table("./UCI HAR Dataset/test/X_test.txt");
dYTest <- read.table("./UCI HAR Dataset/test/y_test.txt");

ActLab <- read.table("./UCI HAR Dataset/activity_labels.txt")
Feat   <- read.table("./UCI HAR Dataset/features.txt")


#1 Merges the training and the test sets to create one data set.
data <- rbind(cbind(dSTrain,dYTrain,dXTrain),cbind(dSTest,dYTest,dXTest))
names(data)<- c("Subject","Label",as.character(Feat$V2))

# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
extract_features <- grepl("mean|std", Feat$V2 )
data_meanstd <- data[,c(1,1,extract_features)]
names(data_meanstd)<- c("Subject","Label",as.character(Feat$V2[extract_features]))

# 3 Uses descriptive activity names to name the activities in the data set
data_meanstd$Label <- ActLab[data_meanstd$Label, 2]

# 4 Appropriately labels the data set with descriptive variable names.
names(data_meanstd) <- tolower(gsub("[^[:alpha:]]", "", names(data_meanstd)))

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
agg_data <- aggregate(data_meanstd[, 3:ncol(data_meanstd)],
                      by=list(subject = data_meanstd$subject, 
                               label = data_meanstd$label), mean)

write.table(format(agg_data, scientific=T), "tidy.txt", row.names=F, col.names=F, quote=2)
