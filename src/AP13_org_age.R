# AP13_org_age.r -----------------------------------------------------------------
#
# This script returns the number of UNIQUE volunteers making applications in
# each calendar year, segmented by the "created_date" field of the organisation publishing
# the opportunity they are applying for
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
# add created year to org table 
# next commented out line doesnt convert to date correctly
# org$Created.Date <- as.Date(org$Created.Date, format = "%m/%d/%Y")
# next line converts successfully
org$Created.Date2 <- strptime(x = as.character(org$Created.Date), format = "%m/%d/%Y")
org$Created.Date.Year  <- as.factor(format(org$Created.Date2, format = "%Y"))


# match organisation info to opportunities table via "Organisation_ID" --------
opps_and_orgs <-
    merge(x = opportunities[, c("Organisation.ID", "Opportunity_ID")],
          y = org[, c("Organisation.ID", "Created.Date.Year")],
          by = "Organisation.ID", all.x = TRUE)

# match org / opp info to applications table via "Opportunity_ID" -------------
applications_opps_and_orgs <- merge(x = opps_applied_for, y = opps_and_orgs,
                                  by = "Opportunity_ID", all.x = TRUE)

# total number of unique vols applying ----------
vols_applied_by_org_age <- applications_opps_and_orgs %>%
    filter(Application_Date_Year == "2014"  ) %>%
    group_by(Created.Date.Year) %>%
    summarise(Num_apps = n_distinct(Application_ID),
              Num_vols_applied = n_distinct(Volunteer_ID)) %>%
    ungroup() 

# View(vols_applied_by_org_age)
View(vols_applied_by_org_age)
