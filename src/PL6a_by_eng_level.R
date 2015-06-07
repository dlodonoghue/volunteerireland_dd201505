# Count Placements for 2014, by 'level of english required' in df_oppsaltm

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

# add opportunities 
placements_vols_opps <- merge(x = placements_and_vols, 
              y = opportunities[, c("Opportunity_ID","Level.of.English.required.for.role")],
              by = "Opportunity_ID", all.x = TRUE)


vols_placed_by_eng_level <- placements_vols_opps %>%
    filter(Placement_Date_Year == "2014") %>%
    group_by(Level.of.English.required.for.role) %>%
    summarise(Num_placements = n_distinct(Placement_ID),
              Num_opportunities = n_distinct(Opportunity_ID),
              Num_vols_placed = n_distinct(Volunteer_ID)) %>%
    ungroup()

View(vols_placed_by_eng_level)

