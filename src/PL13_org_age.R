# PL13_org_age.r -----------------------------------------------------------------
#
# This script returns the number of UNIQUE volunteers placed in 2014, segmented
# by the the "created_date" field of the organisation publishing the opportunity
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
  merge(x = opportunities[, c("Organisation.ID", "Opportunity_ID", "Number.of.Volunteers.Required")],
        y = org[, c("Organisation.ID", "Created.Date.Year")],
        by = "Organisation.ID", all.x = TRUE)

# match org / opp info to placements table via "Opportunity_ID" ---------------
placements_opps_and_orgs <- merge(x = placements, y = opps_and_orgs,
                                  by = "Opportunity_ID", all.x = TRUE)

# total number of unique vols placed ------------
vols_placed_by_org_age <- placements_opps_and_orgs %>%
  filter(Placement_Date_Year == "2014" ) %>%
  group_by(Created.Date.Year) %>%
  summarise(Num_placements = n_distinct(Placement_ID),
            Num_vols_placed = n_distinct(Volunteer_ID)) %>%
  ungroup()

View(vols_placed_by_org_age)

# sanity check; is total placements  in 2014 equal to 5890? -------------
df <- vols_placed_by_cause
ifelse(sum(df$Num_placements) == 4315,
       "correct total number of placements in 2014",
       "total number of placements in 2014 is incorrect")