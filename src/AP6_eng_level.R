# AP6_eng_level.r ----------------------------------------------------------------
#
# This script returns the number of Applications for 2014, by level of English required


# check variables are loaded into workspace  ----------------------------------
if (!("opportunities" %in% ls()) |
    !("opps_applied_for" %in% ls()) |
    !("placements" %in% ls()) |
    !("volunteers" %in% ls()) |
    !("org" %in% ls())) {
    source("load_data.R")      
}

#required library
library(dplyr)


# merge opps_applied_for with opportunities (all time) by Opportunity_ID
applications_opps <- merge(x = opps_applied_for, 
                           y = opportunities[, c("Opportunity_ID", "Level.of.English.required.for.role")],
                           by = "Opportunity_ID", all.x = TRUE)

sum(is.na(applications_opps$Level.of.English.required.for.role)) / nrow(applications_opps)
# 76% don't have a Level.of.English.required value

sum(is.na(opportunities$Level.of.English.required.for.role)) / nrow(opportunities)
# from the initial table of all opportunities only 11% specify a value for level of english

# summary for 2014
appscount_2014_by_eng_level <- applications_opps %>%
    filter(Application_Date_Year == "2014") %>%
    group_by(Level.of.English.required.for.role) %>%
    summarise(Num_Applications = n_distinct(Application_ID)) 

appscount_2014_with_ratio <- appscount_2014_by_eng_level %>%
    mutate (ratio=100*Num_Applications/sum(appscount_2014_by_eng_level$Num_Applications))


View(appscount_2014_with_ratio)

 

