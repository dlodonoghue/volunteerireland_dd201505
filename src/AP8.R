# Count Applications for 2014, by 'face-to-face meeting' in df_vol

if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("load_data.R")      
}

# need to merge opps_applied_for with volunteers
applications_volunteers <- merge(x = opps_applied_for, y = volunteers[, c("Volunteer_ID", "Face.to.Face")],
                                 by = "Volunteer_ID", all.x = TRUE)

sum(is.na(applications_volunteers$Face.to.Face)) / nrow(applications_volunteers)
# 79% don't have a Face.to.Face value

# summarise
summary_by_year_by_f2f <- applications_volunteers %>%
  filter(Application_Date_Year == "2014") %>%
  group_by(Application_Date_Year, Face.to.Face) %>%
  summarise(Num_Applications = n_distinct(Application_ID),
            Num_Volunteers   = n_distinct(Volunteer_ID))

View(summary_by_year_by_f2f)

rm(summary_by_year_by_f2f)
