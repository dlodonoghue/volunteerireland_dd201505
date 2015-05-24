setwd("~/Dropbox/Projects/R/volunteerireland_dd201505/src")

volunteers      <- read.csv("../data/df_vol.csv")
opputunities    <- read.csv("../data/df_oppsaltm.csv")
placements      <- read.csv("../data/df_plc.csv")
org             <- read.csv("../data/df_orgs.csv", sep='\t')
ops_applied_for <- read.csv("../data/df_oppsapfr.csv")

# rename the common columns between the data frames and some others
colnames(volunteers)[1]  <- "Volunteer_ID"
colnames(volunteers)[2] <- "Registration_Date"

colnames(org)[9]  <- "Cause"
colnames(org)[13] <- "Num_Volunteers"
colnames(org)[14] <- "Num_Employees"
colnames(org)[15] <- "Management_Style"

colnames(opputunities)[2] <- "Job_ID"
colnames(opputunities)[5] <- "Role_Name"

colnames(ops_applied_for)[1] <- "Application_Name"
colnames(ops_applied_for)[3] <- "Application_Date"
colnames(ops_applied_for)[4] <- "Volunteer_ID"
colnames(ops_applied_for)[5] <- "Application_ID"
colnames(ops_applied_for)[6] <- "Job_ID"
colnames(ops_applied_for)[7] <- "Role_Wanted"

colnames(placements)[2]  <- "Volunteer_ID"
colnames(placements)[3]  <- "Placement_ID"
colnames(placements)[4]  <- "Placement_Date"
colnames(placements)[5]  <- "Job_Offer_Date"
colnames(placements)[6]  <- "Job_ID"
colnames(placements)[10] <- "Job_Volunteer_Centre"
colnames(placements)[11] <- "Job_Description"

# convert columns to their appropriate types
volunteers$Registration_Date <- as.Date(volunteers$Registration_Date, format = "%d/%m/%Y")
opputunities$Created.Date <- as.Date(opputunities$Created.Date, format = "%m/%d/%y")
opputunities$Publish.Date <- as.Date(opputunities$Publish.Date, format = "%m/%d/%y")
ops_applied_for$Application_Date <- as.Date(ops_applied_for$Application_Date, format = "%m/%d/%Y")
placements$Placement_Date <- as.Date(placements$Placement_Date, format = "%d/%m/%Y")
placements$Job_Offer_Date <- as.Date(placements$Job_Offer_Date, format = "%d/%m/%Y")

# create new fields for day, month and year
opputunities$Created.Date.Day   <- as.factor(format(opputunities$Created.Date, format = "%d"))
opputunities$Created.Date.Month <- as.factor(format(opputunities$Created.Date, format = "%m"))
opputunities$Created.Date.Year  <- as.factor(format(opputunities$Created.Date, format = "%Y"))
opputunities$Publish.Date.Day   <- as.factor(format(opputunities$Publish.Date, format = "%d"))
opputunities$Publish.Date.Month <- as.factor(format(opputunities$Publish.Date, format = "%m"))
opputunities$Publish.Date.Year  <- as.factor(format(opputunities$Publish.Date, format = "%Y"))

ops_applied_for$Application_Date_Day   <- as.factor(format(ops_applied_for$Application_Date, format = "%d"))
ops_applied_for$Application_Date_Month <- as.factor(format(ops_applied_for$Application_Date, format = "%m"))
ops_applied_for$Application_Date_year  <- as.factor(format(ops_applied_for$Application_Date, format = "%Y"))

placements$Placement_Date_Day   <- as.factor(format(placements$Placement_Date, format = "%d"))
placements$Placement_Date_Month <- as.factor(format(placements$Placement_Date, format = "%m"))
placements$Placement_Date_Year  <- as.factor(format(placements$Placement_Date, format = "%Y"))

placements$Job_Offer_Date_Day   <- as.factor(format(placements$Job_Offer_Date, format = "%d"))
placements$Job_Offer_Date_Month <- as.factor(format(placements$Job_Offer_Date, format = "%m"))
placements$Job_Offer_Date_Year  <- as.factor(format(placements$Job_Offer_Date, format = "%Y"))

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
opputunities$Publish.Date.Year <- as.character(opputunities$Publish.Date.Year)
opputunities$Publish.Date.Year[is.na(opputunities$Publish.Date.Year)] <- as.character(opputunities$Created.Date.Year[is.na(opputunities$Publish.Date.Year)])
opputunities$Publish.Date.Year <- as.factor(opputunities$Publish.Date.Year)

opputunities$Publish.Date.Month <- as.character(opputunities$Publish.Date.Month)
opputunities$Publish.Date.Month[is.na(opputunities$Publish.Date.Month)] <- as.character(opputunities$Created.Date.Month[is.na(opputunities$Publish.Date.Month)])
opputunities$Publish.Date.Month <- as.factor(opputunities$Publish.Date.Month)

opputunities$Publish.Date.Day <- as.character(opputunities$Publish.Date.Day)
opputunities$Publish.Date.Day[is.na(opputunities$Publish.Date.Day)] <- as.character(opputunities$Created.Date.Day[is.na(opputunities$Publish.Date.Day)])
opputunities$Publish.Date.Day <- as.factor(opputunities$Publish.Date.Day)