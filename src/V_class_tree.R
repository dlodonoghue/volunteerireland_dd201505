# V_class_tree.R ----------------------------------------------------------------
#
# This script builds a classification tree to predict if a volunteer will be placed or not based on her/his features

# check variables are loaded into workspace  ----------------------------------

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

# Select columns of dataset to be used as predictors of success in placement. MODIFY AS NEEDED
df <- volunteers[, c("Age.Group", "Volunteer.Recruitment.Method", "Gender", "Nationality", "Volunteered.before.", "Why.do.you.want.to.volunteer.now", "Activity.you.are.interested.in", "Cause.you.are.interested.in", "County", "Skills.Profile", "Placed")]

# Function to compute the mean of an age bucket
change.age <- function(x){
	ages <- unlist(strsplit(x, "-"))
	return((as.numeric(ages[1]) + as.numeric(ages[2]))/2)
}

# Cast age bucket into number by taking the average of the bucket
levels(df$Age.Group)[grepl("-", levels(df$Age.Group))] <- unlist(lapply(levels(df$Age.Group)[grepl("-", levels(df$Age.Group))], change.age))

# Assign to over- and under- age the lowest and highest age compatible with the interval (not very legitimate)
levels(df$Age.Group) <- gsub("under ", "", levels(df$Age.Group), ignore.case = T)
levels(df$Age.Group) <- gsub(">", "", levels(df$Age.Group))
levels(df$Age.Group) <- gsub("<", "", levels(df$Age.Group))
levels(df$Age.Group) <- gsub("\\+", "", levels(df$Age.Group))

# Convert to numbers
levels(df$Age.Group) <- unlist(lapply(levels(df$Age.Group), as.numeric))
df$Age.Group <- as.numeric(as.character(df$Age.Group))

# Lump non-Irish nationals into the same bucket
levels(df$Nationality)[levels(df$Nationality) != "Irish"] <- "Non-Irish"

# Reduce the number of reasons to volunteer to the most (top 28) popular ones
levels(df$Why.do.you.want.to.volunteer.now)[!(levels(df$Why.do.you.want.to.volunteer.now) %in% names(rev(sort(table(volunteers$Why.do.you.want.to.volunteer.now)))[1:28]))] <- NA 

# Find people who state explicitly that haven't volunteered before
levels(df$Volunteered.before.)[levels(df$Volunteered.before.) %in% c("No", "No.", "None")] <- "No"
# All the others (sometimes providing detailed info) have
levels(df$Volunteered.before.)[levels(df$Volunteered.before.) != "No"] <- "Yes"

# Count skills using semicolons as separators. 1 semicolon = 2 skills, 0 semicolons = 1 skill, NA = 0 skills
df$NSkills <- str_count(df$Skills.Profile, ";") + 1
df$NSkills[is.na(df$Skills.Profile)] <- 0
df$Skills.Profile <- NULL # delete the Skills.Profile data

# Is the volunteered placed or not? This is what we are trying to predict. MODIFY AS NEEDED
levels(df$Placed)[!levels(df$Placed) %in% c("Placed", "Referred to Organisation")] <- "Not placed"
levels(df$Placed)[levels(df$Placed) %in% c("Placed", "Referred to Organisation")] <- "Placed"

# Perform test and control split on the dataset to check the performance of the model, with split ratio alpha
seed = 121188 # random seed
set.seed(seed)
alpha = 0.8 # split ratio
sel <- sample.split(df$Placed, alpha)
train <- df[sel,]
test <- df[!sel,]

# Train decision tree (rather than running cross validation we fix the complexity of the model, as complex tree are not easy to use)
cp <- 0.006
mod <- rpart(Placed ~ ., data = train, na.action = na.pass, cp = cp) # use all features
#mod <- rpart(Placed ~ County + Age.Group + NSkills, data = train, na.action = na.pass, cp = 0.006) # use a simpler model

# Plot tree representation (useful to read it)
prp(mod, extra = 6)

# Model performance summary
cat("Confusion matrix\n")
conf.mat <- table(predict(mod, "class", newdata = test), test$Placed)
print(conf.mat)
cat("\n")
cat(sprintf("Accuracy = %.3f \n", (conf.mat[1,1] + conf.mat[2,2])/sum(conf.mat)))

# Plot ROC curve (fails to run, as the model has no strong opinions on the classification)
#library(ROCR)
#predictTest =  predict(mod, "prob", newdata = test)
#ROCRpred = prediction(predictTest[,2], test$Placed)
#as.numeric(performance(ROCRpred, "auc")@y.values)
#
#plot(performance(ROCRpred,"tpr","fpr"))
