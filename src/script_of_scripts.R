# this is a template of a meta-script, that collects the output of different R scripts and puts all the resulting tables in a google spreadsheet, separating output in different worksheets.
# this code relies on the googlesheets and dplyr library, and requires access to a google spreadsheet to be executed.
# in this specific example, the code requires that a google spreadsheet with title "VI DataKind" is accessible on the Google Drive of the account running the code (therefore a Google account is required to run...)

library(googlesheets)
library(dplyr)

# look for a spreadsheet whose name is VI DataKind in Google Drive
results_sheet <- gs_title("VI DataKind")

# create a worksheet which will be the output of the sanity_check.R code 
source("sanity_check.r")

# delete previous "sanity check" worksheet, if present
if("sanity check" %in% gs_ws_ls(results_sheet)){
	results_sheet <- results_sheet %>% gs_ws_delete("sanity check")
}

# create worksheet
results_sheet <- results_sheet %>% gs_ws_new("sanity check")
# fill it
results_sheet <- results_sheet %>% gs_edit_cells(ws = "sanity check", input = c("total_applications"), anchor = "A1")
results_sheet <- results_sheet %>% gs_edit_cells(ws = "sanity check", input = total_applications, anchor = "A2")
results_sheet <- results_sheet %>% gs_edit_cells(ws = "sanity check", input = c("total_volunteers_placed"), anchor = "D1")
results_sheet <- results_sheet %>% gs_edit_cells(ws = "sanity check", input = total_volunteers_placed, anchor = "D2")
results_sheet <- results_sheet %>% gs_edit_cells(ws = "sanity check", input = c("total_placements"), anchor = "G1")
results_sheet <- results_sheet %>% gs_edit_cells(ws = "sanity check", input = total_placements, anchor = "G2")

# create a worksheet which will be the output of the code below
source("AP1_age_group.r")
source("PL1_age_group.r")

# delete previous "age group" worksheet, if present
if("age group" %in% gs_ws_ls(results_sheet)){
	results_sheet <- results_sheet %>% gs_ws_delete("age group")
}

# create worksheet
results_sheet <- results_sheet %>% gs_ws_new("age group")
# fill it
results_sheet <- results_sheet %>% gs_edit_cells(ws = "age group", input = c("Unique Volunteers that made an application, by Age Group"), anchor = "A1")
results_sheet <- results_sheet %>% gs_edit_cells(ws = "age group", input = vols_applied_by_age_group, anchor = "A2")

results_sheet <- results_sheet %>% gs_edit_cells(ws = "age group", input = c("Unique Volunteers Placed by Age Group"), anchor = "E1")
results_sheet <- results_sheet %>% gs_edit_cells(ws = "age group", input = vols_placed_by_age_group, anchor = "E2")

# adding sheet for apps / placements by gender
source("AP2_gender.r")
source("PL2_gender.r")

if("gender" %in% gs_ws_ls(results_sheet)){
    results_sheet <- results_sheet %>% gs_ws_delete("gender")
}

results_sheet <- results_sheet %>% gs_ws_new("gender")

results_sheet <- results_sheet %>%
    gs_edit_cells(ws = "gender",
                  input = c("Unique Volunteers that made an application, by Gender"),
                  anchor = "A1")

results_sheet <- results_sheet %>%
    gs_edit_cells(ws = "gender", input = vols_applied_by_gender,
                  anchor = "A2")

results_sheet <- results_sheet %>%
    gs_edit_cells(ws = "gender", input = c("Unique Volunteers Placed by Gender"),
                  anchor = "E1")

results_sheet <- results_sheet %>%
    gs_edit_cells(ws = "gender", input = vols_placed_by_gender,
                  anchor = "E2")

# repeat for other tables according to the same pattern, i.e.
# source("foo.r")
# if("foo ws" %in% gs_ws_ls(results_sheet)){
	# results_sheet <- results_sheet %>% gs_ws_delete("foo ws")
# }
# results_sheet <- results_sheet %>% gs_ws_new("foo ws")
# results_sheet <- results_sheet %>% gs_edit_cells(ws = "foo ws", input = c("foo title"), anchor = "A1")
# results_sheet <- results_sheet %>% gs_edit_cells(ws = "foo ws", input = foo_table, anchor = "A2")
