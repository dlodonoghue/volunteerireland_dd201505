# Count Applications for 2014, by 'publish_direct_contact' in opportunities

if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("load_data.R")      
}

# need to merge opps_applied_for with volunteers
applications_opps <- merge(x = opps_applied_for, y = opportunities[, c("Opportunity_ID", "Publish.Direct.Contact.")],
                           by = "Opportunity_ID", all.x = TRUE)

sum(is.na(applications_opps$Publish.Direct.Contact.)) / nrow(applications_opps)
# 3% don't have a Publish.Direct.Contact. value

# summarise
summary_by_year_by_PDC <- applications_opps %>%
  filter(Application_Date_Year == "2014") %>%
  group_by(Application_Date_Year, Publish.Direct.Contact.) %>%
  summarise(Num_Applications = n_distinct(Application_ID),
            Num_Volunteers   = n_distinct(Volunteer_ID))

View(summary_by_year_by_PDC)

rm(applications_opps)
rm(summary_by_year_by_PDC)