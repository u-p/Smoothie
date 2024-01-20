#
# Author: Umesh Patil (umesh.patil@gmail.com)
#

#! start fresh
rm(list=ls())
source("global.R")


#! load r-act-r
setwd("R-ACT-R")
source("functions.R")
source("act-r-params.R")


# Warnings are disabled because 'rbind' in function 'add.time()'
# keeps giving (non-replicable) warning message 
options(warn=-1)


####################################
# Condition 1 (SVO) 
####################################

picCreStage = 1  		# picture creation stage


#------ run models ------
source("global-var.R")

# no. of times to run each simulation set (defined in the global parameter 'sims')
run = 1


# which experiment to run the model first
# run Experiment 2 models
EXPT1 = FALSE

# print('', quote=F)
# print("Running cond - 1")
# setwd("cond-1")
# run.model("cond-1-model.R", "../output/cond-1/", run)
# print('', quote=F)
# print('', quote=F)
# 
# print('', quote=F)
# print("Running cond - 2")
# setwd("../cond-2")
# run.model("cond-2-model.R", "../output/cond-2/", run)
# print('', quote=F)
# print('', quote=F)

print('', quote=F)
print('==========>')
print("Running cond - 3")
setwd("cond-3")
run.model("cond-3-model.R", "../output/cond-3/", run)
print('', quote=F)
print('', quote=F)


#! go back to HOME
setwd(HOME)
