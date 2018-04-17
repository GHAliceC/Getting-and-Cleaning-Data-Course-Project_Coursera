## clear global environment and set working directory
rm(list = ls())
setwd("./Documents/R_programming/UCI HAR Dataset/")

## restructure and aggregate data 
library(reshape2)

## load activity labels and features information
activity_labels <- read.table(file = "./activity_labels.txt")
a_labels <- as.character(activity_labels[,2])
features_info <- read.table(file = "./features.txt")
features <- as.character(features_info[,2])

## keep only mean and standard deviation measurements among all features
featuresSelected <- grep("mean|std", features)
featuresnames <- features_info[featuresSelected, 2]
featuresnames <- gsub("-mean", "Mean", featuresnames)
featuresnames <- gsub("-std", "Std", featuresnames)

## load training and test datasets with selected features columns
train_X <- read.table(file = "./train/X_train.txt")[featuresSelected]
train_y <- read.table(file = "./train/y_train.txt")
train_sub <- read.table(file = "./train/subject_train.txt")
train <- cbind(train_sub, train_y, train_X)

test_X <- read.table(file = "./test/X_test.txt")[featuresSelected]
test_y <- read.table(file = "./test/y_test.txt")
test_sub <- read.table(file = "./test/subject_test.txt")
test <- cbind(test_sub, test_y, test_X)

## merge training and test dataset and add columns names
merged_data <- rbind(train, test)
colnames(merged_data) <- c("Subjects", "Activities", featuresnames)

merged_data$Activities <- factor(merged_data$Activities, levels = activity_labels[,1], labels = a_labels)
merged_data$Subjects <- as.factor(merged_data$Subjects)

## create dataframe to generate a new independent dataset entitled "tidy.txt"
merged_data.melted <- melt(merged_data, id = c("Subjects", "Activities"))
merged_data.mean <- dcast(merged_data.melted, Subjects + Activities ~ variable, mean)

write.table(merged_data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
