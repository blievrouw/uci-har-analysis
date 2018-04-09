#
# run_analysis.R
#

library(stringr)
library(dplyr)
library(tidyr)

# Combine test and training data of feature vectors, activities and subjects
feature_vectors_df <- rbind(read.table("data/test/X_test.txt"), read.table("data/train/X_train.txt"))
activities_df <- rbind(read.table("data/test/y_test.txt"), read.table("data/train/y_train.txt"))
subjects_df <- rbind(read.table("data/test/subject_test.txt"), read.table("data/train/subject_train.txt"))

# Read feature names from data and assign them to df
feature_names <- read.table("data/features.txt")[,2]
names(feature_vectors_df) <- feature_names

# Extract only mean and std feature measurements
mean_lgl <- grepl(".*?mean\\(\\).*", feature_names)
std_lgl <- grepl(".*?std\\(\\).*", feature_names)
feature_vectors_df <- feature_vectors_df[, (mean_lgl | std_lgl)]

# Read activity names from data
activity_names <- read.table("data/activity_labels.txt")[,2]

# Combine subject, activity, and feature vector data for each window
windows_df = cbind(
    subject = as.factor(subjects_df[[1]]),
    activity = sapply(activities_df[[1]], function(i) tolower(activity_names[i])),
    feature_vectors_df
)

feature_means_tbl <- windows_df %>%
    # Calculate average of each feature for each subject and each activity
    group_by(subject) %>% 
    group_by(activity, add=T) %>%
    summarise_all(mean) %>%
    # Tidy up data
    gather(feature_measurement_coordinate_str, average, -subject, -activity) %>%
    separate(feature_measurement_coordinate_str, c("feature_str", "measurement", "coordinate")) %>%
    extract(feature_str, c("signaltype", "feature"), '(.)(.*)') %>%
    # Rearrange rows by variables
    arrange(subject, activity, feature, signaltype, coordinate, measurement, average)

# Make column order match row arrangement
feature_means_tbl <- feature_means_tbl[,c(1,2,4,3,6,5,7)]

# Change coordinate values of features without dimensions to NA
feature_means_tbl$coordinate[feature_means_tbl$coordinate == ""] <- NA

# Make signaltype values more verbose
feature_means_tbl$signaltype[feature_means_tbl$signaltype == "t"] <- "time"
feature_means_tbl$signaltype[feature_means_tbl$signaltype == "f"] <- "frequency"

# Change dtype of new columns to factors
feature_means_tbl[3:6] <- lapply(feature_means_tbl[3:6], as.factor)

# Save result
write.csv(data.frame(feature_means_tbl), file="uci_har_analysis.csv", row.names = F)
