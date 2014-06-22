Getting and Cleaning Data - Course Project
===========
The first part of the script "run_analysis.R" reads all the different data sets from the experiments.

First it loads the "features" and "activity_labels", these files are stored as data frames in two variables and will be used later as column-variables in our final tidy data frame. The "features" data frame will be used to name all the different measurements that were taken in the study (variable-columns) and the "activity_labels" will be used to decode the activity that each subject (person) was performing when the measurement was taken.

```
features <- read.table("features.txt", stringsAsFactors = FALSE)
activity_labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE)
```

The "subject_test" and the "activity" data variables-columns were added using the cbind() function for both sets, the test and the training data. Once both data sets, the "test" data frame and the "train" data frame were finished they were merged together to create a big data frame called "X_main" using the rbind() function, this data frame contained all the information from all the variables "features" for each subject (person), in total 30 persons and the 6 different activities for each person.

```
#Test variables values
X_test <- read.table("./test/X_test.txt", stringsAsFactors = FALSE)
subject_test <- read.table("./test/subject_test.txt", stringsAsFactors = FALSE)
y_test <- read.table("./test/y_test.txt", stringsAsFactors = FALSE)
names(X_test) <- features$V2
X_test <- cbind(subject = subject_test$V1, activity = y_test$V1, X_test)

#######################
#Train variables values
X_train <- read.table("./train/X_train.txt", stringsAsFactors = FALSE)
subject_train <- read.table("./train/subject_train.txt", stringsAsFactors = FALSE)
y_train <- read.table("./train/y_train.txt", stringsAsFactors = FALSE)
names(X_train) <- features$V2
X_train <- cbind(subject = subject_train$V1, activity = y_train$V1, X_train)
```

Next, the function grep() was used to keep just the variables-columns that contained the measurements that contained the "mean()" or "std()" strings which are the ones we are interested in.

```
X_main <- rbind(X_test, X_train)
X_shorted <- X_main[c(1:2, grep("mean()", names(X_main), fixed = TRUE), grep("std()", names(X_main), fixed = TRUE))]
```

To rename from numbers to description in the activity column is used a "for" loop, inside this loop the rows that contain each activity are filtered and replaced by its corresponding description. Next the subject and activity columns are changed from character to factor in order to facilitate its use.

```
for (i in 1:length(activity_labels$V1)) {
  X_shorted$activity[X_shorted$activity == activity_labels$V1[i]] <- 
    activity_labels$V2[i]
}

X_shorted$subject <- factor(X_shorted$subject)
X_shorted$activity <- factor(X_shorted$activity)
```
Then the variables that are not used anymore are removed to free some memmory.

```
rm(features, X_train, X_test, X_main, subject_test, subject_train, y_test, y_train, activity_labels)
```

Finally the reshape2 library is loaded into R in order to use the melt() and dcast() functions. The melt() function is used to make a long data frame where all the variable-columns are melted into rows where each feature is now a row with its respective value as a variable-column as well.

```
library(reshape2)
df_melt <- melt(X_shorted, id.vars = 1:2, measure.vars = 3:68)
tidy_df <- dcast(df_melt, subject + activity ~ variable, mean)
```

Then we use the dcast() function to make again our data frame "wide" but this time the final tidy data frame is summarized by grouping each subject (person) with every activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) and its respective feature-measurement value pair, **now the final data frame contains the mean of all the measurements taken for each subject-activity-feature in order to summarize all the measurements.**

```
#Making the variable names a little more explicit
names(tidy_df) <- gsub("-mean()", ".Mean", names(tidy_df), fixed = TRUE)
names(tidy_df) <- gsub("-std()", ".Std", names(tidy_df), fixed = TRUE)
names(tidy_df) <- gsub("-X$", ".Xaxis", names(tidy_df))
names(tidy_df) <- gsub("-Y$", ".Yaxis", names(tidy_df))
names(tidy_df) <- gsub("-Z$", ".Zaxis", names(tidy_df))
names(tidy_df) <- gsub("^t", "Time.", names(tidy_df))
names(tidy_df) <- gsub("^f", "Fourier.", names(tidy_df))

#Removing sub-data frames from memory
rm(X_shorted, df_melt, i)

#Saving to a .csv file the final tidy data frame
write.csv(tidy_df, file = "samsung_tidy.csv", row.names = FALSE)

#Saving to a .txt file the final tidy data frame
write.table(tidy_df, file = "samsung_tidy.txt", row.names = FALSE)
```

By the end of the script the function gsub() is used to replace some strings with more explicit words in order to make the variable names more understandable then the final tidy data frame is saved to a csv file and a txt file.
