
volunteers      <- read.csv("../data/df_vol.csv", na.strings="")
opportunities    <- read.csv("../data/df_oppsaltm.csv", na.strings="")
placements      <- read.csv("../data/df_plc.csv", na.strings="")
org             <- read.csv("../data/df_orgs.csv", sep='\t', na.strings="")
opps_applied_for <- read.csv("../data/df_oppsapfr.csv", na.strings="")

# rename the common columns between the data frames and some others
colnames(volunteers)[1]  <- "Volunteer_ID"
colnames(volunteers)[2] <- "Registration_Date"

colnames(org)[9]  <- "Cause"
colnames(org)[13] <- "Num_Volunteers"
colnames(org)[14] <- "Num_Employees"
colnames(org)[15] <- "Management_Style"

colnames(opportunities)[2] <- "Opportunity_ID"
colnames(opportunities)[5] <- "Role_Name"

colnames(opps_applied_for)[1] <- "Application_Name"
colnames(opps_applied_for)[3] <- "Application_Date"
colnames(opps_applied_for)[4] <- "Volunteer_ID"
colnames(opps_applied_for)[5] <- "Application_ID"
colnames(opps_applied_for)[6] <- "Opportunity_ID"
colnames(opps_applied_for)[7] <- "Role_Wanted"

colnames(placements)[2]  <- "Volunteer_ID"
colnames(placements)[3]  <- "Placement_ID"
colnames(placements)[4]  <- "Placement_Date"
colnames(placements)[5]  <- "Opportunity_Offer_Date"
colnames(placements)[6]  <- "Opportunity_ID"
colnames(placements)[10] <- "Opportunity_Volunteer_Centre"
colnames(placements)[11] <- "Opportunity_Description"

# convert columns to their appropriate types
volunteers$Registration_Date <- as.Date(volunteers$Registration_Date, format = "%d/%m/%Y")
opportunities$Created.Date <- as.Date(opportunities$Created.Date, format = "%m/%d/%y")
opportunities$Publish.Date <- as.Date(opportunities$Publish.Date, format = "%m/%d/%y")
opps_applied_for$Application_Date <- as.Date(opps_applied_for$Application_Date, format = "%m/%d/%Y")
placements$Placement_Date <- as.Date(placements$Placement_Date, format = "%d/%m/%Y")
placements$Opportunity_Offer_Date <- as.Date(placements$Opportunity_Offer_Date, format = "%d/%m/%Y")

# create new fields for day, month and year
opportunities$Created.Date.Day   <- as.factor(format(opportunities$Created.Date, format = "%d"))
opportunities$Created.Date.Month <- as.factor(format(opportunities$Created.Date, format = "%m"))
opportunities$Created.Date.Year  <- as.factor(format(opportunities$Created.Date, format = "%Y"))
opportunities$Publish.Date.Day   <- as.factor(format(opportunities$Publish.Date, format = "%d"))
opportunities$Publish.Date.Month <- as.factor(format(opportunities$Publish.Date, format = "%m"))
opportunities$Publish.Date.Year  <- as.factor(format(opportunities$Publish.Date, format = "%Y"))

opps_applied_for$Application_Date_Day   <- as.factor(format(opps_applied_for$Application_Date, format = "%d"))
opps_applied_for$Application_Date_Month <- as.factor(format(opps_applied_for$Application_Date, format = "%m"))
opps_applied_for$Application_Date_year  <- as.factor(format(opps_applied_for$Application_Date, format = "%Y"))

placements$Placement_Date_Day   <- as.factor(format(placements$Placement_Date, format = "%d"))
placements$Placement_Date_Month <- as.factor(format(placements$Placement_Date, format = "%m"))
placements$Placement_Date_Year  <- as.factor(format(placements$Placement_Date, format = "%Y"))

placements$Opportunity_Offer_Date_Day   <- as.factor(format(placements$Opportunity_Offer_Date, format = "%d"))
placements$Opportunity_Offer_Date_Month <- as.factor(format(placements$Opportunity_Offer_Date, format = "%m"))
placements$Opportunity_Offer_Date_Year  <- as.factor(format(placements$Opportunity_Offer_Date, format = "%Y"))

# cleanup some categories
levels(org$Num_Employees)[1] <- "N/A"
levels(org$Num_Employees)[2] <- "10-20"
levels(org$Num_Employees)[3] <- "100+"
levels(org$Num_Employees)[4] <- "20-50"
levels(org$Num_Employees)[5] <- "5-10"
levels(org$Num_Employees)[6] <- "50-100"
levels(org$Num_Employees)[7] <- "1-4"
levels(org$Num_Employees)[8] <- "0"

# in oppurtunities there are two dates: create and publish. The first is used first
# when the record is first created. The second is used only if a job is reactivated.
# thus, publish contains the most up-to-date date, so let's set any publish date
# that's empty (i.e. == NA) to the creation date, so that later on we only work with
# publish date in the stats.
opportunities$Publish.Date.Year <- as.character(opportunities$Publish.Date.Year)
opportunities$Publish.Date.Year[is.na(opportunities$Publish.Date.Year)] <- as.character(opportunities$Created.Date.Year[is.na(opportunities$Publish.Date.Year)])
opportunities$Publish.Date.Year <- as.factor(opportunities$Publish.Date.Year)

opportunities$Publish.Date.Month <- as.character(opportunities$Publish.Date.Month)
opportunities$Publish.Date.Month[is.na(opportunities$Publish.Date.Month)] <- as.character(opportunities$Created.Date.Month[is.na(opportunities$Publish.Date.Month)])
opportunities$Publish.Date.Month <- as.factor(opportunities$Publish.Date.Month)

opportunities$Publish.Date.Day <- as.character(opportunities$Publish.Date.Day)
opportunities$Publish.Date.Day[is.na(opportunities$Publish.Date.Day)] <- as.character(opportunities$Created.Date.Day[is.na(opportunities$Publish.Date.Day)])
opportunities$Publish.Date.Day <- as.factor(opportunities$Publish.Date.Day)