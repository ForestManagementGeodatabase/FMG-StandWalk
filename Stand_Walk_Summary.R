#' @title Create a Stand Walk Summary Report
#' 
#' @description  Creates a Stand Walk Summary Report for the input list of 
#' forest stands. 
#' 
#' @export
#' @param stand_vector           vector; A vector of FMG forest stand IDs. 
#' @param age_fixed_summary_tbl  .gdb table; A FMG age & fixed plot summary 
#'                               table.
#' @param stand_summary_tbl      .gdb table; A FMG stand summary table. 
#' @param species_summary_tbl    .gdb table; A FMG species summary table.
#' @param health_summary_tbl     .gdb table; A FMG Health summary table.
#' @param imp_stand_summary_tbl  .gdb table; A FMG stand importance summary 
#'                               table.
#' @param imp_plot_summary_tbl   .gdb table; A FMG plot importance summary 
#'                               table.
#'
tool_exec <- function(in_params, out_params) {
  # Load utility R functions
  dir_name <- getSrcDirectory(function(x) {x})
  fmg_install <- file.path(dir_name, "install")
  source(file.path(fmg_install, "FMG_utils.R"))
  
  # Load required libraries
  load_packages(c("dplyr", "purrr", "tibble"))
  
  # gp tool parameters
  stand_vector              <- in_params[[1]]
  age_fixed_summary_tbl     <- in_params[[2]]
  stand_summary_tbl         <- in_params[[3]]
  species_summary_tbl       <- in_params[[4]]
  health_summary_tbl        <- in_params[[5]]
  
  # Code for testing in RStudio
  library(sf)
  dir_name                  <- "D:/Workspace/FMG/Stand_Walk_Sheets/FMG_StandWalk"
  stand_id                  <- c("p14c007u001st02")
  age_fixed_summary_tbl     <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Age_Fixed_Sum"
  stand_summary_tbl         <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Stand_Sum"
  species_summary_tbl       <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Species_Sum"
  health_summary_tbl        <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Health_Sum"
  imp_stand_summary_tbl     <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Importance_Stand_Sum"
  imp_plot_summary_tbl      <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Beaver_Island_Sum.gdb\\Importance_Sum"
  in_params <- list(stand_id, age_fixed_summary_tbl, 
                    stand_summary_tbl, species_summary_tbl, 
                    health_summary_tbl, 
                    imp_stand_summary_tbl, imp_plot_summary_tbl)

  # Verify parameters
  ## Create list of parameters (named using the parameter names)
  param_list <- tibble::lst(stand_id, age_fixed_summary_tbl, 
                            stand_summary_tbl, species_summary_tbl, 
                            health_summary_tbl, 
                            imp_stand_summary_tbl, imp_plot_summary_tbl)
  
  ## Get parameter verification table
  message("Compare input tool parameters")
  print(compare_params(in_params, param_list))
  
  # Create a `reports` folder in the parent folder that holds the geodatabase

  parent_dir <- dirname(dirname(age_fixed_summary_tbl))
  report_dir <- file.path(parent_dir, "reports")
  if(!dir.exists(report_dir)) {
    dir.create(report_dir)
    message("Report folder created.")
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
  imp_stand_summary <- sf::read_sf(dsn = gdb,
                                   layer = basename(imp_stand_summary_tbl))
  imp_plot_summary  <- sf::read_sf(dsn = gdb,
                                   layer = basename(imp_plot_summary_tbl))
  
  # Iterate through stands
  for (s in stand_id) {
    # Create the report name
    report_name <- paste0("Stand_Summary_", s)
    output_file <- file.path(report_dir, report_name)
    report <- file.path(dir_name, "report", "Stand_Walk_Summary_report.Rmd")
    report_params <- list("stand_id" =  s,
                          "age_fixed_summary" = age_fixed_summary,
                          "stand_summary" = stand_summary,
                          "species_summary" = species_summary,
                          "health_summary" = health_summary,
                          "imp_stand_summary" = imp_stand_summary,
                          "imp_plot_summary" = imp_plot_summary)
    
    # Render the report
    rmarkdown::render(input = report,
                      output_format = "html_document",
                      output_options = list(self_contained = TRUE),
                      params = report_params,
                      output_file = output_file)
  }
  
  return(out_params)
}