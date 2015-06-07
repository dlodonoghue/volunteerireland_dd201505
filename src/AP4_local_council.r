# AP4_local_council.r ---------------------------------------------------------
#
# This script returns the number of UNIQUE volunteers making applications in
# each calendar year, segmented by the "Volunteer.Bureau" associated with the
# opportunity they are applying for
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
opps_and_orgs <- merge(x = opportunities, y = org, by = "Organisation.ID",
                       all.x = TRUE)

# match org / opp info to applications table via "Opportunity_ID" ---------------
applications_opps_and_orgs <- merge(x = opps_applied_for, y = opps_and_orgs,
                                  by = "Opportunity_ID", all.x = TRUE)

# total number of unique vols applying, by Volunteer Bureau and Year ----------
vols_applied_by_bureau <- applications_opps_and_orgs %>%
                group_by(Application_Date_Year, Volunteer.Bureau.x) %>%
                summarise(Num_vols_applied = n_distinct(Volunteer_ID)) %>%
                ungroup()  