#' @title Create a Stand Walk Summary Report
#' 
#' @description  Creates a Stand Walk Summary Report for the input list of 
#' forest stands. 
#' 
#' @export
#' @param stand_vector      vector; A vector of FMG forest stand IDs. 
#' @param output_dir        character; The output directory.
#'
tool_exec <- function(in_params, out_params) {
  # Load utility R functions
  dir_name <- getSrcDirectory(function(x) {x})
  fmg <- dirname(dir_name)
  fmg_install <- file.path(fmg, "install")
  source(file.path(fmg_install, "FMG_utils.R"))
  # Load required libraries
  load_packages(c("dplyr", "purrr", "tibble"))
  # Load FluvialGeomorph R packages
  load_fluvgeo_packages()
  
  # gp tool parameters
  stand_vector              <- in_params[[1]]

  
  # Code for testing in RStudio
  # library(sp)
  # library(dplyr)
  # library(fluvgeo)
  # library(arcgisbinding)
  # arc.check_product()
  # stand_vector              <- "D:\\Workspace\\EMRRP_Sediment\\Methods\\FluvialGeomorph\\tests\\data\\test.gdb\\xs_200"
  # in_params <- list(stand_list)
  
  # Verify parameters
  ## Create list of parameters (named using the parameter names)
  param_list <- tibble::lst(stand_vector, dir_name)
  
  # Iterate through stands
  for (s in stand_vector) {
    
  output_file = file.path(output_dir, )
  
  # Render the report
  rmarkdown::render(input = file.path(dir_name, "Stand_Walk_Summary.Rmd"),
                    output_format = "html_document",
                    output_options = list(self_contained = TRUE),
                    params = list(stand_id),
                    output_file = output_file,
                    quite = FALSE)
  }
  
  return(out_params)
}