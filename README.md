##### DataKind Dublin 2016

## Volunteer Ireland

# Volunteer Information Project 2015-2016

---

## Getting started:

### Git clone the repo to your workspace

e.g. in Mac OSX / Linux terminal:

        workspace $ git clone [GITHUB_PATH]
        workspace $ cd volunteerireland_dd201505

### How to get the data (it's not stored in the repo!) and details about the data

The /data directory in this repository is empty (as data is not public). 
Ask the DataKind ambassadors to provide you with the data (in the form of csv files) and put them inside the /data folder.
The data and its schema is described in detail [here](https://hackpad.com/Volunteer-Ireland-DataDive-Repository-RetFXo5yDX6).

### How to run the R scripts

The /src directory contains several R scripts that run successfully once that the /data directory has been populated with the input csv files.

To run in a Mac OSX / Linux terminal:

		workspace/volunteerireland_dd201505 $ cd src
		workspace/volunteerireland_dd201505/src $ R
		> source [SCRIPT_NAME.R]

### Scripts description

The scripts in the /src directory were written by participants in the DataKind Dublin DataDive 2015, and contain useful comments to make them easier to understand. 
Here's an overview of their purpose.

The script load_data.R creates the dataframes volunteers, opportunities, placements, org, opps_applied_for starting from the csv data in the /data directory.
This script is invoked by the majority of the other scripts whenever the dataframes above do not appear to have been loaded into R.

The scripts whose filename starts with "OP" output tables with the number of volunteers required by organisations, breaking down them by features of the OPportunities offered by the latter, such as location, level of english required, cause, etc.
  
The scripts whose filename starts with "AP" output tables that make it easier to understand how many APplications to volunteer were sent by applicants (segmenting the volunteers by features as age, gender, nationality, etc.) and how many applications were generated as a response to opportunities (segmenting the opportunties by features as the level of English required to volunteer, how volunteers are managed by the organisation proposing the opportunity, organisation size, etc.).

The scripts whose filename starts with "PL" output tables that make it easier to understand how many PLacements occurred (segmenting the volunteers by features) and how many placements were generated as a response to opportunities (segmenting the opportunties by their features). The PL scripts correspond to the AP scripts, the difference being that the former deal with placements (i.e. data on successful applications) and the latter deal with applications, regardless their success.

#### Other scripts / useful examples of data visualizations

Other scripts mainly provide data visualizations of the dataset or compute totals of the overall applications/placements by year.  
Irish **geographical data** at a county level can be visualized using the stub provided in V_map.R, using data from gadm.org.  
**Predictors of placements** could be analysed using machine learning techniques. An example using decision trees (rpart package) is provided in V_class_tree.R.  
**Clustering** of volunteering causes with respect to number of applications/placements is provided in Heatmap_AP5_PL5.R.  
Other plots of trends of placement ratio with respect to nationality are provided in V04.R.  

#### Legacy scripts

Legacy scripts are in the /src/legacy directory.
