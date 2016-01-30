# Count Placements for 2015, by 'number of volunteers required' in df_oppsaltm

if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("load_data.R")      
}

library(dplyr)

# join placements and volunteers on "volunteer ID"
placements_and_vols <- merge(x = placements, y = volunteers[, c("Volunteer_ID", "Nationality")],
                             by = "Volunteer_ID", all.x = TRUE)

# join applications and volunteers on "volunteer ID"
opps_and_vols <- merge(x = opps_applied_for, y = volunteers[, c("Volunteer_ID", "Nationality")],
                       by = "Volunteer_ID", all.x = TRUE)

# change the nationality of non Irish to "Non-Irish"
levels(placements_and_vols$Nationality)[levels(placements_and_vols$Nationality) != "Irish"] <- "Non-Irish"
levels(opps_and_vols$Nationality)[levels(opps_and_vols$Nationality) != "Irish"] <- "Non-Irish"

# total number of unique vols applying, by Nationality
vols_placed_by_nationality <- placements_and_vols %>%
  group_by(Placement_Date_Year, Nationality) %>%
  summarise(Num_placements = n_distinct(Placement_ID),
            Num_vols_placed = n_distinct(Volunteer_ID)) %>%
  ungroup()

View(vols_placed_by_nationality)

# total number of unique vols placed, by Nationality
vols_applied_by_nationality <- opps_and_vols %>%
  group_by(Application_Date_Year, Nationality) %>%
  summarise(Num_apps = n_distinct(Application_ID),
            Num_vols_applied = n_distinct(Volunteer_ID)) %>%
  ungroup()

View(vols_applied_by_nationality)


# total number of unique vols applying, by Nationality
vols_placed_by_nationality <- placements_and_vols %>%
  group_by(Nationality, Placement_Date_Year) %>%
  summarise(Num_placements = n_distinct(Placement_ID),
            Num_vols_placed = n_distinct(Volunteer_ID)) %>%
  ungroup()

View(vols_placed_by_nationality)

# total number of unique vols placed, by Nationality
vols_applied_by_nationality <- opps_and_vols %>%
  group_by(Nationality, Application_Date_Year) %>%
  summarise(Num_apps = n_distinct(Application_ID),
            Num_vols_applied = n_distinct(Volunteer_ID)) %>%
  ungroup()

View(vols_applied_by_nationality)