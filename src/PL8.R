# Count Placements for 2014, by 'face-to-face meeting' in df_vol,  where Vol req'd <21 in Opp record
if (!("opportunities" %in% ls()) |
        !("opps_applied_for" %in% ls()) |
        !("placements" %in% ls()) |
        !("volunteers" %in% ls()) |
        !("org" %in% ls())) {
    source("load_data.R")      
}

library(dplyr)

placements_and_vols <- merge(x = placements, y = volunteers[, c("Volunteer_ID", "Face.to.Face")],
                             by = "Volunteer_ID", all.x = TRUE)
# add opportunities to get the number of volunteers required
data <- merge(x = placements_and_vols, y = opportunities[, c("Opportunity_ID", "Number.of.Volunteers.Required")],
              by = "Opportunity_ID", all.x = TRUE)
rm(placements_and_vols)

vols_placed_by_f2f <- data %>%
  filter(Placement_Date_Year == "2014" &
           Number.of.Volunteers.Required < 21) %>%
  group_by(Placement_Date_Year, Face.to.Face) %>%
  summarise(Num_placements = n_distinct(Placement_ID),
            Num_opportunities = n_distinct(Opportunity_ID),
            Num_vols_placed = n_distinct(Volunteer_ID)) %>%
  ungroup()

View(vols_placed_by_f2f)

rm(data)
rm(vols_placed_by_f2f)
