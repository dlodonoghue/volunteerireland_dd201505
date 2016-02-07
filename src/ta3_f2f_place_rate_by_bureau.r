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

# match opportunities to applications table via "Opportunity_ID" --------
opps_and_apps <-
    merge(
        x = opportunities[, c("Volunteer.Bureau", "Opportunity_ID")],
        y = opps_applied_for[ , c("Application_Date_Year", "Application_ID",
                                  "Opportunity_ID", "Volunteer_ID")],
        by = "Opportunity_ID", all.y = TRUE)

# match vols to opportunities / applications by "Volunteer_ID"
vols_opps_and_apps <-
    merge( x = opps_and_apps,
           y = volunteers[ , c("Volunteer_ID", "Face.to.Face")],
           by = "Volunteer_ID", all.x = TRUE, all.y = FALSE)

# count total number of unique vols applying, by Volunteer.Bureau, if they have
# had a "face to face" interaction ----------
vols_applied_by_bureau_f2f <-
    vols_opps_and_apps %>%
    filter(Application_Date_Year == year_of_interest, !is.na(Face.to.Face)) %>%
    group_by(Volunteer.Bureau) %>%
    summarise(Num_apps_f2f = n_distinct(Application_ID),
              Num_vols_applied_f2f = n_distinct(Volunteer_ID)) %>%
    ungroup()

vols_applied_by_bureau_all <-
    vols_opps_and_apps %>%
    filter(Application_Date_Year == year_of_interest) %>%
    group_by(Volunteer.Bureau) %>%
    summarise(Num_apps_all = n_distinct(Application_ID),
              Num_vols_applied_all = n_distinct(Volunteer_ID)) %>%
    ungroup() 

# match vols to placements by "Volunteer_ID"
placements_and_vols <-
    merge( x = placements,
           y = volunteers[ , c("Volunteer_ID", "Face.to.Face")],
           by = "Volunteer_ID", all.x = TRUE, all.y = FALSE)

# count total number of unique vols placed, by Volunteer.Registered.Centre ----
vols_placed_by_bureau_f2f <-
    placements_and_vols %>%
    filter(Placement_Date_Year == year_of_interest, !is.na(Face.to.Face)) %>%
    group_by(Volunteer.Registered.Centre) %>%
    summarise(Num_placements_f2f = n_distinct(Placement_ID),
              Num_vols_placed_f2f = n_distinct(Volunteer_ID)) %>%
    ungroup()

vols_placed_by_bureau_all <-
    placements_and_vols %>%
    filter(Placement_Date_Year == year_of_interest) %>%
    group_by(Volunteer.Registered.Centre) %>%
    summarise(Num_placements_all = n_distinct(Placement_ID),
              Num_vols_placed_all = n_distinct(Volunteer_ID)) %>%
    ungroup()

# combine application & placement counts, then compute placement rate -----
#   only vols with f2f interaction
placement_rate_by_bureau_f2f <- 
    merge(vols_applied_by_bureau_f2f, vols_placed_by_bureau_f2f,
          by.x = "Volunteer.Bureau", by.y = "Volunteer.Registered.Centre",
          all.x = TRUE)

na_indx <- is.na(placement_rate_by_bureau_f2f$Num_placements_f2f)
placement_rate_by_bureau_f2f[na_indx, "Num_placements_f2f"] <- 0

na_indx <- is.na(placement_rate_by_bureau_f2f$Num_vols_placed_f2f)
placement_rate_by_bureau_f2f[na_indx, "Num_vols_placed_f2f"] <- 0

placement_rate_by_bureau_f2f <-
    mutate(placement_rate_by_bureau_f2f,
           vol_placement_rate_f2f = 
               placement_rate_by_bureau_f2f$Num_vols_placed_f2f/
               placement_rate_by_bureau_f2f$Num_vols_applied_f2f)

#   all vols
placement_rate_by_bureau_all <- 
    merge(vols_applied_by_bureau_all, vols_placed_by_bureau_all,
          by.x = "Volunteer.Bureau", by.y = "Volunteer.Registered.Centre",
          all.x = TRUE)

na_indx <- is.na(placement_rate_by_bureau_all$Num_placements_all)
placement_rate_by_bureau_all[na_indx, "Num_placements_all"] <- 0

na_indx <- is.na(placement_rate_by_bureau_all$Num_vols_placed_all)
placement_rate_by_bureau_all[na_indx, "Num_vols_placed_all"] <- 0

placement_rate_by_bureau_all <-
    mutate(placement_rate_by_bureau_all,
           vol_placement_rate_all = 
               placement_rate_by_bureau_all$Num_vols_placed_all/
               placement_rate_by_bureau_all$Num_vols_applied_all)

# arrange causes in descending order of placement rate
# placement_rate_by_bureau_all <- 
#    arrange(placement_rate_by_bureau_all, -vol_placement_rate_all)

placement_rate_f2f_comparison_by_bureau <-
    merge(x = placement_rate_by_bureau_all,
          y = placement_rate_by_bureau_f2f,
          by = "Volunteer.Bureau", all.x = TRUE, all.y = TRUE)

# plotting
ggplot(
    placement_rate_f2f_comparison_by_bureau,
    label = Volunteer.Bureau,
    aes(x = Num_)
)
