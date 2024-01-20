#
# Author: Umesh Patil (umesh.patil@gmail.com)
#


#! the home directory
HOME = getwd()


#! no. of simulations to run
sims = 1000


## -- Cue weighting --
# read weights for various cues
f.cue.weight = read.csv("cueWeights.csv", header = T)
cue.weight = array(f.cue.weight$cWeight, dim = c(dim(f.cue.weight)[1],1))
row.names(cue.weight) = f.cue.weight$cName


# parameter for record activation values of picture objects
getActivation = TRUE

# =============