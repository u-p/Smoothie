# -------------------------------------------------------------
#        Load libraries, functions and set global variable
# -------------------------------------------------------------

library(tidyverse)


# Function that returns the first index of the column in 'data' where 
# 'seq_len' no. of consecutive etnries in 'signif' are TRUE
check_signif_ind <- function(data, seq_len) {
  for(i in c(1: (dim(data)[1] - seq_len + 1))){
    signif <- data$signif[i:(i+4)]
    if(all(signif)){
      return(data$subStepsNo[i])
    }
  }
  print("No sequence found!!", quote=FALSE)
  return(NA)
}


# Initialize global variables:
nSims <- 10000

# no. of consecutive significant subSteps that define the onset
signif_seq_len <- 5

# step no. corresponding to pronoun / determiner 
pronOnsetStep <- DetOnsetStep <- 3


# Add names to conditions and steps
cond1.name <- 'Match'
cond2.name <- 'Mismatch'
cond3.name <- 'Baseline'

step.cond1 <- step.cond2 <- c("empty", "click_on", "pronoun", 
                              "antecedent_retrieval", "picture_prediction", 
                              "adjective", "picture_prediction", "target", 
                              "picture_prediction")

step.cond3 <- c("empty", "click_on", "determiner", "picture_prediction", 
                "adjective", "picture_prediction", "target", 
                "picture_prediction")


# -------------------------------------------------------------
#        Condition: MATCH
# -------------------------------------------------------------

# Create a named vector for step names
named_steps <- setNames(step.cond1, 1:length(step.cond1))

# Load model output -- activation values for 'Knopf' and 'Flasche' sampled
# at various time points
act.cond1 <- read_csv('R-ACT-R/output-10k/cond-1/act-out-1.csv') %>%
  # remove NAs, the first row is always NAs
  na.omit() %>%
  # create numbers for subSteps (needed for significance testing)
  group_by(simNo) %>%
  # add subset numbers
  mutate(subStepsNo = 1:n(), 
         # add names for steps
         step = named_steps[as.character(stepNo)]) %>% 
  # remove the grouping metadata
  ungroup()


# Print mean activation values for Knopf and Flasche across all steps+subStep
act.cond1 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)


# Generate fixations predictions from activation ----

# 'map_int()' is needed because otherwise sample() isn't called 
# for each row, but only once since ifelse() evaluates for all rows
act.cond1 <- act.cond1 %>%
  mutate(knopf.fix = map_int(seq_len(n()), ~ {
    if (knopf.act[.x] > flasche.act[.x]) {
      return(1)
    } else if (knopf.act[.x] < flasche.act[.x]) {
      return(0)
    } else {
      return(sample(c(0, 1), 1))
    }
  })) %>% 
  mutate(flasche.fix = 1 - knopf.fix)


# Sanity check: cases where activation is the same
# the predicted fixation should be random; check that
# the means are close to 0.5
act.cond1 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


# Find the subStepsNo that leads to significant effect
signif.cond1 <- act.cond1 %>% 
  filter(stepNo >= pronOnsetStep) %>%
  group_by(subStepsNo) %>%
  summarise(signif = binom.test(sum(knopf.fix), n(), p = .5, 
                                alternative = "greater")$p.value < 0.05) %>% 
  check_signif_ind(seq_len = signif_seq_len)


# Find the onset as the mean of the timestamp for that 'subStepsNo'
onset.cond1 <- act.cond1 %>% 
  filter(subStepsNo == signif.cond1) %>% 
  summarise(mean(time)) %>% 
  pull()


fix.prob.cond1 <- act.cond1 %>%
  group_by(stepNo) %>% 
  
# Create fixation probabilities
fix.prob.cond1 <- act.cond1 %>%
  group_by(stepNo) %>% 
  summarise(time = mean(time), 
            mnTime = min(time), 
            mxTime = max(time), 
            k.fix.prob = mean(knopf.fix), 
            f.fix.prob = mean(flasche.fix)) %>% 
  arrange(time) %>% 
  pivot_longer(
    cols = c("k.fix.prob", "f.fix.prob"), 
    names_to = "fix.prob.type", 
    values_to = "fix.prob"
  )


# Mean timestamp for each substep
subSteps <- act.cond1 %>%
  group_by(stepNo, subStep) %>%
  summarise(subSteptime = mean(time)) %>% 
  arrange(subSteptime)


