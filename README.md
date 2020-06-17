# CCU-LCA

## Description

This is the code used in the analysis presented in:

_Thonemann N and Pizzol M, Consequential life cycle assessment of carbon capture and utilization technologies within the chemical industry,  Energy & Environmental Science (under review),_ [https://doi.org/10.1039/C9EE00914K](https://doi.org/10.1039/C9EE00914K).

The supplementary materials to the article include the raw data: 

- inventory tables: `CU-UA_MCS_nt.csv` and `CCU-UA_MCS_lt.csv`
- results of the Monte Carlo simulation `CU-UA_MCS_nt.csv`, `CU-UA_MCS_lt.csv`


These are needed to run the scripts contained in this repository, for example if you want to reproduce the results of the paper. If you don't have access to the article or the files, you can get them from me directly, please send a request to [massimo@plan.aau.dk](mailto:massimo@plan.aau.dk)


## The repository includes:

`CCU-UA_MCS_lt.csv` and `CCU-UA_MCS_nt.csv` inventory data formatted for input in brightway2.

`CCU_2018_final_version.ipynb` (and `CCU_2018_final_version.py`) Python script to reproduce results of the LCA using the brightway2 LCA software. Imports the inventory in, performs LCA calculations and exports LCIA results, runs comparative Monte Carlo for the global warming impact category and exports results.

`lci_to_bw2.py` A python script to import inventory tables in .csv directly into brightway2.

`CCU_plots.R` R script used in generating the plots of the paper. 

`CCU_Stat_analysis.R` R script with the statistical analysis of Monte Carlo results, mainly generating descriptive statistics and doing pairwise testing of different alternatives.


**Please get in touch** if you find any mistake or problem in running these scripts.

## DOI and versions

Version identifier:
[![DOI](https://zenodo.org/badge/183655891.svg)](https://zenodo.org/badge/latestdoi/183655891)

You can cite all versions by using the concept DOI [10.5281/zenodo.2652361](https://doi.org/10.5281/zenodo.2652361) that represents all versions, and will always resolve to the latest one. 

However, it is recommended that you cite the specific version, for example for version 1.0:

_Massimo Pizzol. (2019, April 26). massimopizzol/CCU-LCA: Pre-publication release (Version v1.0). Zenodo. http://doi.org/10.5281/zenodo.2652362_
