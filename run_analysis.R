# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

TRAIN_SET <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
DESTFILE <- 'train_set_samsung.zip'
# Download fie, it is an binary archive so use wb(binary) mode
download.file(TRAIN_SET, mode = 'wb', destfile = DESTFILE)
unzip(DESTFILE)

# Set directories to work with
BASE_DIR_PATH <- file.path(getwd(), 'UCI HAR Dataset')

# read the activities file, convert all data to chars
activities_table <- read.table(file.path(BASE_DIR_PATH, "activity_labels.txt"), col.names=c("Activity_id", "Activity_name"), stringsAsFactors=FALSE)

# Clean data for activities
activities_table[,2] <- gsub('_', ' ', tolower(activities_table[,2]))

# Read features list
features <- read.table(file.path(BASE_DIR_PATH, "features.txt"), stringsAsFactors=FALSE)[,2]

# Determine indexes of mean and standart deviation(std) values in features list
features_target_indexes <- (grepl('mean()', features) & !grepl('meanFreq()',features)) | grepl('std()', features)

# Clean features names
features <- gsub('-', ' ', features)
features <- gsub('\\(\\)', '', features)
features <- gsub('Acc', ' acceleration', features)
features <- gsub('Body', 'body', features)
features <- gsub('bodybody', 'body', features)
features <- gsub('Jerk', ' jerk', features)
features <- gsub('Gyro', ' gyroscope', features)
features <- gsub('Gravity', 'gravity', features)
features <- gsub('Mag', ' magnitude', features)
features <- gsub('std', 'standrt dev', features)
features <- gsub('^t', 'Time ', features)
features <- gsub('^f', 'Frequency ', features)

# function to read measurment from directory named like suffix, then filter only target columns
construct_measurments_table <- function(suffix){
  # Read test measurments
  measurments_table <- read.table(file.path(BASE_DIR_PATH, suffix, paste('X_', suffix, '.txt', sep = '')), col.names=features)
  # filter only target measurments
  measurments_table <- measurments_table[,features_target_indexes]
  # Add activities ids
  activity_labels <- read.table(file.path(BASE_DIR_PATH, suffix, paste('y_', suffix, '.txt', sep = '')), col.names=c("Activity_id"))
  # Add subject ids column
  subject_labels <- read.table(file.path(BASE_DIR_PATH, suffix, paste('subject_', suffix, '.txt', sep = '')), col.names=c("Subject_id"))
  cbind(subject_labels, activity_labels, measurments_table)
}

# bind test and training data to one result table
measurments_table <- rbind(construct_measurments_table('train'), construct_measurments_table('test'))
# Add activities names
measurments_table <- merge(measurments_table, activities_table, by.X = 'Activity_id', by.Y = 'Activity_id')

library(data.table)
measurments_tbl <- data.table(measurments_table)
result_measurments_table <- measurments_tbl[,lapply(.SD,mean), by = 'Subject_id,Activity_name', .SDcols = 3:68]

# Change names of features to appropriate
colnames(result_measurments_table) <- c(colnames(result_measurments_table)[1:2], sapply(colnames(result_measurments_table)[3:68], function(x) paste('Mean of',x)))

# Write result as said in assigment
write.table(result_measurments_table, file="tidy_data.txt", row.names = FALSE)
