# this code computes likelihood of being placed bucketing volunteers by their skills and continent of origin

if (!("opportunities" %in% ls()) |
      !("opps_applied_for" %in% ls()) |
      !("placements" %in% ls()) |
      !("volunteers" %in% ls()) |
      !("org" %in% ls())) {
  source("load_data.R")      
}

library(dplyr)
library(stringr)
library(caTools)
library(rpart)
library(rpart.plot)
library(lubridate)
library(ggplot2)

threshold_year = 2014
df <- volunteers %>% filter(year(Registration_Date) >= threshold_year) %>% filter(!Age.Group %in% c("50-59", "Not Given", "26-35", "16-25"))
df <- droplevels(df)

# Select columns of dataset to be used as predictors of success in placement. MODIFY AS NEEDED
df <- df[, c("Age.Group", "Volunteer.Recruitment.Method", "Gender", "Nationality", "Volunteered.before.", "Why.do.you.want.to.volunteer.now", "Activity.you.are.interested.in", "Cause.you.are.interested.in", "County", "Skills.Profile", "Placed", "Face.to.Face")]

levels(df$Face.to.Face) <- c(levels(df$Face.to.Face), "No", "Yes")
df[is.na(df[,"Face.to.Face"]),"Face.to.Face"] <- "No"
df[df[,"Face.to.Face"] != "No", "Face.to.Face"] <- "Yes"

# Categorize volunteers by continent
nationality_continent <- read.csv("../data/nationality_continent.csv")
df <- left_join(df, nationality_continent, by = c("Nationality" = "Adjectivals"))

skills_list <- sapply(strsplit(as.character(df$Skills.Profile), "; "), function(x) x)
skills <- unique(unlist(skills_list))
skills <- skills[!is.na(skills)]

for (s in skills){
	df[, s] <- NA
}

for (i in 1:nrow(df)){
	if(!is.na(skills_list[[i]])){
		df[i, skills] <- skills %in% skills_list[[i]]
	}
}

# all those who are not "Placed" are "Not Placed" 
levels(df$Placed)[!levels(df$Placed) == "Placed"] <- "Not placed"

# Compute fraction of placed people who has a given skill
has_skills <- array(0, dim = c(0, length(skills)))

for (i in 1:length(skills)){
	skills_tab <- table(df[, skills[i]], df$Placed)
 	cat("Placed fraction without ", skills[i], ": ", skills_tab[1,2]/skills_tab[1,1], "\n")
 	cat("Placed fraction with ", skills[i], ": ", skills_tab[2,2]/skills_tab[2,1], "\n")
 	has_skills[i] <- skills_tab[2,2]/(skills_tab[2,1] + skills_tab[2,2])
}

names(has_skills) <- skills

skillsrank <- data.frame(has_skills) %>% add_rownames()

ggplot(skillsrank, aes(x = reorder(rowname, has_skills), y = has_skills)) + geom_bar(stat="identity") + geom_text(aes(x = reorder(rowname, has_skills), y = has_skills, ymax = has_skills, label = colSums(na.omit(df[, skills]))), color = "red") + xlab("Skill") + ylab("Placement probability") + coord_flip()

# Compute fraction of placed people who comes from a given geo area
has_continent <- array(0, dim = length(levels(df$Continent)))
continent <- levels(df$Continent)

for (i in 1:length(continent)){
	continent_tab <- table(df[df[,"Continent"] == continent[i], "Placed"])
 	has_continent[i] <- continent_tab[2]/(continent_tab[1] + continent_tab[2])
}

names(has_continent) <- continent

continentrank <- data.frame(has_continent) %>% add_rownames() 

ggplot(continentrank, aes(x = reorder(rowname, has_continent), y = has_continent)) + geom_bar(stat="identity") + geom_text(aes(x = reorder(rowname, has_continent), y = has_continent, ymax = has_continent, label = as.vector(table(df[, "Continent"]))), color = "red")+ xlab("Geo Area") + ylab("Placement probability") + coord_flip()

