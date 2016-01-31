# ta8_top_performing_vols.r -----------------------------------------------------------------

# This script plots the fraction of work performed by the most active X% of the volunteers, where activity is measured as the sum of human-hours contributed in placements in and after the given threshold year.

# load VI datafiles if not already in namespace
if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("../src/load_data.R")      
}

#

library(ggplot2)
library(lubridate)
library(dplyr)

threshold_year = 2015

# order volunteers by time contributed according to placements they have been involved into (and add a cumulative sum of the time contributed by the first N of them)
ranking_volunteers <- placements %>% filter(year(Placement_Date) >= threshold_year) %>%group_by(Volunteer_ID) %>% summarise(Volunteer.Hours = sum(Volunteer.Hours)) %>% arrange(desc(Volunteer.Hours)) %>% mutate(Sum.Volunteer.Hours = cumsum(Volunteer.Hours))

ggplot(data = ranking_volunteers, aes(x = as.numeric(rownames(ranking_volunteers))/nrow(ranking_volunteers)*100, y = Sum.Volunteer.Hours/sum(Volunteer.Hours)*100)) + 
              geom_line()	+
              xlab(label = "Percentage of volunteers (sorted by time volunteered)") +
              ylab(label = paste("Cumulative fraction of human-hours related to placements in", threshold_year))

# calculate the fraction of time contributed by the top 5, 10, 20, 50 %.
quantile(ranking_volunteers$Sum.Volunteer.Hours, c(0.05, 0.10, 0.20, 0.50))/sum(ranking_volunteers$Volunteer.Hours)