# The onset of the step in the fastest simulation.
# Calculate onset of the each step:
# 
# This piece of code first calculates the onset of the 
# first substep in each step of each simulation (which 
# stands for the onset of each step in that simulation),
# and then calculates the mean across all simulations 
# (so mean onset of each step across all simulations).
steps <- act.cond1 %>% 
  group_by(simNo, stepNo) %>% 
  mutate(stepOnset = min(time)) %>%
  select(simNo, stepNo, stepOnset) %>% 
  distinct() %>% 
  group_by(stepNo) %>% 
  summarise(meanStepOnset = mean(stepOnset))

steps

# Mean pronoun onset
pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(meanStepOnset)


# Plot fixation probabilities ----
ggplot(fix.prob.cond1, 
       aes(x=time, y=fix.prob, group=fix.prob.type)) +
  theme(panel.grid = element_blank(), axis.line=element_blank(),
        panel.background=element_blank(), 
        plot.title = element_text(hjust = 0.5)) +
  xlim(0,2000) +
  ylim(0,1) +
  geom_point() +
  ylab('') +
  xlab('Time') +
  ggtitle(cond1.name) +
  geom_vline(xintercept = subSteps$subSteptime, 
             linetype="dotted", color = "gray70") +
  geom_vline(xintercept = steps$meanStepOnset,
             color = "gray80", ) +
  annotate("text", x=steps$meanStepOnset, y=0, size = 3,
           label= step.cond1, angle=90, hjust = 0) +
  annotate("text", x=subSteps$subSteptime, y=0.9, size = 2.5, 
           label= subSteps$subStep, angle=90, hjust = 0) +
  annotate("text", x=onset.cond1, y=0.5, col = 'red', size = 5,
           label = "x", fontface = "bold") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))

ggsave(paste('model-predictions/plots/MeanFixProb-cond-', cond1.name, '.png', sep=""), plot = last_plot())



# -------------------------------------------------------------
#        Condition: MISMATCH
# -------------------------------------------------------------

# Create a named vector for step names
named_steps <- setNames(step.cond2, 1:length(step.cond2))

# Load model output -- activation values for 'Knopf' and 'Flasche' sampled
# at various time points
act.cond2 <- read_csv('R-ACT-R/output-10k/cond-2/act-out-1.csv') %>%
  # remove NAs, the first row is always NAs
  na.omit() %>%
  # create numbers for subSteps (needed for significance testing)
  group_by(simNo) %>%
  # add subset numbers
  mutate(subStepsNo = 1:n(), 
         # add names for steps
         step = named_steps[as.character(stepNo)]) %>% 
  # remove the grouping metadata
  ungroup()


# Print mean activation values for Knopf and Flasche across all steps+subStep
act.cond2 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)


# Generate fixations predictions from activation ----

# 'map_int()' is needed because otherwise sample() isn't called 
# for each row, but only once since ifelse() evaluates for all rows
act.cond2 <- act.cond2 %>%
  mutate(knopf.fix = map_int(seq_len(n()), ~ {
    if (knopf.act[.x] > flasche.act[.x]) {
      return(1)
    } else if (knopf.act[.x] < flasche.act[.x]) {
      return(0)
    } else {
      return(sample(c(0, 1), 1))
    }
  })) %>% 
  mutate(flasche.fix = 1 - knopf.fix)


# Sanity check: cases where activation is the same
# the predicted fixation should be random; check that
# the means are close to 0.5
act.cond2 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


# Find the subStepsNo that leads to significant effect
signif.cond2 <- act.cond2 %>% 
  filter(stepNo >= pronOnsetStep) %>%
  group_by(subStepsNo) %>%
  summarise(signif = binom.test(sum(knopf.fix), n(), p = .5, 
                                alternative = "greater")$p.value < 0.05) %>% 
  check_signif_ind(seq_len = signif_seq_len)


# Find the onset as the mean of the timestamp for that 'subStepsNo'
onset.cond2 <- act.cond2 %>% 
  filter(subStepsNo == signif.cond2) %>% 
  summarise(mean(time)) %>% 
  pull()