# Below there's a table to convert VI nationality adjectivals into continents (dump into a .csv and place/call it ../data/nationality_continent.csv)
# Country name, Continent
# "Aruba","North America"
# "Afghanistan","Asia"
# "Angola","Africa"
# "Anguilla","North America"
# "Albania","Europe"
# "Andorra","Europe"
# "Netherlands Antilles","North America"
# "United Arab Emirates","Asia"
# "Argentina","South America"
# "Armenia","Asia"
# "American Samoa","Oceania"
# "Antarctica","Antarctica"
# "French Southern territories","Antarctica"
# "Antigua and Barbuda","North America"
# "Australia","Oceania"
# "Austria","Europe"
# "Azerbaijan","Asia"
# "Burundi","Africa"
# "Belgium","Europe"
# "Benin","Africa"
# "Burkina Faso","Africa"
# "Bangladesh","Asia"
# "Bulgaria","Europe"
# "Bahrain","Asia"
# "Bahamas","North America"
# "Bosnia and Herzegovina","Europe"
# "Belarus","Europe"
# "Belize","North America"
# "Bermuda","North America"
# "Bolivia","South America"
# "Brazil","South America"
# "Barbados","North America"
# "Brunei","Asia"
# "Bhutan","Asia"
# "Bouvet Island","Antarctica"
# "Botswana","Africa"
# "Central African Republic","Africa"
# "Canada","North America"
# "Cocos (Keeling) Islands","Oceania"
# "Switzerland","Europe"
# "Chile","South America"
# "China","Asia"
# "Cote d'Ivoire","Africa"
# "Cameroon","Africa"
# "Congo, The Democratic Republic of the","Africa"
# "Congo","Africa"
# "Cook Islands","Oceania"
# "Colombia","South America"
# "Comoros","Africa"
# "Cape Verde","Africa"
# "Costa Rica","North America"
# "Cuba","North America"
# "Christmas Island","Oceania"
# "Cayman Islands","North America"
# "Cyprus","Asia"
# "Czech Republic","Europe"
# "Germany","Europe"
# "Djibouti","Africa"
# "Dominica","North America"
# "Denmark","Europe"
# "Dominican Republic","North America"
# "Algeria","Africa"
# "Ecuador","South America"
# "Egypt","Africa"
# "Western Sahara","Africa"
# "Spain","Europe"
# "Eritrea","Africa"
# "Estonia","Europe"
# "Ethiopia","Africa"
# "Finland","Europe"
# "Fiji Islands","Oceania"
# "Falkland Islands","South America"
# "France","Europe"
# "Faroe Islands","Europe"
# "Federated States of Micronesia","Oceania"
# "Gabon","Africa"
# "United Kingdom","Europe"
# "Georgia","Asia"
# "Ghana","Africa"
# "Gibraltar","Europe"
# "Guinea","Africa"
# "Guadeloupe","North America"
# "Gambia","Africa"
# "Guinea-Bissau","Africa"
# "Equatorial Guinea","Africa"
# "Greece","Europe"
# "Grenada","North America"
# "Greenland","North America"
# "Guatemala","North America"
# "French Guiana","South America"
# "Guam","Oceania"
# "Guyana","South America"
# "Hong Kong","Asia"
# "Heard Island and McDonald Islands","Antarctica"
# "Honduras","North America"
# "Croatia","Europe"
# "Haiti","North America"
# "Hungary","Europe"
# "Indonesia","Asia"
# "India","Asia"
# "British Indian Ocean Territory","Africa"
# "Ireland","Europe"
# "Iran","Asia"
# "Iraq","Asia"
# "Iceland","Europe"
# "Israel","Asia"
# "Italy","Europe"
# "Jamaica","North America"
# "Jordan","Asia"
# "Japan","Asia"
# "Kazakstan","Asia"
# "Kenya","Africa"
# "Kyrgyzstan","Asia"
# "Cambodia","Asia"
# "Kiribati","Oceania"
# "Saint Kitts and Nevis","North America"
# "South Korea","Asia"
# "Kuwait","Asia"
# "Laos","Asia"
# "Lebanon","Asia"
# "Liberia","Africa"
# "Libyan Arab Jamahiriya","Africa"
# "Saint Lucia","North America"
# "Liechtenstein","Europe"
# "Sri Lanka","Asia"
# "Lesotho","Africa"
# "Lithuania","Europe"
# "Luxembourg","Europe"
# "Latvia","Europe"
# "Macao","Asia"
# "Morocco","Africa"
# "Monaco","Europe"
# "Moldova","Europe"
# "Madagascar","Africa"
# "Maldives","Asia"
# "Mexico","North America"
# "Marshall Islands","Oceania"
# "Macedonia","Europe"
# "Mali","Africa"
# "Malta","Europe"
# "Myanmar","Asia"
# "Mongolia","Asia"
# "Northern Mariana Islands","Oceania"
# "Mozambique","Africa"
# "Mauritania","Africa"
# "Montserrat","North America"
# "Martinique","North America"
# "Mauritius","Africa"
# "Malawi","Africa"
# "Malaysia","Asia"
# "Mayotte","Africa"
# "Namibia","Africa"
# "New Caledonia","Oceania"
# "Niger","Africa"
# "Norfolk Island","Oceania"
# "Nigeria","Africa"
# "Nicaragua","North America"
# "Niue","Oceania"
# "Netherlands","Europe"
# "Norway","Europe"
# "Nepal","Asia"
# "Nauru","Oceania"
# "New Zealand","Oceania"
# "Oman","Asia"
# "Pakistan","Asia"
# "Panama","North America"
# "Pitcairn","Oceania"
# "Peru","South America"
# "Philippines","Asia"
# "Palau","Oceania"
# "Papua New Guinea","Oceania"
# "Poland","Europe"
# "Puerto Rico","North America"
# "North Korea","Asia"
# "Portugal","Europe"
# "Paraguay","South America"
# "Palestine","Asia"
# "French Polynesia","Oceania"
# "Qatar","Asia"
# "Reunion","Africa"
# "Romania","Europe"
# "Russian Federation","Europe"
# "Rwanda","Africa"
# "Saudi Arabia","Asia"
# "Sudan","Africa"
# "South Sudan","Africa"
# "Senegal","Africa"
# "Singapore","Asia"
# "South Georgia and the South Sandwich Islands","Antarctica"
# "Saint Helena","Africa"
# "Svalbard and Jan Mayen","Europe"
# "Solomon Islands","Oceania"
# "Sierra Leone","Africa"
# "El Salvador","North America"
# "San Marino","Europe"
# "Somalia","Africa"
# "Saint Pierre and Miquelon","North America"
# "Sao Tome and Principe","Africa"
# "Suriname","South America"
# "Slovakia","Europe"
# "Slovenia","Europe"
# "Sweden","Europe"
# "Swaziland","Africa"
# "Seychelles","Africa"
# "Syria","Asia"
# "Turks and Caicos Islands","North America"
# "Chad","Africa"
# "Togo","Africa"
# "Thailand","Asia"
# "Tajikistan","Asia"
# "Tokelau","Oceania"
# "Turkmenistan","Asia"
# "East Timor","Asia"
# "Tonga","Oceania"
# "Trinidad and Tobago","North America"
# "Tunisia","Africa"
# "Turkey","Asia"
# "Tuvalu","Oceania"
# "Taiwan","Asia"
# "Tanzania","Africa"
# "Uganda","Africa"
# "Ukraine","Europe"
# "United States Minor Outlying Islands","Oceania"
# "Uruguay","South America"
# "United States","North America"
# "Uzbekistan","Asia"
# "Holy See (Vatican City State)","Europe"
# "Saint Vincent and the Grenadines","North America"
# "Venezuela","South America"
# "British Virgin Islands","North America"
# "United States Virgin Islands","North America"
# "Vietnam","Asia"
# "Vanuatu","Oceania"
# "Wallis and Futuna","Oceania"
# "Samoa","Oceania"
# "Yemen","Asia"
# "Yugoslavia","Europe"
# "South Africa","Africa"
# "Zambia","Africa"
# "Zimbabwe","Africa"