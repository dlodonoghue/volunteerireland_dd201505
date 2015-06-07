# AP1_eng_level.r ----------------------------------------------------------------
#
# This script returns the number of Applications for 2014, by level of English required and nationality


# check variables are loaded into workspace  ----------------------------------
if (!("opportunities" %in% ls()) |
    !("opps_applied_for" %in% ls()) |
    !("placements" %in% ls()) |
    !("volunteers" %in% ls()) |
    !("org" %in% ls())) {
    source("load_data.R")      
}
  
#required library
library(dplyr)

# match vol info to opps_applied_for table via the "Volunteer_ID" field -------
applications_and_vols <- merge(x = opps_applied_for, y = volunteers,
                               by = "Volunteer_ID", all.x = TRUE)

# merge applications_and_vols with opportunities (all time) by Opportunity_ID
applications_opps_volu <- merge(x = applications_and_vols, 
                           y = opportunities[, c("Opportunity_ID", "Level.of.English.required.for.role")],
                           by = "Opportunity_ID", all.x = TRUE)


# summary for 2014
apps_2014_by_eng_level_n_nationality <- applications_opps_volu %>%
    filter(Application_Date_Year == "2014") %>%
    group_by(Nationality, Level.of.English.required.for.role) %>%
    summarise(Num_Applications = n_distinct(Application_ID)) 


View(apps_2014_by_eng_level_n_nationality)


