# Language proficiency analysis among placed volunteers

## Loading packages ------

library(dplyr)
library(tidyr)
library(RODBC)      


## Getting the data ----

#Connect to Access db
channel <- odbcConnectAccess("D:/Projects/R_project_temp/Datakind/Data-Files/VIre_DB1v0.1.mdb")


qry_df_vol <-  "SELECT * FROM df_vol" #Run an SQL Query and then save as Rda file

df_vol <- sqlQuery(channel, qry_df_vol)

save (df_vol, file="df_vol.Rda")

load("D:/Projects/R_project_temp/Datakind/Data-Files/df_vol.Rda")  # load the data for analysis


## transformation and data analysis  -----

df_vol <- as.data.frame(df_vol, stringsAsFactors=T) 

df_vol$VolunteerID<- as.character(df_vol$`Volunteer ID`)  # renaming, ideally should do this for all variables

df_vol$Placed <- df_vol$Placed=="Placed"      # Was volunteer placed ?  true or false

placed_complete <- df_vol %>%  filter (Placed==TRUE | Placed==FALSE)  # remove  NAs

placed_irish <-  placed_complete %>% mutate (isIrish=ifelse(Nationality=="Irish", 1, 0))  # Split in Irish vs non
 
placed_irish_complete <- placed_irish %>%   filter(! is.na(isIrish))  # remove NAs from columns isIrish

by_isIrish_placed <- placed_irish_complete %>%  group_by (isIrish, Placed) %>%  summarise (n=n())

spread_by_isIrish_placed <- by_isIrish_placed    %>% spread (Placed, n )

by_Irish_ratio <- spread_by_isIrish_placed %>%  mutate(ratio=100*`TRUE`/(`TRUE` + `FALSE`))

by_Irish_ratio <- by_Irish_ratio %>%  rename(Placed=`TRUE`, notPlaced=`FALSE`)

by_Irish_ratio$isIrish <- as.factor(by_Irish_ratio$isIrish)

#plot(y=by_Irish_ratio$ratio, x=by_Irish_ratio$isIrish)

final <-  by_Irish_ratio %>%  select (isIrish, ratio)

library(lattice)
barchart(final$isIrish ~ final$ratio )   # should do this with ggplot, transpose the axis and scale the y axis 1-100 to represent percentages

percentage_irish_placed  = 21863/(49958 +21863 )   # 0.3044096
#  ~ 22000 irish people placed out of 72000 registered

percentage_nonIrish_placed = 6585/(21347+ 6585)    #  0.2357511
# ~ 6500  nonIrish placed  out of 28000 registered. 

library(xlsx)   # create an xlsx file
write.xlsx(by_isIrish_placed, file="by_isIrish_placed.xlsx", sheetName="Sheet1")




