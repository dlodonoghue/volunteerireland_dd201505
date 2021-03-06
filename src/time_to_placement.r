# time_to_placement.r # ----------------------------
#
# Average time from volunteer application to placement
# - date of volunteer placement; "Placement_Date" in placements table
# - date application is made; "Application_Date" in opps_applied_for table
#
# For each unique "Placement_ID" in the placements table, we would like to
# know the corresponding "Application_ID" that lead to that placement. Then
# we could match the appropriate placement and application dates for these
# records, and determine the time interval between the two.
#
# However, the "Opps_applied_for" and "Placements" tables are only connected
# by two fields,  "Volunteer_ID" and "Opportunity_ID", and there isn't a one
# to one correspondence between these ID fields and the application or
# placement IDs. Put more simply, a volunteer can be placed more than once,
# and a volunteer can apply for more than one opportunity.
#
# Assuming each volunteer will only apply for the same opportunity once, if we
# create a new identifier, the "Volunteer_Opportunity_ID" by combining
# Volunteer_IDs with Opportunity_IDs, this will (hopefully) give us the one to
# one link between individual placements and their corresponding applications.
#
# Merging "placements" and "opps applied for" by this new Vol_Opp_ID, we can
# retain those placements with an App ID (and hence App date), for analysis
# of time from application to placement.

# check variables are loaded into workspace  ----------------------------------
if (!("opportunities" %in% ls()) |
        !("opps_applied_for" %in% ls()) |
        !("placements" %in% ls()) |
        !("volunteers" %in% ls()) |
        !("org" %in% ls())) {
    source("load_data.R")      
}

# load necessary libraries ####
library(lubridate)
library(dplyr)
library(ggplot2)

# tidy data ####
# retain placement dates & Volunteer Centre (based on Vol registration)
placement_dates <-
    data.frame(Place_Date = placements$Placement_Date,
               Vol_Centre = placements$Volunteer.Registered.Centre)

# create new field for placement year
placement_dates$Place_Year  <- year(placement_dates$Place_Date)

# count placements by year and plot ####
Placements_by_year <-
    placement_dates %>% group_by(Place_Year) %>% summarise(Num_Place = n()) %>% ungroup()

ggplot(Placements_by_year, aes(x = factor(Place_Year), y = Num_Place)) + 
    geom_bar(stat = "identity")

# create "Volunteer - Opportunity ID" ####
opps_applied_for$Vol_Opp_ID <-
    paste(opps_applied_for$Volunteer_ID,
          opps_applied_for$Opportunity_ID, sep = "")

placements$Vol_Opp_ID <-
    paste(placements$Volunteer_ID,
          placements$Opportunity_ID, sep = "")

# join placements and applications by the "Vol_Opp_ID" ####
temp_data <- merge(
    placements[ , c("Vol_Opp_ID","Placement_Date", "Placement_ID",
                    "Volunteer_ID", "Volunteer.Registered.Centre")],
    opps_applied_for[ , c("Vol_Opp_ID", "Application_ID", "Application_Date")],
    by = "Vol_Opp_ID", all.x = TRUE, all.y = FALSE)

# retain only placement records that have an application ID 
missing_data_indx <- is.na(temp_data$Application_ID)
placements_w_apps <- temp_data[!missing_data_indx, ]

# group placements with app IDs by year
placements_w_apps$Place_Year <- year(placements_w_apps$Placement_Date)
placements_w_apps_by_year <- placements_w_apps %>% group_by(Place_Year) %>%
    summarise(Num_Place = n()) %>% ungroup()

# manually add "0" placements for 2006 & 2008 (for cleaner plotting)
placements_w_apps_by_year <-
    rbind(placements_w_apps_by_year, c("2008", 0), c("2006", 0))

# combine "all placements" and "placements w/ apps" data and plot ####
Placements_by_year$Sample <- "All placements"
placements_w_apps_by_year$Sample <- "Placements w/ Applications"
placements_w_apps_by_year <-
    placements_w_apps_by_year[order(placements_w_apps_by_year$Place_Year), ]

