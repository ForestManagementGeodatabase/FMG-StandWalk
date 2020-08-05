#' @title Create a Stand Walk Summary Report
#' 
#' @description  Creates a Stand Walk Summary Report for the forest stands in 
#' the `stand_summary_tbl`. 
#' 
#' @export
#' @param stand_polys            feature class; A FMG polygon feature class 
#'                               representing the "stands" in the summary 
#'                               tables (either FMG "Sites" or "Stands"). 
#' @param age_pts                feature class; A FMG point feature class 
#'                               representing age plots.        
#' @param fixed_pts              feature class; A FMG point feature class 
#'                               representing fixed plots.  
#' @param prism_pts              feature class; A FMG point feature class 
#'                               representing prism plots.  
#' @param stand_summary_tbl      .gdb table; A FMG stand summary table. 
#' @param age_fixed_summary_tbl  .gdb table; A FMG age & fixed plot summary 
#'                               table.
#' @param species_summary_tbl    .gdb table; A FMG species summary table.
#' @param health_summary_tbl     .gdb table; A FMG Health summary table.
#'                               
#' @details  This tool creates a folder named `reports` in the folder where the 
#' `stand_summary_tbl` is located. A Stand Walk Summary Report is written into 
#' the `reports` folder for each forest stand in the `stand_summary_tbl`. 
#'
#'
tool_exec <- function(in_params, out_params) {
  # Load utility R functions
  dir_name <- getSrcDirectory(function(x) {x})
  fmg_install <- file.path(dir_name, "install")
  source(file.path(fmg_install, "FMG_utils.R"))
  
  # Install needed packages
  message("Installing needed pacakges...")
  needed_pkgs <- c("dplyr", "tibble", "stringr", "lubridate", "tidyr", "sf", 
                   "units")
  install_needed_packages(needed_pkgs)
  
  # Load required libraries
  message("Loading needed packages...")
  load_packages(needed_pkgs)
  
  # Ensure pandoc can be found
  message("Setting pandoc directory...")
  set_pandoc()
  
  # gp tool parameters
  stand_polys               <- in_params[[1]]
  age_pts                   <- in_params[[2]]
  fixed_pts                 <- in_params[[3]]
  prism_pts                 <- in_params[[4]]
  stand_summary_tbl         <- in_params[[5]]  
  age_fixed_summary_tbl     <- in_params[[6]]
  species_summary_tbl       <- in_params[[7]]
  health_summary_tbl        <- in_params[[8]]

  # Code for testing in RStudio
  # library(dplyr)
  # library(tibble)
  # library(sf)
  # dir_name                  <- "D:/Workspace/FMG/Stand_Walk_Sheets/FMG_StandWalk"
  # stand_polys               <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\20200401_PecanGrove_Summaries.gdb\\Pool_21_Sites"
  # age_pts                   <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\20200401_PecanGrove_Summaries.gdb\\Age"
  # fixed_pts                 <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\20200401_PecanGrove_Summaries.gdb\\Fixed"
  # prism_pts                 <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\20200401_PecanGrove_Summaries.gdb\\Prism"
  # stand_summary_tbl         <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\20200401_PecanGrove_Summaries.gdb\\Stand_Summary"
  # age_fixed_summary_tbl     <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\20200401_PecanGrove_Summaries.gdb\\Age_Fixed_Summary"
  # species_summary_tbl       <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\20200401_PecanGrove_Summaries.gdb\\Species_Summary"
  # health_summary_tbl        <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\20200401_PecanGrove_Summaries.gdb\\Health_Summary"
  # in_params <- list(stand_polys, age_pts, fixed_pts, prism_pts,
  #                   stand_summary_tbl, age_fixed_summary_tbl,
  #                   species_summary_tbl, health_summary_tbl)

  # Verify parameters
  ## Create list of parameters (named using the parameter names)
  param_list <- tibble::lst(stand_polys, age_pts, fixed_pts, prism_pts, 
                            stand_summary_tbl, age_fixed_summary_tbl, 
                            species_summary_tbl, health_summary_tbl)
  
  ## Get parameter verification table
  message("Compare input tool parameters...")
  print(compare_params(in_params, param_list))
  
  # Create a `reports` folder in the parent folder that holds the geodatabase
  parent_dir <- dirname(dirname(age_fixed_summary_tbl))
  report_dir <- file.path(parent_dir, "reports")
  if(!dir.exists(report_dir)) {
    dir.create(report_dir)
  }
  
  # Convert the geodatabase freature class and tables to data frames
  gdb <- dirname(age_fixed_summary_tbl)
  message("Reading data sources...")
  stand_polys_sf    <- sf::st_read(dsn = gdb,
                                   layer = basename(stand_polys))
  age_pts_sf        <- sf::st_read(dsn = gdb,
                                   layer = basename(age_pts))
  fixed_pts_sf      <- sf::st_read(dsn = gdb,
                                   layer = basename(fixed_pts))
  prism_pts_sf      <- sf::st_read(dsn = gdb,
                                   layer = basename(prism_pts))
  age_fixed_summary <- sf::st_read(dsn = gdb,
                                   layer = basename(age_fixed_summary_tbl))
  stand_summary     <- sf::st_read(dsn = gdb,
                               layer = basename(stand_summary_tbl))
  species_summary   <- sf::st_read(dsn = gdb,
                               layer = basename(species_summary_tbl))
  health_summary    <- sf::st_read(dsn = gdb,
                                   layer = basename(health_summary_tbl))
  
  # Fix FMG unique id fields
  stand_polys_sf    <- fix_fmg_id(stand_polys_sf)
  age_pts_sf        <- fix_fmg_id(age_pts_sf)
  fixed_pts_sf      <- fix_fmg_id(fixed_pts_sf)
  prism_pts_sf      <- fix_fmg_id(prism_pts_sf)
  age_fixed_summary <- fix_fmg_id(age_fixed_summary)
  stand_summary     <- fix_fmg_id(stand_summary)
  species_summary   <- fix_fmg_id(species_summary)
  health_summary    <- fix_fmg_id(health_summary)
  
  message("stand_polys_sf: ", colnames(stand_polys_sf))
  message("age_pts_sf: ", colnames(age_pts_sf))
  message("fixed_pts_sf: ", colnames(fixed_pts_sf))
  message("prism_pts_sf: ", colnames(prism_pts_sf))
  message("age_fixed_summary: ", colnames(age_fixed_summary))
  message("stand_summary: ", colnames(stand_summary))
  message("species_summary: ", colnames(species_summary))
  message("health_summary: ", colnames(health_summary))

  # Create a list to store reports for indexing
  report_files <- list()
  
  # Get a list of stand_ids from the stand_summary_tbl
  stand_vector <- stand_summary$Site_ID
  
  # Iterate through stands
  for (s in stand_vector) {
    # Set the report name
    report_name <- paste0("Stand_Summary_", s, ".html")
    output_file <- file.path(report_dir, report_name)
    
    # Add the report to the list for indexing
    report_files <- append(report_files, output_file)
    message("Creating report: ", report_name)
    
    # Remove the report file if it already exists
    if (file.exists(output_file)) {
      file.remove(output_file)
    }
    
    # Set report parameters
    report_params <- list("stand_id" =  s,
                          "stand_polys" = stand_polys_sf, 
                          "age_pts" = age_pts_sf,
                          "fixed_pts" = fixed_pts_sf,
                          "prism_pts" = prism_pts_sf,
                          "age_fixed_summary" = age_fixed_summary,
                          "stand_summary" = stand_summary,
                          "species_summary" = species_summary,
                          "health_summary" = health_summary)
    report_template <- file.path(dir_name, "report", 
                                 "Stand_Walk_Summary_report.Rmd")
    
    # Render the report
    rmarkdown::render(input = report_template,
                      output_format = "html_document",
                      output_options = list(self_contained = TRUE),
                      params = report_params,
                      output_file = output_file)
  }
  
  # Create an `index.html` file with links to reports
  output_file2 <- file.path(report_dir, "index.html")
  report_params2 <- list("report_files" = report_files)
  report_template2 <- file.path(dir_name, "report", 
                                "Stand_Walk_Summary_list.Rmd")
  
  rmarkdown::render(input = report_template2,
                    output_format = "html_document",
                    output_options = list(self_contained = TRUE),
                    params = report_params2,
                    output_file = output_file2)
  
  return(out_params)
}