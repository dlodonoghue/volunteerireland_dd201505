# Count Opps Records, and Sum of Volunteers Reqd, for 2014

if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("load_data.R")     
}

library(dplyr)

# 23921 (out of 35494 = 67%) records don't have a value for the
# number of volunteers required!

summary_by_year <- opportunities %>%
  filter(Publish.Date.Year == "2014" &
           !is.na(Number.of.Volunteers.Required) &
           !is.na(Publish.Date.Year)) %>%
  group_by(Publish.Date.Year) %>%
  summarise(Total_Volunteers_Required = sum(Number.of.Volunteers.Required))

View(summary_by_year)

# The same summary but exclude records where # of VR < 21
summary_by_year <- opportunities %>%
  filter(Publish.Date.Year == "2014" &
           Number.of.Volunteers.Required < 21 &
           !is.na(Number.of.Volunteers.Required) &
           !is.na(Publish.Date.Year)) %>%
  group_by(Publish.Date.Year) %>%
  summarise(Total_Volunteers_Required = sum(Number.of.Volunteers.Required))

View(summary_by_year)
