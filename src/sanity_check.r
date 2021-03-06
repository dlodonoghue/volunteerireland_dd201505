# check variables are loaded into workspace  -----------------------------------
if (!("opportunities" %in% ls()) |
        !("opps_applied_for" %in% ls()) |
        !("placements" %in% ls()) |
        !("volunteers" %in% ls()) |
        !("org" %in% ls())) {
    source("load_data.R")      
}

library(dplyr)

# total opportunity applications 2014 -----------------------------------------
total_applications <- opps_applied_for %>%
                        group_by(Application_Date_Year) %>%
                        summarise(Num_Apps = n_distinct(Application_ID)) %>%
                        ungroup()
print(total_applications)

# total volunteers placed 2014 ------------------------------------------------
total_volunteers_placed <- placements %>%
                    group_by(Placement_Date_Year) %>%
                    summarise(Num_vols_placed = n_distinct(Volunteer_ID)) %>%
                    ungroup()
print(total_volunteers_placed)

# total placements in 2014 ----------------------------------------------------
total_placements <- placements %>%
                    group_by(Placement_Date_Year) %>%
                    summarise(Num_placements = n_distinct(Placement_ID)) %>%
                    ungroup()                     
print(total_placements)

# same stats but for Number.of.Volunteers.Required < 21

# total opportunity applications 2014
total_applications <- merge(opps_applied_for, opportunities[, c("Opportunity_ID",
                                                                "Number.of.Volunteers.Required")],
                            by = "Opportunity_ID", all.x = TRUE) %>%
  filter(Number.of.Volunteers.Required < 21) %>%
  group_by(Application_Date_Year) %>%
  summarise(Num_Apps = n_distinct(Application_ID)) %>%
  ungroup()
print(total_applications)

# total volunteers placed 2014 ------------------------------------------------
total_volunteers_placed <- merge(placements, opportunities[, c("Opportunity_ID",
                                                               "Number.of.Volunteers.Required")],
                                 by = "Opportunity_ID", all.x = TRUE) %>%
  filter(Number.of.Volunteers.Required < 21) %>%
  group_by(Placement_Date_Year) %>%
  summarise(Num_vols_placed = n_distinct(Volunteer_ID)) %>%
  ungroup()
print(total_volunteers_placed)

# total placements in 2014 ----------------------------------------------------
total_placements <- merge(placements, opportunities[, c("Opportunity_ID",
                                                        "Number.of.Volunteers.Required")],
                          by = "Opportunity_ID", all.x = TRUE) %>%
  filter(Number.of.Volunteers.Required < 21) %>%
  group_by(Placement_Date_Year) %>%
  summarise(Num_placements = n_distinct(Placement_ID)) %>%
  ungroup()                     
print(total_placements)