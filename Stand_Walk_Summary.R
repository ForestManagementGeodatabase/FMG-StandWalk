#' @title Create a Stand Walk Summary Report
#' 
#' @description  Creates a Stand Walk Summary Report for the input list of 
#' forest stands. 
#' 
#' @export
#' @param stand_list         list; A list of FMG forest stand IDs. 
#'
tool_exec <- function(in_params, out_params) {
  # Load utility R functions
  dir_name <- getSrcDirectory(function(x) {x})
  fmg <- dirname(dir_name)
  fmg_install <- file.path(fmg, "install")
  source(file.path(fmg_install, "FMG_utils.R"))
  # Load required libraries
  load_packages(c("sp", "dplyr", "purrr", "tibble"))
  # Load FluvialGeomorph R packages
  load_fluvgeo_packages()
  
  # gp tool parameters
  xs_fc              <- in_params[[1]]
  xs_points_fc       <- in_params[[2]]
  bankfull_elevation <- in_params[[3]]
  lead_n             <- in_params[[4]]
  use_smoothing      <- in_params[[5]]
  loess_span         <- in_params[[6]]
  vert_units         <- in_params[[7]]
  discharge_method   <- unlist(in_params[[8]])
  discharge_value    <- in_params[[9]]
  region             <- in_params[[10]]
  drainage_area      <- in_params[[11]]
  width_method       <- in_params[[12]]
  
  # Code for testing in RStudio
  # library(sp)
  # library(dplyr)
  # library(fluvgeo)
  # library(arcgisbinding)
  # arc.check_product()
  # xs_fc              <- "D:\\Workspace\\EMRRP_Sediment\\Methods\\FluvialGeomorph\\tests\\data\\test.gdb\\xs_200"
  # xs_points_fc       <- "D:\\Workspace\\EMRRP_Sediment\\Methods\\FluvialGeomorph\\tests\\data\\test.gdb\\xs_200_points"
  # bankfull_elevation <- 104.5
  # lead_n             <- 1
  # use_smoothing      <- TRUE
  # loess_span         <- 1
  # vert_units         <- "ft"
  # discharge_method   <- "regional_curve"
  # discharge_value    <- NULL
  # region             <- "Lower Southern Driftless"
  # drainage_area      <- 41
  # width_method       <- NULL
  # in_params <- list(xs_fc, xs_points_fc, bankfull_elevation, lead_n,
  #                   use_smoothing, loess_span, vert_units,
  #                   discharge_method, discharge_value, region, 
  #                   drainage_area, width_method)
  
  # Verify parameters
  ## Create list of parameters (named using the parameter names)
  param_list <- tibble::lst(xs_fc, xs_points_fc, bankfull_elevation, lead_n,
                            use_smoothing, loess_span, vert_units,
                            discharge_method, discharge_value, region, 
                            drainage_area, width_method)
  

  
  return(out_params)
}