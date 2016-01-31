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

year_of_interest = "2015"

# match age data to applications table via "Volunteer_ID" --------
applications_and_age <-
    merge(x = opps_applied_for,
          y = volunteers[ , c("Volunteer_ID", "Age.Group")],
          by = "Volunteer_ID", all.x = TRUE)

# count total number of unique vols applying, by age ----------
vols_applied_by_age <-
    applications_and_age %>%
    filter(Application_Date_Year == year_of_interest) %>%
    group_by(Age.Group) %>%
    summarise(Num_apps = n_distinct(Application_ID),
              Num_vols_applied = n_distinct(Volunteer_ID)) %>%
    ungroup() 

# match Age.Group data to placements table via "Volunteer_ID" --------
placements_and_age <-
    merge(x = placements,
          y = volunteers[ , c("Volunteer_ID", "Age.Group")],
          by = "Volunteer_ID", all.x = TRUE)

# count total number of unique vols placed, by Age.Group ----
vols_placed_by_age <-
    placements_and_age %>%
    filter(Placement_Date_Year == year_of_interest) %>%
    group_by(Age.Group) %>%
    summarise(Num_placements = n_distinct(Placement_ID),
              Num_vols_placed = n_distinct(Volunteer_ID)) %>%
    ungroup()

# combine application & placement counts, then compute placement rate -----
placement_rate_by_age <- 
    merge(vols_applied_by_age, vols_placed_by_age,
          by = "Age.Group", all.x = TRUE)

na_indx <- is.na(placement_rate_by_age$Num_placements)
placement_rate_by_age[na_indx, "Num_placements"] <- 0

na_indx <- is.na(placement_rate_by_age$Num_vols_placed)
placement_rate_by_age[na_indx, "Num_vols_placed"] <- 0

placement_rate_by_age <-
    mutate(placement_rate_by_age,
           vol_placement_rate = 
               placement_rate_by_age$Num_vols_placed/
               placement_rate_by_age$Num_vols_applied)

# arrange causes in descending order of placement rate
placement_rate_by_age <- 
    arrange(placement_rate_by_age, -vol_placement_rate)
