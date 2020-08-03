

# Imports the necessary data into R
features <- read.table("./UCI HAR Dataset/features.txt", sep="", stringsAsFactors=F, header=F, col.names = c("id", "feature"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", sep="", stringsAsFactors=F, header=F, col.names = c("id", "Activity"))
activities[2, 2] <- "WALKING UPSTAIRS"
activities[3, 2] <- "WALKING DOWNSTAIRS"

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="", stringsAsFactors=F, header=F) #Datos
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", sep="", stringsAsFactors=F, header=F, col.names = "Activity") #Actividades
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="", stringsAsFactors=F, header=F, col.names = "Subject") #Sujetos
testData <- cbind(subject_test, y_test, X_test)

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="", stringsAsFactors=F, header=F)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", sep="", stringsAsFactors=F, header=F, col.names = "Activity")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="", stringsAsFactors=F, header=F, col.names = "Subject")
trainData <- cbind(subject_train, y_train, X_train)


# Merges the training and test data sets into one data set
dataSet <- rbind(testData, trainData)


# Extracts only the mean and std measurements of the data set
variables <- sort(c((grep("*[Mm]ean*", features$feature) + 2), (grep("*[Ss]td*", features$feature) + 2)))


# Creates a data set with the subject, activity and desired measurements
dataSet2 <- dataSet[,c(1, 2, variables)]


# Changes the activity labels into descriptive names
for (i in 1:10299) {
    id <- dataSet2[i, 2]
    dataSet2[i,2] <- activities[id, 2]
}


# Calculates the mean of each row
dataSet2 <- cbind(dataSet2, RowMean = rowMeans(dataSet2[,3:88]))


# Summarizes the data grouping the dataset by subject and activity and calculating the mean
group <- group_by(dataSet2, Subject, Activity)
result <- as.data.frame(summarize(group, Mean = mean(RowMean)))

# Prints resulting data set
print(result)

