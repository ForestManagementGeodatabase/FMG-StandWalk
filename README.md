# FMG-StandWalk 
Creates a Forest Management Geodatabase (FMG) Stand Walk Report. <img src="docs/images/HDQLO-03_h120.jpg" align="right" />

## Description
The purpose of this report is to automate the production of the reports needed by foresters to conduct the "Stand Walk Recon" task. The purpose of a Stand Walk Recon is to assess the current condition of a given forest stand using the forest survey data recorded in the FMG, and from this information, to develop a "Stand Prescription" that will define its management in the coming years. 

The "Stand Walk Recon" task is composed of two elements:
* **Stand Summary** - A sheet summarizing the FMG field survey data for a given stand. Foresters need to consult the summary statistics on this sheet to help record decisions on the next sheet. 
* **Stand Prescription** - A sheet used by a forester to record their assessment of what management actions should be taken for a given stand. 

## Funding
Funding for the development and maintenance of the Forest Management Geodatabase (FMG) has been provided by USACE Rock Island District, Operations Division, Mississippi River Project, Natural Resources. 

## Latest Updates
Check out the [NEWS](NEWS.md) for details on the latest updates. 

## Authors
* [Michael Dougherty](mailto:Michael.P.Dougherty@usace.army.mil), Geographer, Rock Island District, U.S. Army Corps of Engineers
* [Christopher Hawes](mailto:Christopher.C.Hawes@usace.army.mil), Geographer, Rock Island District, U.S. Army Corps of Engineers

## Preview Reports
Use this link to preview the stand reports for the Mississippi River Pool 21 Pecan Grove test data:
[https://mpdougherty.github.io/FMG-StandWalk/](https://mpdougherty.github.io/FMG-StandWalk/)

## Install
Use the following instructions to start running the reports. This toolbox requires the user to install `R`, `RStudio`, `ArcGIS Pro`, and optionally, `ArcMap`.

### Install `R`
* Ensure that `R` is installed. 
* `R` version 3.6.3 or greater is recommended. 

### Install `RStudio`
* Ensure that `Rstudio` is installed.
* `RStudio` version 1.2.5033 or greater is recommended. 

### Install `ArcGIS Pro`
* Ensure that `ArcGIS Pro` is installed. 
* `ArcGIS Pro` version 2.5 or greater is recommended. 

### Install `arcgisbinding`
* In `ArcGIS Pro`, on the top menu, click "Project", click "Options" on the left menu.
* In the "Options" dialog box, click "Geoprocessing" on the left menu. 
* On the "Geoprocessing" page, scroll down to the "R-ArcGIS Support" section.
* In the "R-ArcGIS Support" section, verify the installed `R` version for ArcGIS to use.
* Below the "Detected R home directories" drop-down menu, you will see the `arcgisbinding` package section. From the drop-down, choose the "Check package for updates" option. If needed, install the latest version. 
* This package allows `ArcGIS Pro` and `ArcMap` to talk to R. Installing it through `ArcGIS Pro` enables it for use in `ArcMap` as well. 

### Download the toolbox
* Use the green "Clone or download" button above to download a ZIP archive of the toolbox. 
* Unzip the archive to your project folder. 
* In `ArcMap` or `ArcGIS Pro`, navigate to the folder where you just unzipped the archive and you are ready to use the toolbox. 

## Test Data
The functionality of this toolbox can be tested using the data provided in the `FMG_StandWalk/test` folder. In the test folder you will find a series of sites where the FMG forestry surveys have been conducted. These geodatabases contain the QA'd necessary to produce a Stand Walk Summary report. 