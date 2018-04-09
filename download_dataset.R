#
# Download dataset
#

if (!dir.exists("data")) {
    zip_path <- "tmp.zip"
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", zip_path)
    unzip(zip_path)
    file.remove(zip_path)
    file.rename("UCI HAR Dataset", "data")
}

