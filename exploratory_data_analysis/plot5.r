NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
scc_list = as.character(SCC[SCC$SCC.Level.Two %in% c("Highway Vehicles - Diesel", "Highway Vehicles - Gasoline", "Off-highway Vehicle Diesel", "Off-highway Vehicle Gasoline, 2-Stroke", "Off-highway Vehicle Gasoline, 4-Stroke"),"SCC"])

filtered_set = NEI[NEI$SCC %in% scc_list & NEI$fips=="24510",]
split_set = split(filtered_set, filtered_set$year)
tot_emissions = sapply(split_set,function(x) sum(x$Emissions))

png("plot5.png")
plot(unique(NEI$year),
     tot_emissions,
     main="Annual Total PM2.5 Emissions from Motor Vehicles in Baltimore City, MD",
     xlab="Year",
     ylab="PM2.5 Emitted [tons]")
dev.off()