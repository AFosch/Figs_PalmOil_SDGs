# Figs_PalmOil_SDGs
Repository for the study "Replanting unproductive palm oil with smallholder plantations can help achieve Sustainable Development Goals in Sumatra, Indonesia".

## Scripts
The scripts included allow for the reproduction of the plots in the main paper and supplementary materials. 

The code to train the spatial regression models is available under demand but the socio-economic data of the PODES must be purchased. See paper for more details.

- ``Plot_Fig1.R``: Creates the figure showing the significant socio-economic characteristics of the villages with four different types of production profile: Unproductive (damaged), Unproductive (possibly replanted), Industrial or smallholder plantations. The data used to generate these plots also contains a data frame with the quality metrics estimated for each of the regression models trained  (``stats``). 

- ``Plot_Fig3_Supp3_12.R``:  Creates the summary plots showing the predicted impact of replanting Unproductive (damaged) plantations with new palm oil (either industrial or smallholder profiles). The script evaluates the effects of the intervention when implemented in the region of Sumatra (Figure 3) and also in all the Sumatran provinces (Supplementary Figs. 3-15). 

- ``Plot_Fig4.R``: Map of the unproductive land in Sumatra. 

- ``Plot_Fig.R``: Map of the primary producer of unproductive land in all Indonesian regions

- ``Plot_SupFig1.R``: Map displaying the provinces in Sumatra.

- ``Plot_SupFig2.R``: Counterfactual maps. They show the difference between the value of 7 SDG indicators before and after the application of the intervention. 

> All maps use shapefile information to extract the geometries of the countries shown: Indonesia (extracted from the PODES data), Malaysia, Singapore, and Thailand. 

## Data
The data provided includes the output from the regression models, needed to plot the Figures. 

The data required to train the models is not provided. 

1. *Data_Fig1.RData:* The dataset contains the socio-economic village indicators significantly associated with different the four production profiles assessed in the study. It also contains a summary table with the statistic measures of each model trained (SDM and SDEM models).

    - ``IN_SDM`` and ``IN_SDEM``: Output of the regression trained using 'percentage of industrial palm oil' as a dependent variable and all the socio-economic indicators as the independent ones. 
    
    - ``SM_SDM`` and ``SM_SDEM``: Output of the regression trained using 'percentage of smallholder palm oil' as a dependent variable and all the socio-economic indicators as the independent ones. 

    - ``PR_SDM`` and ``PR_SDEM``: Output of the regression model trained using 'percentage of unproductive (but possibly replanted) palm oil' as a dependent variable and all the socio-economic indicators as the independent ones. 

    - ``UN_SDM`` and ``UN_SDEM``: Output of the regression model using 'percentage of unproductive (damaged) palm oil' as a dependent variable and all the socio-economic indicators as the independent ones. 

2. *Data_Fig3.RData:* Percentage of villages in which the replanting intervention evaluated entailed positive, negative or neutral effects on the SDG indicators evaluated. 

    - ``prefix``: Flag to indicate the name of the SDGs evaluated.    
    - ``vil_list_0``: Output of the counterfactual analysis (neutral impact) for the 7 SDGs evaluated. The list ``vil_list_0`` contains 7 individual matrices of dimension (11x2), where the rows indicate the provinces evaluated and the 2 indicate the 2 scenarios of the counterfactual analysis (industrial replanting or smallholder replanting). The elements of the matrices indicate the percentage of villages affected by the intervention in which no impact on SDG progress was observed. 

    - ``vil_list_mp``: Output of the counterfactual analysis (moderate positive impact) for the 7 SDGs evaluated. The elements of the matrices indicate the percentage of villages affected by the intervention in which the intervention positively affected SDG progress but did not affect village wellbeing. Check the manuscript for more details. 

    - ``vil_list_mn``: Output of the counterfactual analysis (moderate negative impact) for the 7 SDGs evaluated. The elements of the matrices indicate the percentage of villages affected by the intervention in which the intervention entailed a negative effect on SDG progress but it did not affect village wellbeing. 

    - ``vil_list_hp``: Output of the counterfactual analysis (high positive impact) for the 7 SDGs evaluated. The elements of the matrices indicate the percentage of villages affected by the intervention in which the intervention entailed a positive effect on SDG progress that improved village wellbeing.

    - ``vil_list_hn``: Output of the counterfactual analysis (high negative impact) for the 7 SDGs evaluated. The elements of the matrices indicate the percentage of villages affected by the intervention in which the intervention entailed a positive effect on SDG progress that improved village wellbeing.

    > All impact lists have the same structure as the one explained in ``vil_list_0``.

3. *oil_palm_filtered.csv:* Palm oil dataset for all Indonesian villages. It is obtained by combining the data from https://nusantara-atlas.org and https://doi.org/10.5281/zenodo.4473715.

5. *Shapefiles:* Shapefiles used to create the maps. The ``shapefiles`` folder must be downloaded from [Dropbox](https://www.dropbox.com/scl/fo/ys0r2mravtjtsahfc8pxs/h?rlkey=mdsagu3oos510tzbqyirdekxc&dl=0) and included in the main directory. 
    - `Villages_indonesia.shp`: Village boundaries Indonesia. 
    - `Missing_data.shp`: Sumatran viillages not considered in the analysis. 
    - `bd012vf3991.shp`: Malaysia country boundaries.
    - `sgpBound.shp`: Singapore country boundaries. 
    - `tha_admbnda_adm0_rtsd_20220121.shp`: Thailand country boundaries.
  
# Cite As
