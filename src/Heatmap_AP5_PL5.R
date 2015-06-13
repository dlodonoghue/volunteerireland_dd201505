# This script produces a heatmap that uses color coding to compare the relative similarity (or dissimilarity) between the different causes across the following features: Number of placements, volunteers placed, applications, vols applied- for 2014. Possible clusters of causes with similar patterns across these features are suggested by the algorithm through the use of a dendrogram structure. 

#+ fig.width=8, fig.height=8

# load required libraries

library(gplots)   # contains the heatmap.2 package
library(RColorBrewer)  # for the heatmap palette 

# Sourcing scripts for AP5_cause and  PL5_cause to reproduce the tables: vols_placed_by_cause and 
# vols_applied_by_cause that contain the features mentioned in the comment above

source('../src/AP5_cause.r')
source('../src/PL5_cause.r')


# mege the tables vols_placed_by_cause and 
# vols_applied_by_cause

by_cause_merged <-
    merge(x = vols_applied_by_cause,
          y = vols_placed_by_cause,
          by = "Cause", all.x = TRUE)


# remove NA values from the Cause column
by_cause_merged <- by_cause_merged[!is.na(by_cause_merged$Cause), ] 

#convert the Causes column to row Names as required by the heatmap function
rownames(by_cause_merged) <-  by_cause_merged$Cause

# remove the Cause raw from the table (ony numerical features can stay)
by_cause_merged <- by_cause_merged[, -1] 

# scale the data in order to caluculate similarity distances 
scaled <- scale(by_cause_merged) 

View(scaled)

# set up a palette to use with the heatmap
my_palette <- colorRampPalette(c('white','yellow','green'))(256)


# create the heatmap and cluster the data using hierarchical clustering (euclidean distance)

heatmap.2(scaled, # the (scaled) data
          col = my_palette,
          cexRow=0.7, cexCol=0.7, # decrease font size of row/column labels
          scale="none", #  already scaled the data
          dendrogram= "row",  # display dendrogram on rows
          na.rm=TRUE,
          lwid = c(lcm(8),lcm(8)) ,
          trace="none",
          #main = "heatmap: Key indicators by Cause", 
          srtCol=45,   
          adjCol = c(1,1),
          colsep=c(1,2,3),      # separators 
          #rowsep = c(),        # to separate clusters
          sepcolor="white", 
          #sepwidth=0.01,
          offsetRow=0, 
          offsetCol=0) 

