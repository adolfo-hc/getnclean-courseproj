#Variable names
features <- read.table("features.txt",
                       stringsAsFactors = FALSE)
activity_labels <- read.table("activity_labels.txt",
                              stringsAsFactors = FALSE)

######################
#Test variables values
X_test <- read.table("./test/X_test.txt",
                     stringsAsFactors = FALSE)
subject_test <- read.table("./test/subject_test.txt",
                           stringsAsFactors = FALSE)
y_test <- read.table("./test/y_test.txt",
                     stringsAsFactors = FALSE)
names(X_test) <- features$V2
X_test <- cbind(subject = subject_test$V1, activity = y_test$V1, X_test)

#######################
#Train variables values
X_train <- read.table("./train/X_train.txt",
                      stringsAsFactors = FALSE)
subject_train <- read.table("./train/subject_train.txt",
                            stringsAsFactors = FALSE)
y_train <- read.table("./train/y_train.txt",
                      stringsAsFactors = FALSE)
names(X_train) <- features$V2
X_train <- cbind(subject = subject_train$V1, activity = y_train$V1, X_train)

#######################
#Main Data Frame
X_main <- rbind(X_test, X_train)
X_shorted <- X_main[c(1:2, grep("mean()", names(X_main), fixed = TRUE),
                      grep("std()", names(X_main), fixed = TRUE))]

#######################
for (i in 1:length(activity_labels$V1)) {
  X_shorted$activity[X_shorted$activity == activity_labels$V1[i]] <- 
    activity_labels$V2[i]
}

X_shorted$subject <- factor(X_shorted$subject)
X_shorted$activity <- factor(X_shorted$activity)

rm(features, X_train, X_test, X_main, subject_test, subject_train,
   y_test, y_train, activity_labels)

#Reshaping the final data frame to make it tidy and summarizing it; all
#columns represent mean of the means.
library(reshape2)
df_melt <- melt(X_shorted, id.vars = 1:2, measure.vars = 3:68)
tidy_df <- dcast(df_melt, subject + activity ~ variable, mean)

#Making the variable names a little more explicit
names(tidy_df) <- gsub("-mean()", ".Mean", names(tidy_df), fixed = TRUE)
names(tidy_df) <- gsub("-std()", ".Std", names(tidy_df), fixed = TRUE)
names(tidy_df) <- gsub("-X$", ".Xaxis", names(tidy_df))
names(tidy_df) <- gsub("-Y$", ".Yaxis", names(tidy_df))
names(tidy_df) <- gsub("-Z$", ".Zaxis", names(tidy_df))
names(tidy_df) <- gsub("^t", "Time.", names(tidy_df))
names(tidy_df) <- gsub("^f", "Freq.", names(tidy_df))

#Removing sub-data frames from memory
rm(X_shorted, df_melt, i)

#Saving to a .csv file the final tidy data frame
write.csv(tidy_df, file = "samsung_tidy.csv", row.names = FALSE)

#Saving to a .txt file the final tidy data frame
#write.table(tidy_df, file = "samsung_tidy.txt", row.names = FALSE)
