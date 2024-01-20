
1. This README file describes how to run the models reported in:
	Umesh Patil and Sol Lago (2021).
	Prediction advantage as retrieval interference: an ACT-R model of processing possessive pronouns.
	Proceedings of the 19th International Conference on Cognitive Modeling.


2. How to run the models?
-> Call 'source("run-all.R")' within R from the root directory of the code
-> This will run models for both Expt. 1 and 2 from Stone et al. (2021) and generate plots (similar to the ones reported in the paper) for 1000 simulations per condition (see (3) below for running higher no. of simulations)
-> Running the model with the default settings takes around 12 minutes to finish (depending on the configuration of the computer) and it will take 10 MB of extra space on the hard disk
-> The plots are saved in the 'plots' folder
-> Required R packages:
	. base R packages are sufficient for running the model (Step 1 in 'run-all.R')
	. for generating plots, 'Tidyverse' is needed (Step 2 in 'run-all.R')


3. The R script 'global.R' specifies global variables for running the models.
-> The variable 'sims' specifies the number of simulations to run which is set by default to 1000
-> The ICCM-2021 paper reported results from 10000 simulations
-> If you set 'sims' to 10000, the models will take around 100 MB of extra space on the hard disk, and the amount of time increases non-linearly (depending on the configuration of the computer) as you increase the no. of simulations


4. OSF repository of the paper: https://osf.io/fsbzw/