# Create fixation probabilities
fix.prob.cond2 <- act.cond2 %>%
  group_by(stepNo) %>% 
  summarise(time = mean(time), 
            k.fix.prob = mean(knopf.fix), 
            f.fix.prob = mean(flasche.fix)) %>% 
  arrange(time) %>% 
  pivot_longer(
    cols = c("k.fix.prob", "f.fix.prob"), 
    names_to = "fix.prob.type", 
    values_to = "fix.prob"
  )


# Mean timestamp for each substep
subSteps <- act.cond2 %>%
  group_by(stepNo, subStep) %>%
  summarise(subSteptime = mean(time)) %>% 
  arrange(subSteptime)


# The onset of the step in the fastest simulation.
# Calculate onset of the each step:
# 
# This piece of code first calculates the onset of the 
# first substep in each step of each simulation (which 
# stands for the onset of each step in that simulation),
# and then calculates the mean across all simulations 
# (so mean onset of each step across all simulations).
steps <- act.cond2 %>% 
  group_by(simNo, stepNo) %>% 
  mutate(stepOnset = min(time)) %>%
  select(simNo, stepNo, stepOnset) %>% 
  distinct() %>% 
  group_by(stepNo) %>% 
  summarise(meanStepOnset = mean(stepOnset))

steps

# Mean pronoun onset
pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(meanStepOnset)


# Plot fixation probabilities ----
ggplot(fix.prob.cond2, 
       aes(x=time, y=fix.prob, group=fix.prob.type)) +
  theme(panel.grid = element_blank(), axis.line=element_blank(),
        panel.background=element_blank(), 
        plot.title = element_text(hjust = 0.5)) +
  xlim(0,2000) +
  ylim(0,1) +
  geom_point() +
  ylab('') +
  xlab('Time') +
  ggtitle(cond2.name) +
  geom_vline(xintercept = subSteps$subSteptime, 
             linetype="dotted", color = "gray70") +
  geom_vline(xintercept = steps$meanStepOnset,
             color = "gray80", ) +
  annotate("text", x=steps$meanStepOnset, y=0, size = 3,
           label= step.cond2, angle=90, hjust = 0) +
  annotate("text", x=subSteps$subSteptime, y=0.9, size = 2.5, 
           label= subSteps$subStep, angle=90, hjust = 0) +
  annotate("text", x=onset.cond2, y=0.5, col = 'red', size = 5,
           label = "x", fontface = "bold") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))

ggsave(paste('model-predictions/plots/MeanFixProb-cond-', cond2.name, '.png', sep=""), plot = last_plot())



# -------------------------------------------------------------
#        Condition: BASELINE
# -------------------------------------------------------------

# Create a named vector for step names
named_steps <- setNames(step.cond3, 1:length(step.cond3))

# Load model output -- activation values for 'Knopf' and 'Flasche' sampled
# at various time points
act.cond3 <- read_csv('R-ACT-R/output-10k/cond-3/act-out-1.csv') %>%
  # remove NAs, the first row is always NAs
  na.omit() %>%
  # create numbers for subSteps (needed for significance testing)
  group_by(simNo) %>%
  # add subset numbers
  mutate(subStepsNo = 1:n(), 
         # add names for steps
         step = named_steps[as.character(stepNo)]) %>% 
  # remove the grouping metadata
  ungroup()


# Print mean activation values for Knopf and Flasche across all steps+subStep
act.cond3 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)


# Generate fixations predictions from activation ----

# 'map_int()' is needed because otherwise sample() isn't called 
# for each row, but only once since ifelse() evaluates for all rows
act.cond3 <- act.cond3 %>%
  mutate(knopf.fix = map_int(seq_len(n()), ~ {
    if (knopf.act[.x] > flasche.act[.x]) {
      return(1)
    } else if (knopf.act[.x] < flasche.act[.x]) {
      return(0)
    } else {
      return(sample(c(0, 1), 1))
    }
  })) %>% 
  mutate(flasche.fix = 1 - knopf.fix)


# Sanity check: cases where activation is the same
# the predicted fixation should be random; check that
# the means are close to 0.5
act.cond3 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


# Find the subStepsNo that leads to significant effect
signif.cond3 <- act.cond3 %>% 
  filter(stepNo >= pronOnsetStep) %>%
  group_by(subStepsNo) %>%
  summarise(signif = binom.test(sum(knopf.fix), n(), p = .5, 
                                alternative = "greater")$p.value < 0.05) %>% 
  check_signif_ind(seq_len = signif_seq_len)


