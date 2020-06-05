#' @title Create a Stand Walk Summary Report
#' 
#' @description  Creates a Stand Walk Summary Report for the forest stands in 
#' the `stand_summary_tbl`. 
#' 
#' @export
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
  
  # Set pandoc path
  set_pandoc()
  
  # Load required libraries
  load_packages(c("dplyr", "tibble"))
  
  # gp tool parameters
  stand_summary_tbl         <- in_params[[1]]  
  age_fixed_summary_tbl     <- in_params[[2]]
  species_summary_tbl       <- in_params[[3]]
  health_summary_tbl        <- in_params[[4]]

  # Code for testing in RStudio
  # library(sf)
  # dir_name                  <- "D:/Workspace/FMG/Stand_Walk_Sheets/FMG_StandWalk"
  # stand_summary_tbl         <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Stand_Sum"
  # age_fixed_summary_tbl     <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Age_Fixed_Sum"
  # species_summary_tbl       <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Species_Sum"
  # health_summary_tbl        <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Health_Sum"
  # in_params <- list(stand_summary_tbl, age_fixed_summary_tbl, 
  #                   species_summary_tbl, health_summary_tbl)

  # Verify parameters
  ## Create list of parameters (named using the parameter names)
  param_list <- tibble::lst(stand_summary_tbl, age_fixed_summary_tbl, 
                            species_summary_tbl, health_summary_tbl)
  
  ## Get parameter verification table
  message("Compare input tool parameters")
  print(compare_params(in_params, param_list))
  
  # Create a `reports` folder in the parent folder that holds the geodatabase
  parent_dir <- dirname(dirname(age_fixed_summary_tbl))
  report_dir <- file.path(parent_dir, "reports")
  if(!dir.exists(report_dir)) {
    dir.create(report_dir)
  }
  
  # Convert the geodatabase tables to data frames
  gdb <- dirname(age_fixed_summary_tbl)
  age_fixed_summary <- sf::read_sf(dsn = gdb,
                               layer = basename(age_fixed_summary_tbl))
  stand_summary     <- sf::read_sf(dsn = gdb,
                               layer = basename(stand_summary_tbl))
  species_summary   <- sf::read_sf(dsn = gdb,
                               layer = basename(species_summary_tbl))
  health_summary    <- sf::read_sf(dsn = gdb,
                                   layer = basename(health_summary_tbl))

  # Get a list of stand_ids from the stand_summary_tbl
  stand_vector <- stand_summary$SITE_NEW
  
  # Create a list to store reports
  report_files <- list()
  
  # Iterate through stands
  for (s in stand_vector) {
    # Set the report name
    report_name <- paste0("Stand_Summary_", s, ".html")
    output_file <- file.path(report_dir, report_name)
    report_files <- append(report_files, output_file)
    
    # Remove the report file if it already exists
    if (file.exists(output_file)) {
      file.remove(output_file)
    }
    
    # Set report parameters
    report_params <- list("stand_id" =  s,
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