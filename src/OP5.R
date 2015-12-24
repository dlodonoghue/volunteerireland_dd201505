# Count Opps Records, and Sum of Volunteers Reqd, for 2014, by Level of English reqd (vr <21)

if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("load_data.R")      
}

library(dplyr)

summary_per_year_per_english.level <- opportunities %>%
  filter(Publish.Date.Year == "2014" &
           Number.of.Volunteers.Required < 21 &
           !is.na(Publish.Date.Year) &
           !is.na(Number.of.Volunteers.Required)) %>%
  group_by(Publish.Date.Year, Level.of.English.required.for.role) %>%
  summarise(Number_of_volunteers_required = sum(Number.of.Volunteers.Required)) %>%
  ungroup()
  
View(summary_per_year_per_english.level)

rm(summary_per_year_per_english.level)
