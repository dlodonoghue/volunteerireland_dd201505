# Language proficiency analysis among placed volunteers

# Notebook settings  ------    

#+ fig.width=12, fig.height=8  

# Libraries required
  
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(pander) 

## transformation and data analysis  -----


volunteers <- read.csv("../data/df_vol.csv", na.strings="") #adding na.string param to convert blank fields to NAs  

colnames(volunteers)[1]  <- "Volunteer_ID"    # renaming 
colnames(volunteers)[2] <- "Registration_Date" # renaming

volunteers$Volunteer_ID<- as.character(volunteers$Volunteer_ID)  # convert volunteer ID from factor to character


# create a data frame with just the variables Volunteer_ID,  Registration_Date Placed and Nationality

volu_4vars <- volunteers[,c("Volunteer_ID","Registration_Date","Placed", "Nationality")]

# have a look at the data table
glimpse(volu_4vars)
tbl_df(volu_4vars)

# convert registration date to date object

volu_4vars$Registration_Date <- as.Date(volu_4vars$Registration_Date, format="%d/%m/%Y")

# extract the year with lubridate 
volu_4vars$Registration_Date <- year(volu_4vars$Registration_Date)


table(volu_4vars$Placed)  # to see aggregates by each one of the 8 different levels of the variable

apply(volu_4vars, 2, function(x) length(which(is.na(x))))  # how many NAs by column ?

volu4 <- volu_4vars[complete.cases(volu_4vars),]  # just keep complete cases

volu4$Placed <- volu4$Placed=="Placed"      # Was volunteer placed ?  true or false

volu4 <-  volu4 %>% mutate (isIrish=ifelse(Nationality=="Irish", "Irish", "nonIrish"))  # Split in Irish vs non
 
by_isIrish_placed <- volu4  %>%  group_by (Registration_Date, isIrish, Placed) %>%  summarise (n=n()) # table for Irish/nonIrish vs placed/not placed


# reshape data for plotting
spread_by_isIrish_placed <- by_isIrish_placed    %>% spread (Placed, n )


colnames(spread_by_isIrish_placed)[3]  <- "notPlaced"
colnames(spread_by_isIrish_placed)[4]  <- "Placed"

# add ratio column
by_Irish_ratio <- spread_by_isIrish_placed %>%  mutate(ratioPlaced=100*Placed/(Placed + notPlaced))

# convert to factor for plotting
by_Irish_ratio$isIrish <- as.factor(by_Irish_ratio$isIrish)


# selecting relevant columns and filtering out dates after 1.1.2015
final <-  by_Irish_ratio %>%  select (Registration_Date, isIrish, ratioPlaced) %>% filter (Registration_Date<2015)


colnames(final)[1] <- "Year" 

# pander for nicer visualization on the notebook
# pander(data.frame(final), style = 'rmarkdown')
View(data.frame(final)) # Alternative using View

ggplot(final, aes(isIrish, ratioPlaced)) + geom_bar(stat="identity") + facet_grid(. ~ Year) 

ggplot(final, aes(Year, ratioPlaced)) + geom_line(size=2, aes(color = isIrish)) + scale_x_continuous(breaks=sequence(2005:2014)) + scale_y_continuous(limits = c(0, 100))







