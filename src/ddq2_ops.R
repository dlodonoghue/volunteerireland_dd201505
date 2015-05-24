if (!("opportunities" %in% ls()) |
    !("ops_applied_for" %in% ls() |
    !("placements" %in% ls() |
    !("volunteers" %in% ls() |
    !("org" %in% ls()) {
      source("load_data.R")      
}

ops_and_orgs <- merge(x = opportunities, y = org, by = "Organisation.ID", all.x = TRUE)

# split by Year published and cause
vol_required_per_cause_per_year <- ops_and_orgs %>%
  filter(!is.na(Number.of.Volunteers.Required) &
           !is.na(Publish.Date.Year) &
           Publish.Date.Year == "2014" &
           Number.of.Volunteers.Required <= 20) %>%
  group_by(Publish.Date.Year, Cause) %>%
  summarise(cause_count = n(),
            Number_of_volunteers_required = sum(Number.of.Volunteers.Required)) %>%
  ungroup()

rm(ops_and_orgs)

print(vol_required_per_cause_per_year)
