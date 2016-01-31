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

# match nationality data to applications table via "Volunteer_ID" --------
applications_and_nationality <-
    merge(x = opps_applied_for,
          y = volunteers[ , c("Volunteer_ID", "Nationality")],
          by = "Volunteer_ID", all.x = TRUE)

# count total number of unique vols applying, by nationality ----------
vols_applied_by_nationality <-
    applications_and_nationality %>%
    filter(Application_Date_Year == year_of_interest) %>%
    group_by(Nationality) %>%
    summarise(Num_apps = n_distinct(Application_ID),
              Num_vols_applied = n_distinct(Volunteer_ID)) %>%
    ungroup() 

# match Nationality data to placements table via "Volunteer_ID" --------
placements_and_nationality <-
    merge(x = placements,
          y = volunteers[ , c("Volunteer_ID", "Nationality")],
          by = "Volunteer_ID", all.x = TRUE)

# count total number of unique vols placed, by Nationality ----
vols_placed_by_nationality <-
    placements_and_nationality %>%
    filter(Placement_Date_Year == year_of_interest) %>%
    group_by(Nationality) %>%
    summarise(Num_placements = n_distinct(Placement_ID),
              Num_vols_placed = n_distinct(Volunteer_ID)) %>%
    ungroup()

# combine application & placement counts, then compute placement rate -----
placement_rate_by_nationality <- 
    merge(vols_applied_by_nationality, vols_placed_by_nationality,
          by = "Nationality", all.x = TRUE)

na_indx <- is.na(placement_rate_by_nationality$Num_placements)
placement_rate_by_nationality[na_indx, "Num_placements"] <- 0

na_indx <- is.na(placement_rate_by_nationality$Num_vols_placed)
placement_rate_by_nationality[na_indx, "Num_vols_placed"] <- 0

placement_rate_by_nationality <-
    mutate(placement_rate_by_nationality,
           vol_placement_rate = 
               placement_rate_by_nationality$Num_vols_placed/
               placement_rate_by_nationality$Num_vols_applied)

# arrange causes in descending order of placement rate
placement_rate_by_nationality <- 
    arrange(placement_rate_by_nationality, -vol_placement_rate)
