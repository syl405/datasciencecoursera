NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
scc_list = as.character(SCC[grepl("Coal", SCC$SCC.Level.Three),"SCC"])

filtered_set = NEI[NEI$SCC %in% scc_list,]
split_set = split(filtered_set, filtered_set$year)
tot_emissions = sapply(split_set,function(x) sum(x$Emissions))

png("plot4.png")
plot(unique(NEI$year),
     tot_emissions,
     main="Annual Total PM2.5 Emissions from Coal Related Sources in the US",
     xlab="Year",
     ylab="PM2.5 Emitted [tons]")
dev.off()