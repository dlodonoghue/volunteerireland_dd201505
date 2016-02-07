if (!("opportunities" %in% ls()) |
    !("opps_applied_for" %in% ls()) |
    !("placements" %in% ls()) |
    !("volunteers" %in% ls()) |
    !("org" %in% ls())) {
    source("load_data.R")      
}

library(dplyr)

# filter for 2015 opportunity data 

opps15 <- opportunities %>% filter (Created.Date >= as.Date("2015-01-01") & Created.Date < as.Date("2016-01-01"))

# create relative frequency tables for the activies offered 
opps_by_activity <- 100*table(opps15$Activity.that.reflects.opportunity)/nrow(opps15)

# create csv for visulisation
write.csv(opps_by_activity, "opps_by_activity.csv")

# filter for 2015 volunteer data 
vols15 <- volunteers %>% filter (Registration_Date >= as.Date("2015-01-01") & Registration_Date < as.Date("2016-01-01"))


# create relative frequency tables for the activies preferred by volunteers 
vols_by_activity <- 100*table(vols15$Activity.you.are.interested.in)/nrow(vols15)

# create csv for visulisation

write.csv(vols_by_activity, "vols_by_activity.csv")

