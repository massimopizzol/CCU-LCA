# CCU-LCA

## Description

This is the code used in the analysis presented in:

_Thonemann N and Pizzol M, Consequential life cycle assessment of carbon capture and utilization technologies within the chemical industry,  Energy & Environmental Science (under review),_ [doi to be added]().

The supplementary materials to the article include the raw data: 

- inventory tables: `CU-UA_MCS_nt.csv` and `CCU-UA_MCS_lt.csv`
- results of the Monte Carlo simulation `CU-UA_MCS_nt.csv`, `CU-UA_MCS_lt.csv`


These are needed to run the scripts contained in this repository, for example if you want to reproduce the results of the paper. If you don't have access to the article or the files, you can get them from me directly, please send a request to [massimo@plan.aau.dk](mailto:massimo@plan.aau.dk)


## The repository includes:

`CCU_2018_final_version.ipynb` (and `CCU_2018_final_version.py`) Python script to reproduce results of the LCA using the brightway2 LCA software. Imports the inventory in, performs LCA calculations and exports LCIA results, runs comparative Monte Carlo for the global warming impact category and exports results.

`CCU_plots.R` R script used in generating the plots of the paper. 

`CCU_Stat_analysis.R` R script with the statistical analysis of Monte Carlo results, mainly generating descriptive statistics and doing pairwise testing of different alternatives.

`lci_to_bw2.py` A little python script to import inventory tables in .csv directly into brightway2.

**Please get in touch** if you find any mistake or problem in running these scripts.

## DOI and versions

Version identifier:
DOI [to be added]()

You can cite all versions by using the DOI [to be added](). This DOI represents all versions, and will always resolve to the latest one. 

## Cite as

Pleas cite the specific version, for example for version 1.0:

_Massimo Pizzol. (2019, Month Day). massimopizzol/CCU-LCA: First release (Version 1.0). Zenodo. http://doi.org/xxxx_
