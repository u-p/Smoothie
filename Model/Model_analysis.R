

library(tidyverse)


# Activation:

# Condition 1 ---------
# act.cond1 <- read_csv('R-ACT-R/output-5k_v2/cond-1/act-out-1.csv') %>% 
act.cond1 <- read_csv('R-ACT-R/output-10k/cond-1/act-out-1.csv') %>% 
  na.omit()

act.cond1 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)

act.cond1 %>% 
  group_by(stepNo) %>% 
  summarise(stepNoStart = min(time))


# Generate fixations

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
  mutate(flasche.fix = 1- knopf.fix)

# Sanity check
act.cond1 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


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

pronOnsetStep = DetOnsetStep = 3
pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(stepStartTime)
  
input.stages.cond1 = c("<empty>", "klicke_auf", "pronoun", "<ant ret>", 
                 "<pic pred>", "blauen", "<pic pred>", 
                 "knopf", "<pic pred>")

# Plot fixation probabilities
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
  # geom_vline(xintercept = pronOnset, color = "gray45") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))



# Condition 2 ---------
# act.cond2 <- read_csv('R-ACT-R/output-5k_v2/cond-2/act-out-1.csv') %>% 
act.cond2 <- read_csv('R-ACT-R/output-10k/cond-2/act-out-1.csv') %>% 
  na.omit()

act.cond2 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)

act.cond2 %>% 
  group_by(stepNo) %>% 
  summarise(stepNoStart = min(time))


# Generate fixations

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
  mutate(flasche.fix = 1- knopf.fix)

# Sanity check
act.cond2 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


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

pronOnsetStep = DetOnsetStep = 3
pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(stepStartTime)

input.stages.cond2 = c("<empty>", "klicke_auf", "pronoun", "<ant ret>", 
                       "<pic pred>", "blauen", "<pic pred>", 
                       "knopf", "<pic pred>")

# Plot fixation probabilities
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
  # geom_vline(xintercept = pronOnset, color = "gray45") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))





# Condition 3 ---------
# act.cond3 <- read_csv('R-ACT-R/output-5k_v2/cond-3/act-out-1.csv') %>% 
act.cond3 <- read_csv('R-ACT-R/output-10k/cond-3/act-out-1.csv') %>% 
  na.omit()

act.cond3 %>% 
  group_by(stepNo, subStep) %>% 
  summarise(time = mean(time), 
            k.act = mean(knopf.act), 
            f.act = mean(flasche.act)) %>% 
  arrange(time) %>% 
  print(n = Inf)

act.cond3 %>% 
  group_by(stepNo) %>% 
  summarise(stepNoStart = min(time))


# Generate fixations

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
  mutate(flasche.fix = 1- knopf.fix)

# Sanity check
act.cond3 %>% 
  filter(knopf.act == flasche.act) %>% 
  summarise(mean(knopf.fix), mean(flasche.fix))


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

pronOnsetStep = DetOnsetStep = 3
pronOnset = steps %>% 
  filter(stepNo == pronOnsetStep) %>% 
  pull(stepStartTime)

input.stages.cond3 = c("<empty>", "klicke_auf", "determiner", 
                       "<pic pred>", "blauen", "<pic pred>", 
                       "knopf", "<pic pred>")

# Plot fixation probabilities
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
  # geom_vline(xintercept = pronOnset, color = "gray45") +
  scale_linetype_manual(name = "", 
                        values = c("dashed", "solid"), 
                        labels = c("Flasche", "Knopf")) +
  geom_line(aes(linetype=fix.prob.type ))













