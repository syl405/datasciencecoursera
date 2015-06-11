NEI <- readRDS("summarySCC_PM25.rds")
split_set = split(NEI,NEI$year)
tot_emissions = sapply(split_set,function(x) sum(x$Emissions))
png(file="plot1.png")
plot(unique(NEI$year),
     tot_emissions,
     main="Total PM2.5 Emissions in the United States",
     xlab="Year",
     ylab="PM2.5 Emitted [tons]")
