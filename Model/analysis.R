
library(dplyr)


# fName.match = "R-ACT-R/output/cond-1/act-out-1.txt"
# fName.mismatch = "R-ACT-R/output/cond-2/act-out-1.txt"
# fName.det = "R-ACT-R/output/cond-3/act-out-1.txt"

fName.match =     "R-ACT-R/output-10k/cond-1/act-out-1.txt"
fName.mismatch =  "R-ACT-R/output-10k/cond-2/act-out-1.txt"
fName.det =       "R-ACT-R/output-10k/cond-3/act-out-1.txt"

pronOnsetStep = 3
nEpochs = 43  # the sample number (in total 43 samples / simulation) for match and mismatch
nEpochsDet = 40  # the sample number (in total 40 samples / simulation) for determiner condition (no antecedent retrieval)
nSim = 1000


# MATCH
dt.act.match = read.table(file = fName.match, header=T)
dt.act.match = subset(dt.act.match, simNo > 0)
dt.act.match$epochNo = rep(c(1:nEpochs), nSim)
dt.act.match = subset(dt.act.match, stepNo >= pronOnsetStep)
dt.act.match$knopf.fix = ifelse(dt.act.match$knopf.act >= dt.act.match$flasche.act, 1, 0)

dt.test.match = as.data.frame(dt.act.match %>%
                                group_by(epochNo) %>%
                                summarise(signif = binom.test(sum(knopf.fix), n(), p = .5, 
                                                              alternative = "greater")$p.value < 0.05)
                              )


# MISMATCH
dt.act.mismatch = read.table(file = fName.mismatch, header=T)
dt.act.mismatch = subset(dt.act.mismatch, simNo > 0)
dt.act.mismatch$epochNo = rep(c(1:nEpochs), nSim) # assign the sample number (in total 63 samples / simulation)
dt.act.mismatch = subset(dt.act.mismatch, stepNo >= pronOnsetStep)
dt.act.mismatch$knopf.fix = ifelse(dt.act.mismatch$knopf.act >= dt.act.mismatch$flasche.act, 1, 0)

dt.test.mismatch = as.data.frame(dt.act.mismatch %>%
                                   group_by(epochNo) %>%
                                   summarise(signif = binom.test(sum(knopf.fix), n(), p = .5, 
                                                                 alternative = "greater")$p.value < 0.05)
                                 )


# DETERMINER
dt.act.det = read.table(file = fName.det, header=T)
dt.act.det = subset(dt.act.det, simNo > 0)
dt.act.det$epochNo = rep(c(1:nEpochsDet), nSim)
dt.act.det = subset(dt.act.det, stepNo >= pronOnsetStep)
dt.act.det$knopf.fix = ifelse(dt.act.det$knopf.act >= dt.act.det$flasche.act, 1, 0)

dt.test.det = as.data.frame(dt.act.det %>%
                              group_by(epochNo) %>%
                              summarise(signif = binom.test(sum(knopf.fix), n(), p = .5, 
                                                            alternative = "greater")$p.value < 0.05)
                            )

onset.match = onset.mismatch = onset.det = c()

# (minimum) length of the sequence for which the effect should be consistently significant
seqLen = 5
for(i in 1:(dim(dt.test.match)[1] - seqLen)){
  onset.match[i] <- sum(dt.test.match[i:(i+seqLen-1),2]) == seqLen
  onset.mismatch[i] <- sum(dt.test.mismatch[i:(i+seqLen-1),2]) == seqLen
}

for(i in 1:(dim(dt.test.det)[1] - seqLen)){
  onset.det[i] <- sum(dt.test.det[i:(i+seqLen-1),2]) == seqLen
}

# determine the first entry in the 'onset.(mis)match' that is true and
# get the 'epochNo' to index into the table with 'time' and 'activation' 
# values ('dt.act.match' / 'dt.act.mismatch') to get the distribution of
# 'time' for that 'epochNo'
tStamp.match = dt.test.match[which(onset.match)[1],1]
tStamp.mismatch = dt.test.mismatch[which(onset.mismatch)[1],1]
tStamp.det = dt.test.det[which(onset.det)[1],1]

# mean(subset(dt.act.mismatch, epochNo == tStamp.mismatch)$time) - 
#   mean(subset(dt.act.match, epochNo == tStamp.match)$time)

# plot the 'time' distributions
plot(xlim = c(850, 1150), 
     ylim = c(0, 0.09),
     density(subset(dt.act.match, epochNo == tStamp.match)$time))
lines(density(subset(dt.act.mismatch, epochNo == tStamp.mismatch)$time))
lines(density(subset(dt.act.det, epochNo == tStamp.det)$time), col="blue", cex=3)


# TEMP

dt.act.match %>%
  group_by(simNo) %>%
  summarise(epochs = n())

dt.act.det %>%
  group_by(simNo) %>%
  summarise(epochs = n())





