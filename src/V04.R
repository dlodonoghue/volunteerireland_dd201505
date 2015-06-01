# Language proficiency analysis among placed volunteers

## Loading packages ------    

#+ fig.width=12, fig.height=8  

library(dplyr)
library(tidyr)
library(RODBC) 
library(lubridate)
library(ggplot2)
library(pander) 

## transformation and data analysis  -----


volunteers <- read.csv("../data/df_vol.csv", na.strings="") #adding na.string param to convert blank fields to NAs  

colnames(volunteers)[1]  <- "Volunteer_ID"    # renaming 
colnames(volunteers)[2] <- "Registration_Date" # renaming

volunteers$Volunteer_ID<- as.character(volunteers$Volunteer_ID)  # convert volunteer ID from factor to character

#apply(volunteers, 2, function(x) length(which(is.na(x))))  # how many NAs by column ? The Placed column has about  3000 NA values, the nationality 286 and the registration date no NAs

# create a data frame with just the variables Volunteer_ID,  Registration_Date Placed and Nationality

volu_4vars <- volunteers[,c("Volunteer_ID","Registration_Date","Placed", "Nationality")]

glimpse(volu_4vars)

tbl_df(volu_4vars)

# convert registration date to date object

volu_4vars$Registration_Date <- as.Date(volu_4vars$Registration_Date, format="%d/%m/%Y")


volu_4vars$Registration_Date <- year(volu_4vars$Registration_Date)
#volu_4vars <- separate(volu_4vars, Registration_Date, (c("Day", "Month", "Year"), sep = "/"))



table(volu_4vars$Placed)  # to see aggregates by each one of the 8 different levels of the variable

apply(volu_4vars, 2, function(x) length(which(is.na(x))))  # how many NAs by column ?

volu4 <- volu_4vars[complete.cases(volu_4vars),]  # just keep complete cases

volu4$Placed <- volu4$Placed=="Placed"      # Was volunteer placed ?  true or false

volu4 <-  volu4 %>% mutate (isIrish=ifelse(Nationality=="Irish", "Irish", "nonIrish"))  # Split in Irish vs non
 
by_isIrish_placed <- volu4  %>%  group_by (Registration_Date, isIrish, Placed) %>%  summarise (n=n()) # table for Irish/nonIrish vs placed/not placed

spread_by_isIrish_placed <- by_isIrish_placed    %>% spread (Placed, n )

#spread_by_isIrish_placed <-  spread_by_isIrish_placed %>%  rename (notPlaced= `FALSE` Placed =`TRUE`)

colnames(spread_by_isIrish_placed)[3]  <- "notPlaced"
colnames(spread_by_isIrish_placed)[4]  <- "Placed"

#plot(spread_by_isIrish_placed)


by_Irish_ratio <- spread_by_isIrish_placed %>%  mutate(ratioPlaced=100*Placed/(Placed + notPlaced))

by_Irish_ratio$isIrish <- as.factor(by_Irish_ratio$isIrish)


#plot(y=by_Irish_ratio$ratio, x=by_Irish_ratio$isIrish)

final <-  by_Irish_ratio %>%  select (Registration_Date, isIrish, ratioPlaced) %>% filter (Registration_Date<2015)



#final$Registration_Date <- as.Date(final$Registration_Date, format="%YYYY")

colnames(final)[1] <- "Year" 

pander(data.frame(final), style = 'rmarkdown')

ggplot(final, aes(isIrish, ratioPlaced)) + geom_bar(stat="identity") + facet_grid(. ~ Year) 

ggplot(final, aes(Year, ratioPlaced)) + geom_line(size=2, aes(color = isIrish)) + scale_x_continuous(breaks=sequence(2005:2014)) + scale_y_continuous(limits = c(0, 100))







