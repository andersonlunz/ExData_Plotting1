###############################################################################
## First Download the zip file data set and extract it on working directory  ##
## NOTE: Set your working directory before downloading the file if you want. ##
###############################################################################
#work_dir <- "/tmp/exploratory_data_analysis"

#if (!file.exists(work_dir)) {
#  dir.create(work_dir)
#}

#setwd(work_dir)

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_file_name <- "household_power_consumption.zip"
download.file(fileUrl, destfile=zip_file_name, method="curl")

# Open zip files with all the files in the same directory
unzip(zip_file_name, junkpaths = TRUE)


# Load the dataset
file_to_load <- "household_power_consumption.txt"
electric_pc <- read.table(file_to_load, sep=";", na.strings = "?", header=TRUE)


#Convert Date variable
electric_pc$Date <- as.Date(electric_pc$Date, format="%d/%m/%Y")


#Filter dataframe to get only 2 days on February 2007, I choose the first to days 2007-02-01 and 2007-02-02
library(dplyr)
data_feb_2007 <- filter(electric_pc, Date >= as.Date('2007-02-01', format="%Y-%m-%d") & Date <= as.Date('2007-02-02', format="%Y-%m-%d"))


# Convert other variables
data_feb_2007$Global_active_power <- as.numeric(as.character(data_feb_2007$Global_active_power))
data_feb_2007 <- transform(data_feb_2007, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

# Generate the plot2 and save it on a file
plot(data_feb_2007$timestamp, data_feb_2007$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.copy(png, file="plot2.png", width=480, height=480)
dev.off()