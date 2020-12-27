# only load data if the dataframe does not exist
if(!exists("df", mode="list")) {
  # Note that typeof(df) == "list"

  csv_url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

  get_data <- function(data_url) {
    tfile = tempfile()
    download.file(data_url, tfile)
    tfile
  }

  zip_file = get_data(csv_url)

  unzip(zip_file, exdir = '.')

  df = read.csv(
    "household_power_consumption.txt",
    sep = ';',
    na.strings=c("?")
  )

  # extract values in the date range we care about
  df$Date = as.POSIXct(
    paste(df$Date, df$Time),
    format="%d/%m/%Y %H:%M:%S",
  )

  after = as.POSIXct("2007-02-01 00:00:00")
  before = as.POSIXct("2007-02-02 23:59:59")

  df = subset(df, after <= Date & Date <= before)

  # Cast values to usable data types
  df$Global_active_power = as.numeric(df$Global_active_power)
  df$Global_reactive_power = as.numeric(df$Global_reactive_power)
  df$Voltage = as.numeric(df$Voltage)
  df$Global_intensity = as.numeric(df$Global_intensity)
  df$Sub_metering_1 = as.numeric(df$Sub_metering_1)
  df$Sub_metering_2 = as.numeric(df$Sub_metering_2)
  df$Sub_metering_3 = as.numeric(df$Sub_metering_3)
}

png(
  file="plot1.png",
  width = 480,
  height = 480,
  units='px',
)

hist(
  df$Global_active_power,
  main="Global Active Power",
  xlab="Global Active Power (kilowatts)",
  col="red",
)

dev.off()
