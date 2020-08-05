# FMG-StandWalk v0.1.5 (8/5/2020)

## Major Changes
* Upgraded the install process to insure required R packages are installed. 

## Compatibility Matrix
Please follow the compatibility matrix below to determine the required combination of software components necessary to run the toolbox. 

Software        |Suported  |Not Supported
---             |---       |---          
ArcGIS Pro      |2.5       |2.5          
ArcMap          |10.7      |10.8         
R               |3.6       |![](https://img.shields.io/badge/-4.0-red)          
R-bridge        |1.0.1.239 |![](https://img.shields.io/badge/-1.0.1.241-red)  
FluvialGeomorph |0.1.35    |0.1.35             

*Note: The ArcGIS R-bridge does not yet support R 4.0 for use in ArcGIS Pro or ArcMap geoprocessing tools. *


# Updates 7/9/2020
* Added the stocking calculations (stand and hard mast) to the report.
* Adjusted grid sizing to ensure everything fits on one page using the browser's (Chrome, Firefox) print to pdf capability. 
* Added the "Sapling" class to the "Size Class" section. 
* Added the "BA" column to the "Size Class" section. 
* Added ">1" notation to requested fields. 


# Updates 6/10/2020
* Added the FMG point feature classes `AGE`, `FIXED`, and `PRISM` as parameters to  calculate metrics not currently summarized by the FMG summary tables. 
* Added the "Top 3 Understory Species". 
* Added the "Top 3 Gound Species". 
* Calculated the number of age plots.
* Listed the inventory years.
* Calculated mean hard mast years. 
* Calculated mean growth. 
* Still waiting on the stocking equation from Ben and Lauren. 


# Updates 6/9/2020
* Added parameter to specify the polygon of the FMG hierarchy level (either "Stand" or "Site") used to calculate the "stand" summaries. The polygons are required to calculate the area that the "stand"" represents. 
* Automatically detects if a FMG "Site" or "Stand" has been specified. 
* Automatically compensates for the different formats of the the FMG unique identifier used over the life of the project. Handles both differences in field naming and structure of the FMG hierarchy coding of the unique identifier string. 
* Uses the `sf` R package to calculate area and convert to acres.


# Updates 6/5/2020
* Added Ben's fancy 3-digit species richness code. 
* Updated report value formatting. 
* Added the ability to run reports for all of the stands in the input stand summary table. 
* Added an `index.html` to the output reports folder to quickly navigate outputs. 
* Enabled GitHub Pages to display example reports. [https://mpdougherty.github.io/FMG-StandWalk/](https://mpdougherty.github.io/FMG-StandWalk/)
* Added a data folder to hold the FMG reference tables: `SppMastType.csv` (species common name, USDA code, mast type, typical species), `FCOM.csv` (USDA code, forest community type)
* Added the `TYPICAL` field to the `SppMastType.csv` table to record the whether a species is common or uncommon (aka. typical). This was needed to implement Ben's fancy 3-digit species richness code.  
* Added more test sites. 


# Updates 6/2/2020
* Added an ArcGIS toolbox to allow the reports to be called from ArcGIS. 
* Created a Stand Walk Summary tool that calls the Stand Walk Summary report. 
* Added Beaver Island summary geodatabase to the test folder. This data has been used for development and testing. These summaries were created on 5/11/2020. 
* Report currently displays only the summary values calculated by the current FMG summary scripts. Missing values will need to reference new fields that are added to the FMG summary scripts. 
* Is report supposed to be able to run for multiple hierarchical levels or just the stand level?


# Updates 5/31/2020
* Developed a draft "Stand Walk Summary" report based on the version provided by OD-MN.
* This report has been developed as an rmarkdown document to take advantage of Pandoc's new [`fenced_div`](https://bookdown.org/yihui/rmarkdown-cookbook/custom-blocks.html) capability. This allows the report data to be semantically arranged in the source document while the output display is styled using `.css` for `.html` output and `.tex` for `.pdf` output. 
* For `.html` output, this report uses the `.css` `grid` framework to define the layout the report. The CSS Grid Layout module is a technique in Cascading Style Sheets that allows web developers to create complex responsive web design layouts more easily and consistently across browsers.
* For `.pdf` output, this report does not currently contain any `.tex` code to style the report. To support `.pdf` output, this would require an entirely separate codebase in `.tex` format to mimic the current `.css`-based report layout. Therefore during development, it is recommended to only support the `.html` output version, at least until development of the report has matured. Once the report format has matured, a `.pdf` version could be developed if it is deemed necessary. This would prevent unnecessary duplication of effort during development. 

