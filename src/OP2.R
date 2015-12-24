# Count Opps Records, and Sum of Volunteers Reqd, for 2014, by cause (vr <21)

if (!("opportunities" %in% ls()) |
    !("opps_applied_for" %in% ls()) |
    !("placements" %in% ls()) |
    !("volunteers" %in% ls()) |
    !("org" %in% ls())) {
      source("load_data.R")      
}

library(dplyr)
# need to get the Cause from the org table
opps_and_orgs <- merge(x = opportunities, y = org[, c("Organisation.ID", "Cause")],
                       by = "Organisation.ID", all.x = TRUE)

# split by Year published and cause
vol_required_per_cause_per_year <- opps_and_orgs %>%
  filter(Publish.Date.Year == "2014" &
           Number.of.Volunteers.Required < 21 &
           !is.na(Publish.Date.Year) &
           !is.na(Number.of.Volunteers.Required)) %>%
  group_by(Publish.Date.Year, Cause) %>%
  summarise(Number_of_volunteers_required = sum(Number.of.Volunteers.Required)) %>%
  ungroup()

rm(opps_and_orgs)

View(vol_required_per_cause_per_year)
