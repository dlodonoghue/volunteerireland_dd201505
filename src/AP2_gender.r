# AP2_gender.r ----------------------------------------------------------------
#
# This script returns the number of UNIQUE volunteers that made an application
# in each calendar year, segmented by volunteer gender
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

# match vol info to opps_applied_for table via the "Volunteer_ID" field -------
applications_and_vols <- merge(x = opps_applied_for, y = volunteers,
                             by = "Volunteer_ID", all.x = TRUE)

# total number of unique volunteers making applications, by Gender and Year ---
vols_applied_by_gender    <- applications_and_vols %>%
                    group_by(Application_Date_Year, Gender) %>%
                    summarise(Num_vols_applied = n_distinct(Volunteer_ID)) %>%
                    ungroup()                     

View(vols_applied_by_gender)
