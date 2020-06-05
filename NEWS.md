# Updates 06/05/2020
* Added Ben's fancy 3-digit species richness code. 
* Updated report value formatting. 
* Added the ability to run reports for all of the stands in the input stand summary table. 
* Added an `index.html` to the output reports folder to quickly navigate outputs. 
* Enabled GitHub Pages to display example reports. [https://mpdougherty.github.io/FMG-StandWalk/](https://mpdougherty.github.io/FMG-StandWalk/)
* Added a data folder to hold the FMG reference tables: `SppMastType.csv` (species common name, USDA code, mast type, typical species), `FCOM.csv` (USDA code, forest community type)
* Added the `TYPICAL` field to the `SppMastType.csv` table to record the whether a species is common or uncommon (aka. typical). This was needed to implement Ben's fancy 3-digit species richness code.  

# Updates 06/02/2020
* Added an ArcGIS toolbox to allow the reports to be called from ArcGIS. 
* Created a Stand Walk Summary tool that calls the Stand Walk Summary report. 
* Added Beaver Island summary geodatabase to the test folder. This data has been used for development and testing. These summaries were created on 5/11/2020. 
* Report currently displays only the summary values calculated by the current FMG summary scripts. Missing values will need to reference new fields that are added to the FMG summary scripts. 
* Is report supposed to be able to run for multiple hierarchical levels or just the stand level?


# Updates 05/31/2020

* Developed a draft "Stand Walk Summary" report based on the version provided by OD-MN. 
* This report has been developed as an rmarkdown document to take advantage of Pandoc's new [`fenced_div`](https://bookdown.org/yihui/rmarkdown-cookbook/custom-blocks.html) capability. This allows the report data to be semantically arranged in the source document while the output display is styled using `.css` for `.html` output and `.tex` for `.pdf` output. 
* For `.html` output, this report uses the `.css` `grid` framework to define the layout the report. 
* For `.pdf` output, this report does not currently contain any `.tex` code to style the report. To support `.pdf` output, this would require an entirely separate codebase in `.tex` format to mimic the current `.css`-based report layout. Therefore during development, it is recommended to only support the `.html` output version, at least until development of the report has matured. Once the report format has matured, a `.pdf` version can be developed to prevent unnecessary duplication of effort during development. 