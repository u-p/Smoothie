
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


# Initialize some variables
pronOnsetStep = DetOnsetStep = 3
nSims <- 10000
signif_seq_len <- 5 # no. of consecutive significant subSteps


# -------------------------------------------------------------
#        Condition: MATCH
# -------------------------------------------------------------

act.cond1 <- read_csv('R-ACT-R/output-10k/cond-1/act-out-1.csv') %>%
  na.omit() %>%
  group_by(simNo) %>%
  mutate(subStepsNo = 1:n()) %>% 
  ungroup()

# act.cond1 <- read_csv('R-ACT-R/output-10k/cond-1/act-out-1.csv') %>% 
#   na.omit()

# Print mean activation values for Knopf and Flasche
act.cond1 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)

# Generate fixations ----

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

# Sanity check
act.cond1 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


# # Add the number to the subSteps
# act.cond1 <- act.cond1 %>% 
#   group_by(simNo) %>%
#   mutate(subStepsNo = 1:n())

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


# Create fixation probabilities
fix.prob.cond1 <- act.cond1 %>%
  # filter(stepNo > 2) %>% 
  # group_by(stepNo, subStep) %>% 
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


subSteps <- act.cond1 %>%
  group_by(stepNo, subStep) %>%
  summarise(subSteptime = mean(time)) %>% 
  arrange(subSteptime)

steps <- subSteps %>% 
  group_by(stepNo) %>% 
  summarise(stepStartTime = min(subSteptime))

pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(stepStartTime)
  
input.stages.cond1 = c("<empty>", "klicke_auf", "pronoun", "<ant ret>", 
                 "<pic pred>", "blauen", "<pic pred>", 
                 "knopf", "<pic pred>")


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
  ggtitle('Match') +
  geom_vline(xintercept = subSteps$subSteptime, 
             linetype="dotted", color = "gray70") +
  geom_vline(xintercept = steps$stepStartTime,
             color = "gray80", ) +
  annotate("text", x=steps$stepStartTime, y=0, 
           label= input.stages.cond1, angle=90, hjust = 0) +
  annotate("text", x=subSteps$subSteptime, y=0.9, size = 2.5, 
           label= subSteps$subStep, angle=90, hjust = 0) +
  annotate("text", x=onset.cond1, y=0.5, col = 'red', size = 5, label = "x",
           fontface = "bold") +
  # geom_vline(xintercept = pronOnset, color = "gray45") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))

ggsave('MeanFixProb-cond-MATCH.png', plot = last_plot())



# -------------------------------------------------------------
#        Condition: MISMATCH
# -------------------------------------------------------------

act.cond2 <- read_csv('R-ACT-R/output-10k/cond-2/act-out-1.csv') %>%
  na.omit() %>%
  group_by(simNo) %>%
  mutate(subStepsNo = 1:n()) %>% 
  ungroup()

# act.cond2 <- read_csv('R-ACT-R/output-10k/cond-1/act-out-1.csv') %>% 
#   na.omit()

# Print mean activation values for Knopf and Flasche
act.cond2 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)

# Generate fixations ----

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

# Sanity check
act.cond2 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


# # Add the number to the subSteps
# act.cond2 <- act.cond2 %>% 
#   group_by(simNo) %>%
#   mutate(subStepsNo = 1:n())

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


# Create fixation probabilities ----
fix.prob.cond2 <- act.cond2 %>%
  # filter(stepNo > 2) %>% 
  # group_by(stepNo, subStep) %>% 
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

subSteps <- act.cond2 %>%
  group_by(stepNo, subStep) %>%
  summarise(subSteptime = mean(time)) %>% 
  arrange(subSteptime)

steps <- subSteps %>% 
  group_by(stepNo) %>% 
  summarise(stepStartTime = min(subSteptime))

pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(stepStartTime)


input.stages.cond2 = c("<empty>", "klicke_auf", "pronoun", "<ant ret>", 
                       "<pic pred>", "blauen", "<pic pred>", 
                       "knopf", "<pic pred>")


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
  ggtitle('Mismatch') +
  geom_vline(xintercept = subSteps$subSteptime, 
             linetype="dotted", color = "gray70") +
  geom_vline(xintercept = steps$stepStartTime,
             color = "gray80", ) +
  annotate("text", x=steps$stepStartTime, y=0, 
           label= input.stages.cond2, angle=90, hjust = 0) +
  annotate("text", x=subSteps$subSteptime, y=0.9, size = 2.5, 
           label= subSteps$subStep, angle=90, hjust = 0) +
  annotate("text", x=onset.cond2, y=0.5, col = 'red', size = 5, label = "x",
           fontface = "bold") +
  # geom_vline(xintercept = pronOnset, color = "gray45") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))

ggsave('MeanFixProb-cond-MISMATCH.png', plot = last_plot())



# -------------------------------------------------------------
#        Condition: BASELINE
# -------------------------------------------------------------

act.cond3 <- read_csv('R-ACT-R/output-10k/cond-3/act-out-1.csv') %>%
  na.omit() %>%
  group_by(simNo) %>%
  mutate(subStepsNo = 1:n()) %>% 
  ungroup()

# act.cond3 <- read_csv('R-ACT-R/output-10k/cond-1/act-out-1.csv') %>% 
#   na.omit()

# Print mean activation values for Knopf and Flasche
act.cond3 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)

# Generate fixations ----

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

# Sanity check
act.cond3 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


# # Add the number to the subSteps
# act.cond3 <- act.cond3 %>% 
#   group_by(simNo) %>%
#   mutate(subStepsNo = 1:n())

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


# Create fixation probabilities ----
fix.prob.cond3 <- act.cond3 %>%
  # filter(stepNo > 2) %>% 
  # group_by(stepNo, subStep) %>% 
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

subSteps <- act.cond3 %>%
  group_by(stepNo, subStep) %>%
  summarise(subSteptime = mean(time)) %>% 
  arrange(subSteptime)

steps <- subSteps %>% 
  group_by(stepNo) %>% 
  summarise(stepStartTime = min(subSteptime))

pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(stepStartTime)


input.stages.cond3 = c("<empty>", "klicke_auf", "determiner", 
                       "<pic pred>", "blauen", "<pic pred>", 
                       "knopf", "<pic pred>")


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
  ggtitle('Baseline') +
  geom_vline(xintercept = subSteps$subSteptime, 
             linetype="dotted", color = "gray70") +
  geom_vline(xintercept = steps$stepStartTime,
             color = "gray80", ) +
  annotate("text", x=steps$stepStartTime, y=0, 
           label= input.stages.cond3, angle=90, hjust = 0) +
  annotate("text", x=subSteps$subSteptime, y=0.9, size = 2.5, 
           label= subSteps$subStep, angle=90, hjust = 0) +
  annotate("text", x=onset.cond3, y=0.5, col = 'red', size = 5, label = "x",
           fontface = "bold") +
  # geom_vline(xintercept = pronOnset, color = "gray45") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))

ggsave('MeanFixProb-cond-BASELINE.png', plot = last_plot())


