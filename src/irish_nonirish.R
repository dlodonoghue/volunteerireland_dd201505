#'
#' @require ta10_nationality_place 
#'

# created by John O'Flynn, 2016/02/06, email: reallyjohnflynn@gmail.com

library('dplyr')
library('ggplot2')
library('gridExtra')
library('reshape2')


# creating a variable to tell Irish versus non-Irish
applications_and_nationality$isIrish[
        applications_and_nationality$Nationality == 'Irish'] <- 'Irish'
applications_and_nationality$isIrish[
        applications_and_nationality$Nationality != 'Irish'] <- 'Non-Irish'

# We only want to look at 2014 and 2015
current <- subset(applications_and_nationality, 
                  Application_Date_Year == '2014'|
                          Application_Date_Year == '2015')


current <- left_join(current, opportunities, by = 'Opportunity_ID')


nonIrish <- subset(current, isIrish == 'Non-Irish')
irish <- subset(current, isIrish == 'Irish')

nonIrish_placed_stats <- nonIrish %>%
        group_by(Current.Status.of.Application) %>%
        summarise(nonIrishPercentage = n() / nrow(nonIrish)) %>%
        arrange(desc(nonIrishPercentage))

irish_placed_stats <- irish %>%
        group_by(Current.Status.of.Application) %>%
        summarise(IrishPercentage = n() / nrow(irish)) %>%
        arrange(desc(IrishPercentage))

applicants_responce <- inner_join(irish_placed_stats, 
                            nonIrish_placed_stats, 
                            by = 'Current.Status.of.Application')

applicants_responce <- melt(applicants_responce, 
                            id.vars = "Current.Status.of.Application")

ggplot(applicants_responce, aes(Current.Status.of.Application, 
                                value)) +
        geom_bar(stat = 'identity',
                 fill="#7770BB", 
                 colour="black") +
        theme_bw() +
        coord_flip() +
        ggtitle('Outcome of Placement Applications') +
        xlab('') +
        ylab('') +
        facet_grid(~variable) 