# Find the onset as the mean of the timestamp for that 'subStepsNo'
onset.cond3 <- act.cond3 %>% 
  filter(subStepsNo == signif.cond3) %>% 
  summarise(mean(time)) %>% 
  pull()


# Create fixation probabilities
fix.prob.cond3 <- act.cond3 %>%
  group_by(stepNo) %>% 
  summarise(time = mean(time), 
            k.fix.prob = mean(knopf.fix), 
            f.fix.prob = mean(flasche.fix)) %>% 
  arrange(time) %>% 
  pivot_longer(
    cols = c("k.fix.prob", "f.fix.prob"), 
    names_to = "fix.prob.type", 
    values_to = "fix.prob"
  )


# Mean timestamp for each substep
subSteps <- act.cond3 %>%
  group_by(stepNo, subStep) %>%
  summarise(subSteptime = mean(time)) %>% 
  arrange(subSteptime)


# The onset of the step in the fastest simulation.
# Calculate onset of the each step:
# 
# This piece of code first calculates the onset of the 
# first substep in each step of each simulation (which 
# stands for the onset of each step in that simulation),
# and then calculates the mean across all simulations 
# (so mean onset of each step across all simulations).
steps <- act.cond3 %>% 
  group_by(simNo, stepNo) %>% 
  mutate(stepOnset = min(time)) %>%
  select(simNo, stepNo, stepOnset) %>% 
  distinct() %>% 
  group_by(stepNo) %>% 
  summarise(meanStepOnset = mean(stepOnset))

steps

# Mean pronoun onset
pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(meanStepOnset)


# Plot fixation probabilities ----
ggplot(fix.prob.cond3, 
       aes(x=time, y=fix.prob, group=fix.prob.type)) +
  theme(panel.grid = element_blank(), axis.line=element_blank(),
        panel.background=element_blank(), 
        plot.title = element_text(hjust = 0.5)) +
  xlim(0,2000) +
  ylim(0,1) +
  geom_point() +
  ylab('') +
  xlab('Time') +
  ggtitle(cond3.name) +
  geom_vline(xintercept = subSteps$subSteptime, 
             linetype="dotted", color = "gray70") +
  geom_vline(xintercept = steps$meanStepOnset,
             color = "gray80", ) +
  annotate("text", x=steps$meanStepOnset, y=0, size = 3,
           label= step.cond3, angle=90, hjust = 0) +
  annotate("text", x=subSteps$subSteptime, y=0.9, size = 2.5, 
           label= subSteps$subStep, angle=90, hjust = 0) +
  annotate("text", x=onset.cond3, y=0.5, col = 'red', size = 5,
           label = "x", fontface = "bold") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))

ggsave(paste('model-predictions/plots/MeanFixProb-cond-', cond3.name, '.png', sep=""), plot = last_plot())



# -------------------------------------------------------------
#        Save processed model predictions to CSVs
# -------------------------------------------------------------

write_csv(act.cond1, file='model-predictions/predictions-cond-MATCH.csv')
write_csv(act.cond2, file='model-predictions/predictions-cond-MISMATCH.csv')
write_csv(act.cond3, file='model-predictions/predictions-cond-BASELINE.csv')




# -------------------------------------------------------------
# TEMP
# -------------------------------------------------------------
if(FALSE) {
  
N <- round(nrow(act.cond1) * 99 / 100)
act.cond1.rand1k <- act.cond1 %>% 
  slice_sample(n = N)

# Mean timestamp for each substep
subSteps <- act.cond1.rand1k %>%
  group_by(stepNo, subStep) %>%
  summarise(subSteptime = mean(time)) %>% 
  arrange(subSteptime)

steps <- subSteps %>%
  group_by(stepNo) %>%
  summarise(stepStartTime = min(subSteptime))

steps


steps <- act.cond1.rand1k %>% 
  group_by(simNo, stepNo) %>% 
  # mutate(stepOnset = min(knopf.act)) %>%
  mutate(stepOnset = min(time)) %>%
  select(simNo, stepNo, stepOnset) %>% 
  distinct() %>% 
  group_by(stepNo) %>% 
  summarise(meanStepOnset = mean(stepOnset))

steps

}
# -------------------------------------------------------------

