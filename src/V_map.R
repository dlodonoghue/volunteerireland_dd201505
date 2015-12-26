# V_map.R ----------------------------------------------------------------
#
# This script downloads a map of the counties in Ireland and plots a choropleth with data taken from the volunteers table

# check variables are loaded into workspace  ----------------------------------

if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("load_data.R")      
}

library(sp)
library(dplyr)

# If not present, download Level 1 geo data from http://gadm.org/
if (!file.exists("../data/IRL_adm1.rds")){
	download.file("http://biogeo.ucdavis.edu/data/gadm2.8/rds/IRL_adm1.rds", "../data/IRL_adm1.rds")
}

# Load county map of Ireland
ireland <- readRDS("../data/IRL_adm1.rds")

# Add column with County statistics
ireland$volunteers <- as.vector(table(volunteers["County"]))
spplot(ireland, "volunteers", col.regions = rev(heat.colors(100)), main = "Number of volunteers")

# Sanity check, matching of the county alignment in the RDS file and in the alphabetically ordered table
# View(cbind(ireland$NAME_1, names(table(volunteers["County"]))))
