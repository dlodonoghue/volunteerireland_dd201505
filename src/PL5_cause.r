# PL5_cause.r -----------------------------------------------------------------
#
# This script returns the number of UNIQUE volunteers placed in 2014, segmented
# by the "Cause" of the organisation publishing the opportunity
# The "dplyr" package must be installed for the script to run

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

# match org / opp info to placements table via "Opportunity_ID" ---------------
placements_opps_and_orgs <- merge(x = placements, y = opps_and_orgs,
                                  by = "Opportunity_ID", all.x = TRUE)

# total number of unique vols placed, by Volunteer Bureau and Year ------------
vols_placed_by_cause <- placements_opps_and_orgs %>%
    filter(Placement_Date_Year == "2014") %>%
    group_by(Cause) %>%
    summarise(Num_placements = n_distinct(Placement_ID),
              Num_vols_placed = n_distinct(Volunteer_ID)) %>%
    ungroup()

View(vols_placed_by_cause)

# sanity check; is total placements  in 2014 equal to 5890? -------------
df <- vols_placed_by_cause
ifelse(sum(df$Num_placements) == 5890,
       "correct total number of placements in 2014",
       "total number of placements in 2014 is incorrect")