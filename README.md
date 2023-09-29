# Figs_PalmOil_SDGs
Repository for the study "Replanting unproductive palm oil with smallholder plantations can help achieve Sustainable Development Goals in Sumatra, Indonesia".

## Scripts
The scripts included allow for the reproduction of the plots shown in the main paper and supplementary materials. The code to train the spatial regression models is available under demand but the socio-economic data of the PODES must be purchased for its execution. See disclaimer for more details.

- ``Plot_Fig1.R``: Creates the figure showing the significant socio-economic characteristics of the villages with four different types of production profile: Unproductive (damaged), Unproductive (possibly replanted), Industrial or smallholder plantations. The data used to generate these plots also contains a data frame with the quality metrics estimated for each of the regression models trained  (``stats``). 

- ``Plot_Fig3_Supp3_12.R``:  Creates the summary plots showing the predicted impact of replanting Unproductive (damaged) plantations with new palm oil (either industrial or smallholder profiles). The script evaluates the effects of the intervention when implemented in the region of Sumatra (Figure 3) and also in all the Sumatran provinces (Supplementary Figs. 3-15). 

- ``Latex_Table1.R``:* Creates a table summarising the impact of the counterfactual analysis on all the Sumatran provinces. The output of this script is a printed table on LaTeX format. 

> The code and data used to generate the maps shown on the paper could not be incorporated to the repository due to the limitations of data-sharing agreement. The shapefile for Indonesia is part of the PODES data and thus it is a property of the Indonesian Badan Pusat Statistik. 

## Data
The data provided includes the output from the regression models, needed to run the scripts. The data required to train the models is not provided, see discla. 

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

# Disclaimer:
The code used to train the regression models and to perform the counterfactual analysis cannot be publically shared because it contains information that can be traced back to the original PODES dataset. This code can be requested through email.

# Cite As
