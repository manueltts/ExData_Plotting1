library(dplyr)
library(lubridate)
library(stringr)

## ######### ##
## LOAD FILE ##
## ######### ##

### Define txt, zip and url
dataFile <- "household_power_consumption.txt"
zipFile <- "exdata-data-household_power_consumption.zip"
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

### Check for txt; if not, check for zip; if neither download from url
if(!file.exists(dataFile)) {
        if(!file.exists(zipFile)) {
                download.file(
                        fileUrl,
                        destfile = zipFile,
                        method = "curl")
        } 
        unzip(zipFile)
}

### Load file
data1 <- read.table(dataFile, header = TRUE, sep = ";", na.strings = '?')

## ############ ##
## PREPARE DATA ##
## ############ ##

### set names to lowercase
names(data1) <- str_to_lower(names(data1))

### Date variables convertions and filter
data2 <- tbl_df(data1) %>%
        #### Create a variable with full time (date + daytime)
        mutate(datetime = paste(date, " ",time)) %>%
        mutate(datetime = dmy_hms(datetime)) %>%
        #### change date column to POSIXlt class and filer 2007 FEB 1st & 2nd
        mutate(date = dmy(date)) %>%
        filter(date == ymd("2007-02-01") | date == ymd("2007-02-02"))

## ############ ##
## DO THE GRAPH ##
## ############ ##

# Set graphics device to png file
png(filename = "plot1.png")

# Histogram of global active power
hist(data2$global_active_power, col = "red", main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

# Close png device connection
dev.off()
