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

# match gender data to applications table via "Volunteer_ID" --------
applications_and_gender <-
    merge(x = opps_applied_for,
          y = volunteers[ , c("Volunteer_ID", "Gender")],
          by = "Volunteer_ID", all.x = TRUE)

# count total number of unique vols applying, by gender ----------
vols_applied_by_gender <-
    applications_and_gender %>%
    filter(Application_Date_Year == year_of_interest) %>%
    group_by(Gender) %>%
    summarise(Num_apps = n_distinct(Application_ID),
              Num_vols_applied = n_distinct(Volunteer_ID)) %>%
    ungroup() 

# match gender data to placements table via "Volunteer_ID" --------
placements_and_gender <-
    merge(x = placements,
          y = volunteers[ , c("Volunteer_ID", "Gender")],
          by = "Volunteer_ID", all.x = TRUE)

# count total number of unique vols placed, by gender ----
vols_placed_by_gender <-
    placements_and_gender %>%
    filter(Placement_Date_Year == year_of_interest) %>%
    group_by(Gender) %>%
    summarise(Num_placements = n_distinct(Placement_ID),
              Num_vols_placed = n_distinct(Volunteer_ID)) %>%
    ungroup()

# combine application & placement counts, then compute placement rate -----
placement_rate_by_gender <- 
    merge(vols_applied_by_gender, vols_placed_by_gender,
          by = "Gender", all.x = TRUE)

na_indx <- is.na(placement_rate_by_gender$Num_placements)
placement_rate_by_gender[na_indx, "Num_placements"] <- 0

na_indx <- is.na(placement_rate_by_gender$Num_vols_placed)
placement_rate_by_gender[na_indx, "Num_vols_placed"] <- 0

placement_rate_by_gender <-
    mutate(placement_rate_by_gender,
           vol_placement_rate = 
               placement_rate_by_gender$Num_vols_placed/
               placement_rate_by_gender$Num_vols_applied)

# arrange causes in descending order of placement rate
placement_rate_by_gender <- 
    arrange(placement_rate_by_gender, -vol_placement_rate)
