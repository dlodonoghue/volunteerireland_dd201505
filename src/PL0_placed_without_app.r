# PL0_without_app.r ----------------------------------------------------------------
#
# Counts the number of placements in each year where the matching "Application_ID"
# is missing

# check variables are loaded into workspace  ----------------------------------
if (!("opportunities" %in% ls()) |
        !("opps_applied_for" %in% ls()) |
        !("placements" %in% ls()) |
        !("volunteers" %in% ls()) |
        !("org" %in% ls())) {
    source("load_data.R")      
}

library(dplyr)

# match opps_applied_for info to placements table via "Organisation_ID" --------
apps_and_placements <-
    merge(x = placements,
          y = opps_applied_for[, c("Opportunity_ID", "Application_ID")],
          by = "Opportunity_ID", all.x = TRUE)

# count number of placements where "Application_ID" is missing -----------------
placed_without_app <-   apps_and_placements %>%
                        group_by(Placement_Date_Year) %>%
                        summarise(Num_no_app = sum(is.na(Application_ID))) %>%
                        ungroup() 

View(placed_without_app)