all_placements_by_year <- rbind(Placements_by_year, placements_w_apps_by_year)
all_placements_by_year$Num_Place <- as.numeric(all_placements_by_year$Num_Place)

ggplot(all_placements_by_year, aes(x = factor(Place_Year), y = Num_Place, fill = Sample)) +
    geom_bar(stat = "identity", position = position_dodge()) + theme_minimal()

# determine "time to placement" ####
placements_w_apps$time_to_place <-
    placements_w_apps$Placement_Date - placements_w_apps$Application_Date

# find bad data and remove (i.e. negative wait times)
neg_time_indx <- placements_w_apps$time_to_place < 0
sum(neg_time_indx)*100 / length(neg_time_indx) # % of wait times that are -ve

placements_w_apps <- placements_w_apps[!neg_time_indx, ]

# *** REMOVE RECORDS WHERE TIME TO PLACEMENT IS GREATER THAN 1 YEAR ***
removal_indx <- placements_w_apps$time_to_place >365
sum(removal_indx)*100 / length(removal_indx) 

placements_w_apps <- placements_w_apps[!removal_indx, ]

# histogram of "time to placement" for placements made in 2014
placements_w_apps$time_to_place <- 
    as.numeric(placements_w_apps$time_to_place)

ggplot(placements_w_apps[placements_w_apps$Place_Year == "2014", ],
       aes(x = time_to_place)) +
    geom_histogram(aes(y = ..density..),
        binwidth = 7, colour = "black", fill = "white") +
    geom_density(alpha=.2, fill="#FF6666")

# median time to placement in 2014
median(placements_w_apps[placements_w_apps$Place_Year == "2014",
                         "time_to_place"])

# find median time between application & placement by Volunteer Centre
Vol_centre_time_to_place_stats <-
    placements_w_apps %>% filter(Place_Year == "2014") %>%
    group_by(Volunteer.Registered.Centre) %>%
    summarise(
        Med_time_to_place = median(time_to_place),
        Num_placements = n()) %>% ungroup()
View(Vol_centre_time_to_place_stats)

# boxplot of median app -> placement time by Vol Centre (for 2014 placements)
temp_data <- placements_w_apps[placements_w_apps$Place_Year == "2014", ]

# remove Donegal data
temp_data <- temp_data[temp_data$Volunteer.Registered.Centre != "Donegal", ]

# national median (for placements in 2014, that have app IDs, w/ no Donegal data)
National_median <- median(temp_data$time_to_place)

# Create a data frame to hold your label variables (note "x" will need to be
# determined by trial and error, until you are happy with the label position)
data.label <- data.frame(
    x = 18,
    y = National_median,
    label = paste("National median: ", National_median, " days", sep = "")
)

ggplot(
    temp_data,
    aes(reorder(Volunteer.Registered.Centre, time_to_place, median, order = TRUE),
        time_to_place)) +
    geom_boxplot(outlier.size = 0, colour = "steel blue") +
    geom_hline(yintercept = National_median, colour = "red", alpha = 0.7) +
    geom_text(data = data.label, aes(x = x , y = y , label = label ), size=4,
              colour = "red", angle = 90, vjust = -0.4, hjust = 0, alpha = 0.7) +
#    geom_text(mapping=aes(x = 23, y=National_median, label="National", colour = "red"),
#              size=4, angle=90, vjust=-0.4, hjust=0) +
    stat_summary(
        fun.data = function(x){return(c(y = min(0)-25, label = length(x)))},
        geom = "text") + 
    stat_summary(
        fun.data = function(x){return(c(y = median(x)+10, label = median(x)))},
        geom = "text") + 
    coord_flip() + theme_minimal() +
    labs(y = "#days between application and placement",
         x = "Centre where volunteer registered") +
    theme(axis.text=element_text(size=12),
          axis.title=element_text(size=14,face="bold")) +
    scale_y_continuous(limits = c(-25, 400))