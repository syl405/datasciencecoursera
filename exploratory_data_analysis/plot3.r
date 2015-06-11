library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
type_split = split(NEI,NEI$type)
type_year_splits = lapply(type_split, function(x) split(x,x$year))
tot_emissions = lapply(type_year_splits, function(x) lapply(x, function(y) sum(y$Emissions)))
tot_emissions = lapply(tot_emissions, matrix, 4,1)
emissions_by_type = data.frame()
for (type in 1:4){
  emissions_by_type[((type*4)-3):(type*4),1] = c("NONPOINT","NON-ROAD","ON-ROAD","POINT")[type]
  for (year in 1:4){
    emissions_by_type[((type*4)+year-4),2] = as.character(unique(NEI$year)[year])
    emissions_by_type[((type*4)+year-4),3] = tot_emissions[[type]][[year]]
  }
}
names(emissions_by_type) = c("type","year","total_emissions")
png(file="plot3.png")
print(
  qplot(year,
      total_emissions,
      data=emissions_by_type,
      facets=.~type,
      main="Total Annual PM2.5 Emissions for Various Source Types",
      xlab="Year",
      ylab="Total Annual PM2.5 Emissions [tons]"))
dev.off()