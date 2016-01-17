# check variables are loaded into workspace  ----------------------------------
if (!("opportunities" %in% ls()) |
    !("opps_applied_for" %in% ls()) |
    !("placements" %in% ls()) |
    !("volunteers" %in% ls()) |
    !("org" %in% ls())) {
    source("load_data.R")      
}

library(dplyr)

# retain "Activity" and "Opportunity_ID" fields from opportunities table ------
opps_activity <- opportunities[ , c("Opportunity_ID",
                                    "Activity.that.reflects.opportunity")]
names(opps_activity)[2] <- "Activity"

# match Activity info to applications table via "Opportunity_ID" -------------
applications_and_opps <- merge(x = opps_applied_for, y = opps_activity,
                           by = "Opportunity_ID", all.x = TRUE)

# match Activity info to placements table via "Opportunity_ID" ---------------
placements_and_opps <- merge(x = placements, y = opps_activity,
                             by = "Opportunity_ID", all.x = TRUE)

# total number of unique vols applying, by Activity in 2014 ----------
vols_applied_by_activity <- applications_and_opps %>%
    filter(Application_Date_Year == "2014") %>%
    group_by(Activity) %>%
    summarise(Num_apps = n_distinct(Application_ID),
              Num_vols_applied = n_distinct(Volunteer_ID)) %>%
    ungroup() 

# total number of unique vols placed, by Activity in 2014 ------------
vols_placed_by_activity <- placements_and_opps %>%
    filter(Placement_Date_Year == "2014") %>%
    group_by(Activity) %>%
    summarise(Num_placements = n_distinct(Placement_ID),
              Num_vols_placed = n_distinct(Volunteer_ID)) %>%
    ungroup()

# combine application & placement counts, then compute placement rate -----
placements_by_activity <- 
    merge(vols_applied_by_activity, vols_placed_by_activity, by = "Activity")

placements_by_activity <-
    mutate(placements_by_activity,
           vol_placement_rate = 
               vols_placed_by_activity$Num_vols_placed/
               vols_applied_by_activity$Num_vols_applied)

# arrange Activities in descending order of placement rate
placements_by_activity <- 
    arrange(placements_by_activity, -vol_placement_rate)
