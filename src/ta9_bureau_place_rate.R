# check variables are loaded into workspace  ----------------------------------
if (!("opportunities" %in% ls()) |
    !("opps_applied_for" %in% ls()) |
    !("placements" %in% ls()) |
    !("volunteers" %in% ls()) |
    !("org" %in% ls())) {
    source("load_data.R")      
}

library(dplyr)
library(lubridate)

year_of_interest = "2014"

# match opportunities to applications table via "Opportunity_ID" --------
opps_and_apps <-
    merge(x = opportunities[, c("Volunteer.Bureau", "Opportunity_ID")],
          y = opps_applied_for,
          by = "Opportunity_ID", all.y = TRUE)

# count total number of unique vols applying, by Volunteer.Bureau ----------
vols_applied_by_bureau <-
    opps_and_apps %>%
    filter(Application_Date_Year == year_of_interest) %>%
    group_by(Volunteer.Bureau) %>%
    summarise(Num_apps = n_distinct(Application_ID),
              Num_vols_applied = n_distinct(Volunteer_ID)) %>%
    ungroup() 

# count total number of unique vols placed, by Volunteer.Registered.Centre ----
vols_placed_by_bureau <-
    placements %>%
    filter(Placement_Date_Year == year_of_interest) %>%
    group_by(Volunteer.Registered.Centre) %>%
    summarise(Num_placements = n_distinct(Placement_ID),
              Num_vols_placed = n_distinct(Volunteer_ID)) %>%
    ungroup()

# combine application & placement counts, then compute placement rate -----
placement_rate_by_bureau <- 
    merge(vols_applied_by_bureau, vols_placed_by_bureau,
          by.x = "Volunteer.Bureau", by.y = "Volunteer.Registered.Centre",
          all.x = TRUE)

na_indx <- is.na(placement_rate_by_bureau$Num_placements)
placement_rate_by_bureau[na_indx, "Num_placements"] <- 0

na_indx <- is.na(placement_rate_by_bureau$Num_vols_placed)
placement_rate_by_bureau[na_indx, "Num_vols_placed"] <- 0

placement_rate_by_bureau <-
    mutate(placement_rate_by_bureau,
           vol_placement_rate = 
               placement_rate_by_bureau$Num_vols_placed/
               placement_rate_by_bureau$Num_vols_applied)

# arrange causes in descending order of placement rate
placement_rate_by_bureau <- 
    arrange(placement_rate_by_bureau, -vol_placement_rate)
