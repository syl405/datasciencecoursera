NEI <- readRDS("summarySCC_PM25.rds")
split_set = split(NEI[NEI$fips=="24510",],NEI$year)
tot_emissions = sapply(split_set,function(x) sum(x$Emissions))
png(file="plot2.png")
plot(unique(NEI$year),
     tot_emissions,
     main="Total PM2.5 Emissions in Baltimore City, MD",
     xlab="Year",
     ylab="PM2.5 Emitted [tons]")
dev.off()