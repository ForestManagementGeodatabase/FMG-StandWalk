#' @title Create a Stand Walk Summary Report
#' 
#' @description  Creates a Stand Walk Summary Report for the forest stands in 
#' the `stand_summary_tbl`. 
#' 
#' @export
#' @param project                character; The name of the project. 
#' @param level                  character; The level of the FMG hierarchy. One
#'                               of: stand, site, or unit.  
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
  project                    <- in_params[[1]]
  level                      <- in_params[[2]]
  stand_polys                <- in_params[[3]]
  age_pts                    <- in_params[[4]]
  fixed_pts                  <- in_params[[5]]
  prism_pts                  <- in_params[[6]]
  stand_summary_tbl          <- in_params[[7]]  
  age_fixed_summary_tbl      <- in_params[[8]]
  species_summary_tbl        <- in_params[[9]]
  health_summary_tbl         <- in_params[[10]]
  health_species_summary_tbl <- in_params[[10]]
  
  # Code for testing in RStudio
  # library(dplyr)
  # library(tibble)
  # library(stringr)
  # library(lubridate)
  # library(tidyr)
  # library(sf)
  # library(kableExtra)
  # library(pander)
  # dir_name                   <- "C:/workspace/FMG/FMG-StandWalk"
  # Site based summaries
  # project                    <- "Pool 13 Forestry"
  # level                      <- "site"
  # stand_polys                <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\FMG_Site"
  # age_pts                    <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\Age_Plots"
  # fixed_pts                  <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\Fixed_Plots"
  # prism_pts                  <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\Prism_Plots"
  # stand_summary_tbl          <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\Site_Stand_Summary"
  # age_fixed_summary_tbl      <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\Site_AgeFixed_Summary"
  # species_summary_tbl        <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\Site_Species_Summary"
  # health_summary_tbl         <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\Site_Health_Summary"
  # health_summary_species_tbl <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_13_Lower\\HSI.gdb\\Site_Health_Summary_BySpecies"
  #
  # project                    <- "Pool 12 Forestry"
  # level                      <- "site"
  # stand_polys                <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\Pool12_TimberInventory_ForReconReport.gdb\\Pool12_ForestInventory_Sites"
  # age_pts                    <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\Pool12_TimberInventory_ForReconReport.gdb\\Final_Pool12_Age"
  # fixed_pts                  <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\Pool12_TimberInventory_ForReconReport.gdb\\Final_Pool12_Fixed"
  # prism_pts                  <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\Pool12_TimberInventory_ForReconReport.gdb\\Final_Pool12_Prism"
  # stand_summary_tbl          <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\PPool12_TimberInventory_ForReconReport.gdb\\Site_Stand_Summary"
  # age_fixed_summary_tbl      <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\Pool12_TimberInventory_ForReconReport.gdb\\Site_AgeFixed_Summary"
  # species_summary_tbl        <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\Pool12_TimberInventory_ForReconReport.gdb\\Site_Species_Summary"
  # health_summary_tbl         <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\Pool12_TimberInventory_ForReconReport.gdb\\Site_Health_Summary"
  # health_summary_species_tbl <- "C:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_12_Forestry\\Pool12_TimberInventory_ForReconReport.gdb\\Site_Health_Summary_BySpecies"
  # 
  # project                    <- "Pool 21"
  # level                      <- "site"
  # stand_polys                <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Pool21_Site")
  # age_pts                    <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Pool21_Age")
  # fixed_pts                  <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Pool21_Fixed")
  # prism_pts                  <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Pool21_Prism")
  # stand_summary_tbl          <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Site_Stand_Summary")
  # age_fixed_summary_tbl      <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Site_AgeFixed_Summary")
  # species_summary_tbl        <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Site_Species_Summary")
  # health_summary_tbl         <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Site_Health_Summary")
  # health_summary_species_tbl <- file.path(dir_name, "test/Pool_21/Pool21_ReconSheets.gdb/Site_Health_Summary_BySpecies")
  #
  # project                    <- "Pool 14"
  # level                      <- "site"
  # stand_polys                <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Sites")
  # age_pts                    <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Age_Plots")
  # fixed_pts                  <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Fixed_Plots")
  # prism_pts                  <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Prism_Plots")
  # stand_summary_tbl          <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Site_Stand_Summary")
  # age_fixed_summary_tbl      <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Site_AgeFixed_Summary")
  # species_summary_tbl        <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Site_Species_Summary")
  # health_summary_tbl         <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Site_Health_Summary")
  # health_summary_species_tbl <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Site_Health_Summary_BySpecies")
  #
  # project                    <- "Pool 14"
  # level                      <- "stand"
  # stand_polys                <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Stands")
  # age_pts                    <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Age_Plots")
  # fixed_pts                  <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Fixed_Plots")
  # prism_pts                  <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Prism_Plots")
  # stand_summary_tbl          <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Stand_Stand_Summary")
  # age_fixed_summary_tbl      <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Stand_AgeFixed_Summary")
  # species_summary_tbl        <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Stand_Species_Summary")
  # health_summary_tbl         <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Stand_Health_Summary")
  # health_summary_species_tbl <- file.path(dir_name, "test/Pool_14_WapsiBottoms/P14_Wapsi_20220330.gdb/Stand_Health_Summary_BySpecies")
  # 
  # # Stand based summaries
  # project                   <- "Pecan Grove"
  # level                     <- "stand"
  # stand_polys               <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\Pool21_AGOL.gdb\\Pool21_Stands"
  # age_pts                   <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\Pool21_AGOL.gdb\\Pool21_Age_20210412"
  # fixed_pts                 <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\Pool21_AGOL.gdb\\Pool21_Fixed_20210412"
  # prism_pts                 <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\Pool21_AGOL.gdb\\Pool21_Prism_20210412"
  # stand_summary_tbl         <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\Pool21_AGOL.gdb\\Stand_Summary_Stand"
  # age_fixed_summary_tbl     <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\Pool21_AGOL.gdb\\AgeFixed_Summary_Stand"
  # species_summary_tbl       <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\Pool21_AGOL.gdb\\Species_Summary_Stand"
  # health_summary_tbl        <- "D:\\Workspace\\FMG\\Stand_Walk_Sheets\\FMG_StandWalk\\test\\Pool_21_PecanGrove\\Pool21_AGOL.gdb\\Health_Summary_Stand"
  
  # Build a list of parameters
  in_params <- list(project, level, stand_polys, 
                    age_pts, fixed_pts, prism_pts,
                    stand_summary_tbl, age_fixed_summary_tbl,
                    species_summary_tbl, health_summary_tbl, 
                    health_summary_species_tbl)
  
  # Verify parameters
  ## Create list of parameters (named using the parameter names)
  param_list <- tibble::lst(project, level, stand_polys, 
                            age_pts, fixed_pts, prism_pts, 
                            stand_summary_tbl, age_fixed_summary_tbl, 
                            species_summary_tbl, health_summary_tbl, 
                            health_summary_species_tbl)
  
  ## Get parameter verification table
  message("Compare input tool parameters...")
  print(compare_params(in_params, param_list))
  
  # Convert the geodatabase feature class and tables to data frames
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
  health_summary_species <- sf::st_read(dsn = gdb,
                                  layer = basename(health_summary_species_tbl))
  
  # Fix FMG unique id fields
  stand_polys_sf    <- fix_fmg_id(stand_polys_sf)
  age_pts_sf        <- fix_fmg_id(age_pts_sf)
  fixed_pts_sf      <- fix_fmg_id(fixed_pts_sf)
  prism_pts_sf      <- fix_fmg_id(prism_pts_sf)
  age_fixed_summary <- fix_fmg_id(age_fixed_summary)
  stand_summary     <- fix_fmg_id(stand_summary)
  species_summary   <- fix_fmg_id(species_summary)
  health_summary    <- fix_fmg_id(health_summary)
  health_summary_species    <- fix_fmg_id(health_summary_species)
  
  # Add `Site_ID` to summary tables
  stand_polys_sf         <- add_id(stand_polys_sf, level)
  age_pts_sf             <- add_id(age_pts_sf, level)
  fixed_pts_sf           <- add_id(fixed_pts_sf, level)
  prism_pts_sf           <- add_id(prism_pts_sf, level)
  age_fixed_summary      <- add_id(age_fixed_summary, level)
  stand_summary          <- add_id(stand_summary, level)
  species_summary        <- add_id(species_summary, level)
  health_summary         <- add_id(health_summary, level)
  health_summary_species <- add_id(health_summary_species, level)
  
  # Create a `reports` folder in the parent folder that holds the geodatabase
  parent_dir <- dirname(dirname(age_fixed_summary_tbl))
  report_dir <- file.path(parent_dir, "reports")
  if(!dir.exists(report_dir)) {
    dir.create(report_dir)
  }
  output_file <- file.path(report_dir, "index.html")
  report_template <- file.path(dir_name, "report", 
                               "Stand_Walk_Summary_list.Rmd")
  
  # Set report parameters
  report_params <- list("level" = level,
                        "stand_polys" = stand_polys_sf, 
                        "age_pts" = age_pts_sf,
                        "fixed_pts" = fixed_pts_sf,
                        "prism_pts" = prism_pts_sf,
                        "age_fixed_summary" = age_fixed_summary,
                        "stand_summary" = stand_summary,
                        "species_summary" = species_summary,
                        "health_summary" = health_summary,
                        "health_summary_species" = health_summary_species)
  
  rmarkdown::render(input = report_template,
                    output_format = "html_document",
                    output_options = list(self_contained = TRUE),
                    params = report_params,
                    output_file = output_file)
  
  return(out_params)
}