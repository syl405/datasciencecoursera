NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
scc_list = as.character(SCC[SCC$SCC.Level.Two %in% c("Highway Vehicles - Diesel", "Highway Vehicles - Gasoline", "Off-highway Vehicle Diesel", "Off-highway Vehicle Gasoline, 2-Stroke", "Off-highway Vehicle Gasoline, 4-Stroke"),"SCC"])

filtered_set = NEI[NEI$SCC %in% scc_list & NEI$fips %in% c("24510","06037"),]
filtered_set$fips = as.factor(filtered_set$fips)
split_set = split(filtered_set, filtered_set$fips)
split_set = lapply(split_set, function(x) split(x,x$year))
tot_emissions = sapply(split_set, function(y) sapply(y,function(x) sum(x$Emissions)))

png("plot6.png")
plot.default(unique(NEI$year),
     tot_emissions[,1],
     main="Annual Total PM2.5 Emissions from Motor Vehicles",
     xlab="Year",
     ylab="PM2.5 Emitted [tons]",
     col = "red",
     pch = 19,
     xlim =c(1999,2009), 
     ylim = c(0,8500))
points(unique(NEI$year),
     tot_emissions[,2],
     col = "green",
     pch = 19)
legend(
  "topright",
  pch = 19,
  legend = c("Baltimore City","Los Angelas County"),
  col = c("green","red")
  )
dev.off()