# AP14_opp_size.r ----------------------------------------------------------------
#
# This script returns the number of Applications for 2014, by the number of volunteers required


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


# merge opps_applied_for with opportunities (all time) by Opportunity_ID
applications_opps <- merge(x = opps_applied_for, 
                           y = opportunities[, c("Opportunity_ID", "Number.of.Volunteers.Required")],
                           by = "Opportunity_ID", all.x = TRUE)


# summary for 2014
appscount_2014_by_opp_size <- applications_opps %>%
    filter(Application_Date_Year == "2014") %>%
    group_by(Number.of.Volunteers.Required) %>%
    summarise(Num_Applications = n_distinct(Application_ID),
              Num_unique_vols = n_distinct(Volunteer_ID)) %>%
  ungroup()

View(appscount_2014_by_opp_size)

 

