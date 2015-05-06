# getdata -- function to download, unzip file. Returns file name for loading.

getdata <- function () {
        
        data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        new_file <- FALSE

        #  Check if the data directory exists and if not, create it.
        #  Check if the zip file exists. If not - download from the source 
        #  unzip if necessary

        if (!file.exists ("./data")) {dir.create ("./data")} 

        if (!file.exists ("./data/data.zip")) {
                download.file(data_url, destfile="./data/data.zip", method="curl")
                new_file <- TRUE     
        }

        if ( (!file.exists ("./data/household_power_consumption.txt") ) | new_file ) {unzip ("./data/data.zip", exdir="./data", overwrite=TRUE) }

        return ("./data/household_power_consumption.txt")
} 

#-----------Plot 3 - ------------------
png ("plot3.png", width=480, height=480)

# Get data and load it
hh_power <- read.table (getdata(), na.strings="?", sep=";", header=TRUE)

# subset data by dates
hh_power <- hh_power[hh_power$Date %in% c("1/2/2007","2/2/2007"),]

# add a column with the processed date-time.
datetime <- strptime( paste (hh_power$Date, hh_power$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
hh_power <- cbind (datetime, hh_power)

plot (hh_power$datetime, hh_power$Sub_metering_1, ylab="Energy Sub-metering", xlab="", type="l", col="black")
        lines (hh_power$datetime, hh_power$Sub_metering_2, col="red", type="l")
        lines (hh_power$datetime, hh_power$Sub_metering_3, col="blue", type="l")
        legend("topright",legend = names(hh_power[8:10]), col=c("black","red","blue"), lty=1 )

dev.off()      
