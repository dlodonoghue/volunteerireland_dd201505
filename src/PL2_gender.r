# PL2_gender.r ----------------------------------------------------------------
#
# This script returns the number of UNIQUE volunteers placed in each calendar
# year, segmented by volunteer gender
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

# match volunteer info to placement table via the "Volunteer_ID" field
placements_and_vols <- merge(x = placements, y = volunteers,
                             by = "Volunteer_ID", all.x = TRUE)

# total volunteers placed by Gender in 2014 -----------------------------------
placements_by_gender    <- placements_and_vols %>%
                    group_by(Placement_Date_Year, Gender) %>%
                    summarise(Num_placements = n_distinct(Volunteer_ID)) %>%
                    ungroup()                     

View(placements_by_gender)

# sanity check
df <- placements_by_gender[placements_by_gender$Placement_Date_Year == "2014",]
ifelse(sum(df$Num_placements) == 4555,
       "correct total volunteers placed in 2014",
       "total number of volunteers placed in 2014 is incorrect")


