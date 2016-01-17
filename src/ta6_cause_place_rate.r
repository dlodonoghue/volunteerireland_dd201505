# check variables are loaded into workspace  ----------------------------------
if (!("opportunities" %in% ls()) |
    !("opps_applied_for" %in% ls()) |
    !("placements" %in% ls()) |
    !("volunteers" %in% ls()) |
    !("org" %in% ls())) {
    source("load_data.R")      
}

library(dplyr)

# match organisation info to opportunities table via "Organisation_ID" --------
opps_and_orgs <-
    merge(x = opportunities[, c("Organisation.ID", "Opportunity_ID")],
          y = org[, c("Organisation.ID", "Cause")],
          by = "Organisation.ID", all.x = TRUE)

# match org / opp info to applications table via "Opportunity_ID" -------------
applications_opps_and_orgs <- merge(x = opps_applied_for, y = opps_and_orgs,
                                    by = "Opportunity_ID", all.x = TRUE)

# match org / opp info to placements table via "Opportunity_ID" ---------------
placements_opps_and_orgs <- merge(x = placements, y = opps_and_orgs,
                                  by = "Opportunity_ID", all.x = TRUE)

# total number of unique vols applying, by Cause in 2014 ----------
vols_applied_by_cause <- applications_opps_and_orgs %>%
    filter(Application_Date_Year == "2014") %>%
    group_by(Cause) %>%
    summarise(Num_apps = n_distinct(Application_ID),
              Num_vols_applied = n_distinct(Volunteer_ID)) %>%
    ungroup() 

# total number of unique vols placed, by Cause in 2014 ------------
vols_placed_by_cause <- placements_opps_and_orgs %>%
    filter(Placement_Date_Year == "2014") %>%
    group_by(Cause) %>%
    summarise(Num_placements = n_distinct(Placement_ID),
              Num_vols_placed = n_distinct(Volunteer_ID)) %>%
    ungroup()

# combine application & placement counts, then compute placement rate -----
placements_by_cause <- 
    merge(vols_applied_by_cause, vols_placed_by_cause, by = "Cause")

placements_by_cause <-
    mutate(placements_by_cause,
           vol_placement_rate = 
               vols_placed_by_cause$Num_vols_placed/
               vols_applied_by_cause$Num_vols_applied)

# arrange causes in descending order of placement rate
placements_by_cause <- 
    arrange(placements_by_cause, -vol_placement_rate)
