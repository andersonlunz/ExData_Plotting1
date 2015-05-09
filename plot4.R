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
data_feb_2007$Global_reactive_power <- as.numeric(as.character(data_feb_2007$Global_reactive_power))
data_feb_2007$Voltage <- as.numeric(as.character(data_feb_2007$Voltage))
data_feb_2007 <- transform(data_feb_2007, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")
data_feb_2007$Sub_metering_1 <- as.numeric(as.character(data_feb_2007$Sub_metering_1))
data_feb_2007$Sub_metering_2 <- as.numeric(as.character(data_feb_2007$Sub_metering_2))
data_feb_2007$Sub_metering_3 <- as.numeric(as.character(data_feb_2007$Sub_metering_3))


# Generate the plot4 and save it on a file

# Set layout
par(mfrow=c(2,2))

# Draw plot left upper corner
plot(data_feb_2007$timestamp, data_feb_2007$Global_active_power, type="l", xlab="", ylab="Global Active Power")

# Draw plot right upper corner
plot(data_feb_2007$timestamp, data_feb_2007$Voltage, type="l", xlab="datetime", ylab="Voltage")

# Draw plot left down corner
plot(data_feb_2007$timestamp, data_feb_2007$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(data_feb_2007$timestamp, data_feb_2007$Sub_metering_2,col="red")
lines(data_feb_2007$timestamp, data_feb_2007$Sub_metering_3,col="blue")
legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), bty="n", cex=.5)

# Draw plot right down corner
plot(data_feb_2007$timestamp, data_feb_2007$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()