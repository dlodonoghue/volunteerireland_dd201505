# ta4_vols_vs_population.r -----------------------------------------------------------------
#
# This script visualizes the number of volunteers associated to a county who have applied for an opportunity in the year specified, vs the population of that county according to the census 2011.

# The "dplyr", "ggplot2", and "lubridate" packages must be installed for the script to run

# To get and integrate census data on population distribution in different counties, go to:
#http://www.cso.ie/px/pxeirestat/Statire/SelectVarVal/Define.asp?MainTable=CD111&TabStrip=Select&PLanguage=0&FF=1 and (optionally) deselect provinces.

#And follow the procedure to manually get the tables.

# load VI datafiles if not already in namespace
if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("../src/load_data.R")      
}

#
counties.activity <- read.csv("../data/vccounties.csv")
counties.activity <- counties.activity[, colSums(is.na(counties.activity)) != nrow(counties.activity)]

library(ggplot2)
library(lubridate)
library(dplyr)

threshold_year = 2015

# filter, among volunters, those who have done a recent application
active_volunteers_ID <- opps_applied_for %>% filter(year(Application_Date) >= threshold_year) %>% select(Volunteer_ID) %>% unique

active_volunteers <- inner_join(volunteers, active_volunteers_ID)

# get and clean census data
census <- read.csv("../data/census/2016130161250425607CD11158463467589.csv", header = F, col.names = c("Sex", "County", "Population"), stringsAsFactors = F)
census[grepl("Tipperary", census$County), "County"] <- "Tipperary"
census <- census %>% group_by(County) %>% summarise(Population = sum(Population))

active_volunteers <- as.data.frame(table(active_volunteers$County))
colnames(active_volunteers) <- c("County", "Volunteers")

census <- inner_join(census, counties.activity)

active_volunteers_and_population <- inner_join(census, active_volunteers)
active_volunteers_and_population <- active_volunteers_and_population %>% mutate(Volunteer.Rate = Volunteers/Population)

ggplot(active_volunteers_and_population, label = County, aes(x = Population, y = Volunteers, color = Volunteer.Centre)) + 
        geom_point() + 
        geom_text(aes(label = County), hjust = 0.5, vjust = -0.3) +
        scale_x_log10() + 
        scale_y_log10() + 
        ylab(paste("Volunteers who applied, in and after", threshold_year)) +
        scale_color_discrete(name ="Volunteer centre present", labels=c("Yes", "No")) 
        annotation_logticks()

ggplot(active_volunteers_and_population, aes(x = reorder(County, Volunteer.Rate), y = Volunteer.Rate*1000, fill = Volunteer.Centre)) + 
         geom_bar(stat="identity") +
		 scale_fill_discrete(name ="Volunteer centre present", labels=c("Yes", "No")) + 
		 xlab("County") + 
		 ylab(paste(c("Volunteers who applied, in and after ", threshold_year, "per 1000 inhabitants"), collapse = " ")) +
         coord_flip()
